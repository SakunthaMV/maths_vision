import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Home/home_screen.dart';
import 'package:maths_vision/Screens/Splashes/common_widgets.dart';

class LogOutSplashScreen extends StatefulWidget {
  const LogOutSplashScreen({Key key}) : super(key: key);

  @override
  _LogOutSplashScreenState createState() => _LogOutSplashScreenState();
}

class _LogOutSplashScreenState extends State<LogOutSplashScreen> {

  StreamSubscription _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
      _subscription = FirebaseAuth.instance.authStateChanges().listen((event) {
        if(event==null){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) {
                return HomeScreen();
              },
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return splashCommon(
      context,
      middle: Text(
        'Good Bye !!!',
        style: TextStyle(
          fontSize: 45,
          color: Colors.white,
          fontFamily: 'Brush',
          height: 1,
          shadows: [
            Shadow(
              blurRadius: 3,
              color: Colors.black.withOpacity(0.6),
              offset: Offset(1.5, 1.5),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
