import 'dart:developer';
import 'package:budgetly/model/dataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Datacontroller with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Datamodel> allData = [];
  List<Datamodel> filteredData = [];

  String selected = "All";
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());

  // ---------------- DATE PARSE (COMMON) ----------------
  DateTime? parseDate(String? date) {
    if (date == null) return null;
    try {
      return DateFormat('dd-MM-yyyy').parse(date);
    } catch (e) {
      return null;
    }
  }

  // ---------------- FIRESTORE FETCH (COMMON) ----------------
  Future<List<Datamodel>> getAllDocs(Query<Map<String, dynamic>> query,) async {
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Datamodel.fromJson(doc.data(), doc.id))
        .toList();
  }

  // ---------------- SEARCH ----------------
  void filterData(String query) {
    if (query.isEmpty) {
      filteredData = List.from(allData);
    } else {
      filteredData = allData
          .where((data) =>
              data.particular!
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // ---------------- FETCH + SET ----------------
  Future<void> getdata([String? interval, String? monthFilter]) async {
    interval ??= "All";

    if (interval == "Monthly" && monthFilter != null) {
      selectedMonth = monthFilter;
    }

    allData = await fetchData(interval, monthFilter: monthFilter);
    filteredData = List.from(allData);
    notifyListeners();
  }

  void selectedColor(String filter) {
    if (selected != filter) {
      selected = filter;
      notifyListeners();
    }
  }

  // ---------------- MAIN FETCH LOGIC ----------------
  Future<List<Datamodel>> fetchData(
  String interval, {
  String? monthFilter,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];

  Query<Map<String, dynamic>> query = firestore
      .collection('cash_book')
      .doc(user.uid)
      .collection('transactions')
      .orderBy('createdAt', descending: true);

  final snapshot = await query.get();

  final allDocs = snapshot.docs
      .map((doc) => Datamodel.fromJson(doc.data(), doc.id))
      .toList();

  final now = DateTime.now();

  // DAILY
  if (interval == 'Daily') {
    return allDocs.where((data) {
      final d = data.createdAt;
      return d.year == now.year &&
          d.month == now.month &&
          d.day == now.day;
    }).toList();
  }

  // WEEKLY
  if (interval == 'Weekly') {
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return allDocs.where((data) {
      return data.createdAt.isAfter(sevenDaysAgo);
    }).toList();
  }

  // MONTHLY
  if (interval == 'Monthly') {
    if (monthFilter != null) {
      return allDocs.where((data) {
        return DateFormat('MMMM').format(data.createdAt) == monthFilter;
      }).toList();
    }

    return allDocs.where((data) {
      return data.createdAt.month == now.month &&
          data.createdAt.year == now.year;
    }).toList();
  }

  return allDocs;
}


  // ---------------- ADD ----------------
  Future<void> addDatafireBase({required Datamodel data}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DocumentReference docRef = await firestore
          .collection('cash_book')
          .doc(user.uid)
          .collection('transactions')
          .add(data.toJson());

      await docRef.update({'id': docRef.id});
      await getdata();
    } catch (e) {
      log("Add error: $e");
    }
  }

  // ---------------- UPDATE ----------------
  Future<void> updateDatafireBase({
    required Datamodel oldData,
    required Datamodel newData,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || oldData.id == null) return;

    try {
      await firestore
          .collection('cash_book')
          .doc(user.uid)
          .collection('transactions')
          .doc(oldData.id)
          .update(newData.toJson());

      await getdata(); 
    } catch (e) { 
      log("Update error: $e");
    }
  }

  // ---------------- DELETE ----------------
  Future<void> deleteDatafireBase(String documentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await firestore
          .collection('cash_book')
          .doc(user.uid)
          .collection('transactions')
          .doc(documentId)
          .delete();

      await getdata();
    } catch (e) {
      log("Delete error: $e");
    }
  }

  Set<String> selectedIds = {};
bool get isSelectionMode => selectedIds.isNotEmpty; 
void toggleSelection(String id) {
  if (selectedIds.contains(id)) {
    selectedIds.remove(id);
  } else {
    selectedIds.add(id);
  }
  notifyListeners();
}

void clearSelection() {
  selectedIds.clear();
  notifyListeners();
}


  Future<void> deleteAllTransactions() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final collectionRef = firestore
      .collection('cash_book')
      .doc(user.uid)
      .collection('transactions');

  final snapshot = await collectionRef.get();

  WriteBatch batch = firestore.batch();

  for (var doc in snapshot.docs) {
    batch.delete(doc.reference);
  }

  await batch.commit();

  allData.clear();
  filteredData.clear();
  notifyListeners();
}
Future<void> deleteSelectedTransactions() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  WriteBatch batch = firestore.batch();

  for (String id in selectedIds) {
    final docRef = firestore
        .collection('cash_book')
        .doc(user.uid)
        .collection('transactions')
        .doc(id);

    batch.delete(docRef);
  }

  await batch.commit();

  clearSelection(); // exit selection mode
  await getdata();
}


  // ---------------- TOTALS ----------------
  double totalIncome() {
  return filteredData.fold(
    0.0,
    (sum, item) =>
        sum + (double.tryParse(item.cashIn ?? '0') ?? 0),
  );
}

 double totalExpense() {
  return filteredData.fold(
    0.0,
    (sum, item) =>
        sum + (double.tryParse(item.cashout ?? '0') ?? 0),
  );
}


  double totalCash() {
  return filteredData.fold(0.0, (sum, item) {
    final cashIn = double.tryParse(item.cashIn ?? '0') ?? 0;
    final cashOut = double.tryParse(item.cashout ?? '0') ?? 0;
    return sum + cashIn - cashOut;
  });
}


  //CATEGORY MAP(COMMON)
  Map<String, double> categoryMap(bool isIncome) {
    final Map<String, double> result = {};

    for (var item in filteredData) {
      final amount = double.tryParse(
            isIncome ? item.cashIn ?? '0' : item.cashout ?? '0',
          ) ??
          0;

      if (amount <= 0) continue;

      final category = item.category ?? 'Others';
      result[category] = (result[category] ?? 0) + amount;
    }
    return result;
  }

 Map<String, double> incomeCategoryMap() {
  return categoryMap(true);
}

Map<String, double> expenseCategoryMap() {
  return categoryMap(false);
}


  // ---------------- URL ----------------
  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}
