import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Home/home_screen.dart';
import 'package:maths_vision/Screens/Splashes/common_widgets.dart';

class LogInSplashScreen extends StatefulWidget {
  const LogInSplashScreen({Key key}) : super(key: key);

  @override
  _LogInSplashScreenState createState() => _LogInSplashScreenState();
}

class _LogInSplashScreenState extends State<LogInSplashScreen> {

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
    final TextTheme textTheme = Theme.of(context).textTheme;
    return splashCommon(
      context,
      middle: Text(
        'Welcome To',
        style: textTheme.labelLarge.copyWith(
          fontSize: 38,
          letterSpacing: 1.7,
          height: 1,
          shadows: [
            Shadow(
              blurRadius: 3,
              color: Colors.black.withOpacity(0.6),
              offset: Offset(1.5, 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
