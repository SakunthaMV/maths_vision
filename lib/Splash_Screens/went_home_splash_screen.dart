import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class WentHomeSplashScreen extends StatefulWidget {
  const WentHomeSplashScreen({Key key}) : super(key: key);

  @override
  _WentHomeSplashScreenState createState() => _WentHomeSplashScreenState();
}

class _WentHomeSplashScreenState extends State<WentHomeSplashScreen> {
  String _userId;

  Future getValidationData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedUserId = sharedPreferences.getString('userId');
    setState(() {
      _userId = obtainedUserId;
    });
  }

  @override
  void initState() {
    super.initState();
    getValidationData().whenComplete(
      () {
        Timer(
          Duration(milliseconds: 1000),
          () {
            return Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return _userId == null
                      ? HomeScreen(loggedIn: false)
                      : HomeScreen(loggedIn: true,userId: _userId);
                },
              ),
            );
          },
        );
      },
    );
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
              alignment: Alignment(0, -0.3),
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
