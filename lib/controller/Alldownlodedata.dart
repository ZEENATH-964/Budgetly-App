import 'dart:io';
import 'package:budgetly/controller/login.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> downloadAllDataFromController(BuildContext context) async {
  final pdf = pw.Document();
  final usercontroller = Provider.of<UserController>(context, listen: false);

  try {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission denied")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('cash_book')
        .doc(user.uid)
        .collection('transactions')
        .get();

    final dataList = snapshot.docs.map((doc) => doc.data()).toList();

    if (dataList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No data available to export.")),
      );
      return;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text('${usercontroller.companyName}  All Transaction Data',
              style:
                  pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            border: pw.TableBorder.all(width: 0.5),
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: pw.TextStyle(fontSize: 10),
            headers: ['Date', 'Particular', 'Cash In', 'Cash Out'],
            data: dataList.map((data) {
              return [
                data['date'] ?? '',
                data['particular'] ?? '',
                data['cashin'].toString(),
                data['cashout'].toString(),
              ];
            }).toList(),
          ),
        ],
      ),
    );

    // Save PDF
    final dir = await getExternalStorageDirectory();
    final file = File(
        "${dir!.path}/all_transactions_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "All data PDF from SherSoft",
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PDF with table generated & shared!")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}
