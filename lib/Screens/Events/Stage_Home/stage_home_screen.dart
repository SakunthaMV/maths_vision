import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Screens/Basic/Papers/Categorized_List/papers_screen.dart';
import 'package:maths_vision/Widgets/event_app_bar.dart';
import 'package:connectivity/connectivity.dart';

import '../Common_Widgets/reward_class.dart';
import '../Common_Widgets/video_button.dart';
import '../../../Widgets/event_errors_and_loading.dart';
import '../../../Models/questions_data.dart';
import '../Question_Display/question_display_screen.dart';

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
                    VideoButton(widget.stage, false),
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
                                        RewardClass(fontSize: 17.0).coinReward(rewardCoins),
                                        RewardClass(fontSize: 17.0).xpReward(rewardXP, false),
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
}
