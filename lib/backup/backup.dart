import 'dart:convert';
import 'dart:io';
import 'package:budgetly/model/dataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CloudBackupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  String? get userId => _auth.currentUser?.uid;

  Future<void> backupTransaction(Datamodel transaction) async {
    if (userId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.id)
          .set({
        'id': transaction.id,
        'createdAt': Timestamp.fromDate(transaction.createdAt),
        'particular': transaction.particular,
        'cashIn': transaction.cashIn,
        'cashOut': transaction.cashout,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Backup failed: $e');
    }
  }

  Future<void> backupAllTransactions(List<Datamodel> transactions) async {
    if (userId == null) throw Exception('User not logged in');
    if (!await isConnected()) throw Exception('No internet connection');

    try {
      WriteBatch batch = _firestore.batch();

      for (var transaction in transactions) {
        final docRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .doc(transaction.id);

        batch.set(docRef, {
          'id': transaction.id,
            'createdAt': Timestamp.fromDate(transaction.createdAt),
          'particular': transaction.particular,
          'cashIn': transaction.cashIn,
          'cashOut': transaction.cashout,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      await _firestore.collection('users').doc(userId).set({
        'lastBackup': FieldValue.serverTimestamp(),
        'email': _auth.currentUser?.email,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Backup failed: $e');
    }
  }

  Future<String> createFullBackup(List<Datamodel> transactions) async {
    if (userId == null) throw Exception('User not logged in');
    if (!await isConnected()) throw Exception('No internet connection');

    try {
      final backupData = {
        'version': '1.0',
        'timestamp': DateTime.now().toIso8601String(),
        'user': _auth.currentUser?.email,
        'transactionCount': transactions.length,
        'transactions': transactions
            .map((t) => {
                  'id': t.id,
                  'createdAt': t.createdAt.toIso8601String(),
                  'particular': t.particular,
                  'cashIn': t.cashIn,
                  'cashOut': t.cashout,
                })
            .toList(),
      };

      // Convert to JSON
      final jsonString = jsonEncode(backupData);

      // Create file
      final tempDir = await getTemporaryDirectory();
      final fileName = 'backup_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(jsonString);

      final storageRef =
          _storage.ref().child('backups').child(userId!).child(fileName);

      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('backups')
          .add({
        'fileName': fileName,
        'downloadUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'transactionCount': transactions.length,
        'size': file.lengthSync(),
      });

      await file.delete();

      return downloadUrl;
    } catch (e) {
      throw Exception('Full backup failed: $e');
    }
  }

  Future<List<Datamodel>> restoreFromCloud() async {
    if (userId == null) throw Exception('User not logged in');
    if (!await isConnected()) throw Exception('No internet connection');

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Datamodel(
  id: data['id'],
  createdAt: (data['createdAt'] as Timestamp).toDate(),
  particular: data['particular'],
  cashIn: data['cashIn'],
  cashout: data['cashOut'],
);

      }).toList();
    } catch (e) {
      throw Exception('Restore failed: $e');
    }
  }

  Future<List<BackupInfo>> getBackupHistory() async {
    if (userId == null) return [];

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('backups')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return BackupInfo(
          id: doc.id,
          fileName: data['fileName'],
          downloadUrl: data['downloadUrl'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          transactionCount: data['transactionCount'],
          size: data['size'],
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Delete old backups (keep last 5)
  Future<void> cleanupOldBackups() async {
    if (userId == null) return;

    try {
      final backups = await getBackupHistory();
      if (backups.length > 5) {
        for (int i = 5; i < backups.length; i++) {
          await _storage.refFromURL(backups[i].downloadUrl).delete();

          // Delete from Firestore
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('backups')
              .doc(backups[i].id)
              .delete();
        }
      }
    } catch (e) {
      print('Cleanup failed: $e');
    }
  }
}

class BackupInfo {
  final String id;
  final String fileName;
  final String downloadUrl;
  final DateTime timestamp;
  final int transactionCount;
  final int size;

  BackupInfo({
    required this.id,
    required this.fileName,
    required this.downloadUrl,
    required this.timestamp,
    required this.transactionCount,
    required this.size,
  });
}

class SyncController extends ChangeNotifier {
  final CloudBackupService _backupService = CloudBackupService();
  bool _isSyncing = false;
  bool _autoSyncEnabled = true;
  DateTime? _lastSyncTime;
  String? _syncError;
  Timer? _autoSyncTimer;

  bool get isSyncing => _isSyncing;
  bool get autoSyncEnabled => _autoSyncEnabled;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get syncError => _syncError;

  // Initialize auto sync
  void initAutoSync() {
    if (_autoSyncEnabled) {
      _autoSyncTimer?.cancel();
      _autoSyncTimer = Timer.periodic(
        const Duration(minutes: 5), // Sync every 5 minutes
        (_) => syncTransactions([]), // Pass your transactions list
      );
    }
  }

  // Toggle auto sync
  void toggleAutoSync(bool enabled) {
    _autoSyncEnabled = enabled;
    notifyListeners();

    if (enabled) {
      initAutoSync();
    } else {
      _autoSyncTimer?.cancel();
    }
  }

  // Sync single transaction
  Future<void> syncTransaction(Datamodel transaction) async {
    if (!await _backupService.isConnected()) return;

    try {
      await _backupService.backupTransaction(transaction);
    } catch (e) {
      print('Sync error: $e');
    }
  }

  // Sync all transactions
  Future<void> syncTransactions(List<Datamodel> transactions) async {
    if (_isSyncing) return;

    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      await _backupService.backupAllTransactions(transactions);
      _lastSyncTime = DateTime.now();
      _syncError = null;
    } catch (e) {
      _syncError = e.toString();
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // Create manual backup
  Future<String?> createBackup(List<Datamodel> transactions) async {
    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      final url = await _backupService.createFullBackup(transactions);
      await _backupService.cleanupOldBackups();
      _lastSyncTime = DateTime.now();
      return url;
    } catch (e) {
      _syncError = e.toString();
      return null;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // Restore from cloud
  Future<List<Datamodel>?> restoreData() async {
    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      final transactions = await _backupService.restoreFromCloud();
      _lastSyncTime = DateTime.now();
      return transactions;
    } catch (e) {
      _syncError = e.toString();
      return null;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _autoSyncTimer?.cancel();
    super.dispose();
  }
}

class CloudBackupPage extends StatefulWidget {
  @override
  _CloudBackupPageState createState() => _CloudBackupPageState();
}

class _CloudBackupPageState extends State<CloudBackupPage> {
  final CloudBackupService _backupService = CloudBackupService();
  List<BackupInfo> _backupHistory = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBackupHistory();
  }

  Future<void> _loadBackupHistory() async {
    setState(() => _isLoading = true);
    try {
      final history = await _backupService.getBackupHistory();
      setState(() => _backupHistory = history);
    } catch (e) {
      print('Error loading history: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF0008B4),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Cloud Backup & Sync',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Consumer<SyncController>(
                    builder: (context, syncController, child) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sync Status Card
                            _buildSyncStatusCard(syncController),
                            const SizedBox(height: 24),

                            // Auto Sync Toggle
                            _buildAutoSyncToggle(syncController),
                            const SizedBox(height: 24),

                            // Action Buttons
                            _buildActionButtons(syncController),
                            const SizedBox(height: 32),

                            // Backup History
                            _buildBackupHistory(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard(SyncController syncController) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: syncController.isSyncing
              ? [Colors.orange.shade400, Colors.orange.shade600]
              : syncController.syncError != null
                  ? [Colors.red.shade400, Colors.red.shade600]
                  : [const Color(0xFF30CB76), const Color(0xFF26A65B)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  syncController.isSyncing
                      ? Icons.sync
                      : syncController.syncError != null
                          ? Icons.error_outline
                          : Icons.cloud_done,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      syncController.isSyncing
                          ? 'Syncing...'
                          : syncController.syncError != null
                              ? 'Sync Failed'
                              : 'All Synced',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      syncController.lastSyncTime != null
                          ? 'Last sync: ${DateFormat('MMM dd, yyyy hh:mm a').format(syncController.lastSyncTime!)}'
                          : 'Never synced',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (syncController.syncError != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                syncController.syncError!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAutoSyncToggle(SyncController syncController) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF667eea).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.sync_alt,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Auto Sync',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Automatically sync every 5 minutes',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: syncController.autoSyncEnabled,
            onChanged: syncController.toggleAutoSync,
            activeColor: const Color(0xFF30CB76),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(SyncController syncController) {
    return Column(
      children: [
        // Backup Now Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: syncController.isSyncing
                  ? null
                  : () async {
                      // Get transactions from your provider
                      // final transactions = context.read<DataController>().transactions;
                      // await syncController.createBackup(transactions);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Backup started...'),
                          backgroundColor: Color(0xFF667eea),
                        ),
                      );
                    },
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.backup, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      syncController.isSyncing ? 'Backing up...' : 'Backup Now',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Restore Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF667eea), width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: syncController.isSyncing
                  ? null
                  : () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text('Restore Data?'),
                          content: const Text(
                            'This will replace all your current data with the cloud backup. Are you sure?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF667eea),
                              ),
                              child: const Text('Restore'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        final transactions = await syncController.restoreData();
                        if (transactions != null) {
                          // Update your local data
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data restored successfully!'),
                              backgroundColor: Color(0xFF30CB76),
                            ),
                          );
                        }
                      }
                    },
              borderRadius: BorderRadius.circular(16),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restore, color: Color(0xFF667eea)),
                    SizedBox(width: 8),
                    Text(
                      'Restore from Cloud',
                      style: TextStyle(
                        color: Color(0xFF667eea),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackupHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Backup History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: _loadBackupHistory,
              icon: const Icon(Icons.refresh),
              color: const Color(0xFF667eea),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF667eea),
            ),
          )
        else if (_backupHistory.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No backups yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _backupHistory.length,
            itemBuilder: (context, index) {
              final backup = _backupHistory[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667eea).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.backup,
                        color: Color(0xFF667eea),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMM dd, yyyy').format(backup.timestamp),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${backup.transactionCount} transactions • ${_formatFileSize(backup.size)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'download') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Downloading backup...'),
                            ),
                          );
                        } else if (value == 'delete') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Backup deleted'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'download',
                          child: Row(
                            children: [
                              Icon(Icons.download, size: 20),
                              SizedBox(width: 8),
                              Text('Download'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
