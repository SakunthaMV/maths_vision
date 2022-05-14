import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maths_vision/Event_1/event_front_screen.dart';
import 'package:maths_vision/Event_1/event_home_screen.dart';
import 'package:shimmer/shimmer.dart';

class GoEventSplashScreen extends StatefulWidget {
  final String screen;

  const GoEventSplashScreen(this.screen, {Key key}) : super(key: key);

  @override
  _GoEventSplashScreenState createState() => _GoEventSplashScreenState();
}

class _GoEventSplashScreenState extends State<GoEventSplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1000), () {
      return Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return widget.screen == 'Event' ? EventHomeScreen() : EventFrontScreen();
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
        backgroundColor: Color.fromARGB(255, 1, 79, 134),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
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
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Guidance for the Combat with The Examination.',
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.white,
                      fontFamily: 'Pristina',
                      height: 1.2,
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
                              ..strokeWidth = 1.2
                              ..color = Color.fromARGB(255, 176, 232, 255),
                          ),
                        ),
                        Text(
                          'MATHS VISION',
                          style: TextStyle(
                            fontFamily: 'Aquire Bold',
                            fontSize: 45,
                            color: Color.fromARGB(255, 30, 16, 95),
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.4),
                                offset: Offset(0, 1),
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
                            offset: Offset(0, 3),
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
                            color: Color.fromARGB(255, 125, 169, 187),
                            shadows: [
                              Shadow(
                                blurRadius: 1,
                                color: Colors.black.withOpacity(0.6),
                                offset: Offset(1, 1),
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
