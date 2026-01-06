import 'package:hive/hive.dart';
part 'import_transactiondb.g.dart';

@HiveType(typeId: 1)
class ImportTransactiondb{
  @HiveField(0)
  String cashIn;

  @HiveField(1)
  String cashOut;

  @HiveField(2)
  String? date;

  @HiveField(3)
  String? day;

  @HiveField(4)
  String? uid;

  @HiveField(5)
  String? time;

  @HiveField(6)
  String? particular;

  @HiveField(7)
  String? category;

  @HiveField(8)
String? pdfPath;


  ImportTransactiondb({
     required this.cashIn,
    required this.cashOut,
    required this.date,
    required this.day,
    required this.uid,
    required this.time,
    required this.particular,
    required this.category,
    required this.pdfPath
  });
}