
import 'package:budgetly/controller/dataController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

Future<void> generateMonthlyPdfReport(
  BuildContext context, {
  String? company,
  String? selectedMonth,
}) async {
  final pdf = pw.Document();
  final dataProvider = Provider.of<Datacontroller>(context, listen: false);

  await dataProvider.getdata('Monthly', selectedMonth);

  final dataList = dataProvider.filteredData;

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return [
          pw.Center(
            child: pw.Column(
              children: [
                if (company != null)
                  pw.Text(company,
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.Text(
                  'Monthly Report',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                if (selectedMonth != null)
                  pw.Text('Month: $selectedMonth',
                      style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 20),
              ],
            ),
          ),
          pw.Table.fromTextArray(
            headers: ['Date', 'Particular', 'Cash In', 'Cash Out'],
            data: dataList.map((data) {
              return [
                DateFormat('dd MMM yyyy').format(data.createdAt),

                data.particular ?? '',
                data.cashIn ?? '0',
                data.cashout ?? '0'
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(color: PdfColors.blue100),
            cellHeight: 25,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
            },
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                'Total Cash: ₹${dataProvider.totalCash().toStringAsFixed(2)}',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ];
      },
    ),
  );

  // Save and share the PDF
  final pdfBytes = await pdf.save();
  await Printing.sharePdf(
      bytes: pdfBytes, filename: 'MonthlyReport_${selectedMonth ?? "All"}.pdf');
}
