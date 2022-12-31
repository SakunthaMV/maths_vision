import 'package:flutter/material.dart';

import '../../Utilities/check_internet.dart';
import '../toast.dart';

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
        final bool hasConnection = oneTimeCheck(context);
        if (screen == null) {
          Navigator.pop(context, false);
          return 0;
        }
        if (!hasConnection) {
          toast('You don\'t have Internet Connection.');
          return 0;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return screen;
            },
          ),
        );
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
