import 'package:flutter/material.dart';

Text userValues(BuildContext context, String value) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  return Text(
    value,
    style: TextStyle(
      fontFamily: 'Forte',
      fontSize: 18,
      color: colorScheme.onPrimary,
    ),
  );
}

Widget loginDialogActions(BuildContext context, {Widget screen}) {
  final TextTheme textTheme = Theme.of(context).textTheme;
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  return SizedBox(
    width: 100,
    child: ElevatedButton(
      onPressed: () {
        if (screen != null) {
          return Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) {
                return screen;
              },
            ),
          );
        }
        Navigator.pop(context, false);
      },
      child: Text(
        screen != null ? 'Log In' : 'Ok',
        style: textTheme.bodyLarge.copyWith(
          fontSize: 22,
          color: colorScheme.primary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        backgroundColor: colorScheme.onBackground,
      ),
    ),
  );
}
