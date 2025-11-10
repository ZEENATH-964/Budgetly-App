// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// Future<void> resetAllData(BuildContext context) async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("User not logged in")),
//     );
//     return;
//   }

//   try {
//     final transactionsRef = FirebaseFirestore.instance
//         .collection('cash_book')
//         .doc(user.uid)
//         .collection('transactions');

//     final snapshot = await transactionsRef.get();

//     for (var doc in snapshot.docs) {
//       await doc.reference.delete();
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("All data has been reset.")),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Error: ${e.toString()}")),
//     );
//   }
// }
//.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> resetAllDataController(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User not logged in")),
    );
    return false;
  }

  try {
    final transactionsRef = FirebaseFirestore.instance
        .collection('cash_book')
        .doc(user.uid)
        .collection('transactions');

    final snapshot = await transactionsRef.get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ All data has been reset.")),
    );

    return true;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error while resetting: ${e.toString()}")),
    );
    return false;
  }
}
