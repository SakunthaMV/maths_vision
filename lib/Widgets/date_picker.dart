import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<DateTime> datePicker(BuildContext context, TextEditingController controller) async {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final TextTheme textTheme = Theme.of(context).textTheme;
  DateTime pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1960),
    lastDate: DateTime.now(),
    confirmText: 'Done',
    cancelText: 'Cancel',
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: colorScheme.background,
            onPrimary: colorScheme.primary,
            onSurface: colorScheme.onPrimary,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onPrimary,
              textStyle: textTheme.bodySmall,
            ),
          ),
        ),
        child: child,
      );
    },
  );
  if (pickedDate != null) {
    String formatted = DateFormat('dd-MMM-yyyy').format(pickedDate);
    controller.text = formatted;
  }
  return pickedDate;
}