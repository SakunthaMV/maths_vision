import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Home/home_screen.dart';
import 'package:shimmer/shimmer.dart';

class LogOutSplashScreen extends StatefulWidget {
  const LogOutSplashScreen({Key key}) : super(key: key);

  @override
  _LogOutSplashScreenState createState() => _LogOutSplashScreenState();
}

class _LogOutSplashScreenState extends State<LogOutSplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
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
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              color: Color.fromARGB(255, 0, 135, 145),
            ),
            Opacity(
              opacity: 0.12,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/HomeBackground.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -0.35),
              child: Container(
                width: 230,
                height: 230,
                child: Image.asset('assets/Loading_Icon.png'),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 120,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Good Bye !!!',
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      fontFamily: 'Brush',
                      height: 1,
                      shadows: [
                        Shadow(
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.7),
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        Text(
                          'MATHS VISION',
                          style: TextStyle(
                            fontFamily: 'Aquire Bold',
                            fontSize: 45,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1.5
                              ..color = Colors.black,
                          ),
                        ),
                        Text(
                          'MATHS VISION',
                          style: TextStyle(
                            fontFamily: 'Aquire Bold',
                            fontSize: 45,
                            color: Color.fromARGB(255, 0, 70, 98),
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.4),
                                offset: Offset(0,1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 130,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7,
                            spreadRadius: 0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(0.5, 3),
                          ),
                        ],
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Colors.black,
                        highlightColor: Colors.white,
                        child: Text(
                          'NEXT LEVEL',
                          style: TextStyle(
                            fontFamily: 'AgencyFB',
                            fontSize: 30,
                            color: Color.fromARGB(255, 1, 79, 134),
                            shadows: [
                              Shadow(
                                blurRadius: 1,
                                color: Colors.black.withOpacity(0.6),
                                offset: Offset(1,1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
