import 'package:flutter/material.dart';

Widget detailRow(String title, String value,
    {bool isCashIn = false, bool isCashOut = false}) {
  Color textColor = Colors.black;
  if (isCashIn) textColor = const Color(0XFF30CB76);
  if (isCashOut) textColor = const Color(0XFFF31717);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
