import 'package:flutter/material.dart';

Widget roundedLogo(BuildContext context, {double size, bool border, Color borderColor, EdgeInsetsGeometry padding}) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  return Container(
    margin: padding,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 15,
          spreadRadius: 1,
        ),
      ],
      border: Border.all(
        color: borderColor ?? colorScheme.onPrimary,
        width: border!=null ? (3 / 100) * (size ?? 160) : 0,
      ),
    ),
    child: ClipOval(
      child: Image.asset('assets/HomeButton.jpg', width: size ?? 160),
    ),
  );
}
