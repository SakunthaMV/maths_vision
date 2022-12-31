import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget leadingPastPaper(BuildContext context, String topic, double spacing) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  return Container(
    width: 60,
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: colorScheme.primary,
      border: Border.all(color: colorScheme.tertiaryContainer, width: 4,)
    ),
    child: Center(
      child: FittedBox(
        child: Text(
          topic,
          style: GoogleFonts.freehand(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: colorScheme.tertiaryContainer,
            letterSpacing: spacing,
          ),
        ),
      ),
    ),
  );
}