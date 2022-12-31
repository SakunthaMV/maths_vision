import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Home/home_screen.dart';
import 'package:maths_vision/Screens/Splashes/common_widgets.dart';

class OpenSplashScreen extends StatefulWidget {
  const OpenSplashScreen({Key key}) : super(key: key);

  @override
  _OpenSplashScreenState createState() => _OpenSplashScreenState();
}

class _OpenSplashScreenState extends State<OpenSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
      return Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return HomeScreen();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return splashCommon(
      context,
      middle: Text(
        'A Platform to Create a Vision\nfor Your Tomorrow.',
        style: TextStyle(
          fontSize: 20,
          color: colorScheme.primary,
          fontFamily: 'Lucida Fax Italic',
          height: 1.6,
          shadows: [
            Shadow(
              blurRadius: 3,
              color: Colors.black.withOpacity(0.5),
              offset: Offset(1.5, 1.5),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
