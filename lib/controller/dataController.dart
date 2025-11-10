// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shersoft/model/dataModel.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Datacontroller with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Datamodel> _allData = [];
//   List<Datamodel> _filteredData = [];

//   String selected = "All";

//   List<Datamodel> get filteredData => _filteredData;

//   void filterData(String query) {
//     if (query.isEmpty) {
//       _filteredData = List.from(_allData);
//     } else {
//       _filteredData = _allData
//           .where((data) =>
//               data.particular!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//     notifyListeners();
//   }

//   //   filter
//   Future<void> getdata([String? filter]) async {
//     filter ??= "All";
//     _allData = await fetchData(filter);
//     _filteredData = List.from(_allData);
//     notifyListeners();
//   }

//   //  filter color
//   void selectedColor(String filter) {
//     if (selected != filter) {
//       selected = filter;
//       notifyListeners();
//     }
//   }

//   // Fetch  from
//   Future<List<Datamodel>> fetchData(String interval) async {
//     log(interval);
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       print("User is not logged in.");
//       return [];
//     }

//     String today = DateFormat('dd-MM-yyyy').format(DateTime.now());
//     Query<Map<String, dynamic>> query = _firestore
//         .collection('cash_book')
//         .doc(user.uid)
//         .collection('transactions');

//     switch (interval) {
//       case 'Daily':
//         query = query.where('date', isEqualTo: today);
//         log(today);
//         break;
//       case 'Weekly':
//         DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
//         String formattedDateSevenDaysAgo =
//             DateFormat('dd-MM-yyyy').format(sevenDaysAgo);
//         log(formattedDateSevenDaysAgo);
//         query = query.where('date',
//             isGreaterThanOrEqualTo: formattedDateSevenDaysAgo);
//         break;
//       case 'Monthly':
//         DateTime firstDayOfMonth =
//             DateTime(DateTime.now().year, DateTime.now().month, 1);
//         String formattedFirstDayOfMonth =
//             DateFormat('dd-MM-yyyy').format(firstDayOfMonth);
//         query = query.where('date',
//             isGreaterThanOrEqualTo: formattedFirstDayOfMonth);
//         break;
//       case 'All':
//         break;
//       default:
//         print("Invalid interval selected");
//         return [];
//     }

//     try {
//       var querySnapshot = await query.get();

//       if (querySnapshot.docs.isNotEmpty) {
//         return querySnapshot.docs
//             .map((doc) => Datamodel.fromJson(doc.data(), doc.id))
//             .toList();
//       } else {
//         return [];
//       }
//     } on FirebaseException catch (e) {
//       log(e.toString());
//       return [];
//     }
//   }

//   // Add ne
//   Future<void> addDatafireBase({required Datamodel data}) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         DocumentReference docRef = await _firestore
//             .collection('cash_book')
//             .doc(user.uid)
//             .collection('transactions')
//             .add(
//               data.toJson(),
//             );

//         await docRef.update({'id': docRef.id});

//         getdata();
//       } on FirebaseException catch (e) {
//         log("Firebase error: ${e.message}");
//       } catch (e) {
//         log("Error adding data: $e");
//       }
//     } else {
//       print("User not logged in.");
//     }
//   }

//   // Update transaction
//   Future<void> updateDatafireBase({
//     required Datamodel oldData,
//     required Datamodel newData,
//   }) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null && oldData.id != null) {
//       try {
//         await _firestore
//             .collection('cash_book')
//             .doc(user.uid)
//             .collection('transactions')
//             .doc(oldData.id)
//             .update(newData.toJson());
//         await getdata();
//       } on FirebaseException catch (e) {
//         log("Firebase update error: ${e.message}");
//       } catch (e) {
//         log("Error updating data: $e");
//       }
//     } else {
//       print("User not logged in or document ID missing.");
//     }
//     notifyListeners();
//   }

//   // Delete transaction
//   Future<void> deleteDatafireBase(String documentId) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         await _firestore
//             .collection('cash_book')
//             .doc(user.uid)
//             .collection('transactions')
//             .doc(documentId)
//             .delete();

//         getdata();
//       } on FirebaseException catch (e) {
//         log("Firebase delete error: ${e.message}");
//       } catch (e) {
//         log("Error deleting data: $e");
//       }
//     } else {
//       print("User not logged in.");
//     }
//   }

//   //totel cash
//   double get totalCash {
//     return _filteredData.fold(0.0, (sum, item) {
//       double cashInValue = double.tryParse(item.cashIn ?? '0') ?? 0;
//       double cashOutValue = double.tryParse(item.cashout ?? '0') ?? 0;
//       return sum + cashInValue - cashOutValue;
//     });
//   }

//   void launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri)) {
//       throw 'Could not launch $url';
//     }
//   }
// }
//...................
import 'dart:developer';
import 'package:budgetly/model/dataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Datacontroller with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Datamodel> _allData = [];
  List<Datamodel> _filteredData = [];

  String selected = "All";

  List<Datamodel> get filteredData => _filteredData;

  // Search filtering
  void filterData(String query) {
    if (query.isEmpty) {
      _filteredData = List.from(_allData);
    } else {
      _filteredData = _allData
          .where((data) =>
              data.particular!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Fetch and set data with optional month filter
  Future<void> getdata([String? interval, String? monthFilter]) async {
    interval ??= "All";
    _allData = await fetchData(interval, monthFilter: monthFilter);
    _filteredData = List.from(_allData);
    notifyListeners();
  }

  void selectedColor(String filter) {
    if (selected != filter) {
      selected = filter;
      notifyListeners();
    }
  }

  Future<List<Datamodel>> fetchData(String interval,
      {String? monthFilter}) async {
    log("Fetching data: Interval = $interval, Month Filter = $monthFilter");
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in.");
      return [];
    }

    Query<Map<String, dynamic>> query = _firestore
        .collection('cash_book')
        .doc(user.uid)
        .collection('transactions');

    try {
      if (interval == 'Daily') {
        String today = DateFormat('dd-MM-yyyy').format(DateTime.now());
        query = query.where('date', isEqualTo: today);
      } else if (interval == 'Weekly') {
        DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
        String formatted = DateFormat('dd-MM-yyyy').format(sevenDaysAgo);
        query = query.where('date', isGreaterThanOrEqualTo: formatted);
      } else if (interval == 'Monthly' && monthFilter != null) {
        var allDocs = await query.get();
        return allDocs.docs
            .map((doc) => Datamodel.fromJson(doc.data(), doc.id))
            .where((data) {
          if (data.date != null) {
            try {
              DateTime parsed = DateFormat('dd-MM-yyyy').parse(data.date!);
              return DateFormat('MMMM').format(parsed) == monthFilter;
            } catch (e) {
              return false;
            }
          }
          return false;
        }).toList();
      } else if (interval == 'Monthly') {
        DateTime firstDayOfMonth =
            DateTime(DateTime.now().year, DateTime.now().month, 1);
        String formatted = DateFormat('dd-MM-yyyy').format(firstDayOfMonth);
        query = query.where('date', isGreaterThanOrEqualTo: formatted);
      }

      var querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) => Datamodel.fromJson(doc.data(), doc.id))
            .toList();
      } else {
        return [];
      }
    } on FirebaseException catch (e) {
      log("FirebaseException: ${e.message}");
      return [];
    }
  }

  // Add new transaction
  Future<void> addDatafireBase({required Datamodel data}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentReference docRef = await _firestore
            .collection('cash_book')
            .doc(user.uid)
            .collection('transactions')
            .add(data.toJson());

        await docRef.update({'id': docRef.id});
        getdata();
      } on FirebaseException catch (e) {
        log("Firebase error: ${e.message}");
      } catch (e) {
        log("Error adding data: $e");
      }
    } else {
      print("User not logged in.");
    }
  }

  // Update existing transaction
  Future<void> updateDatafireBase({
    required Datamodel oldData,
    required Datamodel newData,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && oldData.id != null) {
      try {
        await _firestore
            .collection('cash_book')
            .doc(user.uid)
            .collection('transactions')
            .doc(oldData.id)
            .update(newData.toJson());
        await getdata();
      } on FirebaseException catch (e) {
        log("Firebase update error: ${e.message}");
      } catch (e) {
        log("Error updating data: $e");
      }
    } else {
      print("User not logged in or document ID missing.");
    }
    notifyListeners();
  }

  // Delete transaction
  Future<void> deleteDatafireBase(String documentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('cash_book')
            .doc(user.uid)
            .collection('transactions')
            .doc(documentId)
            .delete();
        getdata();
      } on FirebaseException catch (e) {
        log("Firebase delete error: ${e.message}");
      } catch (e) {
        log("Error deleting data: $e");
      }
    } else {
      print("User not logged in.");
    }
  }

  // Calculate total cash = cashIn - cashOut
  double get totalCash {
    return _filteredData.fold(0.0, (sum, item) {
      double cashInValue = double.tryParse(item.cashIn ?? '0') ?? 0;
      double cashOutValue = double.tryParse(item.cashout ?? '0') ?? 0;
      return sum + cashInValue - cashOutValue;
    });
  }

  // Launch external URL
  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}
