import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Golden_Stage/golden_level_up_screen.dart';
import 'package:maths_vision/Golden_Stage/golden_question_map.dart';
import 'package:maths_vision/Golden_Stage/golden_stage_home_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wakelock/wakelock.dart';

class GoldenQuestionScreen extends StatefulWidget {
  final int question;
  final List order;
  final int startLevel;

  const GoldenQuestionScreen(this.question, this.order, this.startLevel, {Key key})
      : super(key: key);

  @override
  _GoldenQuestionScreenState createState() => _GoldenQuestionScreenState(question, order);
}

class _GoldenQuestionScreenState extends State<GoldenQuestionScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int question;
  List order;

  _GoldenQuestionScreenState(this.question, this.order);

  Future<void> screenProtect() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  String Q = 'Questions';
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  User user;
  DocumentSnapshot _stageData;
  DocumentSnapshot _userData;
  Map _questionOne;
  Map _questionTwo;
  Map _questionThree;
  List _answersOne = [];
  List _answersTwo = [];
  List _answersThree = [];
  String _correctAnswerOne = '';
  String _correctAnswerTwo = '';
  String _correctAnswerThree = '';
  String _selectedValueOne = '';
  String _selectedValueTwo = '';
  String _selectedValueThree = '';
  bool _answerOneIsCorrect;
  bool _answerTwoIsCorrect;
  bool _answerThreeIsCorrect;
  Color _selectedColor = Color.fromARGB(255, 1, 79, 134);
  Color _unselectedColor = Colors.black;
  AnimationController _secondQuestionController;
  AnimationController _thirdQuestionController;
  bool _thirdQuestion = false;
  int _startLevel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    user = FirebaseAuth.instance.currentUser;
    _stopWatchTimer.onStartTimer();
    screenProtect();
    Wakelock.enable();
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    userData.snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _userData = doc;
      });
    });
    DocumentReference stageData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Golden_Stage');
    stageData.snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _stageData = doc;
      });
    });
    _secondQuestionController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _thirdQuestionController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _questionOne = goldenMap[order[question - 1]]['part1']['question'];
    _answersOne = goldenMap[order[question - 1]]['part1']['answers'];
    _correctAnswerOne = goldenMap[order[question - 1]]['part1']['answer'];
    _questionTwo = goldenMap[order[question - 1]]['part2']['question'];
    _answersTwo = goldenMap[order[question - 1]]['part2']['answers'];
    _correctAnswerTwo = goldenMap[order[question - 1]]['part2']['answer'];
    _questionThree = goldenMap[order[question - 1]]['part3']['question'];
    _answersThree = goldenMap[order[question - 1]]['part3']['answers'];
    _correctAnswerThree = goldenMap[order[question - 1]]['part3']['answer'];
    _startLevel = widget.startLevel;
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    Wakelock.disable();
    print('disposed');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        _destroyUpdates().whenComplete(() {
          _stopWatchTimer.dispose();
          WidgetsBinding.instance.removeObserver(this);
          Wakelock.disable();
        });
        break;
      case AppLifecycleState.detached:
        _destroyUpdates().whenComplete(() {
          _stopWatchTimer.dispose();
          WidgetsBinding.instance.removeObserver(this);
          Wakelock.disable();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        if (_stageData['$Q.Question_$question.stepOneCompleted'] &&
            _stageData['$Q.Question_$question.stepTwoCompleted']) {
          return Future.value(false);
        } else {
          return _quitPopup(context, question);
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 1, 79, 134),
        body: SafeArea(
          child: Center(
            child: Container(
              width: width * 0.95,
              height: double.infinity,
              margin: EdgeInsets.only(
                top: width*0.025,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                top: 115,
                                left: width * 0.025,
                                right: width * 0.025,
                              ),
                              padding: EdgeInsets.only(
                                top: 10,
                                left: 8,
                                right: 8,
                                bottom: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.black, width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    child: Math.tex(
                                      _questionOne['firstLine'],
                                      mathStyle: MathStyle.display,
                                      textStyle: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  _questionOne.length > 2
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: FittedBox(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${_questionOne['secondLine'][0]} ',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Iskola Potha',
                                                    color: Colors.black,
                                                    height: 1.2,
                                                  ),
                                                ),
                                                Math.tex(
                                                  _questionOne['secondLine'][1],
                                                  mathStyle: MathStyle.display,
                                                  textStyle: TextStyle(fontSize: 25),
                                                ),
                                                Text(
                                                  ' ${_questionOne['secondLine'][2]}',
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
                                      '${_questionOne['thirdLine']}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Iskola Potha',
                                        color: Colors.black,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  _questionOne.length > 3
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Math.tex(
                                            _questionOne['forthLine'],
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
                                children: _answersOne.map((value) {
                                  final selected = this._selectedValueOne == value;
                                  final color = selected ? _selectedColor : _unselectedColor;
                                  return RadioListTile<String>(
                                    value: value,
                                    groupValue: _selectedValueOne,
                                    title: FittedBox(
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
                                        this._selectedValueOne = value;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              height: 2,
                              thickness: 2,
                              endIndent: width * 0.025,
                              indent: width * 0.025,
                            ),
                          ],
                        ),
                        SizeTransition(
                          axisAlignment: 1.0,
                          sizeFactor:
                              Tween(begin: 0.0, end: 1.0).animate(_secondQuestionController),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                  top: 15,
                                  left: width * 0.025,
                                  right: width * 0.025,
                                ),
                                padding: EdgeInsets.only(
                                  top: 10,
                                  left: 8,
                                  right: 8,
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black, width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: Math.tex(
                                        _questionTwo['firstLine'],
                                        mathStyle: MathStyle.display,
                                        textStyle: TextStyle(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    _questionTwo.length > 2
                                        ? Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: FittedBox(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${_questionTwo['secondLine'][0]} ',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'Iskola Potha',
                                                      color: Colors.black,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                  Math.tex(
                                                    _questionTwo['secondLine'][1],
                                                    mathStyle: MathStyle.display,
                                                    textStyle: TextStyle(fontSize: 25),
                                                  ),
                                                  Text(
                                                    ' ${_questionTwo['secondLine'][2]}',
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
                                        '${_questionTwo['thirdLine']}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Iskola Potha',
                                          color: Colors.black,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    _questionTwo.length > 3
                                        ? Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Math.tex(
                                              _questionTwo['forthLine'],
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
                                  children: _answersTwo.map((value) {
                                    final selected = this._selectedValueTwo == value;
                                    final color = selected ? _selectedColor : _unselectedColor;
                                    return RadioListTile<String>(
                                      value: value,
                                      groupValue: _selectedValueTwo,
                                      title: FittedBox(
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
                                          this._selectedValueTwo = value;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                height: 2,
                                thickness: 2,
                                endIndent: width * 0.025,
                                indent: width * 0.025,
                              ),
                            ],
                          ),
                        ),
                        SizeTransition(
                          axisAlignment: 1.0,
                          sizeFactor:
                              Tween(begin: 0.0, end: 1.0).animate(_thirdQuestionController),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                  top: 15,
                                  left: width * 0.025,
                                  right: width * 0.025,
                                ),
                                padding: EdgeInsets.only(
                                  top: 10,
                                  left: 8,
                                  right: 8,
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black, width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: Math.tex(
                                        _questionThree['firstLine'],
                                        mathStyle: MathStyle.display,
                                        textStyle: TextStyle(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    _questionThree.length > 2
                                        ? Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: FittedBox(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${_questionThree['secondLine'][0]} ',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'Iskola Potha',
                                                      color: Colors.black,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                  Math.tex(
                                                    _questionThree['secondLine'][1],
                                                    mathStyle: MathStyle.display,
                                                    textStyle: TextStyle(fontSize: 25),
                                                  ),
                                                  Text(
                                                    ' ${_questionThree['secondLine'][2]}',
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
                                        '${_questionThree['thirdLine']}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Iskola Potha',
                                          color: Colors.black,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    _questionThree.length > 3
                                        ? Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Math.tex(
                                              _questionThree['forthLine'],
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
                                  children: _answersThree.map((value) {
                                    final selected = this._selectedValueThree == value;
                                    final color = selected ? _selectedColor : _unselectedColor;
                                    return RadioListTile<String>(
                                      value: value,
                                      groupValue: _selectedValueThree,
                                      title: FittedBox(
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
                                          this._selectedValueThree = value;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                height: 2,
                                thickness: 2,
                                endIndent: width * 0.025,
                                indent: width * 0.025,
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment(0.9, 0),
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            width: 100,
                            child: OutlinedButton(
                              onPressed: () {
                                if (!_stageData['$Q.Question_$question.stepOneCompleted']) {
                                  if (_selectedValueOne == '') {
                                    Fluttertoast.showToast(
                                      msg: 'Please select an answer before click Next.',
                                      fontSize: 18,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      backgroundColor:
                                          Color.fromARGB(255, 1, 79, 134).withOpacity(0.8),
                                    );
                                  } else {
                                    if (_selectedValueOne == _correctAnswerOne) {
                                      setState(() {
                                        _answerOneIsCorrect = true;
                                      });
                                    } else {
                                      setState(() {
                                        _answerOneIsCorrect = false;
                                      });
                                    }
                                    _answerOneUpdates();
                                    if (_answerOneIsCorrect) {
                                      _secondQuestionController.forward();
                                    } else {
                                      _stopWatchTimer.dispose();
                                      Fluttertoast.showToast(
                                        msg: 'Your answer is incorrect',
                                        fontSize: 18,
                                      );
                                      Navigator.of(context, rootNavigator: true).pop();
                                    }
                                  }
                                } else if (!_stageData[
                                    '$Q.Question_$question.stepTwoCompleted']) {
                                  if (_selectedValueTwo == '') {
                                    Fluttertoast.showToast(
                                      msg: 'Please select an answer before click Next.',
                                      fontSize: 18,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      backgroundColor:
                                          Color.fromARGB(255, 1, 79, 134).withOpacity(0.8),
                                    );
                                  } else {
                                    if (_selectedValueTwo == _correctAnswerTwo) {
                                      setState(() {
                                        _answerTwoIsCorrect = true;
                                      });
                                    } else {
                                      setState(() {
                                        _answerTwoIsCorrect = false;
                                      });
                                    }
                                    _answerTwoUpdates();
                                    if (_answerTwoIsCorrect) {
                                      _thirdQuestionController.forward();
                                      setState(() {
                                        _thirdQuestion = true;
                                      });
                                    } else {
                                      _stopWatchTimer.dispose();
                                      Fluttertoast.showToast(
                                        msg: 'Your answer is incorrect.',
                                        fontSize: 18,
                                      );
                                      Navigator.of(context, rootNavigator: true).pop();
                                    }
                                  }
                                } else {
                                  if (_selectedValueThree == '') {
                                    Fluttertoast.showToast(
                                      msg: 'Please select an answer before click Finish.',
                                      fontSize: 18,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      backgroundColor:
                                          Color.fromARGB(255, 1, 79, 134).withOpacity(0.8),
                                    );
                                  } else {
                                    if (_selectedValueThree == _correctAnswerThree) {
                                      setState(() {
                                        _answerThreeIsCorrect = true;
                                      });
                                    } else {
                                      setState(() {
                                        _answerThreeIsCorrect = false;
                                      });
                                    }
                                    _showPendingDialog(context);
                                  }
                                }
                              },
                              child: Text(
                                _thirdQuestion ? 'Finish' : 'Next',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Open Sans',
                                  letterSpacing: 1,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 1, 79, 134),
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width * 0.95,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 239, 197, 1),
                          Color.fromARGB(255, 249, 224, 159),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          spreadRadius: -1,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment(-0.8, -0.8),
                          child: Text(
                            'Question ${widget.question < 10 ? '0' : ''}${widget.question}',
                            style: TextStyle(
                              fontFamily: 'Forte',
                              fontSize: 35,
                              color: Colors.black,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.4),
                                  offset: Offset(1, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(-0.83, 0.7),
                          child: StreamBuilder<int>(
                            stream: _stopWatchTimer.rawTime,
                            initialData: _stopWatchTimer.rawTime.value,
                            builder: (context, snapshot) {
                              final value = snapshot.data;
                              final displayTime =
                                  StopWatchTimer.getDisplayTime(value, milliSecond: false);
                              return Text(
                                '$displayTime',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 35,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 130,
                            height: 100,
                            padding: EdgeInsets.fromLTRB(50, 0, 15, 15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color.fromARGB(255, 239, 197, 1),
                                Color.fromARGB(255, 249, 224, 159),
                              ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.elliptical(130, 100),
                                  topRight: Radius.circular(25)),
                            ),
                            child: _stageData != null
                                ? Image.asset(
                                    'assets/${_stageData['order'][widget.question - 1]}_Black.png',
                                  )
                                : LoadingBouncingLine.circle(
                                    size: 50,
                                    backgroundColor: Color.fromARGB(255, 239, 197, 1),
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
        ),
      ),
    );
  }

  Future<void> _quitPopup(BuildContext context, int index) async {
    String qNow = 'Question_$question';
    String qNext = 'Question_${question + 1}';
    String S = 'Stage_Info';
    String G = 'Golden_Stages';
    String qI = 'Questions_Info';
    String qS = 'Question_${order[question - 1]}';

    DocumentReference stageData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Golden_Stage');
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    DocumentReference allEvents =
        FirebaseFirestore.instance.collection('Events').doc('All_Events');
    DocumentReference trigonometryGoldenStage = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Golden_Stage');

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
            contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: RichText(
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
                          text: ' ${index == 10 ? '' : '0'}$index',
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
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      'If you exit from this question we consider that you have given a wrong answer for this question.',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 1, 79, 134),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 135,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text(
                          'Continue',
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
                    SizedBox(
                      width: 135,
                      child: OutlinedButton(
                        onPressed: () async {
                          _stopWatchTimer.dispose();
                          WidgetsBinding.instance.removeObserver(this);
                          Wakelock.disable();
                          if (!_stageData['$Q.$qNow.stepOneCompleted'] &&
                              !_stageData['$Q.$qNow.stepTwoCompleted']) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) {
                                  return GoldenStageHomeScreen();
                                },
                              ),
                            );
                            await stageData.update({
                              '$S.stepOneCompleted': FieldValue.increment(1),
                              '$S.totalTimeElapsed':
                                  FieldValue.increment(_stopWatchTimer.rawTime.value),
                              '$S.unlocked': FieldValue.increment(1),
                              '$Q.$qNow.stepOneCompleted': true,
                              '$Q.$qNow.timeElapsed': _stopWatchTimer.rawTime.value,
                              '$Q.$qNext.unlocked': true,
                            });
                            if (_stageData['$S.correct'] != 0) {
                              await stageData.update({
                                '$S.averageTimeElapsed': (_stageData['$S.totalTimeElapsed'] /
                                        _stageData['$S.correct'])
                                    .ceil(),
                              });
                              await userData.update({
                                'User_Details.average_time':
                                    (_stageData['$S.totalTimeElapsed'] /
                                            _stageData['$S.correct'])
                                        .ceil(),
                              });
                            }
                            await allEvents.update({
                              '$G.AllStepOneCompleted': FieldValue.increment(1),
                              '$G.AllUnlocked': FieldValue.increment(1),
                              '$G.AllTimeElapsed':
                                  FieldValue.increment(_stopWatchTimer.rawTime.value),
                            });
                            await trigonometryGoldenStage.update({
                              '$S.TotalStepOneCompleted': FieldValue.increment(1),
                              '$S.TotalUnlocked': FieldValue.increment(1),
                              '$S.TotalTimeElapsed':
                                  FieldValue.increment(_stopWatchTimer.rawTime.value),
                              '$qI.$qS.StepOneCompleted': FieldValue.increment(1),
                              '$qI.$qS.Unlocked': FieldValue.increment(1),
                              '$qI.$qS.TimeElapsed':
                                  FieldValue.increment(_stopWatchTimer.rawTime.value),
                            });
                          } else if (_stageData['$Q.$qNow.stepOneCompleted'] &&
                              !_stageData['$Q.$qNow.stepTwoCompleted']) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) {
                                  return GoldenStageHomeScreen();
                                },
                              ),
                            );
                            await stageData.update({
                              '$S.stepTwoCompleted': FieldValue.increment(1),
                              '$S.totalTimeElapsed':
                                  FieldValue.increment(_stopWatchTimer.rawTime.value),
                              '$Q.$qNow.stepTwoCompleted': true,
                              '$Q.$qNow.timeElapsed': _stopWatchTimer.rawTime.value,
                            });
                            if (_stageData['$S.correct'] != 0) {
                              await stageData.update({
                                '$S.averageTimeElapsed': (_stageData['$S.totalTimeElapsed'] /
                                        _stageData['$S.correct'])
                                    .ceil()
                              });
                              await userData.update({
                                'User_Details.average_time':
                                    (_stageData['$S.totalTimeElapsed'] /
                                            _stageData['$S.correct'])
                                        .ceil(),
                              });
                            }
                            await allEvents.update({
                              '$G.AllStepTwoCompleted': FieldValue.increment(1),
                              '$G.AllTimeElapsed':
                                  FieldValue.increment(_stopWatchTimer.rawTime.value),
                            });
                            await trigonometryGoldenStage.update({
                              '$S.TotalStepTwoCompleted': FieldValue.increment(1),
                              '$S.TotalTimeElapsed':
                                  FieldValue.increment(_stopWatchTimer.rawTime.value),
                              '$qI.$qS.StepTwoCompleted': FieldValue.increment(1),
                              '$qI.$qS.TimeElapsed':
                                  FieldValue.increment(_stopWatchTimer.rawTime.value),
                            });
                          }
                        },
                        child: Text(
                          'OK, I Quit',
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
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _destroyUpdates() async {
    String qNow = 'Question_$question';
    String qNext = 'Question_${question + 1}';
    String S = 'Stage_Info';
    String G = 'Golden_Stages';
    String qI = 'Questions_Info';
    String qS = 'Question_${order[question - 1]}';
    DocumentReference stageData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Golden_Stage');
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    DocumentReference allEvents =
        FirebaseFirestore.instance.collection('Events').doc('All_Events');
    DocumentReference trigonometryGoldenStage = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Golden_Stage');
    if (!_stageData['$Q.$qNow.stepOneCompleted'] && !_stageData['$Q.$qNow.stepTwoCompleted']) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return GoldenStageHomeScreen();
          },
        ),
      );
      await stageData.update({
        '$S.stepOneCompleted': FieldValue.increment(1),
        '$S.totalTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
        '$S.unlocked': FieldValue.increment(1),
        '$Q.$qNow.stepOneCompleted': true,
        '$Q.$qNow.timeElapsed': _stopWatchTimer.rawTime.value,
        '$Q.$qNext.unlocked': true,
      });
      if (_stageData['$S.correct'] != 0) {
        await stageData.update({
          '$S.averageTimeElapsed':
              (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil()
        });
        await userData.update({
          'User_Details.average_time':
              (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil(),
        });
      }
      await allEvents.update({
        '$G.AllStepOneCompleted': FieldValue.increment(1),
        '$G.AllUnlocked': FieldValue.increment(1),
        '$G.AllTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
      });
      await trigonometryGoldenStage.update({
        '$S.TotalStepOneCompleted': FieldValue.increment(1),
        '$S.TotalUnlocked': FieldValue.increment(1),
        '$S.TotalTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
        '$qI.$qS.StepOneCompleted': FieldValue.increment(1),
        '$qI.$qS.Unlocked': FieldValue.increment(1),
        '$qI.$qS.TimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
      });
    } else if (_stageData['$Q.$qNow.stepOneCompleted'] &&
        !_stageData['$Q.$qNow.stepTwoCompleted']) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return GoldenStageHomeScreen();
          },
        ),
      );
      await stageData.update({
        '$S.stepTwoCompleted': FieldValue.increment(1),
        '$S.totalTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
        '$Q.$qNow.stepTwoCompleted': true,
        '$Q.$qNow.timeElapsed': _stopWatchTimer.rawTime.value,
      });
      if (_stageData['$S.correct'] != 0) {
        await stageData.update({
          '$S.averageTimeElapsed':
              (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil()
        });
        await userData.update({
          'User_Details.average_time':
              (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil(),
        });
      }
      await allEvents.update({
        '$G.AllStepTwoCompleted': FieldValue.increment(1),
        '$G.AllTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
      });
      await trigonometryGoldenStage.update({
        '$S.TotalStepTwoCompleted': FieldValue.increment(1),
        '$S.TotalTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
        '$qI.$qS.StepTwoCompleted': FieldValue.increment(1),
        '$qI.$qS.TimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return GoldenStageHomeScreen();
          },
        ),
      );
      await stageData.update({
        '$S.completed': FieldValue.increment(1),
        '$S.totalTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
        '$Q.$qNow.completed': true,
        '$Q.$qNow.timeElapsed': _stopWatchTimer.rawTime.value,
      });
      if (_stageData['$S.correct'] != 0) {
        await stageData.update({
          '$S.averageTimeElapsed':
              (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil()
        });
        await userData.update({
          'User_Details.average_time':
              (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil(),
        });
      }
      await allEvents.update({
        '$G.AllCompleted': FieldValue.increment(1),
        '$G.AllTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
      });
      await trigonometryGoldenStage.update({
        '$S.TotalCompleted': FieldValue.increment(1),
        '$S.TotalTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
        '$qI.$qS.Completed': FieldValue.increment(1),
        '$qI.$qS.TimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
      });
    }
  }

  Future<void> _answerOneUpdates() async {
    String qNow = 'Question_$question';
    String qNext = 'Question_${question + 1}';
    String S = 'Stage_Info';
    String G = 'Golden_Stages';
    String qI = 'Questions_Info';
    String qS = 'Question_${order[question - 1]}';
    DocumentReference stageData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Golden_Stage');
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    DocumentReference allEvents =
        FirebaseFirestore.instance.collection('Events').doc('All_Events');
    DocumentReference trigonometryGoldenStage = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Golden_Stage');

    await stageData.update({
      '$S.stepOneCompleted': FieldValue.increment(1),
      '$S.stepOneCorrect':
          _answerOneIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$S.totalTimeElapsed': _answerOneIsCorrect
          ? FieldValue.increment(0)
          : FieldValue.increment(_stopWatchTimer.rawTime.value),
      '$S.unlocked': FieldValue.increment(1),
      '$Q.$qNow.stepOneCompleted': true,
      '$Q.$qNow.stepOneCorrect': _answerOneIsCorrect ? true : false,
      '$Q.$qNow.timeElapsed': _answerOneIsCorrect ? 0 : _stopWatchTimer.rawTime.value,
      '$Q.$qNext.unlocked': true,
    });
    if (!_answerOneIsCorrect) {
      if (_stageData['$S.correct'] != 0) {
        await stageData.update({
          '$S.averageTimeElapsed':
              (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil()
        });
        await userData.update({
          'User_Details.average_time':
              (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil(),
        });
      }
    }
    await allEvents.update({
      '$G.AllStepOneCompleted': FieldValue.increment(1),
      '$G.AllStepOneCorrect':
          _answerOneIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$G.AllUnlocked': FieldValue.increment(1),
      '$G.AllTimeElapsed': _answerOneIsCorrect
          ? FieldValue.increment(0)
          : FieldValue.increment(_stopWatchTimer.rawTime.value),
    });
    await trigonometryGoldenStage.update({
      '$S.TotalStepOneCompleted': FieldValue.increment(1),
      '$S.TotalStepOneCorrect':
          _answerOneIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$S.TotalUnlocked': FieldValue.increment(1),
      '$S.TotalTimeElapsed': _answerOneIsCorrect
          ? FieldValue.increment(0)
          : FieldValue.increment(_stopWatchTimer.rawTime.value),
      '$qI.$qS.StepOneCompleted': FieldValue.increment(1),
      '$qI.$qS.StepOneCorrect':
          _answerOneIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$qI.$qS.Unlocked': FieldValue.increment(1),
      '$qI.$qS.TimeElapsed': _answerOneIsCorrect
          ? FieldValue.increment(0)
          : FieldValue.increment(_stopWatchTimer.rawTime.value),
    });
  }

  Future<void> _answerTwoUpdates() async {
    String qNow = 'Question_$question';
    String S = 'Stage_Info';
    String G = 'Golden_Stages';
    String qI = 'Questions_Info';
    String qS = 'Question_${order[question - 1]}';
    DocumentReference stageData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Golden_Stage');
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    DocumentReference allEvents =
        FirebaseFirestore.instance.collection('Events').doc('All_Events');
    DocumentReference trigonometryGoldenStage = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Golden_Stage');

    await stageData.update({
      '$S.stepTwoCompleted': FieldValue.increment(1),
      '$S.stepTwoCorrect':
          _answerTwoIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$S.totalTimeElapsed': _answerTwoIsCorrect
          ? FieldValue.increment(0)
          : FieldValue.increment(_stopWatchTimer.rawTime.value),
      '$Q.$qNow.stepTwoCompleted': true,
      '$Q.$qNow.stepTwoCorrect': _answerTwoIsCorrect ? true : false,
      '$Q.$qNow.timeElapsed': _answerTwoIsCorrect ? 0 : _stopWatchTimer.rawTime.value,
    });
    if (!_answerTwoIsCorrect) {
      if (_stageData['$S.correct'] != 0) {
        await stageData.update({
          '$S.averageTimeElapsed':
              (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil()
        });
        await userData.update({
          'User_Details.average_time':
              (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil(),
        });
      }
    }
    await allEvents.update({
      '$G.AllStepTwoCompleted': FieldValue.increment(1),
      '$G.AllStepTwoCorrect':
          _answerTwoIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$G.AllTimeElapsed': _answerTwoIsCorrect
          ? FieldValue.increment(0)
          : FieldValue.increment(_stopWatchTimer.rawTime.value),
    });
    await trigonometryGoldenStage.update({
      '$S.TotalStepTwoCompleted': FieldValue.increment(1),
      '$S.TotalStepTwoCorrect':
          _answerTwoIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$S.TotalTimeElapsed': _answerTwoIsCorrect
          ? FieldValue.increment(0)
          : FieldValue.increment(_stopWatchTimer.rawTime.value),
      '$qI.$qS.StepTwoCompleted': FieldValue.increment(1),
      '$qI.$qS.StepTwoCorrect':
          _answerTwoIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$qI.$qS.TimeElapsed': _answerTwoIsCorrect
          ? FieldValue.increment(0)
          : FieldValue.increment(_stopWatchTimer.rawTime.value),
    });
  }

  Future<void> _showPendingDialog(BuildContext context) async {
    int count = 2;
    Timer countTimer;

    int sumOfN = 0;
    int xp = _userData != null ? _userData['User_Details.xp'] : 0;
    int level;
    for (int i = 1; i < 150; i += 1) {
      level = i;
      sumOfN += i;
      int levelNValue = sumOfN * 10;
      if (levelNValue > xp) {
        break;
      }
    }

    CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');

    countTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (count == 0) {
        setState(() {
          countTimer.cancel();
          _stopWatchTimer.dispose();
          Navigator.pop(context, false);
          _answerThreeUpdates();
          _showResultDialog(context, level);
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
                    radius: 250,
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
                          'If you are noy sure that your\nanswer is correct, cancel\nthis immediately.',
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
                      'Events_Details.wrongAndCancel': _answerThreeIsCorrect
                          ? FieldValue.increment(0)
                          : FieldValue.increment(1),
                      'Events_Details.correctAndCancel': _answerThreeIsCorrect
                          ? FieldValue.increment(1)
                          : FieldValue.increment(0),
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

  Future<void> _answerThreeUpdates() async {
    String qNow = 'Question_$question';
    String S = 'Stage_Info';
    String G = 'Golden_Stages';
    String qI = 'Questions_Info';
    String qS = 'Question_${order[question - 1]}';
    DocumentReference stageData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Golden_Stage');
    DocumentReference eventData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Event_Info');
    DocumentReference userInfo = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    DocumentReference allEvents =
        FirebaseFirestore.instance.collection('Events').doc('All_Events');
    DocumentReference trigonometryGoldenStage = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Golden_Stage');
    await stageData.update({
      '$S.completed': FieldValue.increment(1),
      '$S.correct': _answerThreeIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$S.xpEarned':
          _answerThreeIsCorrect ? FieldValue.increment(450) : FieldValue.increment(0),
      '$S.totalTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
      '$Q.$qNow.completed': true,
      '$Q.$qNow.correct': _answerThreeIsCorrect ? true : false,
      '$Q.$qNow.timeElapsed': _stopWatchTimer.rawTime.value,
    });
    if (_stageData['$S.correct'] != 0) {
      await stageData.update({
        '$S.averageTimeElapsed':
            (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil()
      });
      await userInfo.update({
        'User_Details.average_time':
            (_stageData['$S.totalTimeElapsed'] / _stageData['$S.correct']).ceil(),
      });
    }
    await eventData.update({
      'xpEarned': _answerThreeIsCorrect ? FieldValue.increment(450) : FieldValue.increment(0),
    });
    await userInfo.update({
      'User_Details.xp':
          _answerThreeIsCorrect ? FieldValue.increment(450) : FieldValue.increment(0),
      'Events_Details.wrongAndSubmit':
          _answerThreeIsCorrect ? FieldValue.increment(0) : FieldValue.increment(1),
      'Events_Details.correctAndSubmit':
          _answerThreeIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      'Events_Details.totalCompleted': FieldValue.increment(1),
      'Events_Details.totalCorrect':
          _answerThreeIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
    });
    await allEvents.update({
      '$G.AllCompleted': FieldValue.increment(1),
      '$G.AllCorrect':
          _answerThreeIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$G.AllTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
    });
    await trigonometryGoldenStage.update({
      '$S.TotalCompleted': FieldValue.increment(1),
      '$S.TotalCorrect':
          _answerThreeIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$S.TotalTimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
      '$qI.$qS.Completed': FieldValue.increment(1),
      '$qI.$qS.Correct':
          _answerThreeIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$qI.$qS.TimeElapsed': FieldValue.increment(_stopWatchTimer.rawTime.value),
    });
    if (_answerThreeIsCorrect) {
      trigonometryGoldenStage.get().then((doc) {
        trigonometryGoldenStage.update({
          '$qI.$qS.BestTiming.Time': doc['$qI.$qS.BestTiming.Time'] > _stopWatchTimer.rawTime.value
              ? _stopWatchTimer.rawTime.value
              : doc['$qI.$qS.BestTiming.Time'],
          '$qI.$qS.BestTiming.UserID': _userData['User_Details.userId'],
        });
      });
    }
  }

  Future<void> _showResultDialog(BuildContext context, int level) async {
    String qNow = 'Question_$question';
    String qI = 'Questions_Info';
    String qS = 'Question_${order[question - 1]}';
    String S = 'Stage_Info';
    String D = 'Collection.Double_XP_Cards.Golden_Double_XP';
    CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');
    CollectionReference eventsInfo = FirebaseFirestore.instance.collection('Events');
    DocumentReference stageInfo =
        eventsInfo.doc('Trigonometry').collection('Stages').doc('Golden_Stage');
    DocumentReference stageData =
        userInfo.doc(user.uid).collection('Trigonometry_Event').doc('Golden_Stage');
    DocumentReference eventData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Event_Info');

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
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
                                child: Image.asset(_answerThreeIsCorrect
                                    ? 'assets/Correct_Icon.png'
                                    : 'assets/Incorrect_Icon.png'),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _answerThreeIsCorrect ? 'Congratulations!' : 'Bad Luck',
                                    style: TextStyle(
                                        fontFamily: 'Pristina',
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    _answerThreeIsCorrect
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
                        SizedBox(
                          width: 170,
                          height: 170,
                          child: _answerThreeIsCorrect
                              ? Image.asset('assets/Correct_Clip.png')
                              : Image.asset('assets/Incorrect_Clip.png'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: [
                _answerThreeIsCorrect
                    ? OutlinedButton(
                        onPressed: () async {
                          if (_userData['$D.available'] > 0) {
                            await stageData.update({
                              '$Q.$qNow.goldenDoubleXPUsed': true,
                              '$S.xpEarned': FieldValue.increment(450),
                            });
                            userInfo.doc(user.uid).update({
                              'User_Details.level': level,
                            });
                            Navigator.pop(context, false);
                            _shareResultDialog(context);
                            await userInfo.doc(user.uid).update({
                              '$D.available': FieldValue.increment(-1),
                              '$D.used': FieldValue.increment(1),
                              'User_Details.xp': FieldValue.increment(450),
                            });
                            await eventData.update({
                              'xpEarned': FieldValue.increment(450),
                            });
                            await eventsInfo.doc('All_Events').update({
                              'Golden_Stages.AllGoldenDoubleXPUsed': FieldValue.increment(1),
                            });
                            await stageInfo.update({
                              'Stage_Info.TotalGoldenDoubleXPUsed': FieldValue.increment(1),
                              '$qI.$qS.GoldenDoubleXPUsed': FieldValue.increment(1),
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg: 'You don\'t have golden double xp card to use.',
                              fontSize: 16,
                            );
                          }
                        },
                        child: Text(
                          'Use Golden 2x',
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
                      )
                    : SizedBox.shrink(),
                ElevatedButton(
                  onPressed: () {
                    if (_answerThreeIsCorrect) {
                      Navigator.pop(context, false);
                      _shareResultDialog(context);
                      userInfo.doc(user.uid).update({
                        'User_Details.level': level,
                      });
                    } else {
                      _stopWatchTimer.dispose();
                      WidgetsBinding.instance.removeObserver(this);
                      Wakelock.disable();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) {
                            return GoldenStageHomeScreen();
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

  Future<void> _shareResultDialog(BuildContext context) async {
    final double width = MediaQuery.of(context).size.width;
    Map<String, List> quotes = {
      'topQuote': [
        'Good effort!',
        'Good going!',
        'Good work!',
        'Keep it up!',
        'Keep on trying!',
        'Keep working on it',
        'Much better!',
        'Nice work!',
        'Right on!',
        'Super Duper!',
        'Superior work.',
        'Terrific!',
        'That’s better.',
        'That’s good!',
        'Very interesting.',
        'Wonderful!',
        'Brilliant!',
        'Excellent!',
        'Outstanding!',
        'Smashing!',
      ],
      'bottomQuote': [
        'You are doing a good job!',
        'You are learning a lot.',
        'You are learning fast.',
        'You must have been practicing.',
        'You’re doing a great job',
        'You’re getting better and better.',
        'You’re on the right track now.',
        'You’re really improving.',
        'Now you’ve figured it out.',
      ]
    };
    int _topQuote = Random().nextInt(quotes['topQuote'].length);
    int _bottomQuote = Random().nextInt(quotes['bottomQuote'].length);
    String qNow = 'Question_$question';
    String name =
        '${_userData['User_Details.firstName']} ${_userData['User_Details.lastName']}';
    String time =
        StopWatchTimer.getDisplayTime(_stageData['$Q.$qNow.timeElapsed'], milliSecond: false);
    String timeMil =
        StopWatchTimer.getDisplayTimeMillisecond(_stageData['$Q.$qNow.timeElapsed']);
    bool doubleXP = _stageData['$Q.$qNow.goldenDoubleXPUsed'];
    List<Color> colors = [
      Color.fromARGB(255, 0, 136, 145),
      Color.fromARGB(255, 131, 178, 208),
      Color.fromARGB(255, 242, 230, 178),
      Color.fromARGB(255, 220, 133, 128),
      Color.fromARGB(255, 39, 104, 140),
      Color.fromARGB(255, 217, 162, 121),
      Color.fromARGB(255, 159, 176, 166),
      Color.fromARGB(255, 196, 200, 175),
    ];
    Color frameColor = Color.fromARGB(255, 0, 136, 145);
    int sumOfN = 0;
    int xp = _userData != null ? _userData['User_Details.xp'] : 0;
    int level;
    for (int i = 1; i < 150; i += 1) {
      level = i;
      sumOfN += i;
      int levelNValue = sumOfN * 10;
      if (levelNValue > xp) {
        break;
      }
    }
    CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');
    String quote = '${quotes['topQuote'][_topQuote]} ${quotes['bottomQuote'][_bottomQuote]}';
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 253, 239, 239),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              contentPadding: EdgeInsets.fromLTRB(15, 20, 15, 10),
              content: TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 1000),
                builder: (context, opacity, __) {
                  return Opacity(
                    opacity: opacity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Reward',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                            color: Color.fromARGB(255, 1, 79, 134),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Reward',
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 20,
                                color: Colors.transparent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 3),
                              child: Text(
                                '${doubleXP ? '900' : '450'}',
                                style: TextStyle(
                                  fontFamily: 'Gothic',
                                  fontSize: 23,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 33,
                              height: 33,
                              child: Image.asset('assets/XP.png'),
                            ),
                          ],
                        ),
                        Text(
                          'Card of Admiration',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                            color: Color.fromARGB(255, 1, 79, 134),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: Transform.scale(
                            scale: width * 0.75 / 300,
                            child: Container(
                              width: 300,
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(19),
                              ),
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Positioned(
                                    top: 42,
                                    child: Container(
                                      height: 22,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 239, 197, 1),
                                            Color.fromARGB(255, 249, 224, 159),
                                            Color.fromARGB(255, 239, 197, 1),
                                            Color.fromARGB(255, 249, 224, 159),
                                            Color.fromARGB(255, 239, 197, 1),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 3,
                                              spreadRadius: -3.5,
                                              color: Colors.black.withOpacity(0.4),
                                              offset: Offset(0, 5),),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$name',
                                          style: TextStyle(
                                            fontFamily: 'Javanese Text',
                                            fontSize: 15,
                                            letterSpacing: 0.2,
                                            height: 1.8,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 25,
                                    top: 70,
                                    child: SizedBox(
                                      height: 85,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Congratulations',
                                            style: TextStyle(
                                              fontFamily: 'Hey October',
                                              fontSize: 25,
                                              letterSpacing: 0.7,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Container(
                                            width: 170,
                                            height: 40,
                                            padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: Color.fromARGB(255, 106, 197, 254),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  quote,
                                                  style: TextStyle(
                                                    fontFamily: 'Centaur',
                                                    fontSize: 12,
                                                    height: 1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 1),
                                                    child: Text(
                                                      '- MATHS VISION -',
                                                      style: TextStyle(
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 7,
                                                        height: 1,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 0.2,
                                                        shadows: [
                                                          Shadow(
                                                            color:
                                                                Colors.black.withOpacity(0.3),
                                                            offset: Offset(0.5, 0.5),
                                                          ),
                                                        ],
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
                                  SizedBox(
                                    width: 300,
                                    height: 160,
                                    child: Image.asset(
                                      'assets/Share_Frame.png',
                                      fit: BoxFit.fill,
                                      color: frameColor,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    left: 0,
                                    child: SizedBox(
                                      width: 170,
                                      child: Center(
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: time,
                                              ),
                                              TextSpan(
                                                text: ':$timeMil',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset('assets/${order[question-1]}_Gold_Inner.png'),
                                    ),
                                  ),
                                  Positioned(
                                    top: 28,
                                    right: 15.5,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: frameColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: frameColor, width: 2.5),
                                      ),
                                      child: Center(
                                        child: ClipOval(
                                          child: _userData['User_Details.photoURL'] != null
                                              ? CachedNetworkImage(
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.cover,
                                                  imageUrl: _userData['User_Details.photoURL'],
                                                  placeholder: (_, url) {
                                                    return CircularProgressIndicator();
                                                  },
                                                  errorWidget: (context, url, error) {
                                                    return Icon(Icons.error);
                                                  },
                                                )
                                              : Icon(
                                                  Icons.account_circle_rounded,
                                                  size: 48,
                                                  color: Color.fromARGB(255, 202, 202, 202),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Choose a colour',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                            color: Color.fromARGB(255, 1, 79, 134),
                          ),
                        ),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 5, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              colors.length,
                              (index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      frameColor = colors[index];
                                    });
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Container(
                                    width: 27,
                                    height: 27,
                                    decoration: BoxDecoration(
                                      color: colors[index],
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black, width: 1.5),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await userInfo.doc(user.uid).update({
                                  'User_Details.level': level,
                                });
                                _postShareUpdates(frameColor, quote);
                                _donePopup();
                              },
                              child: Text(
                                'Share on the wall',
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
                            OutlinedButton(
                              onPressed: () async {
                                await userInfo.doc(user.uid).update({
                                  'User_Details.level': level,
                                });
                                _donePopup();
                              },
                              child: Text(
                                'OK',
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
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> _postShareUpdates(Color frameColor, String quote) async {
    String T = 'Trigonometry_Posts';
    DocumentReference wall = FirebaseFirestore.instance.collection('Events').doc('Wall');
    await wall.update({
      '$T':FieldValue.arrayUnion(
        [{
          'UserID': _userData['User_Details.userId'],
          'Color': frameColor.value.toString(),
          'Quote': quote,
          'Symbol': order[question - 1],
          'Time': _stopWatchTimer.rawTime.value,
        }]
      ),
    });
    Fluttertoast.showToast(
      msg: 'Your post has been shared on the wall',
      fontSize: 17,
    );
  }

  void _donePopup() {
    int sumOfN = 0;
    int xp = _userData != null ? _userData['User_Details.xp'] : 0;
    int level;
    for (int i = 1; i < 150; i += 1) {
      level = i;
      sumOfN += i;
      int levelNValue = sumOfN * 10;
      if (levelNValue > xp) {
        break;
      }
    }
    if (_startLevel == level) {
      _stopWatchTimer.dispose();
      WidgetsBinding.instance.removeObserver(this);
      Wakelock.disable();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return GoldenStageHomeScreen();
          },
        ),
      );
    } else {
      int toStartLevelXP = 0;
      int x = 0;
      int toCurrentLevelXP = 0;
      int y = 0;
      for (int i = 1; i < _startLevel; i++) {
        x += i;
        toStartLevelXP = x * 10;
      }
      for (int i = 1; i < level; i++) {
        y += i;
        toCurrentLevelXP = y * 10;
      }
      _stopWatchTimer.dispose();
      WidgetsBinding.instance.removeObserver(this);
      Wakelock.disable();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return GoldenLevelUpScreen(
                level, toStartLevelXP, toCurrentLevelXP - toStartLevelXP);
          },
        ),
      );
    }
  }
}
