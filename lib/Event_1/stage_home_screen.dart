import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Data_Directory/event_data.dart';
import 'package:maths_vision/Event_1/store.dart';
import 'package:maths_vision/Event_1/video_display_screen.dart';
import 'package:maths_vision/Screens/papers_screen.dart';
import 'package:maths_vision/Widgets/event_app_bar.dart';
import 'package:connectivity/connectivity.dart';

import '../Support_Classes/event_errors_and_loading.dart';
import '../Data_Directory/questions_data.dart';
import 'question_display_screen.dart';

class StageHomeScreen extends StatefulWidget {
  final String category;
  final int stage;

  const StageHomeScreen(this.category, this.stage, {Key key}) : super(key: key);

  @override
  _StageHomeScreenState createState() => _StageHomeScreenState();
}

class _StageHomeScreenState extends State<StageHomeScreen> {
  bool _hasConnection;
  StreamSubscription _subscription;

  Future<void> checkInternet() async {
    bool status = await InternetConnectionChecker().hasConnection;
    setState(() {
      _hasConnection = status;
    });
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      status = await InternetConnectionChecker().hasConnection;
      setState(() {
        _hasConnection = status;
      });
    });
  }

  User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    checkInternet();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: EventAppBar(
        backgroundColor: Color.fromARGB(255, 63, 129, 176),
      ),
      backgroundColor: Color.fromARGB(255, 1, 79, 134),
      body: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Builder(builder: (context) {
            if(_hasConnection==null){
              return Container(
                margin: EdgeInsets.only(top: 220),
                child: Center(
                  child: EventLoading(),
                ),
              );
            }
            if (!_hasConnection) {
              return Container(
                margin: EdgeInsets.only(top: 220),
                child: Center(
                  child: NetworkError(Colors.white),
                ),
              );
            }
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return SizedBox.shrink();
                }
                int level = snapshot.data['User_Details.level'];
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 230),
                  itemCount: questions['stage${widget.stage}'].length,
                  itemBuilder: (context, index) {
                    return _questionListItem(index, level);
                  },
                );
              }
            );
          }),
          Container(
            width: width,
            height: 220,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 63, 129, 176),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(90),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 7,
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 15,
            child: SizedBox(
              height: 140,
              width: 140,
              child: Image.asset('assets/Trigonometry_Stage_${widget.stage}.png'),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35, top: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _videoPlay(context, dialog: false),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 170,
                      height: 50,
                      child: Text(
                        widget.category,
                        style: TextStyle(
                          color: Colors.white,
                          height: 1,
                          fontSize: 17,
                          fontFamily: 'Abhaya Libre',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 2,
                              offset: Offset(0.5, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        child: Image.asset('assets/Unlock_Icon.png'),
                      ),
                      Positioned(
                        bottom: 7,
                        child: _avgQuestionUnlock(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Avg No of Unlock',
                        style: TextStyle(
                          fontFamily: 'Ebrima',
                          fontSize: 20,
                          color: Colors.white,
                          height: 1,
                          shadows: [
                            Shadow(
                              blurRadius: 3,
                              offset: Offset(1, 1),
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Questions in this stage',
                        style: TextStyle(
                          fontFamily: 'Lemon Jelly',
                          fontSize: 20,
                          color: Colors.white,
                          height: 0.9,
                          shadows: [
                            Shadow(
                              blurRadius: 2,
                              offset: Offset(1, 1),
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avgQuestionUnlock() {
    Widget loading = Center(
      child: LoadingAnimationWidget.threeRotatingDots(
        color: Colors.white,
        size: 20,
      ),
    );
    return Builder(
      builder: (context) {
        if(!(_hasConnection?? false)){
          return loading;
        }
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return loading;
              }
              int noOfUsers = userSnapshot.data.size;
              return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Events')
                      .doc('Trigonometry')
                      .collection('Stages')
                      .doc('Stage_${widget.stage}')
                      .snapshots(),
                  builder: (context, stageSnapshot) {
                    if (!stageSnapshot.hasData) {
                      return loading;
                    }
                    int unlockQuestions = stageSnapshot.data['TotalUnlocked'];
                    return RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'AgencyFB',
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: '${(unlockQuestions / noOfUsers).toStringAsFixed(1)}',
                          ),
                          TextSpan(
                            text: '/${questions['stage${widget.stage}'].length}',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            });
      }
    );
  }

  Widget _videoPlay(BuildContext context, {bool dialog}) {
    Widget loading = SizedBox(
      height: 70,
      child: LoadingAnimationWidget.threeArchedCircle(
        color: Colors.white,
        size: 40,
      ),
    );
    return Builder(
      builder: (context) {
        if(!(_hasConnection?? false)){
          return loading;
        }
        return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .collection('Trigonometry_Event')
                .doc('Stages')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return loading;
              }
              bool videoPurchased = snapshot.data['Stage_${widget.stage}.Info.Video.purchased'];
              return InkWell(
                onTap: () {
                  if (dialog) {
                    return null;
                  }
                  if (videoPurchased) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return VideoDisplayScreen(widget.stage);
                        },
                      ),
                    );
                  } else {
                    _videoBuyDialog(context);
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      width: 120,
                      height: 70,
                      padding: EdgeInsets.fromLTRB(0, 5, 12, 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 172, 140, 92),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 0.5,
                            color: Colors.black.withOpacity(0.7),
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 65,
                            height: 13,
                            margin: EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 111, 136, 147),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.3),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Trigonometry',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontFamily: 'Blenda Script',
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.3),
                                      offset: Offset(0.5, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Stage',
                                  style: TextStyle(
                                    fontFamily: 'Copperplate Gothic Light',
                                    fontSize: 17,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.35),
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${widget.stage == 10 ? '' : '0'}${widget.stage}',
                                      style: TextStyle(
                                        fontFamily: 'Blenda Script',
                                        fontSize: 13,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 2,
                                            color: Colors.black.withOpacity(0.35),
                                            offset: Offset(0.5, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Builder(builder: (context) {
                                double opacity = 0.0;
                                if (videoPurchased) {
                                  opacity = 1.0;
                                }
                                if (dialog) {
                                  opacity = 1.0;
                                }
                                return Opacity(
                                  opacity: opacity,
                                  child: Stack(
                                    alignment: AlignmentDirectional.centerStart,
                                    children: [
                                      Transform.rotate(
                                        angle: pi / 2,
                                        child: Container(
                                          width: 24,
                                          height: 19,
                                          margin: EdgeInsets.only(
                                            left: 1.5,
                                            bottom: 1,
                                          ),
                                          child: Image.asset(
                                            'assets/Play_Triangle.png',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.play_arrow,
                                        color: Colors.black,
                                        size: 23,
                                      )
                                    ],
                                  ),
                                );
                              }),
                              Text(
                                'Lesson',
                                style: TextStyle(
                                  fontFamily: 'Colonna MT',
                                  fontSize: 25,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.4),
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Builder(builder: (context) {
                      if (videoPurchased) {
                        return SizedBox.shrink();
                      }
                      if (dialog) {
                        return SizedBox.shrink();
                      }
                      return Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            width: 120,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 1, 79, 134).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Transform.scale(
                            scale: 1.3,
                            child: Stack(
                              alignment: AlignmentDirectional.centerStart,
                              children: [
                                Transform.rotate(
                                  angle: pi / 2,
                                  child: Container(
                                    width: 24,
                                    height: 19,
                                    margin: EdgeInsets.only(
                                      left: 1.5,
                                      bottom: 1,
                                    ),
                                    child: Image.asset(
                                      'assets/Play_Triangle.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                  size: 23,
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              );
            });
      }
    );
  }

  Widget _questionListItem(int index, int level) {
    final double width = MediaQuery.of(context).size.width;
    int rewardCoins = questions['stage${widget.stage}']['question${index + 1}']['coins'];
    int rewardXP = questions['stage${widget.stage}']['question${index + 1}']['xp'];
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        height: 110,
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .collection('Trigonometry_Event')
                .doc('Stages')
                .snapshots(),
            builder: (context, unlockSnapshot) {
              if (!unlockSnapshot.hasData) {
                return LoadingAnimationWidget.dotsTriangle(
                  color: Colors.white,
                  size: 40,
                );
              }
              int unlocks = unlockSnapshot.data['Stage_${widget.stage}.Info.completed'] + 1;
              return Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          if (index < unlocks) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return QuestionDisplayScreen(widget.stage, index + 1, level);
                                },
                              ),
                            );
                          }
                          return null;
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: width * 0.75,
                          height: 80,
                          margin: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 155, 192, 219),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                spreadRadius: 0,
                                color: Colors.black.withOpacity(0.4),
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        'Question No ${index < 9 ? '0' : ''}${index + 1}',
                                        style: TextStyle(
                                          fontFamily: 'AgencyFB',
                                          fontSize: 30,
                                          color: Colors.white,
                                          height: 1,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 4,
                                              offset: Offset(1, 1),
                                              color: Colors.black.withOpacity(0.7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Reward',
                                      style: TextStyle(
                                        fontFamily: 'Gothic',
                                        fontSize: 13,
                                        color: Color.fromARGB(255, 23, 66, 97),
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 2,
                                            offset: Offset(1, 1),
                                            color: Colors.black.withOpacity(0.4),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '$rewardCoins',
                                              style: TextStyle(
                                                fontFamily: 'Gothic',
                                                fontSize: 17,
                                                color: Colors.black,
                                                height: 1,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 1,
                                                    offset: Offset(1, 1),
                                                    color: Colors.black.withOpacity(0.4),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            SizedBox(
                                              width: 17,
                                              child: Image.asset('assets/Coin.png'),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '$rewardXP',
                                              style: TextStyle(
                                                fontFamily: 'Gothic',
                                                fontSize: 17,
                                                color: Colors.black,
                                                height: 1,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 1,
                                                    offset: Offset(1, 1),
                                                    color: Colors.black.withOpacity(0.4),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            SizedBox(
                                              width: 17,
                                              child: Image.asset('assets/XP.png'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 55,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 77, 131, 170),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(25),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      color: Colors.black.withOpacity(0.3),
                                      offset: Offset(-2, 0),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Accuracy',
                                      style: TextStyle(
                                        fontFamily: 'AgencyFB',
                                        fontSize: 13,
                                        color: Colors.white,
                                        height: 1,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 1,
                                            offset: Offset(1, 1),
                                            color: Colors.black.withOpacity(0.4),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Events')
                                          .doc('Trigonometry')
                                          .collection('Stages')
                                          .doc('Stage_${widget.stage}')
                                          .collection('Questions')
                                          .orderBy('Question', descending: false)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return LoadingAnimationWidget.threeRotatingDots(
                                            color: Colors.black,
                                            size: 25,
                                          );
                                        }
                                        List accuracyList = snapshot.data.docs;
                                        int completed = accuracyList[index]['Completed'];
                                        int correct = accuracyList[index]['Correct'];
                                        double accuracy =
                                            completed != 0 ? 100 * correct / completed : 0.0;
                                        return RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${accuracy.toStringAsFixed(0)}',
                                                style: TextStyle(
                                                  fontFamily: 'AgencyFB',
                                                  fontSize: 27,
                                                  color: Colors.black,
                                                  height: 1,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '%',
                                                style: TextStyle(
                                                  fontFamily: 'AgencyFB',
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                  height: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!(index < unlocks))
                        Container(
                          width: width * 0.75,
                          height: 80,
                          margin: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 20, 10, 108).withOpacity(0.6),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        width: 40,
                        height: 110,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 77, 131, 170),
                              Color.fromARGB(255, 155, 192, 219),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              spreadRadius: 0,
                              color: Colors.black.withOpacity(0.4),
                              offset: Offset(2, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 36,
                                  fontFamily: 'Ateeca',
                                ),
                                children: [
                                  TextSpan(
                                    text: 'S',
                                  ),
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: const Offset(1.0, 4.0),
                                      child: Text(
                                        '${widget.stage}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'Ateeca',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 36,
                                  fontFamily: 'Ateeca',
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Q',
                                  ),
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: const Offset(1.0, 4.0),
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'Ateeca',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                      if (!(index < unlocks))
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              width: 40,
                              height: 110,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 3, 1, 68).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            SizedBox(
                              height: 28,
                              child: Image.asset('assets/Lock_Icon.png'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }

  Future<void> _videoBuyDialog(BuildContext context) {
    CollectionReference userData = FirebaseFirestore.instance.collection('Users');
    DocumentReference stageData =
        userData.doc(user.uid).collection('Trigonometry_Event').doc('Stages');
    CollectionReference eventInfo = FirebaseFirestore.instance.collection('Events');
    DocumentReference stageInfo =
        eventInfo.doc('Trigonometry').collection('Stages').doc('Stage_${widget.stage}');
    int videoPrice = videoPrices[widget.stage - 1];
    return showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 60, 20, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 2.1,
                  child: _videoPlay(context, dialog: true),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 55, 10, 15),
                  child: Text(
                    'This Video will help you to solve the questions of the Stage '
                    '${widget.stage < 10 ? '0' : ''}${widget.stage}.',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 15,
                      letterSpacing: 0.0,
                      wordSpacing: 1.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Transform.scale(
                  scale: 0.9,
                  child: SizedBox(
                    width: 110,
                    height: 50,
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(user.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed: () async {
                              if (!_hasConnection) {
                                Fluttertoast.showToast(
                                  msg: "You don't have internet connection.",
                                );
                                return;
                              }
                              if (snapshot.hasData) {
                                int coins = snapshot.data['User_Details.coins'];
                                if (coins > videoPrice) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return VideoDisplayScreen(widget.stage);
                                      },
                                    ),
                                  );
                                  await userData.doc(user.uid).update({
                                    'User_Details.coins': FieldValue.increment(-videoPrice),
                                  });
                                  await stageData.update({
                                    'Stage_${widget.stage}.Info.Video.purchased': true,
                                  });
                                  await eventInfo.doc('All_Events').update({
                                    'AllVideoBought': FieldValue.increment(1),
                                  });
                                  await eventInfo.doc('Trigonometry').update({
                                    'TotalVideoBought': FieldValue.increment(1),
                                  });
                                  await stageInfo.update({
                                    'Video.PurchaseCount': FieldValue.increment(1),
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "You don't have enough coins.",
                                  );
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return Store();
                                      },
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 1, 79, 134),
                              padding: EdgeInsets.only(left: 3, right: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(width: 3, color: Colors.black),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  height: 35,
                                  width: 110,
                                  color: Colors.black,
                                ),
                                Builder(builder: (context) {
                                  if (widget.stage == 1) {
                                    return Text(
                                      'Free',
                                      style: TextStyle(
                                        fontFamily: 'Crash',
                                        fontSize: 23,
                                        color: Colors.white,
                                        height: 0.9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${videoPrices[widget.stage - 1]}',
                                        style: TextStyle(
                                          fontFamily: 'Crash',
                                          fontSize: 23,
                                          color: Colors.white,
                                          height: 0.9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: 23,
                                        child: Image.asset('assets/Coin.png'),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
