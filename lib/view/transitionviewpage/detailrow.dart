import 'dart:io';

import 'package:budgetly/model/dataModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/widgets.dart' as pw;
Widget detailRow(String title, String value, IconData icon,
      {bool isCashIn = false, bool isCashOut = false}) {
    Color textColor = Colors.black87;
    Color iconColor = Colors.grey[600]!;

    if (isCashIn) {
      textColor = const Color(0XFF30CB76);
      iconColor = const Color(0XFF30CB76);
    }
    if (isCashOut) {
      textColor = const Color(0XFFF31717);
      iconColor = const Color(0XFFF31717);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> shareViaWhatsApp(BuildContext context, Datamodel data) async {
   

    String message = '''
Transaction Details:
Date: ${DateFormat('dd MMM yyyy').format(data.createdAt)}
Day: ${DateFormat('EEEE').format(data.createdAt)}
Time: ${DateFormat('hh:mm a').format(data.createdAt)}
Particular: ${data.particular ?? ""}
Cash In: ${data.cashIn ?? "0"}
Cash Out: ${data.cashout ?? "0"}
''';

    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = 'whatsapp://send?text=$encodedMessage';

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0XFF0008B4),
          content: const Text(
            "WhatsApp is not installed.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> generateAndSharePdf( BuildContext context, Datamodel data) async {
    final pdf = pw.Document();


    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Transaction Invoice',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text(
  'Date: ${DateFormat('dd MMM yyyy').format(data.createdAt)}',
),
pw.Text(
  'Day: ${DateFormat('EEEE').format(data.createdAt)}',
),
pw.Text(
  'Time: ${DateFormat('hh:mm a').format(data.createdAt)}',
),

                pw.SizedBox(height: 10),
                pw.Text('Particular: ${data.particular ?? ""}'),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Cash In',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('${data.cashIn ?? "0"}',
                        style: pw.TextStyle(color: PdfColors.green)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Cash Out',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('${data.cashout ?? "0"}',
                        style: pw.TextStyle(color: PdfColors.red)),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text('Thank you for your business!',
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              ],
            ),
          );
        },
      ),
    );

    try {
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/transaction_invoice.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)], text: 'Transaction Invoice');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
