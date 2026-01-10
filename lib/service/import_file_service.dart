import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import '../model/import_transactiondb.dart';


class ImportTransactionFileService {
  /// Pick file (Excel / TXT)
  Future<void> pickAndImportFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'txt','pdf'],
    );

    if (result == null) return;

    final file = File(result.files.single.path!);
    final ext = path.extension(file.path);

    if (ext == '.xlsx') {
      await _importExcel(file);
    } else if (ext == '.txt') {
      await _importTxt(file);
    }else if(ext == '.pdf'){
      await _importPdf(file);
    }
  }

  // ================= EXCEL =================
  Future<void> _importExcel(File file) async {
    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      final rows = excel.tables[table]!.rows;

      // skip header row
      for (var row in rows.skip(1)) {
        final model = ImportTransactiondb(
          date: row[0]?.value?.toString(),
          cashIn: row[1]?.value?.toString() ?? '0',
          cashOut: row[2]?.value?.toString() ?? '0',
          particular: row[3]?.value?.toString(),
          category: row[4]?.value?.toString(),
          day: null,
          uid: null,
          time: null,
          pdfPath:file.path 
        );

   await     _saveToHive(model); // Hive function
      }
    }
  }

  // ================= TXT =================
  Future<void> _importTxt(File file) async {
    final lines = await file.readAsLines();

    for (var line in lines) {
      final parts = line.split(',');

      if (parts.length < 5) continue;

      final model = ImportTransactiondb(
        date: parts[0],
        cashIn: parts[1],
        cashOut: parts[2],
        particular: parts[3],
        category: parts[4],
        day: null,
        uid: null,
        time: null,
        pdfPath: file.path,
      );

    await  _saveToHive(model); 
    }
  }


  Future<void> _importPdf(File file) async {
  // Just store pdf as attachment (NO text extraction)

  final model = ImportTransactiondb(
    date: null,
    cashIn: '0',
    cashOut: '0',
    particular: path.basename(file.path), // file name
    category: 'PDF Attachment',
    day: null,
    uid: null,
    time: null,
    pdfPath: file.path, // IMPORTANT
  );

await  _saveToHive(model);
}

Future<void> _saveToHive(ImportTransactiondb model) async {
  final box = Hive.box<ImportTransactiondb>('import_transactions');
  await box.add(model);
}


}









