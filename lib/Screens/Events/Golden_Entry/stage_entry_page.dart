import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Screens/Account/Details/account_details.dart';
import 'package:maths_vision/Widgets/event_errors_and_loading.dart';
import 'package:maths_vision/Screens/Special/Leaderboard/leaderboard.dart';
import 'package:maths_vision/Screens/Special/Store/store.dart';
import 'package:maths_vision/Screens/Events/Golden_Stage/Information/more_info_screen.dart';
import 'package:maths_vision/Screens/Events/Golden_Stage/Information/rewards_screen.dart';
import 'package:maths_vision/Screens/Splashes/went_home_splash_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StageEntryPage extends StatefulWidget {
  const StageEntryPage({Key key}) : super(key: key);

  @override
  _StageEntryPageState createState() => _StageEntryPageState();
}

class _StageEntryPageState extends State<StageEntryPage> {
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

  Query data = FirebaseFirestore.instance.collection('Users').orderBy(
        'User_Details.xp',
        descending: true,
      );

  DocumentReference event = FirebaseFirestore.instance
      .collection('Events')
      .doc('Trigonometry')
      .collection('Stages')
      .doc('Golden_Stage');

  User user;
  DocumentSnapshot _userData;
  DocumentSnapshot _eventData;
  DocumentSnapshot _goldenStageData;
  int _accuracyCoins;
  double _accuracy;
  double _accuracyOpacity;
  int _loginDays;
  int _loginCoins;
  double _loginOpacity;
  double _surpassPercentage;
  int _surpassCoins;
  double _surpassOpacity;
  List _leaderboardData;
  int _currentRank;
  int _totalUsers;
  bool _tasksCompleted;
  bool _allCompleted;
  bool _loading = false;

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
        _loginDays = _userData['LogIn_Details.loginDays'] < 6
            ? _userData['LogIn_Details.loginDays']
            : 5;
      });
      if (_loginDays == 5) {
        setState(() {
          _loginCoins = 0;
        });
      } else {
        setState(() {
          _loginCoins = (5 - _loginDays) * 25;
        });
      }
    });
    userData.collection('Trigonometry_Event').doc('Golden_Stage').snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _goldenStageData = doc;
      });
      if (!mounted) {
        return;
      }
      if (_goldenStageData['Entry_Tasks.loginTask']) {
        setState(() {
          _loginOpacity = 0.0;
        });
      } else {
        setState(() {
          _loginOpacity = 1.0;
        });
      }
      if (!mounted) {
        return;
      }
      if (_goldenStageData['Entry_Tasks.leaderboardTask']) {
        setState(() {
          _surpassOpacity = 0.0;
        });
      } else {
        setState(() {
          _surpassOpacity = 1.0;
        });
      }
      if (_goldenStageData['Entry_Tasks.accuracyTask'] &&
          _goldenStageData['Entry_Tasks.leaderboardTask'] &&
          _goldenStageData['Entry_Tasks.loginTask']) {
        setState(() {
          _tasksCompleted = true;
        });
        if (_eventData['totalCompleted'] == 105) {
          setState(() {
            _allCompleted = true;
          });
        } else {
          setState(() {
            _allCompleted = false;
          });
        }
      } else {
        setState(() {
          _tasksCompleted = false;
          _allCompleted = false;
        });
      }
    });
    userData.collection('Trigonometry_Event').doc('Event_Info').snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _eventData = doc;
        _accuracy = _eventData['totalCompleted'] != 0
            ? 100 * _eventData['totalCorrect'] / _eventData['totalCompleted']
            : 0;
      });
      if (_accuracy >= 75) {
        setState(() {
          _accuracyCoins = 0;
        });
      } else if (_accuracy < 75 && _accuracy >= 50) {
        setState(() {
          _accuracyCoins = 50 + 9 * (75 - _accuracy.round());
        });
      } else {
        setState(() {
          _accuracyCoins = 275;
        });
      }
      if (!mounted) {
        return;
      }
      if (_eventData['totalCompleted'] == 105 &&
          !_goldenStageData['Entry_Tasks.accuracyTask']) {
        setState(() {
          _accuracyOpacity = 1.0;
        });
      } else {
        if (!mounted) {
          return;
        }
        if (_goldenStageData['Entry_Tasks.accuracyTask']) {
          setState(() {
            _accuracyOpacity = 0.0;
          });
        } else {
          setState(() {
            _accuracyOpacity = 0.6;
          });
        }
      }
    });
    data.snapshots().listen((docs) {
      if (!mounted) {
        return;
      }
      setState(() {
        _leaderboardData = docs.docs.toList();
        _totalUsers = _leaderboardData.length;
      });
      for (int i = 0; i < _leaderboardData.length; i++) {
        if (_leaderboardData[i]['User_Details.userId'] == user.uid) {
          if (!mounted) {
            return;
          }
          setState(() {
            _currentRank = i + 1;
          });
          userData.collection('Trigonometry_Event').doc('Event_Info').get().then((doc) {
            userData.collection('Trigonometry_Event').doc('Event_Info').update({
              'currentRank': _currentRank,
              'bestRank': doc.get('bestRank') == 0
                  ? _currentRank
                  : doc.get('bestRank') > _currentRank
                      ? _currentRank
                      : doc.get('bestRank'),
            });
          });
          userData.get().then((doc) {
            userData.update({
              'User_Details.currentRank': _currentRank,
              'User_Details.bestRank': doc.get('User_Details.bestRank') == 0
                  ? _currentRank
                  : doc.get('User_Details.bestRank') > _currentRank
                      ? _currentRank
                      : doc.get('User_Details.bestRank'),
            });
          });
        }
      }
      setState(() {
        _surpassPercentage = 100 - (100 * _currentRank / _totalUsers);
      });
      if (_surpassPercentage >= 70) {
        setState(() {
          _surpassCoins = 0;
        });
      } else if (_surpassPercentage < 70 && _surpassPercentage >= 45) {
        setState(() {
          _surpassCoins = 75 + 12 * (70 - _surpassPercentage.round());
        });
      } else {
        setState(() {
          _surpassCoins = 375;
        });
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 79, 134),
      body: _connectionStatus == 'ConnectivityResult.wifi' ||
              _connectionStatus == 'ConnectivityResult.mobile'
          ? _userData != null &&
                  _eventData != null &&
                  _goldenStageData != null &&
                  _totalUsers != null
              ? Column(
                  children: [
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
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
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
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
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
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
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
                    Expanded(
                      child: Container(
                        width: width,
                        margin: EdgeInsets.all(width * 0.05),
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(25)),
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 230,
                                  left: 12,
                                  right: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: width * 0.6,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'COMPLETED',
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontSize: 21,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                              height: 1.1,
                                            ),
                                          ),
                                          Container(
                                            width: 19,
                                            height: 19,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              color: Color.fromARGB(255, 250, 237, 178),
                                              border: Border.all(
                                                color: Color.fromARGB(255, 112, 112, 112),
                                              ),
                                            ),
                                            child: _eventData['totalCompleted'] == 105
                                                ? Image.asset('assets/Complete_Icon.png')
                                                : SizedBox.shrink(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3, top: 2),
                                      child: Text(
                                        'You must complete the normal stages 100%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.71,
                                      child: LinearPercentIndicator(
                                        percent: _eventData['progress'] / 100,
                                        padding: EdgeInsets.only(left: 8, right: 20),
                                        lineHeight: 10,
                                        backgroundColor: Color.fromARGB(255, 250, 237, 178),
                                        progressColor: Color.fromARGB(255, 249, 166, 2),
                                        trailing: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color.fromARGB(255, 239, 197, 4),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${(_eventData['progress']).toStringAsFixed(0)}%',
                                              style: TextStyle(
                                                fontFamily: 'AgencyFB',
                                                fontSize: 14,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.6,
                                      margin: EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'TASKS',
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontSize: 21,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                              height: 1.1,
                                            ),
                                          ),
                                          Container(
                                            width: 19,
                                            height: 19,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              color: Color.fromARGB(255, 250, 237, 178),
                                              border: Border.all(
                                                color: Color.fromARGB(255, 112, 112, 112),
                                              ),
                                            ),
                                            child: _tasksCompleted
                                                ? Image.asset('assets/Complete_Icon.png')
                                                : SizedBox.shrink(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Your accuracy should exceed 75% by the end of the normal stages.',
                                                      style: TextStyle(
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    LinearPercentIndicator(
                                                      percent: _accuracy / 100,
                                                      padding:
                                                          EdgeInsets.only(left: 3, right: 20),
                                                      lineHeight: 6,
                                                      backgroundColor:
                                                          Color.fromARGB(255, 250, 237, 178),
                                                      progressColor:
                                                          Color.fromARGB(255, 249, 166, 2),
                                                      trailing: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: Color.fromARGB(
                                                                255, 239, 197, 4),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '${_accuracy.toStringAsFixed(0)}%',
                                                            style: TextStyle(
                                                              fontFamily: 'AgencyFB',
                                                              fontSize: 14,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(17.0),
                                                child: SizedBox(
                                                  width: 110 * 0.5,
                                                  height: 27.5,
                                                  child: Opacity(
                                                    opacity: _accuracyOpacity,
                                                    child: ElevatedButton(
                                                      onPressed: _eventData[
                                                                      'totalCompleted'] ==
                                                                  105 &&
                                                              !_goldenStageData[
                                                                  'Entry_Tasks.accuracyTask']
                                                          ? () {
                                                              DocumentReference details =
                                                                  FirebaseFirestore.instance
                                                                      .collection('Users')
                                                                      .doc(user.uid)
                                                                      .collection(
                                                                          'Trigonometry_Event')
                                                                      .doc('Golden_Stage');
                                                              if (_accuracy >= 75) {
                                                                details.update({
                                                                  'Entry_Tasks.accuracyTask':
                                                                      true,
                                                                });
                                                                event.update({
                                                                  'Entry_Tasks.AccuracyTask':
                                                                      FieldValue.increment(1),
                                                                });
                                                                setState(() {
                                                                  _accuracyOpacity = 0.0;
                                                                });
                                                              } else {
                                                                _accuracyPayPopup(context);
                                                              }
                                                            }
                                                          : null,
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Color.fromARGB(255, 1, 79, 134),
                                                        padding: EdgeInsets.only(
                                                            left: 1.5, right: 1.5),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(5),
                                                        ),
                                                        side: BorderSide(
                                                            width: 1.5, color: Colors.black),
                                                      ),
                                                      child: Stack(
                                                        alignment: AlignmentDirectional.center,
                                                        children: [
                                                          Container(
                                                            height: 19,
                                                            width: 55,
                                                            color: Colors.black,
                                                          ),
                                                          _eventData['totalCompleted'] == 105
                                                              ? _accuracy >= 75
                                                                  ? Text(
                                                                      'CLAIM',
                                                                      style: TextStyle(
                                                                        fontFamily:
                                                                            'Microsoft',
                                                                        fontSize: 16,
                                                                        color: Color.fromARGB(
                                                                            255, 239, 197, 1),
                                                                        height: 1.2,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        letterSpacing: 1.5,
                                                                      ),
                                                                    )
                                                                  : Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize.min,
                                                                      children: [
                                                                        Text(
                                                                          '$_accuracyCoins',
                                                                          style: TextStyle(
                                                                            fontFamily:
                                                                                'Crash',
                                                                            fontSize: 12,
                                                                            color:
                                                                                Colors.white,
                                                                            height: 0.85,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .bold,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 2.5,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 12,
                                                                          child: Image.asset(
                                                                              'assets/Coin.png'),
                                                                        ),
                                                                      ],
                                                                    )
                                                              : Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      '$_accuracyCoins',
                                                                      style: TextStyle(
                                                                        fontFamily: 'Crash',
                                                                        fontSize: 12,
                                                                        color: Colors.white,
                                                                        height: 0.85,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 2.5,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 12,
                                                                      child: Image.asset(
                                                                          'assets/Coin.png'),
                                                                    ),
                                                                  ],
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Stack(
                                                alignment: AlignmentDirectional.bottomStart,
                                                children: [
                                                  Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color.fromARGB(255, 112, 112, 112),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      bottom: 3,
                                                      left: 3,
                                                    ),
                                                    child: SizedBox(
                                                      width: 15,
                                                      height: 15,
                                                      child: _goldenStageData[
                                                              'Entry_Tasks.accuracyTask']
                                                          ? Image.asset(
                                                              'assets/Complete_Icon.png')
                                                          : SizedBox(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'You must use the app 5 days in row.',
                                                      style: TextStyle(
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    LinearPercentIndicator(
                                                      percent: _loginDays / 5,
                                                      padding:
                                                          EdgeInsets.only(left: 3, right: 20),
                                                      lineHeight: 6,
                                                      backgroundColor:
                                                          Color.fromARGB(255, 250, 237, 178),
                                                      progressColor:
                                                          Color.fromARGB(255, 249, 166, 2),
                                                      trailing: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: Color.fromARGB(
                                                                255, 239, 197, 4),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '$_loginDays/5',
                                                            style: TextStyle(
                                                              fontFamily: 'AgencyFB',
                                                              fontSize: 14,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(17.0),
                                                child: SizedBox(
                                                  width: 110 * 0.5,
                                                  height: 27.5,
                                                  child: Opacity(
                                                    opacity: _loginOpacity,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        DocumentReference details =
                                                            FirebaseFirestore.instance
                                                                .collection('Users')
                                                                .doc(user.uid)
                                                                .collection(
                                                                    'Trigonometry_Event')
                                                                .doc('Golden_Stage');
                                                        if (_loginCoins == 0) {
                                                          details.update({
                                                            'Entry_Tasks.loginTask': true,
                                                          });
                                                          event.update({
                                                            'Entry_Tasks.LoginTask':
                                                                FieldValue.increment(1),
                                                          });
                                                          setState(() {
                                                            _loginOpacity = 0.0;
                                                          });
                                                        } else {
                                                          _loginPayPopup(context);
                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Color.fromARGB(255, 1, 79, 134),
                                                        padding: EdgeInsets.only(
                                                            left: 1.5, right: 1.5),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(5),
                                                        ),
                                                        side: BorderSide(
                                                            width: 1.5, color: Colors.black),
                                                      ),
                                                      child: Stack(
                                                        alignment: AlignmentDirectional.center,
                                                        children: [
                                                          Container(
                                                            height: 19,
                                                            width: 55,
                                                            color: Colors.black,
                                                          ),
                                                          _loginCoins == 0
                                                              ? Text(
                                                                  'CLAIM',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Microsoft',
                                                                    fontSize: 16,
                                                                    color: Color.fromARGB(
                                                                        255, 239, 197, 1),
                                                                    height: 1.2,
                                                                    fontWeight:
                                                                        FontWeight.bold,
                                                                    letterSpacing: 1.5,
                                                                  ),
                                                                )
                                                              : Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      '$_loginCoins',
                                                                      style: TextStyle(
                                                                        fontFamily: 'Crash',
                                                                        fontSize: 12,
                                                                        color: Colors.white,
                                                                        height: 0.85,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 2.5,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 12,
                                                                      child: Image.asset(
                                                                          'assets/Coin.png'),
                                                                    ),
                                                                  ],
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Stack(
                                                alignment: AlignmentDirectional.bottomStart,
                                                children: [
                                                  Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color.fromARGB(255, 112, 112, 112),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      bottom: 3,
                                                      left: 3,
                                                    ),
                                                    child: SizedBox(
                                                      width: 15,
                                                      height: 15,
                                                      child: _goldenStageData[
                                                              'Entry_Tasks.loginTask']
                                                          ? Image.asset(
                                                              'assets/Complete_Icon.png')
                                                          : SizedBox(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'You should surpass 70% of the competitors.',
                                                      style: TextStyle(
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    LinearPercentIndicator(
                                                      percent:
                                                          1 - (_currentRank / _totalUsers),
                                                      padding:
                                                          EdgeInsets.only(left: 7, right: 24),
                                                      lineHeight: 15,
                                                      backgroundColor:
                                                          Color.fromARGB(255, 250, 237, 178),
                                                      progressColor:
                                                          Color.fromARGB(255, 249, 166, 2),
                                                      trailing: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: Color.fromARGB(
                                                                255, 239, 197, 4),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '${(100 - (100 * _currentRank / _totalUsers)).toStringAsFixed(0)}%',
                                                            style: TextStyle(
                                                              fontFamily: 'AgencyFB',
                                                              fontSize: 14,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      center: RichText(
                                                        text: TextSpan(
                                                          style: TextStyle(
                                                              fontFamily: 'Sylfaen',
                                                              color: Colors.black,
                                                              fontSize: 12,
                                                              height: 1.4),
                                                          children: [
                                                            TextSpan(
                                                              text: '$_currentRank',
                                                            ),
                                                            TextSpan(
                                                              text: '/$_totalUsers',
                                                              style: TextStyle(
                                                                fontSize: 9,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(17.0),
                                                child: SizedBox(
                                                  width: 110 * 0.5,
                                                  height: 27.5,
                                                  child: Opacity(
                                                    opacity: _surpassOpacity,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        DocumentReference details =
                                                            FirebaseFirestore.instance
                                                                .collection('Users')
                                                                .doc(user.uid)
                                                                .collection(
                                                                    'Trigonometry_Event')
                                                                .doc('Golden_Stage');
                                                        if (_surpassCoins == 0) {
                                                          details.update({
                                                            'Entry_Tasks.leaderboardTask':
                                                                true,
                                                          });
                                                          event.update({
                                                            'Entry_Tasks.LeaderboardTask':
                                                                FieldValue.increment(1),
                                                          });
                                                          setState(() {
                                                            _surpassOpacity = 0.0;
                                                          });
                                                        } else {
                                                          _surpassPayPopup(context);
                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Color.fromARGB(255, 1, 79, 134),
                                                        padding: EdgeInsets.only(
                                                            left: 1.5, right: 1.5),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(5),
                                                        ),
                                                        side: BorderSide(
                                                            width: 1.5, color: Colors.black),
                                                      ),
                                                      child: Stack(
                                                        alignment: AlignmentDirectional.center,
                                                        children: [
                                                          Container(
                                                            height: 19,
                                                            width: 55,
                                                            color: Colors.black,
                                                          ),
                                                          _surpassCoins == 0
                                                              ? Text(
                                                                  'CLAIM',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Microsoft',
                                                                    fontSize: 16,
                                                                    color: Color.fromARGB(
                                                                        255, 239, 197, 1),
                                                                    height: 1.2,
                                                                    fontWeight:
                                                                        FontWeight.bold,
                                                                    letterSpacing: 1.5,
                                                                  ),
                                                                )
                                                              : Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      '$_surpassCoins',
                                                                      style: TextStyle(
                                                                        fontFamily: 'Crash',
                                                                        fontSize: 12,
                                                                        color: Colors.white,
                                                                        height: 0.85,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 2.5,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 12,
                                                                      child: Image.asset(
                                                                          'assets/Coin.png'),
                                                                    ),
                                                                  ],
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Stack(
                                                alignment: AlignmentDirectional.bottomStart,
                                                children: [
                                                  Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color.fromARGB(255, 112, 112, 112),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      bottom: 3,
                                                      left: 3,
                                                    ),
                                                    child: SizedBox(
                                                      width: 15,
                                                      height: 15,
                                                      child: _goldenStageData[
                                                              'Entry_Tasks.leaderboardTask']
                                                          ? Image.asset(
                                                              'assets/Complete_Icon.png')
                                                          : SizedBox(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                                        child: SizedBox(
                                          height: 35,
                                          width: 120,
                                          child: ElevatedButton(
                                            onPressed: _allCompleted
                                                ? () {
                                              initConnectivity().whenComplete(() {
                                                if(_connectionStatus == 'ConnectivityResult.wifi' ||
                                                    _connectionStatus == 'ConnectivityResult.mobile'){
                                                  setState(() {
                                                    _loading = true;
                                                  });
                                                  _unlockUpdated().whenComplete(() {
                                                    setState(() {
                                                      _loading = false;
                                                    });
                                                    Navigator.of(context).pop();
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                    msg: 'You Are not connected to the internet.',
                                                    fontSize: 16,
                                                  );
                                                }
                                              });
                                                  }
                                                : null,
                                            child: Container(
                                              height: 35,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(40),
                                                gradient: _allCompleted
                                                    ? LinearGradient(
                                                        colors: [
                                                          Color.fromARGB(255, 239, 197, 1),
                                                          Color.fromARGB(255, 249, 224, 159),
                                                          Color.fromARGB(255, 239, 197, 1),
                                                        ],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      )
                                                    : LinearGradient(
                                                        colors: [
                                                          Color.fromARGB(255, 197, 197, 197),
                                                          Color.fromARGB(255, 229, 229, 229),
                                                          Color.fromARGB(255, 197, 197, 197),
                                                        ],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 3,
                                                    color: Colors.black.withOpacity(0.4),
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: _loading? LoadingBouncingLine.circle(
                                                backgroundColor: Colors.white,
                                              ):Center(
                                                child: Text(
                                                  'UNLOCK',
                                                  style: TextStyle(
                                                    fontFamily: 'Open Sans',
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    letterSpacing: 2,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 2,
                                                        offset: Offset(1, 1),
                                                        color: Colors.black.withOpacity(0.9),
                                                      ),
                                                    ],
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
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: width,
                              height: 215,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.elliptical(width * 0.45, width * 0.3),
                                  bottomRight: Radius.elliptical(width * 0.45, width * 0.3),
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 249, 224, 159),
                                    Color.fromARGB(255, 239, 197, 1),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return MoreInfoScreen();
                                          },
                                        ),
                                      );
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromARGB(255, 243, 214, 78),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 3,
                                            color: Colors.black.withOpacity(0.3),
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          '?',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 130,
                                          height: 130,
                                          child: Image.asset(
                                              'assets/Golden_Stage_Entry_Page_Clip.png'),
                                        ),
                                        Text(
                                          'HOW TO UNLOCK',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 3,
                                                offset: Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          'GOLDEN STAGE',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 17,
                                            color: Colors.white,
                                            letterSpacing: 2,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 2,
                                                offset: Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      margin: EdgeInsets.all(15),
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
                                          height: 40,
                                          width: 40,
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
              child: NetworkError(),
            ),
    );
  }

  Future<void> _accuracyPayPopup(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Your accuracy should exceed 75% by the end of the normal stages.',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      LinearPercentIndicator(
                        percent: _accuracy / 100,
                        padding: EdgeInsets.only(left: 3, right: 20),
                        lineHeight: 6,
                        backgroundColor: Color.fromARGB(255, 250, 237, 178),
                        progressColor: Color.fromARGB(255, 249, 166, 2),
                        trailing: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 239, 197, 4),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${_accuracy.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontFamily: 'AgencyFB',
                                fontSize: 14,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'If you want to complete this task,',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.4),
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: SizedBox(
                    width: 120,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        DocumentReference userDetails =
                            FirebaseFirestore.instance.collection('Users').doc(user.uid);
                        if (_userData['User_Details.coins'] >= _accuracyCoins) {
                          userDetails.update({
                            'User_Details.coins': FieldValue.increment(-_accuracyCoins),
                          });
                          userDetails
                              .collection('Trigonometry_Event')
                              .doc('Golden_Stage')
                              .update({
                            'Entry_Tasks.accuracyTask': true,
                          });
                          event.update({
                            'Entry_Tasks.AccuracyTask': FieldValue.increment(1),
                          });
                          setState(() {
                            _accuracyOpacity = 0.0;
                          });
                          Navigator.pop(context, false);
                        } else {
                          Fluttertoast.showToast(
                            msg: "You don't have enough coins to complete this task.",
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
                            height: 40,
                            width: 120,
                            color: Colors.black,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_accuracyCoins',
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _loginPayPopup(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You must use the app 5 days in row.',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      LinearPercentIndicator(
                        percent: _loginDays / 5,
                        padding: EdgeInsets.only(left: 3, right: 20),
                        lineHeight: 6,
                        backgroundColor: Color.fromARGB(255, 250, 237, 178),
                        progressColor: Color.fromARGB(255, 249, 166, 2),
                        trailing: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 239, 197, 4),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$_loginDays/5',
                              style: TextStyle(
                                fontFamily: 'AgencyFB',
                                fontSize: 14,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'If you want to complete this task,',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.4),
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: SizedBox(
                    width: 120,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        DocumentReference userDetails =
                            FirebaseFirestore.instance.collection('Users').doc(user.uid);
                        if (_userData['User_Details.coins'] >= _loginCoins) {
                          userDetails.update({
                            'User_Details.coins': FieldValue.increment(-_loginCoins),
                          });
                          userDetails
                              .collection('Trigonometry_Event')
                              .doc('Golden_Stage')
                              .update({
                            'Entry_Tasks.loginTask': true,
                          });
                          event.update({
                            'Entry_Tasks.LoginTask': FieldValue.increment(1),
                          });
                          setState(() {
                            _loginOpacity = 0.0;
                          });
                          Navigator.pop(context, false);
                        } else {
                          Fluttertoast.showToast(
                            msg: "You don't have enough coins to complete this task.",
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
                            height: 40,
                            width: 120,
                            color: Colors.black,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_loginCoins',
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _surpassPayPopup(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You should surpass 70% of the competitors.',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      LinearPercentIndicator(
                        percent: 1 - (_currentRank / _totalUsers),
                        padding: EdgeInsets.only(left: 7, right: 24),
                        lineHeight: 15,
                        backgroundColor: Color.fromARGB(255, 250, 237, 178),
                        progressColor: Color.fromARGB(255, 249, 166, 2),
                        trailing: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 239, 197, 4),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${(100 - (100 * _currentRank / _totalUsers)).toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontFamily: 'AgencyFB',
                                fontSize: 14,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                        center: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Sylfaen',
                              color: Colors.black,
                              fontSize: 12,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: '$_currentRank',
                              ),
                              TextSpan(
                                text: '/$_totalUsers',
                                style: TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'If you want to complete this task,',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.4),
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: SizedBox(
                    width: 120,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        DocumentReference userDetails =
                            FirebaseFirestore.instance.collection('Users').doc(user.uid);
                        if (_userData['User_Details.coins'] >= _surpassCoins) {
                          userDetails.update({
                            'User_Details.coins': FieldValue.increment(-_surpassCoins),
                          });
                          userDetails
                              .collection('Trigonometry_Event')
                              .doc('Golden_Stage')
                              .update({
                            'Entry_Tasks.leaderboardTask': true,
                          });
                          event.update({
                            'Entry_Tasks.LeaderboardTask': FieldValue.increment(1),
                          });
                          setState(() {
                            _surpassOpacity = 0.0;
                          });
                          Navigator.pop(context, false);
                        } else {
                          Fluttertoast.showToast(
                            msg: "You don't have enough coins to complete this task.",
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
                            height: 40,
                            width: 120,
                            color: Colors.black,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_surpassCoins',
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _unlockUpdated() async {
    DocumentReference eventDetails =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);
    CollectionReference eventsData = FirebaseFirestore.instance.collection('Events');
    List questionIcons = [
      'Alpha',
      'Beta',
      'Gamma',
      'Delta',
      'Epsilon',
      'Lambda',
      'Mu',
      'Tau',
      'Phi',
      'Psi',
    ];
    questionIcons.shuffle();
    await eventDetails.collection('Trigonometry_Event').doc('Event_Info').update({
      'goldenStageUnlocked': true,
    });
    await eventsData.doc('All_Events').update({
      'Golden_Stages.AllUnlocked': FieldValue.increment(1),
      'Golden_Stages.AllStageUnlocks': FieldValue.increment(1),
    });
    await eventsData.doc('Trigonometry').collection('Stages').doc('Golden_Stage').update({
      'Stage_Info.TotalUnlocked': FieldValue.increment(1),
      'Stage_Info.TotalStageUnlocks': FieldValue.increment(1),
      'Questions_Info.Question_${questionIcons[0]}.TotalUnlocked': FieldValue.increment(1),
    });
    for (int i = 1; i < 11; i++) {
      await eventDetails.collection('Trigonometry_Event').doc('Golden_Stage').set(
        {
          'order': questionIcons,
          'Stage_Info': {
            'Unlocked': 1,
            'finished': false,
            'stepOneCompleted':0,
          },
          'Questions': {
            'Question_$i': {
              'questionSymbol': questionIcons[i - 1],
              'completed': false,
              'correct': false,
              'stepOneCompleted': false,
              'stepOneCorrect': false,
              'stepTwoCompleted': false,
              'stepTwoCorrect': false,
              'goldenDoubleXPUsed': false,
              'timeElapsed': 0,
              'unlocked': i == 1 ? true : false,
            }
          }
        },
        SetOptions(merge: true),
      );
    }
  }
}
