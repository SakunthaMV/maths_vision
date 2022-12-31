import 'package:flutter/material.dart';

Scaffold commonScaffold(BuildContext context, {Widget child}) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  return Scaffold(
    backgroundColor: colorScheme.background,
    body: SafeArea(
      child: child,
    ),
  );
}