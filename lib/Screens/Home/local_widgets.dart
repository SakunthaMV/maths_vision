import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Widget quitDialogActions(BuildContext context, String word) {
  final TextTheme textTheme = Theme.of(context).textTheme;
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  return TextButton(
    child: Text(
      word,
      style: textTheme.displayMedium.copyWith(
        height: 1.5,
        fontSize: 16,
        color: colorScheme.secondaryContainer,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () {
      if (word == 'No') {
        Navigator.pop(context, false);
      } else {
        SystemNavigator.pop();
      }
    },
  );
}

Widget homeTitles(BuildContext context, String title) {
  return Text(
    title,
    style: GoogleFonts.roboto(
      fontSize: 12.0,
      color: Theme.of(context).colorScheme.primary,
      letterSpacing: 2.5,
      shadows: [
        Shadow(
          blurRadius: 2,
          color: Colors.black.withOpacity(0.6),
          offset: Offset(0.5, 0.5),
        ),
      ],
    ),
  );
}
