import 'package:budgetly/model/localdb.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

ValueNotifier<List<UserAcoountDb>> valueNotifier = ValueNotifier([]);

final Box<UserAcoountDb> db = Hive.box<UserAcoountDb>("user-db");

Future<void> addData(UserAcoountDb value)async {
 await db.add(value);
  getData();
}

void getData(){
  valueNotifier.value = db.values.toList();
}

Future<void> removedata(int index) async {
  await db.deleteAt(index);
  getData();
}
