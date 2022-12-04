import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maths_vision/Screens/Account/Details/account_details.dart';
import 'package:maths_vision/Widgets/event_errors_and_loading.dart';
import 'package:maths_vision/Screens/Events/Event_Home/event_front_screen.dart';
import 'package:maths_vision/Screens/Special/Store/store.dart';
import 'package:maths_vision/Screens/Events/Golden_Stage/Question_Display/golden_question_screen.dart';
import 'package:maths_vision/Screens/Events/Golden_Stage/Golden_Leaderboard/goldenboard.dart';
import 'package:maths_vision/Screens/Events/Golden_Stage/Information/rewards_screen.dart';
import 'package:maths_vision/Screens/Events/Golden_Stage/Information/rules_screen.dart';
import 'package:maths_vision/Screens/Basic/Papers/Categorized_List/papers_screen.dart';
import 'package:maths_vision/Screens/Splashes/went_home_splash_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GoldenStageHomeScreen extends StatefulWidget {
  const GoldenStageHomeScreen({Key key}) : super(key: key);

  @override
  _GoldenStageHomeScreenState createState() => _GoldenStageHomeScreenState();
}

class _GoldenStageHomeScreenState extends State<GoldenStageHomeScreen> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  User user;
  DocumentSnapshot _userData;
  DocumentSnapshot _stageData;
  String Q = 'Questions';
  List _goldenList;
  int _userRank;
  Query data = FirebaseFirestore.instance
      .collection('Users')
      .where('User_Details.average_time', isGreaterThan: 0)
      .orderBy(
        'User_Details.average_time',
      );

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    initConnectivity();
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    userData.snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _userData = doc;
      });
    });
    userData.collection('Trigonometry_Event').doc('Golden_Stage').snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _stageData = doc;
      });
    });
    data.snapshots().listen((docs) {
      if (!mounted) {
        return;
      }
      setState(() {
        _goldenList = docs.docs.toList();
      });
    });
    Future.delayed(Duration(seconds: 1)).whenComplete(() {
      if (_stageData != null) {
        if (!_stageData['Entry_Tasks.rulesDialog']) {
          _neverShowAgainPopup(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    int sumOfN = 0;
    int xp = _userData != null ? _userData['User_Details.xp'] : 0;
    int sumOfBeforeN = 0;
    int currentLevelXP;
    int level;
    int currentLevelTotalXP;
    for (int i = 1; i < 150; i += 1) {
      level = i;
      sumOfN += i;
      sumOfBeforeN += i - 1;
      int levelNValue = sumOfN * 10;
      int levelBeforeNValue = sumOfBeforeN * 10;
      if (levelNValue > xp) {
        currentLevelXP = xp - levelBeforeNValue;
        currentLevelTotalXP = levelNValue - levelBeforeNValue;
        break;
      }
    }
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return EventFrontScreen(
                goldenStage: true,
              );
            },
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 1, 79, 134),
        body: _connectionStatus == 'ConnectivityResult.wifi' ||
                _connectionStatus == 'ConnectivityResult.mobile'
            ? _userData != null && _stageData != null
                ? Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 225),
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 75, bottom: 10),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.05,
                                right: width * 0.05,
                                top: 18,
                                bottom: 18,
                              ),
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      initConnectivity().whenComplete(() {
                                        if (_connectionStatus == 'ConnectivityResult.wifi' ||
                                            _connectionStatus == 'ConnectivityResult.mobile') {
                                          if (_stageData[
                                                  '$Q.Question_${index + 1}.stepOneCompleted'] &&
                                              !_stageData[
                                                  '$Q.Question_${index + 1}.stepTwoCompleted']) {
                                            _questionPayPopup(context, index, 1, level);
                                          } else if (_stageData[
                                                  '$Q.Question_${index + 1}.stepOneCompleted'] &&
                                              !_stageData[
                                                  '$Q.Question_${index + 1}.completed']) {
                                            _questionPayPopup(context, index, 2, level);
                                          } else if (_stageData[
                                              '$Q.Question_${index + 1}.completed']) {
                                            _questionCompletePopup(context, index);
                                          } else {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) {
                                                  return GoldenQuestionScreen(
                                                      index + 1, _stageData['order'], level);
                                                },
                                              ),
                                            );
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: 'You are not connected to the internet.',
                                            fontSize: 16,
                                          );
                                        }
                                      });
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(255, 77, 131, 170),
                                                Color.fromARGB(255, 105, 153, 188),
                                                Colors.white,
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3,
                                                spreadRadius: 1,
                                                color: Colors.black.withOpacity(0.4),
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 15, right: 10),
                                                    child: Stack(
                                                      alignment: AlignmentDirectional.center,
                                                      children: [
                                                        _stageData[
                                                                '$Q.Question_${index + 1}.unlocked']
                                                            ? Container(
                                                                width: 30,
                                                                height: 30,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors.black),
                                                                  shape: BoxShape.circle,
                                                                ),
                                                              )
                                                            : SizedBox(
                                                                width: 30,
                                                                height: 30,
                                                              ),
                                                        _questionState(index),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    'Question',
                                                    style: TextStyle(
                                                      fontFamily: 'AgencyFB',
                                                      fontSize: 30,
                                                      letterSpacing: 0.3,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              FittedBox(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '450',
                                                      style: TextStyle(
                                                        fontFamily: 'Gothic',
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          right: 15, left: 5),
                                                      child: SizedBox(
                                                        width: 35,
                                                        height: 35,
                                                        child: Image.asset('assets/XP.png'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 50),
                                          child: Stack(
                                            alignment: AlignmentDirectional.center,
                                            children: [
                                              SizedBox(
                                                width: 60,
                                                height: 60,
                                                child: CustomPaint(
                                                  painter: RingPainter(),
                                                  child: Container(),
                                                ),
                                              ),
                                              _questionMiddleState(index),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  !_stageData['$Q.Question_${index + 1}.unlocked']
                                      ? Stack(
                                          alignment: AlignmentDirectional.center,
                                          children: [
                                            Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(40),
                                                  color: Color.fromARGB(255, 0, 33, 56)
                                                      .withOpacity(0.5)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 50),
                                              child: Stack(
                                                alignment: AlignmentDirectional.center,
                                                children: [
                                                  SizedBox(
                                                    width: 60,
                                                    height: 60,
                                                    child: CustomPaint(
                                                      painter: RingPainterShade(),
                                                      child: Container(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              left: 15,
                                              child: SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: Image.asset('assets/Lock_Icon.png'),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: width,
                        height: 290,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 239, 197, 1),
                              Color.fromARGB(255, 249, 224, 159),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
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
                        top: 110,
                        right: 15,
                        child: SizedBox(
                          height: 140,
                          width: 140,
                          child: Image.asset('assets/Trigonometry_Golden_Stage_Enter.png'),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 15,
                            right: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return GoldenBoard();
                                      },
                                    ),
                                  );
                                },
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            spreadRadius: 0,
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 43,
                                      height: 43,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 243, 243, 243),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/Golden_Stage_Leaderboard_Icon.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return Store();
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 95,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12.5),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 5,
                                            color: Colors.black.withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 4),
                                            child: SizedBox(
                                              child: Image.asset('assets/Coin.png'),
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          Text(
                                            '${_userData['User_Details.coins']}',
                                            style: TextStyle(
                                              fontFamily: 'Forte',
                                              fontSize: 17,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 4),
                                            child: Container(
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color.fromARGB(255, 139, 205, 250),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Stack(
                                    alignment: AlignmentDirectional.centerEnd,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 42),
                                        child: LinearPercentIndicator(
                                          width: 100.0,
                                          lineHeight: 20.0,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          animationDuration: 1000,
                                          percent: 1 * currentLevelXP / currentLevelTotalXP,
                                          barRadius: Radius.circular(10),
                                          progressColor: Color.fromARGB(255, 111, 164, 200),
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(255, 55, 82, 100),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 3,
                                                  color: Colors.black.withOpacity(0.4),
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$level',
                                                style: TextStyle(
                                                  fontFamily: 'Cambria',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 3,
                                                      color: Colors.black.withOpacity(0.4),
                                                      offset: Offset(1, 1),
                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  spreadRadius: 0,
                                                  blurRadius: 8,
                                                ),
                                              ],
                                            ),
                                            child: ClipOval(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) {
                                                        return AccountScreen();
                                                      },
                                                    ),
                                                  );
                                                },
                                                onLongPress: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) {
                                                        return WentHomeSplashScreen();
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Stack(
                                                  alignment: AlignmentDirectional.center,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    ClipOval(
                                                      child: SizedBox(
                                                        width: 45,
                                                        height: 45,
                                                        child:
                                                            _userData['User_Details.photoURL'] !=
                                                                    null
                                                                ? CachedNetworkImage(
                                                                    fit: BoxFit.cover,
                                                                    imageUrl: _userData[
                                                                        'User_Details.photoURL'],
                                                                    placeholder: (_, url) {
                                                                      return CircularProgressIndicator();
                                                                    },
                                                                    errorWidget:
                                                                        (context, url, error) {
                                                                      return Icon(Icons.error);
                                                                    },
                                                                  )
                                                                : Icon(
                                                                    Icons.account_circle_rounded,
                                                                    size: 45,
                                                                    color: Color.fromARGB(
                                                                        255, 202, 202, 202),
                                                                  ),
                                                      ),
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
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100, left: 15),
                        child: SizedBox(
                          width: width * 0.55,
                          child: Column(
                            children: [
                              FittedBox(
                                child: Text(
                                  'GOLDEN STAGE',
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4,
                                        color: Colors.black.withOpacity(0.35),
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.47,
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  'We warmly welcome you to the paradise of the best of the best.',
                                  style: TextStyle(
                                    fontFamily: 'Lemon Jelly',
                                    fontSize: 25,
                                    color: Colors.black,
                                    height: 0.8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      width: 100,
                                      child: ElevatedButton(
                                        onPressed:
                                            _stageData['Stage_Info.stepOneCompleted'] == 10 &&
                                                    !_stageData['Stage_Info.finished']
                                                ? () {
                                                    if (_goldenList.length >= 20) {
                                                      for (int i = 0;
                                                          i < _goldenList.length;
                                                          i++) {
                                                        if (_goldenList[i]
                                                                ['User_Details.userId'] ==
                                                            user.uid) {
                                                          setState(() {
                                                            _userRank = i + 1;
                                                          });
                                                        }
                                                      }
                                                      _finishPopup(context);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            'You still can\'t finish the Golden Stage.'
                                                            'You have to wait until, there are more than 20 competitors on the GoldenBoard.',
                                                        fontSize: 16,
                                                      );
                                                    }
                                                  }
                                                : null,
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40),
                                            gradient:
                                                _stageData['Stage_Info.stepOneCompleted'] ==
                                                            10 &&
                                                        !_stageData['Stage_Info.finished']
                                                    ? LinearGradient(
                                                        colors: [
                                                          Color.fromARGB(255, 226, 191, 11),
                                                          Color.fromARGB(255, 229, 194, 27),
                                                          Color.fromARGB(255, 249, 223, 157),
                                                          Color.fromARGB(255, 229, 194, 27),
                                                          Color.fromARGB(255, 226, 191, 11),
                                                        ],
                                                        begin: Alignment.bottomLeft,
                                                        end: Alignment.topRight,
                                                      )
                                                    : LinearGradient(
                                                        colors: [
                                                          Color.fromARGB(255, 181, 183, 187),
                                                          Color.fromARGB(255, 168, 169, 173),
                                                          Color.fromARGB(255, 216, 216, 216),
                                                          Color.fromARGB(255, 168, 169, 173),
                                                          Color.fromARGB(255, 181, 183, 187),
                                                        ],
                                                        begin: Alignment.bottomLeft,
                                                        end: Alignment.topRight,
                                                      ),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3,
                                                color: Colors.black.withOpacity(0.4),
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              _stageData['Stage_Info.finished']
                                                  ? 'FINISHED'
                                                  : 'FINISH',
                                              style: TextStyle(
                                                fontFamily: 'Roboto Regular',
                                                fontSize: _stageData['Stage_Info.finished']
                                                    ? 16
                                                    : 18,
                                                color: Colors.white,
                                                letterSpacing:
                                                    _stageData['Stage_Info.finished']
                                                        ? 1.2
                                                        : 2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(0),
                                          shape: StadiumBorder(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 35,
                                      width: 35,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) {
                                                return RulesScreen();
                                              },
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40),
                                            color: Color.fromARGB(255, 239, 197, 4),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3,
                                                color: Colors.black.withOpacity(0.4),
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 3, right: 1),
                                            child: Image.asset('assets/Rules_Icon.png'),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(0),
                                          shape: StadiumBorder(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 35,
                                      width: 35,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) {
                                                return RewardScreen();
                                              },
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40),
                                            color: Color.fromARGB(255, 239, 197, 4),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3,
                                                color: Colors.black.withOpacity(0.4),
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 6, top: 4),
                                            child: Image.asset('assets/Rewords_Icon.png'),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(0),
                                          shape: StadiumBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : EventLoading()
            : Center(
                child: NetworkError(Colors.white),
              ),
      ),
    );
  }

  Widget _questionState(int index) {
    String N = 'Question_${index + 1}';
    if (_stageData['$Q.$N.stepOneCompleted'] &&
        !_stageData['$Q.$N.stepTwoCompleted'] &&
        !_stageData['$Q.$N.completed']) {
      return Text(
        '1',
        style: TextStyle(
          fontSize: 25,
          fontFamily: 'Arial',
          color: Colors.black,
        ),
      );
    } else if (_stageData['$Q.$N.stepTwoCompleted'] && !_stageData['$Q.$N.completed']) {
      return Text(
        '2',
        style: TextStyle(
          fontSize: 25,
          fontFamily: 'Arial',
          color: Colors.black,
        ),
      );
    } else if (_stageData['$Q.$N.correct'] && _stageData['$Q.$N.completed']) {
      return SizedBox(
        width: 20,
        height: 20,
        child: Image.asset('assets/Complete_Icon.png'),
      );
    } else if (!_stageData['$Q.$N.correct'] && _stageData['$Q.$N.completed']) {
      return SizedBox(
        width: 20,
        height: 20,
        child: Image.asset('assets/Complete_Incorrect.png'),
      );
    } else if (_stageData['$Q.$N.unlocked']) {
      return Text(
        '?',
        style: TextStyle(
          fontSize: 25,
          fontFamily: 'Arial',
          color: Colors.black,
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _questionMiddleState(int index) {
    String N = 'Question_${index + 1}';
    if ((_stageData['$Q.$N.stepOneCompleted'] || _stageData['$Q.$N.stepTwoCompleted']) &&
        !_stageData['$Q.$N.completed']) {
      return Container(
        width: 60,
        height: 60,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 2, 53, 89),
        ),
        child: Image.asset('assets/Lock_Icon.png'),
      );
    } else if (_stageData['$Q.$N.completed'] && _stageData['$Q.$N.correct']) {
      return SizedBox(
        width: 35,
        height: 35,
        child: Image.asset('assets/${_stageData['order'][index]}_Gold_Outer.png'),
      );
    } else {
      return Text(
        '${index == 9 ? '' : '0'}${index + 1}',
        style: TextStyle(
          fontSize: 33,
          fontFamily: 'Arial',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          shadows: [
            Shadow(
              blurRadius: 4,
              offset: Offset(1, 2),
              color: Colors.black.withOpacity(0.4),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _questionPayPopup(BuildContext context, int index, int value, int level) async {
    String N = 'Question_${index + 1}';
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
            actionsPadding: EdgeInsets.only(right: 10, bottom: 5),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: StadiumBorder(),
                  side: BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  ),
                ),
              ),
            ],
            contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Question',
                        style: TextStyle(
                          fontFamily: 'AgencyFB',
                          fontSize: 33,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' ${index == 9 ? '' : '0'}${index + 1}',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 33,
                          color: Colors.black,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    'The time you had taken until the ${value == 1 ? 'first' : 'second'} part.',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 1, 79, 134),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 15),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    '${StopWatchTimer.getDisplayTime(_stageData['$Q.$N.timeElapsed'], milliSecond: false)}',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 23,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  'As you have already seen the first part${value == 2 ? ' and the second part' : ''} of the following question, coins will be deducted in order to unlock it again.',
                  style: TextStyle(
                    fontFamily: 'Calisto MT Italic',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                Transform.scale(
                  scale: 0.9,
                  child: Container(
                    width: 110,
                    height: 50,
                    margin: EdgeInsets.only(top: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        _questionPayUpdates(value, index, level);
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${value == 1 ? '50' : '100'}',
                                style: TextStyle(
                                  fontFamily: 'Crash',
                                  fontSize: 25,
                                  color: Colors.white,
                                  height: 0.9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 25,
                                child: Image.asset('assets/Coin.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _questionPayUpdates(int value, int index, int level) async {
    String N = 'Question_${index + 1}';
    String S = 'Stage_Info';
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    CollectionReference eventsData = FirebaseFirestore.instance.collection('Events');
    if (value == 1) {
      if (_userData['User_Details.coins'] > 50) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return GoldenQuestionScreen(index + 1, _stageData['order'], level);
            },
          ),
        );
        await userData.update({
          'User_Details.coins': FieldValue.increment(-50),
        });
        await userData.collection('Trigonometry_Event').doc('Golden_Stage').update({
          '$Q.$N.stepOneBought': true,
          '$Q.$N.stepOneCompleted': false,
          '$S.totalTimeElapsed': FieldValue.increment(-_stageData['$Q.$N.timeElapsed']),
          '$S.unlocked': FieldValue.increment(-1),
          '$S.stepOneCompleted': FieldValue.increment(-1),
        });
        await eventsData.doc('All_Events').update({
          'Golden_Stages.AllStepOneBought': FieldValue.increment(1),
        });
        await eventsData.doc('Trigonometry').collection('Stages').doc('Golden_Stage').update({
          'Stage_Info.TotalStepOneBought': FieldValue.increment(1),
          'Questions_Info.Question_${_stageData['order'][index]}.StepOneBought':
              FieldValue.increment(1),
        });
      } else {
        Fluttertoast.showToast(
          msg: "You don't have enough coins.",
          fontSize: 18,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 1, 79, 134).withOpacity(0.8),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return Store();
            },
          ),
        );
      }
    } else {
      if (_userData['User_Details.coins'] > 100) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return GoldenQuestionScreen(index + 1, _stageData['order'], level);
            },
          ),
        );
        await userData.update({
          'User_Details.coins': FieldValue.increment(-100),
        });
        await userData.collection('Trigonometry_Event').doc('Golden_Stage').update({
          '$Q.$N.stepTwoBought': true,
          '$Q.$N.stepOneCompleted': false,
          '$Q.$N.stepTwoCompleted': false,
          '$Q.$N.stepOneCorrect': false,
          '$S.totalTimeElapsed': FieldValue.increment(-_stageData['$Q.$N.timeElapsed']),
          '$S.unlocked': FieldValue.increment(-1),
          '$S.stepOneCompleted': FieldValue.increment(-1),
          '$S.stepTwoCompleted': FieldValue.increment(-1),
          '$S.stepOneCorrect': FieldValue.increment(-1),
        });
        await eventsData.doc('All_Events').update({
          'Golden_Stages.AllStepTwoBought': FieldValue.increment(1),
        });
        await eventsData.doc('Trigonometry').collection('Stages').doc('Golden_Stage').update({
          'Stage_Info.TotalStepTwoBought': FieldValue.increment(1),
          'Questions_Info.Question_${_stageData['order'][index]}.StepTwoBought':
              FieldValue.increment(1),
        });
      } else {
        Fluttertoast.showToast(
          msg: "You don't have enough coins.",
          fontSize: 18,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 1, 79, 134).withOpacity(0.8),
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
  }

  Future<void> _questionCompletePopup(BuildContext context, int index) async {
    String N = 'Question_${index + 1}';
    return await showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              actionsPadding: EdgeInsets.only(right: 10, bottom: 5),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                ),
              ],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Question',
                          style: TextStyle(
                            fontFamily: 'AgencyFB',
                            fontSize: 33,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${index == 9 ? '' : '0'}${index + 1}',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 33,
                            color: Colors.black,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'The time you had taken for this question.',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 1, 79, 134),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 15),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Text(
                      '${StopWatchTimer.getDisplayTime(_stageData['$Q.$N.timeElapsed'], milliSecond: false)}',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 23,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _neverShowAgainPopup(BuildContext context) async {
    DocumentReference stageData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Golden_Stage');
    bool change = false;
    return await showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  actionsPadding: EdgeInsets.fromLTRB(0, 0, 15, 5),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        if (change) {
                          stageData.update({
                            'Entry_Tasks.rulesDialog': change,
                          });
                        }
                        Navigator.pop(context, false);
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.black,
                      ),
                    ),
                  ],
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'තරඟ කිරීමට ආරම්භ කිරීමට පෙර තරඟ නීති රීති කියවා තිබීමෙන් අවබෝදයෙන් සහ පහසුවෙන් තරඟ කල හැක.',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Iskola Potha',
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Go To',
                              style: TextStyle(
                                fontFamily: 'Roboto Regular',
                                fontSize: 28,
                              ),
                            ),
                            SizedBox(
                              height: 55,
                              width: 55,
                              child: ElevatedButton(
                                onPressed: null,
                                child: Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Color.fromARGB(255, 239, 197, 4),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3,
                                        color: Colors.black.withOpacity(0.4),
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 3, right: 1),
                                    child: Image.asset('assets/Rules_Icon.png'),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Never Show Again',
                            style: TextStyle(
                              fontFamily: 'Roboto Regular',
                              fontSize: 15,
                            ),
                          ),
                          Checkbox(
                            activeColor: Color.fromARGB(255, 183, 183, 183),
                            value: change,
                            onChanged: (val) {
                              setState(() {
                                change = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  Future<void> _finishPopup(BuildContext context) async {
    DocumentReference stageData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Golden_Stage');
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    String G = 'Collection';
    String D = 'Double_XP_Cards';
    String dG = 'Golden_Double_XP';
    String dS = 'Silver_Double_XP';
    String a = 'available';
    String V = 'Vouchers';
    String vA = 'Answer_Vouchers';
    String vV = 'Video_Vouchers';
    String B = 'Bonus_Cards';
    return await showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Considerable Notice',
                    style: TextStyle(
                      fontSize: 27,
                      fontFamily: 'Open Sans',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 20),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontFamily: 'Roboto Regular', fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'After clicking on the ',
                          ),
                          TextSpan(
                              text: 'FINISH',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                          TextSpan(
                            text:
                                ' button, you can\'t make any further changes in this stage.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      onPressed: () {
                        stageData.update({
                          'Stage_Info.finished': true,
                        });
                        for (int i = 1; i < 11; i++) {
                          stageData.update({
                            'Questions.Question_$i.completed': true,
                            'Questions.Question_$i.stepOneCompleted': true,
                            'Questions.Question_$i.stepTwoCompleted': true,
                          });
                        }
                        Navigator.pop(context, false);
                        double position = 100 * _userRank / _goldenList.length;
                        if (_userRank == 1) {
                          userData.update({
                            '$G.$V.$vV.$a': FieldValue.increment(1),
                            '$G.$V.$vA.$a': FieldValue.increment(2),
                            '$G.$D.$dS.$a': FieldValue.increment(5),
                            '$G.$D.$dG.$a': FieldValue.increment(2),
                            '$G.$B.$a': FieldValue.increment(3),
                            'User_Details.coins': FieldValue.increment(1000),
                          });
                          _rewardPopup(context, 1);
                        } else if (_userRank == 2) {
                          userData.update({
                            '$G.$V.$vA.$a': FieldValue.increment(1),
                            '$G.$D.$dS.$a': FieldValue.increment(5),
                            '$G.$D.$dG.$a': FieldValue.increment(2),
                            '$G.$B.$a': FieldValue.increment(2),
                            'User_Details.coins': FieldValue.increment(700),
                          });
                          _rewardPopup(context, 2);
                        } else if (_userRank == 3) {
                          userData.update({
                            '$G.$D.$dS.$a': FieldValue.increment(3),
                            '$G.$D.$dG.$a': FieldValue.increment(1),
                            '$G.$B.$a': FieldValue.increment(1),
                            'User_Details.coins': FieldValue.increment(500),
                          });
                          _rewardPopup(context, 3);
                        } else if (position <= 10) {
                          userData.update({
                            '$G.$D.$dS.$a': FieldValue.increment(2),
                            '$G.$B.$a': FieldValue.increment(1),
                            'User_Details.coins': FieldValue.increment(300),
                          });
                          _rewardPopup(context, 10);
                        } else if (position <= 20) {
                          userData.update({
                            '$G.$D.$dS.$a': FieldValue.increment(1),
                            'User_Details.coins': FieldValue.increment(200),
                          });
                          _rewardPopup(context, 20);
                        } else if (position <= 30) {
                          userData.update({
                            'User_Details.coins': FieldValue.increment(100),
                          });
                          _rewardPopup(context, 30);
                        } else {
                          _rewardPopup(context, 40);
                        }
                      },
                      child: Text(
                        'Finish Now',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _rewardPopup(BuildContext context, int rank) async {
    final double width = MediaQuery.of(context).size.width;
    Widget position;
    Widget reward;
    if (rank == 1) {
      position = Row(
        children: [
          Text(
            'RANK:',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Open Sans',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset('assets/LeaderBoard_First_Batch.png'),
          ),
        ],
      );
      reward = Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 233, 233, 233),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              offset: Offset(0, 2),
              color: Colors.black.withOpacity(0.2),
            )
          ],
        ),
        child: FittedBox(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Image.asset('assets/Video_Voucher.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Answer_Voucher.png'),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Golden_Double_XP_Card.png'),
                          Positioned(
                            top: 2,
                            right: 1,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Double_XP_Card.png'),
                          Positioned(
                            top: 2,
                            right: 1,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '5',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Double_Coin_Bonus_Card.png'),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.25,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(5, 5, 10, 10),
                    child: FittedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '1000',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 17,
                              color: Colors.black,
                              height: 1.3,
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (rank == 2) {
      position = Row(
        children: [
          Text(
            'RANK:',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Open Sans',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset('assets/LeaderBoard_Second_Batch.png'),
          ),
        ],
      );
      reward = Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 233, 233, 233),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              offset: Offset(0, 2),
              color: Colors.black.withOpacity(0.2),
            )
          ],
        ),
        child: FittedBox(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Answer_Voucher.png'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Golden_Double_XP_Card.png'),
                          Positioned(
                            top: 2,
                            right: 1,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Double_XP_Card.png'),
                          Positioned(
                            top: 2,
                            right: 1,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '5',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Double_Coin_Bonus_Card.png'),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.25,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(5, 5, 10, 10),
                child: FittedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '700',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 17,
                          color: Colors.black,
                          height: 1.3,
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
                ),
              ),
            ],
          ),
        ),
      );
    } else if (rank == 3) {
      position = Row(
        children: [
          Text(
            'RANK:',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Open Sans',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset('assets/LeaderBoard_Third_Batch.png'),
          ),
        ],
      );
      reward = Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 233, 233, 233),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              offset: Offset(0, 2),
              color: Colors.black.withOpacity(0.2),
            )
          ],
        ),
        child: FittedBox(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Golden_Double_XP_Card.png'),
                          Positioned(
                            top: 2,
                            right: 1,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Double_XP_Card.png'),
                          Positioned(
                            top: 2,
                            right: 1,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Double_Coin_Bonus_Card.png'),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.25,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(5, 5, 10, 10),
                    child: FittedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '500',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 17,
                              color: Colors.black,
                              height: 1.3,
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (rank == 10) {
      position = Row(
        children: [
          Text(
            'POSITION:',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Open Sans',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' 0%',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              color: Color.fromARGB(255, 1, 79, 134),
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 30,
              color: Color.fromARGB(255, 1, 79, 134),
            ),
          ),
          Text(
            '10%',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              color: Color.fromARGB(255, 1, 79, 134),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
      reward = Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 233, 233, 233),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              offset: Offset(0, 2),
              color: Colors.black.withOpacity(0.2),
            )
          ],
        ),
        child: FittedBox(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Double_XP_Card.png'),
                          Positioned(
                            top: 2,
                            right: 1,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
                    child: SizedBox(
                      width: width * 0.25,
                      child: Stack(
                        children: [
                          Image.asset('assets/Double_Coin_Bonus_Card.png'),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    fontFamily: 'Blenda Script',
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: width * 0.25,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(5, 5, 10, 10),
                child: FittedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '300',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 17,
                          color: Colors.black,
                          height: 1.3,
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
                ),
              ),
            ],
          ),
        ),
      );
    } else if (rank == 20) {
      position = Row(
        children: [
          Text(
            'POSITION:',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Open Sans',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' 10%',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              color: Color.fromARGB(255, 1, 79, 134),
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 30,
              color: Color.fromARGB(255, 1, 79, 134),
            ),
          ),
          Text(
            '20%',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              color: Color.fromARGB(255, 1, 79, 134),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
      reward = Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 233, 233, 233),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              offset: Offset(0, 2),
              color: Colors.black.withOpacity(0.2),
            )
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
              child: SizedBox(
                width: width * 0.25,
                child: Stack(
                  children: [
                    Image.asset('assets/Double_XP_Card.png'),
                    Positioned(
                      top: 2,
                      right: 1,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Text(
                            '1',
                            style: TextStyle(
                              fontFamily: 'Blenda Script',
                              fontSize: 9,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: width * 0.25,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.fromLTRB(5, 10, 10, 10),
              child: FittedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '200',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 17,
                        color: Colors.black,
                        height: 1.3,
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
              ),
            ),
          ],
        ),
      );
    } else if (rank == 30) {
      position = Row(
        children: [
          Text(
            'POSITION:',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Open Sans',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' 20%',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              color: Color.fromARGB(255, 1, 79, 134),
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 30,
              color: Color.fromARGB(255, 1, 79, 134),
            ),
          ),
          Text(
            '30%',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              color: Color.fromARGB(255, 1, 79, 134),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
      reward = Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 233, 233, 233),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              offset: Offset(0, 2),
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Container(
          width: width * 0.5,
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '100',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 17,
                    color: Colors.black,
                    height: 1.3,
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
          ),
        ),
      );
    } else {
      position = Row(
        children: [
          Text(
            'POSITION:',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Open Sans',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '  Below 30%',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              color: Color.fromARGB(255, 1, 79, 134),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
      reward = Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'There are no rewards for you to claim.',
          style: TextStyle(fontSize: 30, fontFamily: 'Philosopher', color: Colors.black),
          textAlign: TextAlign.center,
        ),
      );
    }
    return await showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              actionsPadding: EdgeInsets.only(right: 10, bottom: 5),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'CLAIM',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Colors.black,
                  ),
                ),
              ],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Rewards',
                    style: TextStyle(
                      fontSize: 27,
                      fontFamily: 'Open Sans',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10, bottom: 5),
                    child: position,
                  ),
                  Transform.scale(
                    scale: 0.9,
                    child: reward,
                  )
                ],
              ),
            ),
          );
        });
  }
}

class RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    var rect = Offset.zero & size;
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 239, 197, 1),
        Color.fromARGB(255, 249, 224, 159),
        Color.fromARGB(255, 239, 197, 1),
      ],
    ).createShader(rect);
    paint.style = PaintingStyle.fill;
    var path = Path.combine(
      PathOperation.difference,
      Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(size.width * 0.5, size.height * 0.5),
            width: size.width * 1.3,
            height: size.height * 1.3,
          ),
        ),
      Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(size.width * 0.5, size.height * 0.5),
            width: size.width,
            height: size.height,
          ),
        ),
    );
    canvas.drawShadow(path, Colors.black, 3.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class RingPainterShade extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;
    var path = Path.combine(
      PathOperation.difference,
      Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(size.width * 0.5, size.height * 0.5),
            width: size.width * 1.3,
            height: size.height * 1.3,
          ),
        ),
      Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(size.width * 0.5, size.height * 0.5),
            width: size.width,
            height: size.height,
          ),
        ),
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
