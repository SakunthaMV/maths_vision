import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Account/Sign_Up/sign_up_screen.dart';

Widget cancelDialogActions(BuildContext context, String word) {
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
      if (word == 'OK') {
        Navigator.pop(context, false);
      } else {
        // FirebaseAuth.instance.signOut();
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return SignUpScreen();
            },
          ),
        );
      }
    },
  );
}
