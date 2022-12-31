import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(BuildContext context,
    {String massage}) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final TextTheme textTheme = Theme.of(context).textTheme;
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
      content: Text(
        massage ?? 'Something Went Wrong.',
        style: textTheme.displayLarge.copyWith(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
