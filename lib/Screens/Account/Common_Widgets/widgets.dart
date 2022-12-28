import 'package:flutter/material.dart';

Container backgroundContainer(BuildContext context, {Widget child}){
  final double width = MediaQuery.of(context).size.width;
  return Container(
    width: width * 0.85,
    margin: const EdgeInsets.symmetric(vertical: 20.0),
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: width * 0.05),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.25),
          Colors.black.withOpacity(0.15),
          Colors.black.withOpacity(0.15),
          Colors.black.withOpacity(0.25),
        ],
      ),
    ),
    child: child,
  );
}