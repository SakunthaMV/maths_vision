import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Models/event_data.dart';
import 'package:maths_vision/Screens/Events/Events_Details/event_home_screen.dart';
import 'package:maths_vision/Screens/Events/Golden_Stage/Stage_Home/golden_stage_home_screen.dart';
import 'package:maths_vision/Screens/Events/Golden_Entry/stage_entry_page.dart';
import 'package:maths_vision/Widgets/event_app_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../../../Widgets/event_errors_and_loading.dart';
import '../Stage_Home/stage_home_screen.dart';

class EventFrontScreen extends StatefulWidget {
  final bool goldenStage;

  const EventFrontScreen({this.goldenStage});

  @override
  _EventFrontScreenState createState() => _EventFrontScreenState();
}

class _EventFrontScreenState extends State<EventFrontScreen> {
  bool _hasConnection;
  StreamSubscription _subscription;

  ScrollController _snapController = ScrollController();
  double _listHeight = 290;
  double _listWidth = 260;
  double _firstContainerScale = 1.0;
  double _secondContainerScale = 1.0;
  double _thirdContainerScale = 1.0;
  int _stageIndex = 0;
  ScrollController controller = ScrollController();
  User user;

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

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    checkInternet();
    Future.delayed(Duration(milliseconds: 200)).whenComplete(() {
      if (widget.goldenStage != null && _snapController.hasClients) {
        _snapController.animateTo(
          _snapController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
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
    _subscription.cancel();
    controller.dispose();
    _snapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
        appBar: EventAppBar(),
        backgroundColor: Color.fromARGB(255, 1, 79, 134),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Align(
              alignment: Alignment(0, -1.8),
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
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: size.height * 0.18,
                child: Image.asset('assets/Event_Top_Clip.png'),
              ),
            ),
            Builder(builder: (context) {
              if (_hasConnection == null) {
                return EventLoading();
              }
              if (!_hasConnection) {
                return Center(
                  child: NetworkError(),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.18),
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
                            itemCount: trigonometryEventData.length,
                            itemBuilder: (context, index) {
                              return _snapListTile(index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
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
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        controller: controller,
                        child: Builder(builder: (context) {
                          if (_stageIndex == 10) {
                            return _goldenStageDetailsColumn();
                          }
                          return _stageDetailsColumn();
                        }),
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
  }

  Widget _firstTwoRows(int completed, double containerScale, String topic,
      {int noOfQuestions, int correct}) {
    final double width = MediaQuery.of(context).size.width;
    return Opacity(
      opacity: containerScale,
      child: Transform(
        transform: Matrix4.identity()..scale(containerScale, containerScale),
        alignment: Alignment.bottomCenter,
        child: Container(
          width: width * 0.8,
          height: 55,
          margin: EdgeInsets.only(top: 13),
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
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic,
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
                        color: Color.fromARGB(255, 200, 62, 77),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 55,
                    margin: const EdgeInsets.only(right: 15),
                    color: Color.fromARGB(255, 176, 232, 255),
                    child: Center(
                      child: Text(
                        '${correct ?? completed}/${noOfQuestions ?? completed}',
                        style: TextStyle(
                          fontFamily: 'Niagara Solid',
                          fontSize: 25,
                          color: Color.fromARGB(255, 115, 111, 114),
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 16,
                        child: CustomPaint(
                          painter: FlashDrawer(
                            40,
                            40,
                            Color.fromARGB(255, 217, 209, 252),
                          ),
                          child: Container(),
                        ),
                      ),
                      TweenAnimationBuilder(
                        tween: Tween(
                          begin: 0.0,
                          end: (noOfQuestions ?? completed) == 0
                              ? 0.0
                              : ((correct ?? completed) / (noOfQuestions ?? completed))
                                  .toDouble(),
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
                                Color.fromARGB(255, 30, 16, 95),
                              ),
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
                      end: (noOfQuestions ?? completed) == 0
                          ? 0.0
                          : ((correct ?? completed) / (noOfQuestions ?? completed)).toDouble(),
                    ),
                    duration: Duration(seconds: 1),
                    builder: (_, percentage, __) {
                      return SizedBox(
                        width: 40,
                        child: Text(
                          '${(100 * percentage).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: percentage == 1 ? 15 : 20,
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
      ),
    );
  }

  Widget _stageDetailsColumn() {
    final double width = MediaQuery.of(context).size.width;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Trigonometry_Event')
          .doc('Stages')
          .snapshots(),
      builder: (context, stageSnapshot) {
        if (!stageSnapshot.hasData) {
          return FittedBox(
            child: LoadingAnimationWidget.halfTriangleDot(
              color: Colors.white,
              size: 100,
            ),
          );
        }
        int noOfQuestions = trigonometryEventData[_stageIndex][1];
        int stageTotalXP = trigonometryEventData[_stageIndex][2];
        Map<String, dynamic> data = stageSnapshot.data.data();
        if (!data.containsKey('Stage_${_stageIndex + 1}')) {
          return SizedBox.shrink();
        }
        int completed = data['Stage_${_stageIndex + 1}']['Info']['completed'];
        int correct = data['Stage_${_stageIndex + 1}']['Info']['correct'];
        int stageXP = data['Stage_${_stageIndex + 1}']['Info']['xpEarned'];
        return Column(
          children: [
            _firstTwoRows(
              completed ?? 0,
              _firstContainerScale,
              'Completed',
              noOfQuestions: noOfQuestions,
            ),
            _firstTwoRows(
              completed ?? 0,
              _secondContainerScale,
              'Accuracy',
              correct: correct ?? 0,
            ),
            Opacity(
              opacity: _thirdContainerScale,
              child: Transform(
                transform: Matrix4.identity()
                  ..scale(_thirdContainerScale, _thirdContainerScale),
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width * 0.8,
                  height: 70,
                  margin: const EdgeInsets.only(top: 13),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color: Color.fromARGB(255, 200, 62, 77),
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
                            height: 70,
                            color: Color.fromARGB(255, 176, 232, 255),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TweenAnimationBuilder(
                                    tween: Tween(
                                      begin: 0.0,
                                      end: stageXP,
                                    ),
                                    duration: Duration(seconds: 1),
                                    builder: (_, xp, __) {
                                      return RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${(xp).toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontFamily: 'AgencyFB',
                                                fontSize: 25,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '/$stageTotalXP',
                                              style: TextStyle(
                                                fontFamily: 'AgencyFB',
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: LinearPercentIndicator(
                                    animation: true,
                                    animationDuration: 1000,
                                    animateFromLastPercent: true,
                                    width: 125.0,
                                    lineHeight: 8.0,
                                    barRadius: Radius.circular(4.0),
                                    percent:
                                        stageXP <= stageTotalXP ? stageXP / stageTotalXP : 1,
                                    progressColor: Color.fromARGB(255, 30, 16, 95),
                                    alignment: MainAxisAlignment.center,
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
              ),
            ),
            Container(
              width: width * 0.8,
              height: 85,
              margin: EdgeInsets.only(top: 13, bottom: 13),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: Color.fromARGB(255, 200, 62, 77),
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
                          height: 85,
                          color: Color.fromARGB(255, 176, 232, 255),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TweenAnimationBuilder(
                                  tween: Tween(
                                    begin: 0.0,
                                    end: completed != 0 ? correct * 5 / completed : 0,
                                  ),
                                  duration: Duration(seconds: 1),
                                  builder: (_, probability, __) {
                                    return RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${(probability).toStringAsFixed(2)}',
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
                                    end: completed != 0 ? correct * 5 / completed : 0.0,
                                  ),
                                  duration: Duration(seconds: 1),
                                  builder: (_, probability, __) {
                                    return RatingBarIndicator(
                                      rating: probability,
                                      itemBuilder: (context, index) {
                                        return Icon(
                                          Icons.done,
                                          color: Color.fromARGB(255, 30, 16, 95),
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
          ],
        );
      },
    );
  }

  Widget _goldenStageDetailsColumn() {
    final double width = MediaQuery.of(context).size.width;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Trigonometry_Event')
          .doc('Event_Info')
          .snapshots(),
      builder: (context, eventSnapshot) {
        if (!eventSnapshot.hasData) {
          return FittedBox(
            child: LoadingAnimationWidget.halfTriangleDot(
              color: Colors.white,
              size: 100,
            ),
          );
        }
        Map<String, dynamic> eventData = eventSnapshot.data.data();
        if (!eventData.containsKey('goldenStageUnlocked')) {
          return SizedBox.shrink();
        }
        bool isGoldenStageUnlocked = eventData['goldenStageUnlocked'];
        return Column(
          children: [
            if (!isGoldenStageUnlocked)
              Opacity(
                opacity: _firstContainerScale,
                child: Transform(
                  transform: Matrix4.identity()
                    ..scale(_firstContainerScale, _firstContainerScale),
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
                          width: width * 0.8,
                          height: 55,
                          margin: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 239, 197, 1),
                                Color.fromARGB(255, 249, 224, 159),
                                Color.fromARGB(255, 239, 197, 1),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 1,
                                color: Colors.black.withOpacity(0.3),
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
              ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .collection('Trigonometry_Event')
                  .doc('Golden_Stage')
                  .snapshots(),
              builder: (context, goldenSnapshot) {
                if (!goldenSnapshot.hasData) {
                  return FittedBox(
                    child: LoadingAnimationWidget.halfTriangleDot(
                      color: Colors.white,
                      size: 100,
                    ),
                  );
                }
                int noOfQuestions = trigonometryEventData[_stageIndex][1];
                int stageTotalXP = trigonometryEventData[_stageIndex][2];
                int completed = goldenSnapshot.data['Stage_Info.completed'];
                int stageXP = goldenSnapshot.data['Stage_Info.xpEarned'];
                return Column(
                  children: [
                    Opacity(
                      opacity:
                          isGoldenStageUnlocked ? _firstContainerScale : _secondContainerScale,
                      child: Transform(
                        transform: Matrix4.identity()
                          ..scale(
                              isGoldenStageUnlocked
                                  ? _firstContainerScale
                                  : _secondContainerScale,
                              isGoldenStageUnlocked
                                  ? _firstContainerScale
                                  : _secondContainerScale),
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: width * 0.8,
                          height: 55,
                          margin: const EdgeInsets.only(top: 13),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        color: Color.fromARGB(255, 200, 62, 77),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 55,
                                    margin: const EdgeInsets.only(right: 15),
                                    color: Color.fromARGB(255, 176, 232, 255),
                                    child: Center(
                                      child: Text(
                                        '$completed/$noOfQuestions',
                                        style: TextStyle(
                                          fontFamily: 'Niagara Solid',
                                          fontSize: 25,
                                          color: Color.fromARGB(255, 115, 111, 114),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        width: 16,
                                        child: CustomPaint(
                                          painter: FlashDrawer(
                                            40,
                                            40,
                                            Color.fromARGB(255, 217, 209, 252),
                                          ),
                                          child: Container(),
                                        ),
                                      ),
                                      TweenAnimationBuilder(
                                        tween: Tween(
                                          begin: 0.0,
                                          end: completed / noOfQuestions,
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
                                                Color.fromARGB(255, 249, 166, 2),
                                              ),
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
                                      end: completed / noOfQuestions,
                                    ),
                                    duration: Duration(seconds: 1),
                                    builder: (_, percentage, __) {
                                      return SizedBox(
                                        width: 40,
                                        child: Text(
                                          '${(100 * percentage).toStringAsFixed(0)}%',
                                          style: TextStyle(
                                            fontSize: percentage == 1 ? 15 : 20,
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
                      ),
                    ),
                    Opacity(
                      opacity:
                          isGoldenStageUnlocked ? _secondContainerScale : _thirdContainerScale,
                      child: Transform(
                        transform: Matrix4.identity()
                          ..scale(
                              isGoldenStageUnlocked
                                  ? _secondContainerScale
                                  : _thirdContainerScale,
                              isGoldenStageUnlocked
                                  ? _secondContainerScale
                                  : _thirdContainerScale),
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: width * 0.8,
                          height: 70,
                          margin: const EdgeInsets.only(top: 13),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        color: Color.fromARGB(255, 200, 62, 77),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 145,
                                    height: 70,
                                    color: Color.fromARGB(255, 176, 232, 255),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        TweenAnimationBuilder(
                                          tween: Tween(
                                            begin: 0.0,
                                            end: stageXP,
                                          ),
                                          duration: Duration(seconds: 1),
                                          builder: (_, xp, __) {
                                            return RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '${(xp).toStringAsFixed(0)}',
                                                    style: TextStyle(
                                                      fontFamily: 'AgencyFB',
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '/$stageTotalXP',
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
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: LinearPercentIndicator(
                                            animation: true,
                                            animationDuration: 1000,
                                            animateFromLastPercent: true,
                                            width: 125.0,
                                            lineHeight: 8.0,
                                            percent: (stageXP > 4500 ? 4500 : stageXP) /
                                                stageTotalXP,
                                            progressColor: Color.fromARGB(255, 249, 166, 2),
                                            alignment: MainAxisAlignment.center,
                                            barRadius: Radius.circular(4),
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
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                  ],
                );
              },
            )
          ],
        );
      },
    );
  }

  Widget _snapListTile(int index) {
    return SizedBox(
      width: _listWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .collection('Trigonometry_Event')
                .doc('Event_Info')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return FittedBox(
                  child: LoadingAnimationWidget.dotsTriangle(
                    color: Colors.white,
                    size: 100,
                  ),
                );
              }
              Map<String, dynamic> eventData = snapshot.data.data();
              if (!eventData.containsKey('goldenStageUnlocked')) {
                return FittedBox(
                  child: LoadingAnimationWidget.halfTriangleDot(
                    color: Colors.white,
                    size: 100,
                  ),
                );
              }
              bool isGoldenStageUnlocked = eventData['goldenStageUnlocked'];
              return InkWell(
                onTap: () {
                  if (index != 10) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return StageHomeScreen(
                            trigonometryEventData[index][0],
                            index + 1,
                          );
                        },
                      ),
                    );
                  } else {
                    if (isGoldenStageUnlocked) {
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
                child: Builder(builder: (context) {
                  if (index == 10) {
                    return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          width: _listWidth,
                          height: _listHeight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(.6),
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
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Text(
                                      'GOLDEN STAGE',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Aquire Bold',
                                        foreground: Paint()
                                          ..strokeWidth = 0.5
                                          ..color = Color.fromARGB(255, 183, 153, 6)
                                          ..style = PaintingStyle.stroke,
                                      ),
                                    ),
                                    Text(
                                      'GOLDEN STAGE',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 239, 197, 1),
                                        fontFamily: 'Aquire Bold',
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.6),
                                            blurRadius: 2,
                                            offset: Offset(1, 1),
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'TRIGONOMETRY',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontFamily: 'OCR A',
                                        color: Color.fromARGB(255, 249, 166, 2),
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.5),
                                            blurRadius: 4,
                                            offset: Offset(0.5, 0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      width: 210,
                                      child: Text(
                                        trigonometryEventData[index][0],
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 249, 166, 2),
                                          height: 1.5,
                                          fontSize: 12,
                                          fontFamily: 'Open Sans',
                                          shadows: [
                                            Shadow(
                                              color: Color.fromARGB(255, 249, 166, 2)
                                                  .withOpacity(0.9),
                                              blurRadius: 2,
                                              offset: Offset(0.5, 1),
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
                        ),
                        if (!isGoldenStageUnlocked)
                          Container(
                            width: _listWidth,
                            height: _listHeight,
                            alignment: Alignment(-0.7, -0.4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/Lock_Icon.png'),
                            ),
                          ),
                      ],
                    );
                  }
                  return Container(
                    width: _listWidth,
                    height: _listHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(.6),
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
                              color: Color.fromARGB(255, 53, 25, 46),
                              fontFamily: 'Aquire',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.6),
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
                            child: Image.asset('assets/Trigonometry_Stage_${index + 1}.png'),
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 170,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'TRIGONOMETRY',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontFamily: 'OCR A',
                                  color: Color.fromARGB(255, 53, 25, 47),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 4,
                                      offset: Offset(0.5, 0.5),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 7),
                                width: 210,
                                child: Text(
                                  trigonometryEventData[index][0],
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 79, 134),
                                    height: 1.1,
                                    fontSize: 20,
                                    fontFamily: 'Abhaya Libre',
                                    shadows: [
                                      Shadow(
                                        color:
                                            Color.fromARGB(255, 1, 79, 134).withOpacity(0.9),
                                        blurRadius: 2,
                                        offset: Offset(0.5, 1),
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
                  );
                }),
              );
            },
          ),
        ],
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
