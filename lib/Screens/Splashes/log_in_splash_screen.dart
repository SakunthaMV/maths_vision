import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Home/home_screen.dart';
import 'package:maths_vision/Screens/Splashes/common_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
