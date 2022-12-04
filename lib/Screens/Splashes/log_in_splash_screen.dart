import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class LogInSplashScreen extends StatefulWidget {
  const LogInSplashScreen({Key key}) : super(key: key);

  @override
  _LogInSplashScreenState createState() => _LogInSplashScreenState();
}

class _LogInSplashScreenState extends State<LogInSplashScreen> {
  String _userId;

  Future getValidationData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedUserId = sharedPreferences.getString('userId');
    setState(() {
      _userId = obtainedUserId;
    });
  }

  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
    getValidationData().whenComplete(() async {
      if (_userId != null) {
        await users
            .doc(_userId)
            .collection('Trigonometry_Event')
            .doc('Golden_Stage')
            .get()
            .then((doc) {
          if (!doc.exists) {
            users.doc(_userId).collection('Trigonometry_Event').doc('Golden_Stage').set({
              'Entry_Tasks': {
                'accuracyTask': false,
                'leaderboardTask': false,
                'loginTask': false,
                'rulesDialog': false,
              },
              'Stage_Info': {
                'completed': 0,
                'correct': 0,
                'xpEarned': 0,
              },
            });
          }
        });
        await users
            .doc(_userId)
            .collection('Trigonometry_Event')
            .doc('Event_Info')
            .get()
            .then((doc) {
          if (!doc.exists) {
            users.doc(_userId).collection('Trigonometry_Event').doc('Event_Info').set({
              'progress': 0.0,
              'totalCompleted': 0,
              'totalCorrect': 0,
              'xpEarned': 0,
              'currentRank': 0,
              'bestRank': 0,
              'goldenStageUnlocked': false,
            });
          }
        });
        await users
            .doc(_userId)
            .collection('Trigonometry_Event')
            .doc('Stages')
            .get()
            .then((doc) {
          if (!doc.exists) {
            for (int i = 1; i <= 10; i++) {
              users.doc(_userId).collection('Trigonometry_Event').doc('Stages').set({
                'Stage_$i': {
                  'Info': {
                    'completed': 0,
                    'correct': 0,
                    'xpEarned': 0,
                    'stage': i,
                    'Video': {
                      'purchased': false,
                      'liked': false,
                      'commented': false,
                    }
                  },
                  'Questions_Details': {
                    'Question_1': {
                      'correct': false,
                      'done': false,
                      'xpDoubleUsed': false,
                      'answerBought': false,
                      'question': 1,
                      'selectedValue': '',
                    }
                  }
                }
              }, SetOptions(merge: true));
            }
          }
        });
      }
      Timer(Duration(milliseconds: 1500), () {
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return HomeScreen();
            },
          ),
        );
      });
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
              alignment: Alignment(0, -0.4),
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
                    'Welcome To',
                    style: TextStyle(
                      fontSize: 38,
                      color: Colors.white,
                      fontFamily: 'Scriptina',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.7,
                      height: 1,
                      shadows: [
                        Shadow(
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.7),
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
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
                                ..color = Colors.black),
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
