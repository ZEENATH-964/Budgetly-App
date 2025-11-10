import 'package:flutter/material.dart';

Container accountContainer(BuildContext context, Color color, String text) {
  return Container(
    width: MediaQuery.of(context).size.width / 1.8,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: color,
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
  );
}
