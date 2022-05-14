import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:maths_vision/Event_1/account_screen.dart';
import 'package:maths_vision/Event_1/event_home_screen.dart';
import 'package:maths_vision/Event_1/store.dart';
import 'package:maths_vision/Golden_Stage/golden_stage_home_screen.dart';
import 'package:maths_vision/Golden_Stage/stage_entry_page.dart';
import 'package:maths_vision/Screens/papers_screen.dart';
import 'package:maths_vision/Splash_Screens/went_home_splash_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:charcode/charcode.dart';

import 'event_errors_and_loading.dart';
import 'leaderboard.dart';
import 'stage_home_screen.dart';

class EventFrontScreen extends StatefulWidget {
  final bool goldenStage;
  const EventFrontScreen({this.goldenStage});
  @override
  _EventFrontScreenState createState() => _EventFrontScreenState();
}

class _EventFrontScreenState extends State<EventFrontScreen> {
  List stageData = [
    // Subject, Questions, XP
    ['ත්‍රිකෝණමිතික අනුපාත අතර සම්බන්දතා', 10, 100],
    ['පයිතගරස් සර්වසාම්‍යය ආශ්‍රිත ත්‍රිකෝණමිතික සම්බන්දතා', 20, 1100],
    ['වෘත්ත පාද සහ ත්‍රිකෝණමිතිය', 15, 400],
    ['ආකලන සූත්‍ර (A,B)\nසහ ගුණන සූත්‍ර (C,D)', 20, 800],
    ['දෙගුණ සූත්‍ර (2${String.fromCharCode($theta)})', 10, 450],
    ['තෙගුණ සූත්‍ර (3${String.fromCharCode($theta)})', 5, 400],
    ['ත්‍රිකෝණමිතික සාධාරණ විසඳුම්', 5, 450],
    ['ත්‍රිකෝණමිතික ප්‍රතිලෝම සූත්‍ර (Inverse)', 10, 850],
    ['ත්‍රිකෝණමිතික ප්‍රස්තාර', 5, 300],
    ['ත්‍රිකෝණයක සම්මත අංකනය\n(sin නීතිය සහ cos නීතිය)', 5, 650],
    ['WE WARMLY WELCOME YOU TO THE PARADISE OF THE BEST OF THE BEST', 10, 4500]
  ];

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  ScrollController _snapController = ScrollController();
  double _listHeight = 290;
  double _listWidth = 260;
  double _firstContainerScale = 1.0;
  double _secondContainerScale = 1.0;
  double _thirdContainerScale = 1.0;
  int _stageIndex = 0;
  ScrollController controller = ScrollController();
  User user;
  StreamSubscription _userSubscription;
  DocumentSnapshot _userData;
  DocumentSnapshot _stagesData;
  DocumentSnapshot _goldenStage;
  bool _goldenStageUnlocked;

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

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    initConnectivity();
    Future.delayed(Duration(milliseconds: 200)).whenComplete(() {
      if(widget.goldenStage!= null && _snapController.hasClients){
        _snapController.animateTo(
          _snapController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    });

    Stream userStream =
        FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots();
    _userSubscription = userStream.listen((event) {
      setState(() {
        _userData = event;
      });
    });
    DocumentReference stageDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Stages');
    stageDoc.snapshots().listen((event) {
      setState(() {
        _stagesData = event;
      });
    });
    CollectionReference eventDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event');
    eventDoc.doc('Event_Info').snapshots().listen((doc) {
      setState(() {
        _goldenStageUnlocked = doc['goldenStageUnlocked'];
      });
    });
    eventDoc.doc('Golden_Stage').snapshots().listen((doc) {
      setState(() {
        _goldenStage = doc;
      });
    });
    controller.addListener(() {
      double value = controller.offset / 68;
      if (value < 1) {
        setState(() {
          _firstContainerScale = 1.0 - value;
          _secondContainerScale = 1.0;
          _thirdContainerScale = 1.0;
        });
      } else if (value >= 1 && value < 2) {
        setState(() {
          _secondContainerScale = 2.0 - value;
          _thirdContainerScale = 1.0;
        });
      } else if (value >= 2) {
        setState(() {
          _thirdContainerScale = 3.0 - value;
        });
      }
      if (_firstContainerScale < 0) {
        setState(() {
          _firstContainerScale = 0;
        });
      } else if (_firstContainerScale > 1) {
        setState(() {
          _firstContainerScale = 1;
        });
      }
      if (_secondContainerScale < 0) {
        setState(() {
          _secondContainerScale = 0;
        });
      } else if (_secondContainerScale > 1) {
        setState(() {
          _secondContainerScale = 1;
        });
      }
      if (_thirdContainerScale < 0) {
        setState(() {
          _thirdContainerScale = 0;
        });
      } else if (_thirdContainerScale > 1) {
        setState(() {
          _thirdContainerScale = 1;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
              return EventHomeScreen();
            },
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 1, 79, 134),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Align(
              alignment: Alignment(0, -1.55),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(200, 140),
                    bottomRight: Radius.elliptical(200, 140),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      spreadRadius: 0,
                      blurRadius: 13,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(200, 140),
                    bottomRight: Radius.elliptical(200, 140),
                  ),
                  child: Image.asset('assets/Event_Top_Image.jpg'),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.3, -0.75),
              child: Container(
                width: 160,
                height: 160,
                child: Image.asset('assets/Event_Top_Clip.png'),
              ),
            ),
            Align(
              alignment: Alignment(-1.31, -1.01),
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 97, 165, 194),
                ),
              ),
            ),
            Align(
              alignment: Alignment(-1.25, -1.015),
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 137, 194, 217),
                ),
              ),
            ),
            Align(
              alignment: Alignment(-1.21, -1.02),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 169, 214, 229),
                ),
              ),
            ),
            _connectionStatus == 'ConnectivityResult.wifi' ||
                    _connectionStatus == 'ConnectivityResult.mobile'
                ? _userData != null && _stagesData != null && _goldenStageUnlocked != null && _goldenStage != null
                    ? Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top:10,
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
                                              linearStrokeCap: LinearStrokeCap.roundAll,
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
                                                            child: _userData[
                                                                        'User_Details.photoURL'] !=
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
                          Container(
                            margin: EdgeInsets.only(top: size.height * 0.3),
                            height: _listHeight * 1.1,
                            child: Column(
                              children: [
                                Expanded(
                                  child: ScrollSnapList(
                                    onItemFocus: (int) {
                                      setState(() {
                                        _stageIndex = int;
                                      });
                                    },
                                    listController: _snapController,
                                    itemSize: _listWidth,
                                    dynamicItemSize: true,
                                    itemCount: stageData.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: _listWidth,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (index != 10) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) {
                                                        return StageHomeScreen(
                                                            stageData[index][0], index + 1);
                                                      },
                                                    ),
                                                  );
                                                } else {
                                                  if (_goldenStageUnlocked) {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (_) {
                                                          return GoldenStageHomeScreen();
                                                        },
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (_) {
                                                          return StageEntryPage();
                                                        },
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                              highlightColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              child: index != 10
                                                  ? Container(
                                                      width: _listWidth,
                                                      height: _listHeight,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 10,
                                                            color:
                                                                Colors.black.withOpacity(.6),
                                                            spreadRadius: 2,
                                                          )
                                                        ],
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            top: 12,
                                                            left: 15,
                                                            child: Text(
                                                              'STAGE ${index == 9 ? '' : '0'}${index + 1}',
                                                              style: TextStyle(
                                                                fontSize: 25,
                                                                color: Color.fromARGB(
                                                                    255, 53, 25, 46),
                                                                fontFamily: 'Aquire',
                                                                shadows: [
                                                                  Shadow(
                                                                    color: Colors.black
                                                                        .withOpacity(0.6),
                                                                    blurRadius: 2,
                                                                    offset: Offset(1, 1),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: 15,
                                                            top: 25,
                                                            child: SizedBox(
                                                              height: 150,
                                                              width: 150,
                                                              child: Image.asset(
                                                                  'assets/Trigonometry_Stage_${index + 1}.png'),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: 15,
                                                            top: 170,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                  'TRIGONOMETRY',
                                                                  style: TextStyle(
                                                                    fontSize: 28,
                                                                    fontFamily: 'OCR A',
                                                                    color: Color.fromARGB(
                                                                        255, 53, 25, 47),
                                                                    shadows: [
                                                                      Shadow(
                                                                        color: Colors.black
                                                                            .withOpacity(0.5),
                                                                        blurRadius: 4,
                                                                        offset:
                                                                            Offset(0.5, 0.5),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin:
                                                                      EdgeInsets.only(top: 7),
                                                                  width: 210,
                                                                  child: Text(
                                                                    stageData[index][0],
                                                                    style: TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255, 1, 79, 134),
                                                                      height: 1.1,
                                                                      fontSize: 20,
                                                                      fontFamily:
                                                                          'Abhaya Libre',
                                                                      shadows: [
                                                                        Shadow(
                                                                          color:
                                                                              Color.fromARGB(
                                                                                      255,
                                                                                      1,
                                                                                      79,
                                                                                      134)
                                                                                  .withOpacity(
                                                                                      0.9),
                                                                          blurRadius: 2,
                                                                          offset:
                                                                              Offset(0.5, 1),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    textAlign: TextAlign.end,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Stack(
                                                      alignment: AlignmentDirectional.center,
                                                      children: [
                                                        Container(
                                                          width: _listWidth,
                                                          height: _listHeight,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(20),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 10,
                                                                color: Colors.black
                                                                    .withOpacity(.6),
                                                                spreadRadius: 2,
                                                              )
                                                            ],
                                                          ),
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                top: 12,
                                                                left: 15,
                                                                child: Stack(
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      'GOLDEN STAGE',
                                                                      style: TextStyle(
                                                                        fontSize: 25,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontFamily:
                                                                            'Aquire Bold',
                                                                        foreground: Paint()
                                                                          ..strokeWidth = 0.5
                                                                          ..color =
                                                                              Color.fromARGB(
                                                                                  255,
                                                                                  183,
                                                                                  153,
                                                                                  6)
                                                                          ..style =
                                                                              PaintingStyle
                                                                                  .stroke,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'GOLDEN STAGE',
                                                                      style: TextStyle(
                                                                        fontSize: 25,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Color.fromARGB(
                                                                            255, 239, 197, 1),
                                                                        fontFamily:
                                                                            'Aquire Bold',
                                                                        shadows: [
                                                                          Shadow(
                                                                            color: Colors.black
                                                                                .withOpacity(
                                                                                    0.6),
                                                                            blurRadius: 2,
                                                                            offset:
                                                                                Offset(1, 1),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Positioned(
                                                                right: 15,
                                                                top: 35,
                                                                child: SizedBox(
                                                                  height: 135,
                                                                  width: 135,
                                                                  child: Image.asset(
                                                                      'assets/Trigonometry_Golden_Stage_Enter.png'),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                right: 15,
                                                                top: 170,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.end,
                                                                  children: [
                                                                    Text(
                                                                      'TRIGONOMETRY',
                                                                      style: TextStyle(
                                                                        fontSize: 28,
                                                                        fontFamily: 'OCR A',
                                                                        color: Color.fromARGB(
                                                                            255, 249, 166, 2),
                                                                        shadows: [
                                                                          Shadow(
                                                                            color: Colors.black
                                                                                .withOpacity(
                                                                                    0.5),
                                                                            blurRadius: 4,
                                                                            offset: Offset(
                                                                                0.5, 0.5),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: 15),
                                                                      width: 210,
                                                                      child: Text(
                                                                        stageData[index][0],
                                                                        style: TextStyle(
                                                                          color:
                                                                              Color.fromARGB(
                                                                                  255,
                                                                                  249,
                                                                                  166,
                                                                                  2),
                                                                          height: 1.5,
                                                                          fontSize: 12,
                                                                          fontFamily:
                                                                              'Open Sans',
                                                                          shadows: [
                                                                            Shadow(
                                                                              color: Color
                                                                                      .fromARGB(
                                                                                          255,
                                                                                          249,
                                                                                          166,
                                                                                          2)
                                                                                  .withOpacity(
                                                                                      0.9),
                                                                              blurRadius: 2,
                                                                              offset: Offset(
                                                                                  0.5, 1),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        _goldenStageUnlocked
                                                            ? SizedBox.shrink()
                                                            : Container(
                                                                width: _listWidth,
                                                                height: _listHeight,
                                                                alignment:
                                                                    Alignment(-0.7, -0.4),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black
                                                                      .withOpacity(0.3),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          20),
                                                                ),
                                                                child: SizedBox(
                                                                  width: 60,
                                                                  height: 60,
                                                                  child: Image.asset(
                                                                      'assets/Lock_Icon.png'),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            child: Padding(
                              padding: EdgeInsets.only(top: size.height * 0.725, left: 10),
                              child: Text(
                                'Current status of this stage',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Gadugi',
                                  fontSize: 20,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.7),
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          _stageIndex != 10
                              ? Padding(
                                  padding: EdgeInsets.only(top: size.height * 0.77),
                                  child: SingleChildScrollView(
                                    controller: controller,
                                    child: Column(
                                      children: [
                                        Opacity(
                                          opacity: _firstContainerScale,
                                          child: Transform(
                                            transform: Matrix4.identity()
                                              ..scale(
                                                  _firstContainerScale, _firstContainerScale),
                                            alignment: Alignment.bottomCenter,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 13,
                                                ),
                                                Container(
                                                  width: size.width * 0.8,
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        spreadRadius: 0,
                                                        blurRadius: 5,
                                                        color: Colors.black.withOpacity(0.5),
                                                        offset: Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Completed',
                                                                style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontFamily: 'AgencyFB Bold',
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              Text(
                                                                'In this stage',
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily: 'Lemon Jelly',
                                                                  color: Color.fromARGB(
                                                                      255, 200, 62, 77),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 70,
                                                            height: size.height,
                                                            color: Color.fromARGB(
                                                                255, 176, 232, 255),
                                                            child: Center(
                                                              child: Text(
                                                                '${_stagesData['Stage_${_stageIndex + 1}.Info.completed']}/${stageData[_stageIndex][1]}',
                                                                style: TextStyle(
                                                                  fontFamily: 'Niagara Solid',
                                                                  fontSize: 25,
                                                                  color: Color.fromARGB(
                                                                      255, 115, 111, 114),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Stack(
                                                            alignment:
                                                                AlignmentDirectional.center,
                                                            children: [
                                                              SizedBox(
                                                                height: 40,
                                                                width: 16,
                                                                child: CustomPaint(
                                                                  painter: FlashDrawer(
                                                                      40,
                                                                      40,
                                                                      Color.fromARGB(
                                                                          255, 217, 209, 252)),
                                                                  child: Container(),
                                                                ),
                                                              ),
                                                              TweenAnimationBuilder(
                                                                tween: Tween(
                                                                  begin: 0.0,
                                                                  end: _stagesData[
                                                                              'Stage_${_stageIndex + 1}.Info']
                                                                          ['completed'] /
                                                                      stageData[_stageIndex]
                                                                          [1],
                                                                ),
                                                                duration: Duration(seconds: 1),
                                                                builder: (_, height, __) {
                                                                  return SizedBox(
                                                                    height: 40,
                                                                    width: 16,
                                                                    child: CustomPaint(
                                                                      painter: FlashDrawer(
                                                                          40,
                                                                          40 * height,
                                                                          Color.fromARGB(255,
                                                                              30, 16, 95)),
                                                                      child: Container(),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          TweenAnimationBuilder(
                                                            tween: Tween(
                                                              begin: 0.0,
                                                              end: _stagesData[
                                                                          'Stage_${_stageIndex + 1}.Info']
                                                                      ['completed'] /
                                                                  stageData[_stageIndex][1],
                                                            ),
                                                            duration: Duration(seconds: 1),
                                                            builder: (_, percentage, __) {
                                                              return SizedBox(
                                                                width: 40,
                                                                child: Text(
                                                                  '${(100 * percentage).toStringAsFixed(0)}%',
                                                                  style: TextStyle(
                                                                    fontSize: percentage == 1
                                                                        ? 15
                                                                        : 20,
                                                                    fontFamily: 'Open Sans',
                                                                  ),
                                                                  textAlign: TextAlign.end,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: _secondContainerScale,
                                          child: Transform(
                                            transform: Matrix4.identity()
                                              ..scale(_secondContainerScale,
                                                  _secondContainerScale),
                                            alignment: Alignment.bottomCenter,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 13,
                                                ),
                                                Container(
                                                  width: size.width * 0.8,
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        spreadRadius: 0,
                                                        blurRadius: 5,
                                                        color: Colors.black.withOpacity(0.5),
                                                        offset: Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Accuracy',
                                                                style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontFamily: 'AgencyFB Bold',
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              Text(
                                                                'In this stage',
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily: 'Lemon Jelly',
                                                                  color: Color.fromARGB(
                                                                      255, 200, 62, 77),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 70,
                                                            height: size.height,
                                                            color: Color.fromARGB(
                                                                255, 176, 232, 255),
                                                            child: Center(
                                                              child: Text(
                                                                '${_stagesData['Stage_${_stageIndex + 1}.Info']['correct']}/${_stagesData['Stage_${_stageIndex + 1}.Info']['completed']}',
                                                                style: TextStyle(
                                                                  fontFamily: 'Niagara Solid',
                                                                  fontSize: 25,
                                                                  color: Color.fromARGB(
                                                                      255, 115, 111, 114),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Stack(
                                                            alignment:
                                                                AlignmentDirectional.center,
                                                            children: [
                                                              SizedBox(
                                                                height: 40,
                                                                width: 16,
                                                                child: CustomPaint(
                                                                  painter: FlashDrawer(
                                                                      40,
                                                                      40,
                                                                      Color.fromARGB(
                                                                          255, 217, 209, 252)),
                                                                  child: Container(),
                                                                ),
                                                              ),
                                                              TweenAnimationBuilder(
                                                                tween: Tween(
                                                                  begin: 0.0,
                                                                  end: _stagesData[
                                                                                  'Stage_${_stageIndex + 1}.Info']
                                                                              ['completed'] !=
                                                                          0
                                                                      ? _stagesData[
                                                                                  'Stage_${_stageIndex + 1}.Info']
                                                                              ['correct'] /
                                                                          _stagesData[
                                                                                  'Stage_${_stageIndex + 1}.Info']
                                                                              ['completed']
                                                                      : 0.0,
                                                                ),
                                                                duration: Duration(seconds: 1),
                                                                builder: (_, height, __) {
                                                                  return SizedBox(
                                                                    height: 40,
                                                                    width: 16,
                                                                    child: CustomPaint(
                                                                      painter: FlashDrawer(
                                                                          40,
                                                                          40 * height,
                                                                          Color.fromARGB(255,
                                                                              30, 16, 95)),
                                                                      child: Container(),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          TweenAnimationBuilder(
                                                            tween: Tween(
                                                              begin: 0.0,
                                                              end: _stagesData[
                                                                              'Stage_${_stageIndex + 1}.Info']
                                                                          ['completed'] !=
                                                                      0
                                                                  ? _stagesData[
                                                                              'Stage_${_stageIndex + 1}.Info']
                                                                          ['correct'] /
                                                                      _stagesData[
                                                                              'Stage_${_stageIndex + 1}.Info']
                                                                          ['completed']
                                                                  : 0,
                                                            ),
                                                            duration: Duration(seconds: 1),
                                                            builder: (_, percentage, __) {
                                                              return SizedBox(
                                                                width: 40,
                                                                child: Text(
                                                                  '${(100 * percentage).toStringAsFixed(0)}%',
                                                                  style: TextStyle(
                                                                    fontSize: percentage == 1
                                                                        ? 15
                                                                        : 20,
                                                                    fontFamily: 'Open Sans',
                                                                  ),
                                                                  textAlign: TextAlign.end,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: _thirdContainerScale,
                                          child: Transform(
                                            transform: Matrix4.identity()
                                              ..scale(
                                                  _thirdContainerScale, _thirdContainerScale),
                                            alignment: Alignment.bottomCenter,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 13,
                                                ),
                                                Container(
                                                  width: size.width * 0.8,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        spreadRadius: 0,
                                                        blurRadius: 5,
                                                        color: Colors.black.withOpacity(0.5),
                                                        offset: Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'XP Earned',
                                                                style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontFamily: 'AgencyFB Bold',
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              Text(
                                                                'In this stage',
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily: 'Lemon Jelly',
                                                                  color: Color.fromARGB(
                                                                      255, 200, 62, 77),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 145,
                                                            height: size.height,
                                                            color: Color.fromARGB(
                                                                255, 176, 232, 255),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.center,
                                                              children: [
                                                                TweenAnimationBuilder(
                                                                    tween: Tween(
                                                                        begin: 0.0,
                                                                        end: _stagesData[
                                                                                'Stage_${_stageIndex + 1}.Info']
                                                                            ['xpEarned']),
                                                                    duration:
                                                                        Duration(seconds: 1),
                                                                    builder: (_, xp, __) {
                                                                      return RichText(
                                                                        text: TextSpan(
                                                                          children: [
                                                                            TextSpan(
                                                                              text:
                                                                                  '${(xp).toStringAsFixed(0)}',
                                                                              style: TextStyle(
                                                                                fontFamily:
                                                                                    'AgencyFB',
                                                                                fontSize: 25,
                                                                                color: Colors
                                                                                    .black,
                                                                              ),
                                                                            ),
                                                                            TextSpan(
                                                                              text:
                                                                                  '/${stageData[_stageIndex][2]}',
                                                                              style: TextStyle(
                                                                                fontFamily:
                                                                                    'AgencyFB',
                                                                                fontSize: 15,
                                                                                color: Colors
                                                                                    .black,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                    top: 8,
                                                                  ),
                                                                  child:
                                                                      LinearPercentIndicator(
                                                                    animation: true,
                                                                    animationDuration: 1000,
                                                                    animateFromLastPercent:
                                                                        true,
                                                                    width: 125.0,
                                                                    lineHeight: 8.0,
                                                                    percent: _stagesData[
                                                                                    'Stage_${_stageIndex + 1}.Info']
                                                                                ['xpEarned'] <=
                                                                            stageData[
                                                                                _stageIndex][2]
                                                                        ? _stagesData[
                                                                                    'Stage_${_stageIndex + 1}.Info']
                                                                                ['xpEarned'] /
                                                                            stageData[
                                                                                _stageIndex][2]
                                                                        : 1,
                                                                    progressColor:
                                                                        Color.fromARGB(
                                                                            255, 30, 16, 95),
                                                                    alignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 13,
                                        ),
                                        Container(
                                          width: size.width * 0.8,
                                          height: 85,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                spreadRadius: 0,
                                                blurRadius: 5,
                                                color: Colors.black.withOpacity(0.5),
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Probability',
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          fontFamily: 'AgencyFB Bold',
                                                          color: Colors.black,
                                                          height: 1,
                                                        ),
                                                      ),
                                                      Text(
                                                        'of giving an answer \ncorrectly.',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'AgencyFB Bold',
                                                          height: 1.2,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        'In this stage',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: 'Lemon Jelly',
                                                          color:
                                                              Color.fromARGB(255, 200, 62, 77),
                                                          height: 0.9,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  bottomRight: Radius.circular(15),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 145,
                                                      height: size.height,
                                                      color: Color.fromARGB(255, 176, 232, 255),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                          children: [
                                                            TweenAnimationBuilder(
                                                              tween: Tween(
                                                                begin: 0.0,
                                                                end: _stagesData[
                                                                                'Stage_${_stageIndex + 1}.Info']
                                                                            ['completed'] !=
                                                                        0
                                                                    ? _stagesData[
                                                                                'Stage_${_stageIndex + 1}.Info']
                                                                            ['correct'] *
                                                                        5 /
                                                                        _stagesData[
                                                                                'Stage_${_stageIndex + 1}.Info']
                                                                            ['completed']
                                                                    : 0,
                                                              ),
                                                              duration: Duration(seconds: 1),
                                                              builder: (_, probability, __) {
                                                                return RichText(
                                                                  text: TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            '${(probability).toStringAsFixed(2)}',
                                                                        style: TextStyle(
                                                                          fontFamily: 'AgencyFB',
                                                                          fontSize: 25,
                                                                          color: Colors.black,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: '/5',
                                                                        style: TextStyle(
                                                                          fontFamily: 'AgencyFB',
                                                                          fontSize: 15,
                                                                          color: Colors.black,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            TweenAnimationBuilder(
                                                              tween: Tween(
                                                                begin: 0.0,
                                                                end: _stagesData[
                                                                                'Stage_${_stageIndex + 1}.Info']
                                                                            ['completed'] !=
                                                                        0
                                                                    ? _stagesData[
                                                                                'Stage_${_stageIndex + 1}.Info']
                                                                            ['correct'] *
                                                                        5 /
                                                                        _stagesData[
                                                                                'Stage_${_stageIndex + 1}.Info']
                                                                            ['completed']
                                                                    : 0.0,
                                                              ),
                                                              duration: Duration(seconds: 1),
                                                              builder: (_, probability, __) {
                                                                return RatingBarIndicator(
                                                                  rating: probability,
                                                                  itemBuilder: (context, index) {
                                                                    return Icon(
                                                                      Icons.done,
                                                                      color: Color.fromARGB(
                                                                          255, 30, 16, 95),
                                                                    );
                                                                  },
                                                                  itemCount: 5,
                                                                  itemSize: 25,
                                                                  direction: Axis.horizontal,
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 13,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: size.height * 0.77),
                                  child: SingleChildScrollView(
                                    controller: controller,
                                    child: Column(
                                      children: [
                                        !_goldenStageUnlocked
                                            ? Opacity(
                                                opacity: _firstContainerScale,
                                                child: Transform(
                                                  transform: Matrix4.identity()
                                                    ..scale(_firstContainerScale,
                                                        _firstContainerScale),
                                                  alignment: Alignment.bottomCenter,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 13,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                              builder: (_) {
                                                                return StageEntryPage();
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        splashColor: Colors.transparent,
                                                        highlightColor: Colors.transparent,
                                                        child: Container(
                                                          width: size.width * 0.8,
                                                          height: 55,
                                                          margin: EdgeInsets.only(
                                                              left: 5, right: 5),
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(30),
                                                            gradient: LinearGradient(
                                                              colors: [
                                                                Color.fromARGB(
                                                                    255, 239, 197, 1),
                                                                Color.fromARGB(
                                                                    255, 249, 224, 159),
                                                                Color.fromARGB(
                                                                    255, 239, 197, 1),
                                                              ],
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 5,
                                                                spreadRadius: 1,
                                                                color: Colors.black
                                                                    .withOpacity(0.3),
                                                                offset: Offset(0, 3),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'HOW TO UNLOCK',
                                                              style: TextStyle(
                                                                fontFamily: 'Open Sans',
                                                                fontSize: 20,
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                        Opacity(
                                          opacity: _goldenStageUnlocked
                                              ? _firstContainerScale
                                              : _secondContainerScale,
                                          child: Transform(
                                            transform: Matrix4.identity()
                                              ..scale(
                                                  _goldenStageUnlocked
                                                      ? _firstContainerScale
                                                      : _secondContainerScale,
                                                  _goldenStageUnlocked
                                                      ? _firstContainerScale
                                                      : _secondContainerScale),
                                            alignment: Alignment.bottomCenter,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 13,
                                                ),
                                                Container(
                                                  width: size.width * 0.8,
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        spreadRadius: 0,
                                                        blurRadius: 5,
                                                        color: Colors.black.withOpacity(0.5),
                                                        offset: Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Completed',
                                                                style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontFamily: 'AgencyFB Bold',
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              Text(
                                                                'In this stage',
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily: 'Lemon Jelly',
                                                                  color: Color.fromARGB(
                                                                      255, 200, 62, 77),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 70,
                                                            height: size.height,
                                                            color: Color.fromARGB(
                                                                255, 176, 232, 255),
                                                            child: Center(
                                                              child: Text(
                                                                '${_goldenStage['Stage_Info.completed']}/${stageData[_stageIndex][1]}',
                                                                style: TextStyle(
                                                                  fontFamily: 'Niagara Solid',
                                                                  fontSize: 25,
                                                                  color: Color.fromARGB(
                                                                      255, 115, 111, 114),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Stack(
                                                            alignment:
                                                                AlignmentDirectional.center,
                                                            children: [
                                                              SizedBox(
                                                                height: 40,
                                                                width: 16,
                                                                child: CustomPaint(
                                                                  painter: FlashDrawer(
                                                                      40,
                                                                      40,
                                                                      Color.fromARGB(
                                                                          255, 217, 209, 252)),
                                                                  child: Container(),
                                                                ),
                                                              ),
                                                              TweenAnimationBuilder(
                                                                tween: Tween(
                                                                  begin: 0.0,
                                                                  end: _goldenStage['Stage_Info.completed'] /
                                                                      stageData[_stageIndex]
                                                                          [1],
                                                                ),
                                                                duration: Duration(seconds: 1),
                                                                builder: (_, height, __) {
                                                                  return SizedBox(
                                                                    height: 40,
                                                                    width: 16,
                                                                    child: CustomPaint(
                                                                      painter: FlashDrawer(
                                                                          40,
                                                                          40 * height,
                                                                          Color.fromARGB(255,
                                                                              249, 166, 2)),
                                                                      child: Container(),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          TweenAnimationBuilder(
                                                            tween: Tween(
                                                              begin: 0.0,
                                                              end: _goldenStage['Stage_Info.completed'] /
                                                                  stageData[_stageIndex][1],
                                                            ),
                                                            duration: Duration(seconds: 1),
                                                            builder: (_, percentage, __) {
                                                              return SizedBox(
                                                                width: 40,
                                                                child: Text(
                                                                  '${(100 * percentage).toStringAsFixed(0)}%',
                                                                  style: TextStyle(
                                                                    fontSize: percentage == 1
                                                                        ? 15
                                                                        : 20,
                                                                    fontFamily: 'Open Sans',
                                                                  ),
                                                                  textAlign: TextAlign.end,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: _goldenStageUnlocked
                                              ? _secondContainerScale
                                              : _thirdContainerScale,
                                          child: Transform(
                                            transform: Matrix4.identity()
                                              ..scale(
                                                  _goldenStageUnlocked
                                                      ? _secondContainerScale
                                                      : _thirdContainerScale,
                                                  _goldenStageUnlocked
                                                      ? _secondContainerScale
                                                      : _thirdContainerScale),
                                            alignment: Alignment.bottomCenter,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 13,
                                                ),
                                                Container(
                                                  width: size.width * 0.8,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        spreadRadius: 0,
                                                        blurRadius: 5,
                                                        color: Colors.black.withOpacity(0.5),
                                                        offset: Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'XP Earned',
                                                                style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontFamily: 'AgencyFB Bold',
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              Text(
                                                                'In this stage',
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily: 'Lemon Jelly',
                                                                  color: Color.fromARGB(
                                                                      255, 200, 62, 77),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 145,
                                                            height: size.height,
                                                            color: Color.fromARGB(
                                                                255, 176, 232, 255),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.center,
                                                              children: [
                                                                TweenAnimationBuilder(
                                                                  tween: Tween(
                                                                      begin: 0.0, end: _goldenStage['Stage_Info.xpEarned']),
                                                                  duration:
                                                                      Duration(seconds: 1),
                                                                  builder: (_, xp, __) {
                                                                    return RichText(
                                                                      text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                '${(xp).toStringAsFixed(0)}',
                                                                            style: TextStyle(
                                                                              fontFamily:
                                                                                  'AgencyFB',
                                                                              fontSize: 25,
                                                                              color:
                                                                                  Colors.black,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                '/${stageData[_stageIndex][2]}',
                                                                            style: TextStyle(
                                                                              fontFamily:
                                                                                  'AgencyFB',
                                                                              fontSize: 15,
                                                                              color:
                                                                                  Colors.black,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                    top: 8,
                                                                  ),
                                                                  child:
                                                                      LinearPercentIndicator(
                                                                    animation: true,
                                                                    animationDuration: 1000,
                                                                    animateFromLastPercent:
                                                                        true,
                                                                    width: 125.0,
                                                                    lineHeight: 8.0,
                                                                    percent: (_goldenStage['Stage_Info.xpEarned']>4500?4500:_goldenStage['Stage_Info.xpEarned']) /
                                                                        stageData[_stageIndex]
                                                                            [2],
                                                                    progressColor:
                                                                    Color.fromARGB(255,
                                                                        249, 166, 2),
                                                                    alignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 13,
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
          ],
        ),
      ),
    );
  }
}

class FlashDrawer extends CustomPainter {
  Color color;
  double top;
  double height;

  FlashDrawer(this.height, this.top, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;
    var path = Path();

    path.moveTo(size.width * 7 / 8, 0);
    path.lineTo(0, size.height * 0.4);
    path.lineTo(size.width * 3 / 8, size.height * 0.6);
    path.lineTo(size.width * 1 / 8, size.height);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width * 5 / 8, size.height * 0.4);
    path.close();

    canvas.drawPath(
        Path.combine(
            PathOperation.intersect,
            Path()
              ..addRect(
                Rect.fromLTWH(0, height - top, size.width, height),
              ),
            path),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
