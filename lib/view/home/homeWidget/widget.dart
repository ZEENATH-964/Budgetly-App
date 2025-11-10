  import 'package:flutter/material.dart';

Container containerButton({required String text,required Color color}) {
    return Container(
          height: 44,
          width: 170,
child: Center(child: Text(text,style: TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 15,
  color: Color(0XFFFFFFFF)
),),),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          color: color,
        ),);
  }