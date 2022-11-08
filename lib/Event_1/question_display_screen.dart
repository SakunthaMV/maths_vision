import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Event_1/answer_display_screen.dart';
import 'package:maths_vision/Event_1/level_up_screen.dart';
import 'package:maths_vision/Data_Directory/questions_data.dart';
import 'package:maths_vision/Event_1/store.dart';
import 'package:maths_vision/Screens/papers_screen.dart';
import 'package:maths_vision/Widgets/event_app_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../Support_Classes/Event_1/question_notation.dart';
import '../Support_Classes/Event_1/reward_class.dart';
import '../Support_Classes/Event_1/video_button.dart';

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

  int _currentLevel;
  String _selectedValue = '';
  bool _answerIsCorrect;
  bool _answerSelected = false;
  Color _selectedColor = Color.fromARGB(255, 1, 79, 134);
  Color _unselectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    checkInternet();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: EventAppBar(),
      backgroundColor: Color.fromARGB(255, 1, 79, 134),
      body: Container(
        width: width * 0.95,
        height: height,
        margin: EdgeInsets.all(width * 0.025),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Builder(builder: (context) {
          if (!(_hasConnection ?? false)) {
            return Center(child: NetworkError(Colors.black));
          }
          return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData) {
                  int sumOfN = 0;
                  int xp = userSnapshot.data['User_Details.xp'];
                  for (int i = 1; i < 150; i += 1) {
                    _currentLevel = i;
                    sumOfN += i;
                    int levelNValue = sumOfN * 10;
                    if (levelNValue > xp) {
                      break;
                    }
                  }
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
                        return Center(
                          child: LoadingAnimationWidget.threeArchedCircle(
                            color: Colors.black,
                            size: 100.0,
                          ),
                        );
                      }
                      String dataPath =
                          'Stage_${widget.stage}.Questions_Details.Question_${widget.question}';
                      Map<String, dynamic> questionData = snapshot.data[dataPath];
                      if (questionData['done']) {
                        _selectedValue = questionData['selectedValue'];
                        _answerSelected = true;
                      } else {
                        if (!_answerSelected) {
                          _selectedValue = '';
                        }
                      }
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                          child: _questionBody(context, questionData),
                        ),
                      );
                    });
              });
        }),
      ),
    );
  }

  Widget _questionBody(BuildContext context, Map data) {
    final bool done = data['done'];
    final bool xpDoubleUsed = data['xpDoubleUsed'];
    final bool correct = data['correct'];
    final bool answerBought = data['answerBought'];
    final Map question =
        questions['stage${widget.stage}']['question${widget.question}']['question'];
    final List answers =
        questions['stage${widget.stage}']['question${widget.question}']['answers'];
    final int coins = questions['stage${widget.stage}']['question${widget.question}']['coins'];
    final int xp = questions['stage${widget.stage}']['question${widget.question}']['xp'];
    final String correctAnswer =
        questions['stage${widget.stage}']['question${widget.question}']['answer'];
    return Column(
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
            if (!done && !xpDoubleUsed)
              InkWell(
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
                        color: Color.fromARGB(255, 255, 215, 0),
                      ),
                    ),
                    ShapeOfView(
                      shape: PolygonShape(numberOfSides: 6),
                      width: 40,
                      height: 40,
                      elevation: 0,
                      child: Container(
                        color: Color.fromARGB(255, 192, 192, 192),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: const Offset(0.0, -1.0),
                                    child: Text(
                                      'x',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 1, 79, 134),
                                        fontSize: 24,
                                        fontFamily: 'Gothic',
                                        height: 1,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold,
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
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 1, 79, 134),
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
              ),
            if (done)
              SizedBox(
                width: 35,
                height: 35,
                child: correct
                    ? Image.asset('assets/Correct_Icon.png')
                    : Image.asset('assets/Incorrect_Icon.png'),
              ),
          ],
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Math.tex(
                  question['firstLine'],
                  mathStyle: MathStyle.display,
                  textStyle: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              if (question.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: FittedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${question['secondLine'][0]} ',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Iskola Potha',
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                        Math.tex(
                          question['secondLine'][1],
                          mathStyle: MathStyle.display,
                          textStyle: TextStyle(fontSize: 25),
                        ),
                        Text(
                          ' ${question['secondLine'][2]}',
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
                ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${question['thirdLine']}',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Iskola Potha',
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
              ),
              if (question.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Math.tex(
                    question['forthLine'],
                    mathStyle: MathStyle.display,
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            children: answers.map((value) {
              final bool selected = this._selectedValue == value;
              final Color color = selected ? _selectedColor : _unselectedColor;
              return RadioListTile<String>(
                value: value,
                groupValue: _selectedValue,
                title: Builder(builder: (context) {
                  if (widget.stage == 9 && widget.question > 1 && widget.question < 5) {
                    return StreamBuilder(
                      stream: FirebaseStorage.instance
                          .ref('Events/Trigonometry/Stage_${widget.stage}/$value.JPG')
                          .getDownloadURL()
                          .asStream(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return LoadingAnimationWidget.newtonCradle(
                            color: Colors.black,
                            size: 60,
                          );
                        }
                        return InteractiveViewer(
                          minScale: 1,
                          maxScale: 4,
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data,
                            placeholder: (_, url) {
                              return LoadingAnimationWidget.newtonCradle(
                                color: Colors.black,
                                size: 60,
                              );
                            },
                            errorWidget: (context, url, error) {
                              return Icon(Icons.error);
                            },
                          ),
                        );
                      },
                    );
                  }
                  return FittedBox(
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
                  );
                }),
                activeColor: color,
                onChanged: (value) {
                  setState(() {
                    this._selectedValue = value;
                    _answerSelected = true;
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
                  if (answerBought) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return AnswerDisplayScreen(widget.stage, widget.question);
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
                      QuestionNotation(widget.stage, widget.question),
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
                      if (done && !answerBought)
                        SizedBox(
                          width: 28,
                          child: Image.asset(
                            'assets/Answer_Unlock_Icon.png',
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (!done)
                InkWell(
                  onTap: () {
                    Fluttertoast.showToast(
                      msg: 'You must have answered the question first.',
                    );
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 43, 56, 36).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        child: SizedBox(
                          height: 28,
                          child: Image.asset('assets/Lock_Icon.png'),
                        ),
                      ),
                    ],
                  ),
                ),
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
                      if (xpDoubleUsed)
                        Container(
                          width: 40,
                          height: 25,
                          margin: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color.fromARGB(255, 192, 192, 192),
                            ),
                          ),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: const Offset(0.0, -1.0),
                                      child: Text(
                                        'x',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 1, 79, 134),
                                          fontSize: 15,
                                          fontFamily: 'Gothic',
                                          height: 1,
                                          letterSpacing: 3,
                                          fontWeight: FontWeight.bold,
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
                                      color: Color.fromARGB(255, 1, 79, 134),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RewardClass().coinReward(coins),
                      RewardClass().xpReward(xp, true, xpDoubleUsed: xpDoubleUsed),
                      SizedBox(),
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
                    onPressed: !done
                        ? () {
                            if (!_hasConnection) {
                              return Fluttertoast.showToast(
                                msg: 'You don\'t have internet connection.',
                              );
                            }
                            if (_selectedValue == '') {
                              return Fluttertoast.showToast(
                                msg: 'Please select an answer before submit.',
                              );
                            }
                            _showPendingDialog(context, xpDoubleUsed);
                            if (_selectedValue == correctAnswer) {
                              setState(() {
                                _answerIsCorrect = true;
                              });
                            } else {
                              setState(() {
                                _answerIsCorrect = false;
                              });
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
        if (widget.question != questions['stage${widget.stage}'].length)
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 15),
            child: Center(
              child: ElevatedButton(
                onPressed: done
                    ? () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) {
                              return QuestionDisplayScreen(
                                widget.stage,
                                widget.question + 1,
                                _currentLevel,
                              );
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
          ),
      ],
    );
  }

  void _updateDatabaseDetails(bool xpDoubleUsed) {
    final String S = 'Stage_${widget.stage}';
    final String Q = 'Question_${widget.question}';
    final String qNext = 'Question_${widget.question + 1}';
    final int coins = questions['stage${widget.stage}']['question${widget.question}']['coins'];
    final int xp = questions['stage${widget.stage}']['question${widget.question}']['xp'];

    final CollectionReference eventData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event');
    final CollectionReference eventsInfo = FirebaseFirestore.instance.collection('Events');
    final CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');
    final CollectionReference stagesInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages');
    final CollectionReference questionsInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Stage_${widget.stage}')
        .collection('Questions');

    eventData.doc('Stages').update({
      '$S.Info.completed': FieldValue.increment(1),
      '$S.Info.correct': _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      '$S.Info.xpEarned': _answerIsCorrect
          ? xpDoubleUsed
              ? FieldValue.increment(xp * 2)
              : FieldValue.increment(xp)
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
              ? xpDoubleUsed
                  ? xp * 2
                  : xp
              : 0,
        });
      } else {
        eventData.doc('Event_Info').update({
          'progress': FieldValue.increment(1 * 100 / 105),
          'totalCompleted': FieldValue.increment(1),
          'totalCorrect': _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
          'xpEarned': _answerIsCorrect
              ? xpDoubleUsed
                  ? FieldValue.increment(xp * 2)
                  : FieldValue.increment(xp)
              : FieldValue.increment(0),
        });
      }
    });

    userInfo.doc(user.uid).update({
      'User_Details.coins':
          _answerIsCorrect ? FieldValue.increment(coins) : FieldValue.increment(0),
      'User_Details.xp': _answerIsCorrect
          ? xpDoubleUsed
              ? FieldValue.increment(xp * 2)
              : FieldValue.increment(xp)
          : FieldValue.increment(0),
      'Events_Details.wrongAndSubmit':
          _answerIsCorrect ? FieldValue.increment(0) : FieldValue.increment(1),
      'Events_Details.correctAndSubmit':
          _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      'Events_Details.totalCompleted': FieldValue.increment(1),
      'Events_Details.totalCorrect':
          _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      'Events_Details.useDoubleXPAndCorrect': xpDoubleUsed
          ? _answerIsCorrect
              ? FieldValue.increment(1)
              : FieldValue.increment(0)
          : FieldValue.increment(0),
      'Events_Details.useDoubleXPAndWrong': xpDoubleUsed
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
  }

  void _updateCancelDetails() {
    final CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');
    userInfo.doc(user.uid).update({
      'Events_Details.wrongAndCancel':
          _answerIsCorrect ? FieldValue.increment(0) : FieldValue.increment(1),
      'Events_Details.correctAndCancel':
          _answerIsCorrect ? FieldValue.increment(1) : FieldValue.increment(0),
      'Events_Details.totalCancelled': FieldValue.increment(1),
    });
  }

  Future<void> _submitPressed() {
    final CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');
    userInfo.doc(user.uid).update({
      'User_Details.level': _currentLevel,
    });
    int toStartLevelXP = 0;
    int x = 0;
    int toCurrentLevelXP = 0;
    int y = 0;
    for (int i = 1; i < widget.startLevel; i++) {
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
            _currentLevel,
            toStartLevelXP,
            toCurrentLevelXP - toStartLevelXP,
          );
        },
      ),
    );
  }

  Future<void> _showPendingDialog(BuildContext context, bool xpDoubleUsed) async {
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
                duration: Duration(milliseconds: 3000),
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
                          '${(3.3 - animate * 3).toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 100,
                            fontFamily: 'Perpeta',
                            color: Color.fromARGB(255, 38, 50, 56),
                            height: 0.8,
                          ),
                        ),
                        Text(
                          'If you are not sure that your\nanswer is correct, cancel\nthis immediately.',
                          style: TextStyle(
                            fontSize: 18,
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
                onEnd: () {
                  Navigator.pop(context, false);
                  if (!_hasConnection) {
                    return Fluttertoast.showToast(
                      msg: 'You don\'t have internet connection.',
                    );
                  }
                  _showResultDialog(context, xpDoubleUsed);
                  _updateDatabaseDetails(xpDoubleUsed);
                },
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                      _updateCancelDetails();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 28,
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
                ),
              ],
              actionsPadding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showResultDialog(BuildContext context, bool xpDoubleUsed) async {
    final int coins = questions['stage${widget.stage}']['question${widget.question}']['coins'];
    final int xp = questions['stage${widget.stage}']['question${widget.question}']['xp'];
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            if (widget.startLevel == _currentLevel) {
              return Future.value(true);
            } else {
              return _submitPressed();
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
                                      letterSpacing: 0.0,
                                      wordSpacing: 1.0,
                                      color: Colors.black,
                                      shadows: [],
                                    ),
                                  ),
                                  Text(
                                    _answerIsCorrect
                                        ? 'Your answer is correct.'
                                        : 'Your answer is incorrect.',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0.0,
                                      wordSpacing: 1.0,
                                      color: Colors.black,
                                      height: 1,
                                      shadows: [],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Builder(builder: (context) {
                          if (_answerIsCorrect) {
                            return Row(
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
                                          wordSpacing: 1.0,
                                          letterSpacing: 0.0,
                                          shadows: [],
                                        ),
                                      ),
                                      RewardClass().coinReward(coins),
                                      RewardClass().xpReward(
                                        xp,
                                        true,
                                        xpDoubleUsed: xpDoubleUsed,
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
                            );
                          }
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                child: VideoButton(widget.stage, false),
                              ),
                              Text(
                                'This video will help you to solve\nthese type of question.',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Microsoft',
                                  height: 1,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  wordSpacing: 1.0,
                                  shadows: [],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.startLevel == _currentLevel) {
                        Navigator.pop(context, false);
                      } else {
                        _submitPressed();
                      }
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 28,
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
                ),
              ],
              actionsPadding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        );
      },
    );
  }

  Future<void> _doubleXPDialog(BuildContext context) async {
    final String S = 'Stage_${widget.stage}';
    final String Q = 'Question_${widget.question}';
    final String D = 'Collection.Double_XP_Cards.Silver_Double_XP';
    final CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');
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
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.0,
                    wordSpacing: 1.0,
                    shadows: [],
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Image.asset('assets/Double_XP_Card.png'),
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return LoadingAnimationWidget.threeArchedCircle(
                          color: Colors.black,
                          size: 60.0,
                        );
                      }
                      int available = snapshot.data['$D.available'];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                            child: Text(
                              available < 1
                                  ? "You don't have any xp cards, please buy it from the store."
                                  : "If you have the confidence that your answer "
                                      "is correct, use this card to double your XP.",
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.0,
                                wordSpacing: 1.0,
                                fontSize: 15,
                                color: Colors.black,
                                shadows: [],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 140,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!_hasConnection) {
                                  return Fluttertoast.showToast(
                                    msg: 'You don\'t have internet connection.',
                                  );
                                }
                                if (available > 0) {
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
                                  final CollectionReference eventsInfo =
                                      FirebaseFirestore.instance.collection('Events');

                                  final CollectionReference stagesInfo = FirebaseFirestore.instance
                                      .collection('Events')
                                      .doc('Trigonometry')
                                      .collection('Stages');

                                  final CollectionReference questionsInfo = FirebaseFirestore
                                      .instance
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
                                available < 1 ? 'Buy' : 'Use',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'MontereyFLF',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  shadows: [],
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
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _answerBuyDialog(BuildContext context) async {
    final int answerBuyCoins =
        questions['stage${widget.stage}']['question${widget.question}']['answerBuyCoins'];
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
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0.0,
                            wordSpacing: 1.0,
                            shadows: [],
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
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.0,
                              wordSpacing: 1.0,
                              shadows: [],
                            ),
                          ),
                        ),
                        Text(
                          'Answer',
                          style: TextStyle(
                            fontFamily: 'Rockwell',
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0.0,
                            wordSpacing: 1.0,
                            shadows: [],
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
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.0,
                      wordSpacing: 1.0,
                      shadows: [],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return LoadingAnimationWidget.stretchedDots(
                            color: Colors.black,
                            size: 50.0,
                          );
                        }
                        int userCoins = snapshot.data['User_Details.coins'];
                        return SizedBox(
                          width: 110,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_hasConnection) {
                                return Fluttertoast.showToast(
                                  msg: 'You don\'t have internet connection.',
                                );
                              }
                              _purchaseButtonPress(userCoins);
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
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$answerBuyCoins',
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
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _purchaseButtonPress(int userCoins) {
    final String S = 'Stage_${widget.stage}';
    final String Q = 'Question_${widget.question}';
    final int answerBuyCoins =
        questions['stage${widget.stage}']['question${widget.question}']['answerBuyCoins'];
    final CollectionReference userInfo = FirebaseFirestore.instance.collection('Users');
    final CollectionReference eventsInfo = FirebaseFirestore.instance.collection('Events');
    final CollectionReference stagesInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages');
    final CollectionReference questionsInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Stage_${widget.stage}')
        .collection('Questions');
    if (userCoins >= answerBuyCoins) {
      userInfo.doc(user.uid).update({
        'User_Details.coins': FieldValue.increment(-answerBuyCoins),
      });
      userInfo.doc(user.uid).collection('Trigonometry_Event').doc('Stages').update({
        '$S.Questions_Details.$Q.answerBought': true,
      });
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
