import 'dart:ui';

import 'package:flutter/material.dart';

Future<bool> willPopDialog(
  BuildContext context,
  String content, {
  List<Widget> actions,
  bool dismiss,
}) async {
  final TextTheme textTheme = Theme.of(context).textTheme;
  return await showDialog<bool>(
    context: context,
    barrierDismissible: dismiss?? true,
    builder: (c) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: WillPopScope(
        onWillPop: () async => Future.value(dismiss?? true),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: const EdgeInsets.fromLTRB(15, 25, 15, 5),
          content: Text(
            content,
            style: textTheme.displayMedium.copyWith(
              height: 1.5,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: actions,
        ),
      ),
    ),
  );
}
