import 'package:budgetly/constants/colors.dart';
import 'package:flutter/material.dart';

Padding loginform({
  required String label,
  required TextEditingController controller,
  required String hintText,
}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Appcolors.amabarcolors),
        ),
        SizedBox(height: 8),
        TextField(
          style: TextStyle(color: Appcolors.whitecolors),
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Appcolors.hintstylecolors),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Appcolors.greycolors,
                width: 0.5,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
