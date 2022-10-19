import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Event_1/account_screen.dart';
import 'package:maths_vision/Event_1/store.dart';
import 'package:maths_vision/Event_1/video_display_screen.dart';
import 'package:maths_vision/Screens/papers_screen.dart';
import 'package:maths_vision/Splash_Screens/went_home_splash_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:connectivity/connectivity.dart';

import '../Support_Classes/event_errors_and_loading.dart';
import 'leaderboard.dart';
import 'questions_map.dart';
import 'question_display_screen.dart';

class StageHomeScreen extends StatefulWidget {
  final String category;
  final int stage;

  const StageHomeScreen(this.category, this.stage, {Key key}) : super(key: key);

  @override
  _StageHomeScreenState createState() => _StageHomeScreenState();
}

class _StageHomeScreenState extends State<StageHomeScreen> {
  List _videoPrice = [0, 450, 160, 400, 300, 250, 300, 600, 230, 450];
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
  StreamSubscription _stageStream;
  StreamSubscription _userSubscription;

  DocumentSnapshot _stagesData;
  DocumentSnapshot _allStageData;
  DocumentSnapshot _userData;
  int _unlocks = 1;
  int _users;

  List _accuracyList = [];

  CollectionReference _usersCount = FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    initConnectivity();
    Stream userStream =
        FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots();
    _userSubscription = userStream.listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        _userData = event;
      });
    });
    Stream stream = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Stages')
        .snapshots();
    _stageStream = stream.listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        _stagesData = event;
        _unlocks =
            _stagesData.exists ? _stagesData['Stage_${widget.stage}.Info.completed'] + 1 : 1;
      });
    });
    _usersCount.snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _users = doc.docs.length;
      });
    });
    DocumentReference _stageFullData = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Stage_${widget.stage}');
    _stageFullData.snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _allStageData = doc;
      });
    });
  }

  @override
  void dispose() {
    _stageStream.cancel();
    _userSubscription.cancel();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 79, 134),
      body: _connectionStatus == 'ConnectivityResult.wifi' ||
              _connectionStatus == 'ConnectivityResult.mobile'
          ? _userData != null && _allStageData != null && _stagesData != null
              ? Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 295),
                      child: ListView.builder(
                        itemCount: questions['stage${widget.stage}'].length,
                        itemBuilder: (context, index) {
                          return _questionListItem(index, level);
                        },
                      ),
                    ),
                    Container(
                      width: width,
                      height: 310,
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
                      top: 110,
                      right: 15,
                      child: SizedBox(
                        height: 140,
                        width: 140,
                        child: Image.asset('assets/Trigonometry_Stage_${widget.stage}.png'),
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
                                      return LeaderBoard();
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
                                    width: 27,
                                    height: 27,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/Leaderboard_Icon.png'),
                                        fit: BoxFit.fill,
                                        scale: 0.5,
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
                      padding: EdgeInsets.only(top: 100),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 45, bottom: 7),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _videoPlay(),
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
                              SizedBox(
                                width: 7,
                              ),
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
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: _users != null && _allStageData != null
                                                ? '${(_allStageData['TotalUnlocked'] / _users).toStringAsFixed(1)}'
                                                : '0',
                                            style: TextStyle(
                                              fontFamily: 'AgencyFB',
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '/${questions['stage${widget.stage}'].length}',
                                            style: TextStyle(
                                              fontFamily: 'AgencyFB',
                                              fontSize: 13,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                    ),
                  ],
                )
              : EventLoading()
          : Center(
              child: NetworkError(Colors.white),
            ),
    );
  }

  Widget _videoPlay() {
    bool videoPurchased = _stagesData['Stage_${widget.stage}.Info.Video.purchased'];
    return InkWell(
      onTap: () {
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
                  offset: Offset(0,1)
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
                    Opacity(
                      opacity: videoPurchased ? 1 : 0,
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
          videoPurchased
              ? SizedBox()
              : Stack(
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
                ),
        ],
      ),
    );
  }

  Widget _questionListItem(int index, int level) {
    final double width = MediaQuery.of(context).size.width;
    int rewardCoins = questions['stage${widget.stage}']['question${index + 1}']['coins'];
    int rewardXP = questions['stage${widget.stage}']['question${index + 1}']['xp'];
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 110,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Stack(
                    children: [
                      InkWell(
                        onTap: index < _unlocks
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return QuestionDisplayScreen(
                                          widget.stage, index + 1, level);
                                    },
                                  ),
                                );
                              }
                            : null,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: width * 0.75,
                          height: 80,
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
                                        if (snapshot.hasData) {
                                          _accuracyList = snapshot.data.docs;
                                          return RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${_accuracyList[index]['Completed'] != 0 ? (100 * _accuracyList[index]['Correct'] / _accuracyList[index]['Completed']).toStringAsFixed(0) : 0}',
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
                                        } else {
                                          return LoadingBouncingLine.circle(
                                            size: 30,
                                            backgroundColor: Color.fromARGB(255, 1, 79, 134),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      index < _unlocks
                          ? SizedBox()
                          : Container(
                              width: width * 0.75,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 20, 10, 108).withOpacity(0.6),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                            ),
                    ],
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
                  index < _unlocks
                      ? SizedBox()
                      : Stack(
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
          ),
        ),
      ],
    );
  }

  Future<void> _videoBuyDialog(BuildContext context) {
    CollectionReference userData = FirebaseFirestore.instance.collection('Users');
    DocumentReference stageData =
        userData.doc(user.uid).collection('Trigonometry_Event').doc('Stages');
    CollectionReference eventInfo = FirebaseFirestore.instance.collection('Events');
    DocumentReference stageInfo =
        eventInfo.doc('Trigonometry').collection('Stages').doc('Stage_${widget.stage}');
    int videoPrice = _videoPrice[widget.stage - 1];
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
                  scale: 2,
                  child: Container(
                    width: 120,
                    height: 70,
                    padding: EdgeInsets.fromLTRB(0, 5, 12, 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 172, 140, 92),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          spreadRadius: 0,
                          color: Colors.black.withOpacity(0.3),
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
                            Stack(
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 55, 10, 15),
                  child: Text(
                    'This Video will help you to solve the questions of the Stage ${widget.stage < 10 ? '0' : ''}${widget.stage}.',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.9,
                  child: SizedBox(
                    width: 110,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        initConnectivity().whenComplete(() async {
                          if (_connectionStatus == 'ConnectivityResult.wifi' ||
                              _connectionStatus == 'ConnectivityResult.mobile') {
                            if (_userData['User_Details.coins'] > videoPrice) {
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
                                fontSize: 16,
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
                        });
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
                          widget.stage != 1
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${_videoPrice[widget.stage - 1]}',
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
                                )
                              : Text(
                                  'Free',
                                  style: TextStyle(
                                    fontFamily: 'Crash',
                                    fontSize: 23,
                                    color: Colors.white,
                                    height: 0.9,
                                    fontWeight: FontWeight.bold,
                                  ),
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
}
