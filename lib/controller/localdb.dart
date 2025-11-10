import 'dart:developer';

import 'package:budgetly/model/localdb.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

ValueNotifier<List<UserAcoountDb>> valueNotifier = ValueNotifier([]);

Future<void> addData(UserAcoountDb value) async {
  final db = await Hive.openBox<UserAcoountDb>('user-db');
  db.add(value);
  log(db.toString());
  getData();
}

Future<void> getData() async {
  final db = await Hive.openBox<UserAcoountDb>('user-db');
  valueNotifier.value.clear();
  valueNotifier.value.addAll(db.values);
  valueNotifier.notifyListeners();
}

Future<void> removedata(int index) async {
  final db = await Hive.openBox<UserAcoountDb>('user-db');
  await db.deleteAt(index);
  getData();
}
