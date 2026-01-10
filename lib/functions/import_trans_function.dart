// import 'package:budgetly/model/import_transactiondb.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';


//   final Box<ImportTransactiondb> tdb =
//       Hive.box<ImportTransactiondb>('import_transactions');

//   final ValueNotifier<List<ImportTransactiondb>> transactionNotifier =
//       ValueNotifier([]);

//   void addTransaction(ImportTransactiondb value) {
//     tdb.add(value);
//     getTransaction();
//   }

//   void getTransaction() {
//     transactionNotifier.value = tdb.values.toList();
//   }

//   void removeTransaction(int index) async {
//     await tdb.deleteAt(index);
//     getTransaction();
//   }

//   void clearAll() async {
//     await tdb.clear();
//     getTransaction();
//   }

