import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Event_1/account_screen.dart';
import 'package:maths_vision/Event_1/answer_display_screen.dart';
import 'package:maths_vision/Event_1/level_up_screen.dart';
import 'package:maths_vision/Data_Directory/questions_data.dart';
import 'package:maths_vision/Event_1/store.dart';
import 'package:maths_vision/Event_1/video_display_screen.dart';
import 'package:maths_vision/Screens/papers_screen.dart';
import 'package:maths_vision/Splash_Screens/went_home_splash_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../Support_Classes/event_errors_and_loading.dart';
import 'leaderboard.dart';

class QuestionDisplayScreen extends StatefulWidget {
  final int stage;
  final int question;
  final int startLevel;

  const QuestionDisplayScreen(this.stage, this.question, this.startLevel, {Key key})
      : super(key: key);

  @override
  _QuestionDisplayScreenState createState() => _QuestionDisplayScreenState();
}

class _QuestionDisplayScreenState extends State<QuestionDisplayScreen> {
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

  int _currentLevel;
  int _startLevel;
  int _coins;
  int _xp;
  int _answerBuyCoins;
  List _answers = [];
  String _correctAnswer = '';
  String _selectedValue = '';
  Map _question;
  StreamSubscription _userSubscription;
  DocumentSnapshot _userData;
  DocumentSnapshot _stagesData;
  List _questionData = [];
  bool _answerIsCorrect;
  Color _selectedColor = Color.fromARGB(255, 1, 79, 134);
  Color _unselectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    initConnectivity();
    CollectionReference eventData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event');
    eventData.doc('Stages').snapshots().listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        _stagesData = event;
      });
      _questionData = [];
      if (_stagesData != null) {
        setState(() {
          _questionData.add(_stagesData[
              'Stage_${widget.stage}.Questions_Details.Question_${widget.question}']);
        });
      }
      if (_questionData.isNotEmpty) {
        if (_questionData[0]['done']) {
          if (!mounted) {
            return;
          }
          setState(() {
            _selectedValue = _questionData[0]['selectedValue'];
          });
        } else {
          if (!mounted) {
            return;
          }
          setState(() {
            _selectedValue = '';
          });
        }
      }
    });
    Stream userStream =
        FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots();
    _userSubscription = userStream.listen((event) {
      setState(() {
        _userData = event;
      });
    });
    _answers = questions['stage${widget.stage}']['question${widget.question}']['answers'];
    _correctAnswer = questions['stage${widget.stage}']['question${widget.question}']['answer'];
    _question = questions['stage${widget.stage}']['question${widget.question}']['question'];
    _coins = questions['stage${widget.stage}']['question${widget.question}']['coins'];
    _xp = questions['stage${widget.stage}']['question${widget.question}']['xp'];
    _answerBuyCoins =
        questions['stage${widget.stage}']['question${widget.question}']['answerBuyCoins'];
    _startLevel = widget.startLevel;
  }

  @override
  void dispose() {
    super.dispose();
    _userSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    int sumOfN = 0;
    int xp = _userData != null ? _userData['User_Details.xp'] : 0;
    int sumOfBeforeN = 0;
    int currentLevelXP;
    int currentLevelTotalXP;
    for (int i = 1; i < 150; i += 1) {
      _currentLevel = i;
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
          ? _userData != null && _stagesData != null
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
                                              color: Colors.black,
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
                                              '$_currentLevel',
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
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (_) {
                                                      return AccountScreen();
                                                    },
                                                  ),
                                                );
                                              },
                                              onLongPress: () {
                                                Navigator.of(context).pushReplacement(
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
                    SizedBox(
                      height: width * 0.025,
                    ),
                    Expanded(
                      child: Container(
                        width: width * 0.95,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25, top: 15, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Question ${widget.question < 10 ? '0' : ''}${widget.question}',
                                      style: TextStyle(
                                        fontFamily: 'Forte',
                                        fontSize: 35,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    _questionData.isNotEmpty
                                        ? !_questionData[0]['done'] &&
                                                !_questionData[0]['xpDoubleUsed']
                                            ? InkWell(
                                                onTap: () {
                                                  _doubleXPDialog(context);
                                                },
                                                child: Stack(
                                                  alignment: AlignmentDirectional.center,
                                                  children: [
                                                    ShapeOfView(
                                                      shape: PolygonShape(numberOfSides: 6),
                                                      width: 45,
                                                      height: 45,
                                                      elevation: 6,
                                                      child: Container(
                                                        color:
                                                            Color.fromARGB(255, 255, 215, 0),
                                                      ),
                                                    ),
                                                    ShapeOfView(
                                                      shape: PolygonShape(numberOfSides: 6),
                                                      width: 40,
                                                      height: 40,
                                                      elevation: 0,
                                                      child: Container(
                                                        color:
                                                            Color.fromARGB(255, 192, 192, 192),
                                                        child: Center(
                                                          child: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                WidgetSpan(
                                                                  child: Transform.translate(
                                                                    offset: const Offset(
                                                                        0.0, -1.0),
                                                                    child: Text(
                                                                      'x',
                                                                      style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255, 1, 79, 134),
                                                                        fontSize: 24,
                                                                        fontFamily: 'Gothic',
                                                                        height: 1,
                                                                        letterSpacing: 3,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: '2',
                                                                  style: TextStyle(
                                                                    fontSize: 24,
                                                                    fontFamily: 'Gothic',
                                                                    height: 1,
                                                                    letterSpacing: 3,
                                                                    fontWeight:
                                                                        FontWeight.bold,
                                                                    color: Color.fromARGB(
                                                                        255, 1, 79, 134),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox()
                                        : SizedBox(),
                                    _questionData.isNotEmpty
                                        ? _questionData[0]['done']
                                            ? SizedBox(
                                                width: 35,
                                                height: 35,
                                                child: _questionData[0]['correct']
                                                    ? Image.asset('assets/Correct_Icon.png')
                                                    : Image.asset('assets/Incorrect_Icon.png'),
                                              )
                                            : SizedBox()
                                        : SizedBox(),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 5),
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    left: 5,
                                    right: 5,
                                    bottom: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black, width: 1)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        child: Math.tex(
                                          _question['firstLine'],
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                      _question.length > 2
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: FittedBox(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${_question['secondLine'][0]} ',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'Iskola Potha',
                                                        color: Colors.black,
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                    Math.tex(
                                                      _question['secondLine'][1],
                                                      mathStyle: MathStyle.display,
                                                      textStyle: TextStyle(fontSize: 25),
                                                    ),
                                                    Text(
                                                      ' ${_question['secondLine'][2]}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'Iskola Potha',
                                                        color: Colors.black,
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          '${_question['thirdLine']}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Iskola Potha',
                                            color: Colors.black,
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                      _question.length > 3
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: Math.tex(
                                                _question['forthLine'],
                                                mathStyle: MathStyle.display,
                                                textStyle: TextStyle(fontSize: 20),
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Column(
                                    children: _answers.map((value) {
                                      final selected = this._selectedValue == value;
                                      final color =
                                          selected ? _selectedColor : _unselectedColor;
                                      return RadioListTile<String>(
                                        value: value,
                                        groupValue: _selectedValue,
                                        title: widget.stage == 9 &&
                                                widget.question > 1 &&
                                                widget.question < 5
                                            ? StreamBuilder(
                                                stream: FirebaseStorage.instance
                                                    .ref(
                                                        'Events/Trigonometry/Stage_${widget.stage}/$value.JPG')
                                                    .getDownloadURL()
                                                    .asStream(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return InteractiveViewer(
                                                      minScale: 1,
                                                      maxScale: 4,
                                                      child: CachedNetworkImage(
                                                        imageUrl: snapshot.data,
                                                        placeholder: (_, url) {
                                                          return SizedBox(
                                                            width: 50,
                                                            height: 50,
                                                            child: LoadingBumpingLine.circle(
                                                              backgroundColor:
                                                                  Colors.transparent,
                                                              borderColor: Colors.black,
                                                              borderSize: 7,
                                                              size: 50,
                                                            ),
                                                          );
                                                        },
                                                        errorWidget: (context, url, error) {
                                                          return Icon(Icons.error);
                                                        },
                                                      ),
                                                    );
                                                  } else if (snapshot.hasError) {
                                                    return UnknownError();
                                                  } else {
                                                    return EventLoading();
                                                  }
                                                },
                                              )
                                            : FittedBox(
                                                alignment: Alignment.centerLeft,
                                                fit: BoxFit.scaleDown,
                                                child: Math.tex(
                                                  value,
                                                  mathStyle: MathStyle.display,
                                                  textStyle: TextStyle(
                                                    fontSize: 18,
                                                    color: color,
                                                  ),
                                                ),
                                              ),
                                        activeColor: color,
                                        onChanged: (value) {
                                          setState(() {
                                            this._selectedValue = value;
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (_questionData[0]['answerBought']) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) {
                                                  return AnswerDisplayScreen(
                                                      widget.stage, widget.question);
                                                },
                                              ),
                                            );
                                          } else {
                                            _answerBuyDialog(context);
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color.fromARGB(255, 96, 170, 77),
                                                Color.fromARGB(255, 159, 219, 155),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                                offset: Offset(0, 3),
                                                color: Colors.black.withOpacity(0.5),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
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
                                                            offset: Offset(1.0, 0.0),
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
                                                  SizedBox(
                                                    width: 7,
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
                                                            offset: Offset(1.0, 0.0),
                                                            child: Text(
                                                              '${widget.question}',
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
                                                ],
                                              ),
                                              Text(
                                                'Answer',
                                                style: TextStyle(
                                                  fontFamily: 'Scriptina',
                                                  fontSize: 25,
                                                  color: Colors.black,
                                                  height: 1.5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              _questionData[0]['done'] &&
                                                      !_questionData[0]['answerBought']
                                                  ? SizedBox(
                                                      width: 28,
                                                      child: Image.asset(
                                                        'assets/Answer_Unlock_Icon.png',
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      !_questionData[0]['done']
                                          ? InkWell(
                                              onTap: () {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'You must have answered the question first.',
                                                  fontSize: 20,
                                                  gravity: ToastGravity.BOTTOM,
                                                  textColor: Colors.white,
                                                  backgroundColor:
                                                      Color.fromARGB(255, 1, 79, 134)
                                                          .withOpacity(0.8),
                                                );
                                              },
                                              child: Stack(
                                                alignment: AlignmentDirectional.centerEnd,
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(255, 43, 56, 36)
                                                          .withOpacity(0.6),
                                                      borderRadius: BorderRadius.circular(25),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 15,
                                                    child: SizedBox(
                                                      height: 28,
                                                      child:
                                                          Image.asset('assets/Lock_Icon.png'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Reward',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: 'Gothic',
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(255, 1, 79, 134),
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 3,
                                                      color: Colors.black.withOpacity(0.4),
                                                      offset: Offset(1, 1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              _questionData[0]['xpDoubleUsed']
                                                  ? Container(
                                                      width: 40,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(15),
                                                        border: Border.all(
                                                          color: Color.fromARGB(
                                                              255, 192, 192, 192),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              WidgetSpan(
                                                                child: Transform.translate(
                                                                  offset:
                                                                      const Offset(0.0, -1.0),
                                                                  child: Text(
                                                                    'x',
                                                                    style: TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255, 1, 79, 134),
                                                                      fontSize: 15,
                                                                      fontFamily: 'Gothic',
                                                                      height: 1,
                                                                      letterSpacing: 3,
                                                                      fontWeight:
                                                                          FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: '2',
                                                                style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily: 'Gothic',
                                                                  height: 1,
                                                                  letterSpacing: 3,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Color.fromARGB(
                                                                      255, 1, 79, 134),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '$_coins',
                                                    style: TextStyle(
                                                      fontFamily: 'Gothic',
                                                      fontSize: 27,
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
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 27,
                                                    child: Image.asset('assets/Coin.png'),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  !_questionData[0]['xpDoubleUsed']
                                                      ? Text(
                                                          '$_xp',
                                                          style: TextStyle(
                                                            fontFamily: 'Gothic',
                                                            fontSize: 27,
                                                            color: Colors.black,
                                                            height: 1,
                                                            shadows: [
                                                              Shadow(
                                                                blurRadius: 1,
                                                                offset: Offset(1, 1),
                                                                color: Colors.black
                                                                    .withOpacity(0.4),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : TweenAnimationBuilder(
                                                          tween: Tween(
                                                              begin: _xp, end: _xp * 2.0),
                                                          duration: Duration(seconds: 1),
                                                          builder: (_, xp, __) {
                                                            return Text(
                                                              '${xp.toStringAsFixed(0)}',
                                                              style: TextStyle(
                                                                fontFamily: 'Gothic',
                                                                fontSize: 27,
                                                                color: Colors.black,
                                                                height: 1,
                                                                shadows: [
                                                                  Shadow(
                                                                    blurRadius: 1,
                                                                    offset: Offset(1, 1),
                                                                    color: Colors.black
                                                                        .withOpacity(0.4),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 27,
                                                    child: Image.asset('assets/XP.png'),
                                                  ),
                                                ],
                                              ),
                                              SizedBox()
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: FittedBox(
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Open Sans',
                                                  fontSize: 20,
                                                  color: Color.fromARGB(255, 1, 79, 134),
                                                ),
                                              ),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Color.fromARGB(255, 1, 79, 134),
                                              shape: StadiumBorder(),
                                              side: BorderSide(
                                                width: 3,
                                                color: Color.fromARGB(255, 1, 79, 134),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: ElevatedButton(
                                            onPressed: _stagesData[
                                                        'Stage_${widget.stage}.Questions_Details.Question_${widget.question}.done'] !=
                                                    true
                                                ? () async {
                                                    await initConnectivity();
                                                    if (_connectionStatus ==
                                                            'ConnectivityResult.wifi' ||
                                                        _connectionStatus ==
                                                            'ConnectivityResult.mobile') {
                                                      if (_selectedValue == '') {
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              'Please select an answer before submit.',
                                                          fontSize: 20,
                                                          gravity: ToastGravity.BOTTOM,
                                                          textColor: Colors.white,
                                                          backgroundColor:
                                                              Color.fromARGB(255, 1, 79, 134)
                                                                  .withOpacity(0.8),
                                                        );
                                                      } else {
                                                        _showPendingDialog(context);
                                                        if (_selectedValue == _correctAnswer) {
                                                          setState(() {
                                                            _answerIsCorrect = true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _answerIsCorrect = false;
                                                          });
                                                        }
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            'You have disconnected your internet connection.',
                                                        fontSize: 20,
                                                        gravity: ToastGravity.BOTTOM,
                                                        textColor: Colors.white,
                                                        backgroundColor:
                                                            Color.fromARGB(255, 1, 79, 134)
                                                                .withOpacity(0.8),
                                                      );
                                                    }
                                                  }
                                                : null,
                                            child: FittedBox(
                                              child: Text(
                                                'Submit',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Open Sans',
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: StadiumBorder(),
                                              backgroundColor: Color.fromARGB(255, 1, 79, 134),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                widget.question!=questions['stage${widget.stage}'].length
                                    ? Padding(
                                  padding: const EdgeInsets.only(bottom: 20, top: 15),
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: _stagesData[
                                              'Stage_${widget.stage}.Questions_Details.Question_${widget.question}.done']
                                          ? () {
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (_) {
                                                    return QuestionDisplayScreen(widget.stage,
                                                        widget.question + 1, _currentLevel);
                                                  },
                                                ),
                                              );
                                            }
                                          : null,
                                      child: Text(
                                        'Next Question',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Open Sans',
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: StadiumBorder(),
                                        backgroundColor: Colors.black,
                                      ),
                                    ),
                                  ),
                                ):SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: width * 0.025,
                    ),
                  ],
                )
              : EventLoading()
          : Center(
              child: NetworkError(Colors.white),
            ),
    );
  }

  Future<void> _showPendingDialog(BuildContext context) async {
    int count = 2;
    Timer countTimer;
    String S = 'Stage_${widget.stage}';
    String Q = 'Question_${widget.question}';
    String qNext = 'Question_${widget.question + 1}';

    CollectionReference eventData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event');
    CollectionReference eventsInfo = FirebaseFirestore.instance.collection('Events');
    CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');
    CollectionReference stagesInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages');
    CollectionReference questionsInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Stage_${widget.stage}')
        .collection('Questions');
    countTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (count == 0) {
        setState(() {
          countTimer.cancel();
          Navigator.pop(context, false);
          _showResultDialog(context);
        });
        eventData.doc('Stages').update({
          '$S.Info.completed': FieldValue.increment(1),
          '$S.Info.correct':
              _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
          '$S.Info.xpEarned': _answerIsCorrect
              ? _stagesData['$S.Questions_Details.$Q.xpDoubleUsed']
                  ? FieldValue.increment(_xp * 2)
                  : FieldValue.increment(_xp)
              : FieldValue.increment(0),
          '$S.Questions_Details.$Q.done': true,
          '$S.Questions_Details.$Q.correct': (_answerIsCorrect ? true : false),
          '$S.Questions_Details.$Q.selectedValue': _selectedValue,
        });
        if (questions['stage${widget.stage}'].length > widget.question) {
          eventData.doc('Stages').update({
            '$S.Questions_Details.$qNext.done': false,
            '$S.Questions_Details.$qNext.correct': false,
            '$S.Questions_Details.$qNext.selectedValue': '',
            '$S.Questions_Details.$qNext.question': widget.question + 1,
            '$S.Questions_Details.$qNext.answerBought': false,
            '$S.Questions_Details.$qNext.xpDoubleUsed': false,
          });
        }
        eventData.doc('Event_Info').get().then((doc) {
          if (!doc.exists) {
            eventData.doc('Event_Info').set({
              'progress': 1 * 100 / 105,
              'totalCompleted': 1,
              'totalCorrect': _answerIsCorrect ? 1 : 0,
              'xpEarned': _answerIsCorrect
                  ? _stagesData['$S.Questions_Details.$Q.xpDoubleUsed']
                      ? _xp * 2
                      : _xp
                  : 0,
            });
          } else {
            eventData.doc('Event_Info').update({
              'progress': FieldValue.increment(1 * 100 / 105),
              'totalCompleted': FieldValue.increment(1),
              'totalCorrect':
                  _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
              'xpEarned': _answerIsCorrect
                  ? _stagesData['$S.Questions_Details.$Q.xpDoubleUsed']
                      ? FieldValue.increment(_xp * 2)
                      : FieldValue.increment(_xp)
                  : FieldValue.increment(0),
            });
          }
        });

        userInfo.doc(user.uid).update({
          'User_Details.coins':
              _answerIsCorrect ? FieldValue.increment(_coins) : FieldValue.increment(0),
          'User_Details.xp': _answerIsCorrect
              ? _stagesData['$S.Questions_Details.$Q.xpDoubleUsed']
                  ? FieldValue.increment(_xp * 2)
                  : FieldValue.increment(_xp)
              : FieldValue.increment(0),
          'Events_Details.wrongAndSubmit':
              _answerIsCorrect ? FieldValue.increment(0) : FieldValue.increment(1),
          'Events_Details.correctAndSubmit':
              _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
          'Events_Details.totalCompleted': FieldValue.increment(1),
          'Events_Details.totalCorrect':
              _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
          'Events_Details.useDoubleXPAndCorrect':
              _stagesData['$S.Questions_Details.$Q.xpDoubleUsed']
                  ? _answerIsCorrect
                      ? FieldValue.increment(1)
                      : FieldValue.increment(0)
                  : FieldValue.increment(0),
          'Events_Details.useDoubleXPAndWrong':
              _stagesData['$S.Questions_Details.$Q.xpDoubleUsed']
                  ? _answerIsCorrect
                      ? FieldValue.increment(0)
                      : FieldValue.increment(1)
                  : FieldValue.increment(0),
        });
        eventsInfo.doc('All_Events').update({
          'AllCompleted': FieldValue.increment(1),
          'AllCorrect': _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
          'AllUnlocked': FieldValue.increment(1),
        });
        eventsInfo.doc('Trigonometry').update({
          'TotalCompleted': FieldValue.increment(1),
          'TotalCorrect': _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
          'TotalUnlocked': FieldValue.increment(1),
        });
        stagesInfo.doc('Stage_${widget.stage}').update({
          'TotalCompleted': FieldValue.increment(1),
          'TotalCorrect': _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
          'TotalUnlocked': FieldValue.increment(1),
        });
        questionsInfo.doc('Question_${widget.question}').update({
          'Completed': FieldValue.increment(1),
          'Correct': _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
          'Unlocked': FieldValue.increment(1),
        });
      } else {
        setState(() {
          count--;
        });
      }
    });
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AlertDialog(
              contentPadding: const EdgeInsets.fromLTRB(35, 25, 35, 5),
              content: TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 3150),
                builder: (context, animate, __) {
                  return CircularPercentIndicator(
                    radius: 125,
                    percent: animate,
                    progressColor: Colors.black,
                    backgroundColor: Colors.white,
                    lineWidth: 7,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${count + 1}',
                          style: TextStyle(
                            fontSize: 105,
                            fontFamily: 'Perpeta',
                            color: Color.fromARGB(255, 38, 50, 56),
                            height: 0.8,
                          ),
                        ),
                        Text(
                          'If you are not sure that your\nanswer is correct, cancel\nthis immediately.',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Perpeta',
                            color: Color.fromARGB(255, 38, 50, 56),
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: Colors.black),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                    countTimer.cancel();
                    userInfo.doc(user.uid).update({
                      'Events_Details.wrongAndCancel':
                          _answerIsCorrect ? FieldValue.increment(0) : FieldValue.increment(1),
                      'Events_Details.correctAndCancel':
                          _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
                      'Events_Details.totalCancelled': FieldValue.increment(1),
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Perpetua Bold',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Colors.black,
                  ),
                ),
              ],
              actionsPadding: EdgeInsets.only(right: 15, bottom: 5),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showResultDialog(BuildContext context) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            if (_startLevel == _currentLevel) {
              return Future.value(true);
            } else {
              CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');
              userInfo.doc(user.uid).update({
                'User_Details.level': _currentLevel,
              });
              int toStartLevelXP = 0;
              int x = 0;
              int toCurrentLevelXP = 0;
              int y = 0;
              for (int i = 1; i < _startLevel; i++) {
                x += i;
                toStartLevelXP = x * 10;
              }
              for (int i = 1; i < _currentLevel; i++) {
                y += i;
                toCurrentLevelXP = y * 10;
              }
              return Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) {
                    return LevelUpScreen(
                        _currentLevel, toStartLevelXP, toCurrentLevelXP - toStartLevelXP);
                  },
                ),
              );
            }
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              content: TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 1000),
                builder: (context, opacity, __) {
                  return Opacity(
                    opacity: opacity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 270,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 65,
                                height: 65,
                                child: Image.asset(_answerIsCorrect
                                    ? 'assets/Correct_Icon.png'
                                    : 'assets/Incorrect_Icon.png'),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _answerIsCorrect ? 'Congratulations!' : 'Bad Luck',
                                    style: TextStyle(
                                        fontFamily: 'Pristina',
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    _answerIsCorrect
                                        ? 'Your answer is correct.'
                                        : 'Your answer is incorrect.',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 15,
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _answerIsCorrect
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 110,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'Reward',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 23,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '$_coins',
                                              style: TextStyle(
                                                fontFamily: 'Gothic',
                                                fontSize: 27,
                                                color: Color.fromARGB(255, 1, 79, 134),
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
                                              width: 5,
                                            ),
                                            SizedBox(
                                              width: 27,
                                              child: Image.asset('assets/Coin.png'),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              _questionData[0]['xpDoubleUsed']
                                                  ? '${_xp * 2}'
                                                  : '$_xp',
                                              style: TextStyle(
                                                fontFamily: 'Gothic',
                                                fontSize: 27,
                                                color: Color.fromARGB(255, 1, 79, 134),
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
                                              width: 5,
                                            ),
                                            SizedBox(
                                              width: 27,
                                              child: Image.asset('assets/XP.png'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset('assets/Correct_Clip.png'),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _videoPlay(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'This video will help you to solve\nthese type of question.',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'Microsoft',
                                      height: 1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  );
                },
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (_startLevel == _currentLevel) {
                      Navigator.pop(context, false);
                    } else {
                      CollectionReference userInfo =
                          FirebaseFirestore.instance.collection('Users');
                      userInfo.doc(user.uid).update({
                        'User_Details.level': _currentLevel,
                      });
                      int toStartLevelXP = 0;
                      int x = 0;
                      int toCurrentLevelXP = 0;
                      int y = 0;
                      for (int i = 1; i < _startLevel; i++) {
                        x += i;
                        toStartLevelXP = x * 10;
                      }
                      for (int i = 1; i < _currentLevel; i++) {
                        y += i;
                        toCurrentLevelXP = y * 10;
                      }
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) {
                            return LevelUpScreen(_currentLevel, toStartLevelXP,
                                toCurrentLevelXP - toStartLevelXP);
                          },
                        ),
                      );
                    }
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Perpetua Bold',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Colors.black,
                  ),
                ),
              ],
              actionsPadding: EdgeInsets.only(right: 10),
            ),
          ),
        );
      },
    );
  }

  Widget _videoPlay() {
    bool videoPurchased = _stagesData['Stage_${widget.stage}.Info.Video.purchased'];
    return InkWell(
      onTap: () {
        if (videoPurchased) {
          Navigator.of(context).pushReplacement(
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
                        color: Color.fromARGB(255, 172, 140, 92).withOpacity(0.5),
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

  Future<void> _videoBuyDialog(BuildContext context) {
    List _videoPrice = [0, 450, 160, 400, 300, 250, 300, 600, 230, 450];
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

  Future<void> _doubleXPDialog(BuildContext context) async {
    String S = 'Stage_${widget.stage}';
    String Q = 'Question_${widget.question}';
    String D = 'Collection.Double_XP_Cards.Silver_Double_XP';
    CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Self-Confident Test',
                  style: TextStyle(
                    fontFamily: 'MontereyFLF',
                    fontSize: 33,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Image.asset('assets/Double_XP_Card.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: Text(
                    _userData['$D.available'] < 1
                        ? "You don't have any xp cards, please buy it from the store."
                        : "If you have the confidence that your answer is correct, use this card to double your XP.",
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 140,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_userData['$D.available'] > 0) {
                        userInfo.doc(user.uid).update({
                          '$D.available': FieldValue.increment(-1),
                          '$D.used': FieldValue.increment(1),
                        });
                        userInfo
                            .doc(user.uid)
                            .collection('Trigonometry_Event')
                            .doc('Stages')
                            .update({
                          '$S.Questions_Details.$Q.xpDoubleUsed': true,
                        });
                        CollectionReference eventsInfo =
                            FirebaseFirestore.instance.collection('Events');

                        CollectionReference stagesInfo = FirebaseFirestore.instance
                            .collection('Events')
                            .doc('Trigonometry')
                            .collection('Stages');

                        CollectionReference questionsInfo = FirebaseFirestore.instance
                            .collection('Events')
                            .doc('Trigonometry')
                            .collection('Stages')
                            .doc('Stage_${widget.stage}')
                            .collection('Questions');
                        eventsInfo.doc('Trigonometry').update({
                          'TotalXPDoubleUsed': FieldValue.increment(1),
                        });
                        eventsInfo.doc('All_Events').update({
                          'AllXPDoubleUsed': FieldValue.increment(1),
                        });
                        stagesInfo.doc('Stage_${widget.stage}').update({
                          'TotalXPDoubleUsed': FieldValue.increment(1),
                        });
                        questionsInfo.doc('Question_${widget.question}').update({
                          'XPDoubleUsed': FieldValue.increment(1),
                        });
                        Navigator.pop(context, false);
                      } else {
                        Fluttertoast.showToast(
                          msg: 'You are being directed to the MV Store',
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
                    child: Text(
                      _userData['$D.available'] < 1 ? 'Buy' : 'Use',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'MontereyFLF',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: StadiumBorder(),
                      side: BorderSide(
                        color: Colors.yellow,
                        width: 3,
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

  Future<void> _answerBuyDialog(BuildContext context) async {
    String S = 'Stage_${widget.stage}';
    String Q = 'Question_${widget.question}';
    CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromARGB(255, 96, 170, 77),
                        Color.fromARGB(255, 159, 219, 155),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        spreadRadius: 0,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Stage ${widget.stage < 10 ? '0' : ''}${widget.stage}',
                          style: TextStyle(
                            fontFamily: 'Rockwell',
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            'Question ${widget.question < 10 ? '0' : ''}${widget.question}',
                            style: TextStyle(
                              fontFamily: 'Rockwell',
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          'Answer',
                          style: TextStyle(
                            fontFamily: 'Rockwell',
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
                  child: Text(
                    'This answer will help you to know, how to solve this type of questions',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: 110,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_userData['User_Details.coins'] >= _answerBuyCoins) {
                          userInfo.doc(user.uid).update({
                            'User_Details.coins': FieldValue.increment(-_answerBuyCoins),
                          });
                          userInfo
                              .doc(user.uid)
                              .collection('Trigonometry_Event')
                              .doc('Stages')
                              .update({
                            '$S.Questions_Details.$Q.answerBought': true,
                          });
                          CollectionReference eventsInfo =
                              FirebaseFirestore.instance.collection('Events');

                          CollectionReference stagesInfo = FirebaseFirestore.instance
                              .collection('Events')
                              .doc('Trigonometry')
                              .collection('Stages');

                          CollectionReference questionsInfo = FirebaseFirestore.instance
                              .collection('Events')
                              .doc('Trigonometry')
                              .collection('Stages')
                              .doc('Stage_${widget.stage}')
                              .collection('Questions');
                          eventsInfo.doc('Trigonometry').update({
                            'TotalAnswersBought': FieldValue.increment(1),
                          });
                          stagesInfo.doc('Stage_${widget.stage}').update({
                            'TotalAnswersBought': FieldValue.increment(1),
                          });
                          questionsInfo.doc('Question_${widget.question}').update({
                            'AnswersBought': FieldValue.increment(1),
                          });
                          eventsInfo.doc('All_Events').update({
                            'AllAnswersBought': FieldValue.increment(1),
                          });
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) {
                                return AnswerDisplayScreen(widget.stage, widget.question);
                              },
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "You don't have enough coins.",
                            fontSize: 20,
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
                            decoration: BoxDecoration(
                                color: Colors.black, borderRadius: BorderRadius.circular(3)),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_answerBuyCoins',
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

  // Future<void> _updateEvent() async {
  //   List questionIcons = [
  //     'Alpha',
  //     'Beta',
  //     'Gamma',
  //     'Delta',
  //     'Epsilon',
  //     'Lambda',
  //     'Mu',
  //     'Tau',
  //     'Phi',
  //     'Psi',
  //   ];
  //   CollectionReference eventsInfo = FirebaseFirestore.instance.collection('Events');
  //   CollectionReference stagesInfo = FirebaseFirestore.instance
  //       .collection('Events')
  //       .doc('Trigonometry')
  //       .collection('Stages');
  //   await eventsInfo.doc('All_Events').set({
  //     'AllCompleted': 0,
  //     'AllCorrect': 0,
  //     'AllXPDoubleUsed': 0,
  //     'AllAnswersBought': 0,
  //     'AllUnlocked': 0,
  //     'Golden_Stages': {
  //       'AllCompleted': 0,
  //       'AllCorrect': 0,
  //       'AllGoldenDoubleXPUsed': 0,
  //       'AllStageUnlocks': 0,
  //       'AllStepOneBought': 0,
  //       'AllStepOneCompleted': 0,
  //       'AllStepOneCorrect': 0,
  //       'AllStepTwoBought': 0,
  //       'AllStepTwoCompleted': 0,
  //       'AllStepTwoCorrect': 0,
  //       'AllTimeElapsed': 0,
  //       'AllUnlocked': 0,
  //     }
  //   });
  //   await eventsInfo.doc('Trigonometry').set({
  //     'TotalCompleted': 0,
  //     'TotalCorrect': 0,
  //     'TotalXPDoubleUsed': 0,
  //     'TotalAnswersBought': 0,
  //     'TotalUnlocked': 0,
  //     'Event': 'Trigonometry Event',
  //   });
  //   await stagesInfo.doc('Golden_Stage').set({
  //     'Stage_Info': {
  //       'TotalCompleted': 0,
  //       'TotalCorrect': 0,
  //       'TotalGoldenDoubleXPUsed': 0,
  //       'TotalStageUnlocks': 0,
  //       'TotalStepOneBought': 0,
  //       'TotalStepOneCompleted': 0,
  //       'TotalStepOneCorrect': 0,
  //       'TotalStepTwoBought': 0,
  //       'TotalStepTwoCompleted': 0,
  //       'TotalStepTwoCorrect': 0,
  //       'TotalTimeElapsed': 0,
  //       'TotalUnlocked': 0,
  //     }
  //   });
  //   for (int i = 0; i < questionIcons.length; i++) {
  //     await stagesInfo.doc('Golden_Stage').set(
  //       {
  //         'Questions_Info': {
  //           'Question_${questionIcons[i]}': {
  //             'BestTiming': {
  //               'Time': 86400000,
  //               'UserID': null,
  //             },
  //             'Completed': 0,
  //             'Correct': 0,
  //             'GoldenDoubleXPUsed': 0,
  //             'StepOneBought': 0,
  //             'StepOneCompleted': 0,
  //             'StepOneCorrect': 0,
  //             'StepTwoBought': 0,
  //             'StepTwoCompleted': 0,
  //             'StepTwoCorrect': 0,
  //             'TimeElapsed': 0,
  //             'Unlocked': 0,
  //           }
  //         }
  //       },
  //       SetOptions(merge: true),
  //     );
  //   }
  //   for (int i = 1; i <= 10; i++) {
  //     await stagesInfo.doc('Stage_$i').set({
  //       'TotalCompleted': 0,
  //       'TotalCorrect': 0,
  //       'TotalXPDoubleUsed': 0,
  //       'TotalAnswersBought': 0,
  //       'TotalUnlocked': 0,
  //       'Stage': i,
  //       'Video': {
  //         'LikeCount': 0,
  //         'CommentCount': 0,
  //         'PurchaseCount': 0,
  //         'Comments': null,
  //       },
  //     });
  //     for (int j = 1; j <= questions['stage$i'].length; j++) {
  //       await stagesInfo.doc('Stage_$i').collection('Questions').doc('Question_$j').set({
  //         'Completed': 0,
  //         'Correct': 0,
  //         'XPDoubleUsed': 0,
  //         'AnswersBought': 0,
  //         'Question': j,
  //         'Unlocked': 0,
  //       });
  //     }
  //   }
  // }
}
