import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Home/home_screen.dart';
import 'package:maths_vision/Screens/Splashes/common_widgets.dart';

class WentHomeSplashScreen extends StatefulWidget {
  const WentHomeSplashScreen({Key key}) : super(key: key);

  @override
  _WentHomeSplashScreenState createState() => _WentHomeSplashScreenState();
}

class _WentHomeSplashScreenState extends State<WentHomeSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1000), () {
      return Navigator.of(context).push(
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
    return splashCommon(context);
  }
}
