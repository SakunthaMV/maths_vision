import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget quitDialogActions(BuildContext context, String word){
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
      if(word=='No'){
        Navigator.pop(context, false);
      } else {
        SystemNavigator.pop();
      }
    },
  );
}

Widget homeTitles(BuildContext context, String title){
  return Text(
    title,
    style: Theme.of(context).textTheme.displaySmall.copyWith(
      letterSpacing: 2.5,
      fontWeight: FontWeight.bold,
    ),
  );
}