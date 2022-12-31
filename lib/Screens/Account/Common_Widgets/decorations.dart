import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration inputDeco(BuildContext context, String label) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final TextTheme textTheme = Theme.of(context).textTheme;
  return InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.primary,
      ),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.error,
      ),
    ),
    errorStyle: textTheme.bodyLarge.copyWith(
      color: colorScheme.onTertiary,
      fontSize: 12,
      letterSpacing: 0.3,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 1,
          offset: Offset(0.5, 0.5),
        ),
      ],
    ),
    contentPadding: EdgeInsets.only(bottom: 0, top: 0),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.onPrimary,
      ),
    ),
    labelText: label,
    labelStyle: GoogleFonts.roboto(
      fontSize: 22,
      color: colorScheme.primary,
      letterSpacing: 0.5,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 1,
          offset: Offset(1, 1),
        ),
      ],
    ),
  );
}