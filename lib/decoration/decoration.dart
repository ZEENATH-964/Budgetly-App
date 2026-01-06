
import 'package:flutter/material.dart';

Widget text(String text,
Color color,
double size,
FontWeight fontweight,
{int? maxLines,
  TextOverflow? overflow,
  TextAlign? textAlign,
  }
){
  return Text(
    
    text,style: TextStyle(color: color,fontSize: size,fontWeight:fontweight),
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign,
    );
}


Widget containers({
  required Widget child,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  double? width,
  double? height,
  double radius = 0,
  Color color = Colors.white,
    BorderRadius? borderRadius, 
  Border? border,
    Gradient? gradient, 
  List<BoxShadow>? shadow,
}) {
  return Container(
    width: width,
    height: height,
    padding: padding,
    margin: margin,
    decoration: BoxDecoration(
      color:gradient == null ? (color ?? Colors.white) : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      border: border,
      boxShadow: shadow,
    ),
    child: child,
  );
}
