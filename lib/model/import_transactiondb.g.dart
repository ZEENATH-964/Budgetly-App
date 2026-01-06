// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_transactiondb.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImportTransactiondbAdapter extends TypeAdapter<ImportTransactiondb> {
  @override
  final int typeId = 1;

  @override
  ImportTransactiondb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImportTransactiondb(
      cashIn: fields[0] as String,
      cashOut: fields[1] as String,
      date: fields[2] as String?,
      day: fields[3] as String?,
      uid: fields[4] as String?,
      time: fields[5] as String?,
      particular: fields[6] as String?,
      category: fields[7] as String?,
      pdfPath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ImportTransactiondb obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.cashIn)
      ..writeByte(1)
      ..write(obj.cashOut)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.day)
      ..writeByte(4)
      ..write(obj.uid)
      ..writeByte(5)
      ..write(obj.time)
      ..writeByte(6)
      ..write(obj.particular)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.pdfPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImportTransactiondbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
