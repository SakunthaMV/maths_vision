import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Screens/Splashes/went_home_splash_screen.dart';
import 'package:maths_vision/Widgets/event_app_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:shimmer/shimmer.dart';

import '../Event_Home/event_front_screen.dart';
import '../../../Widgets/event_errors_and_loading.dart';

class EventHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return WentHomeSplashScreen();
            },
          ),
        );
      },
      child: Scaffold(
        appBar: EventAppBar(),
        backgroundColor: Color.fromARGB(255, 1, 170, 255),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Align(
              alignment: Alignment(0.0, -2.1),
              child: Container(
                width: width,
                height: height * 0.5,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 176, 232, 255),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(200, 140),
                    bottomRight: Radius.elliptical(200, 140),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      spreadRadius: 0,
                      blurRadius: 13,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 160,
              height: height * 0.19,
              child: Image.asset('assets/Event_Home_Top_Clip.png'),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.19 * (140 / 160)),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Lucida Console',
                    color: Color.fromARGB(255, 53, 25, 46),
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  children: [
                    TextSpan(
                      text: 'T',
                    ),
                    TextSpan(
                      text: 'HE BATTLE BEGAN',
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: width,
                height: height * 0.25,
                child: CustomPaint(
                  painter: EventBottomShape(),
                  child: Container(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    child: Image.asset('assets/Event_Home_Bottom_Clip.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Juice ITC',
                          fontSize: 20,
                          color: Colors.black,
                          height: 1,
                        ),
                        children: [
                          TextSpan(
                            text: '"',
                          ),
                          TextSpan(
                            text: 'Guidance for the Combat with\n   The Examination.',
                            style: TextStyle(
                              fontFamily: 'Lemon Jelly',
                              fontSize: 23,
                            ),
                          ),
                          TextSpan(
                            text: '"',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            EventHomeNetworkData(),
          ],
        ),
      ),
    );
  }
}

class EventHomeNetworkData extends StatefulWidget {
  @override
  _EventHomeNetworkDataState createState() => _EventHomeNetworkDataState();
}

class _EventHomeNetworkDataState extends State<EventHomeNetworkData> {
  bool _hasConnection;
  StreamSubscription _subscription;

  double _listHeight = 380.0;
  double _listWidth = 300.0;

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
    checkInternet();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Builder(builder: (context) {
      if (_hasConnection == null) {
        return EventLoading();
      }
      if (!_hasConnection) {
        return Center(
          child: NetworkError(),
        );
      }
      return Container(
        margin: EdgeInsets.only(top: height * 0.22),
        height: _listHeight * 1.1,
        child: ScrollSnapList(
          onItemFocus: (int) {},
          itemSize: _listWidth,
          itemCount: 2,
          dynamicItemSize: true,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _onPressedFunction(index);
                  },
                  child: Container(
                    width: _listWidth,
                    height: _listHeight,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 1, 79, 134),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.6),
                          spreadRadius: -1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Builder(builder: (context) {
                      if (index == 0) {
                        return TrigonometryEventDetails(user.uid);
                      }
                      return Center(
                        child: Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.white,
                          child: Text(
                            'Coming Soon...',
                            style: TextStyle(
                              fontFamily: 'MontereyFLF',
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  void _onPressedFunction(int index) {
    if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return EventFrontScreen();
          },
        ),
      );
    }
  }
}

class TrigonometryEventDetails extends StatelessWidget {
  final String userId;

  const TrigonometryEventDetails(this.userId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Trigonometry_Event')
          .doc('Event_Info')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.white,
              size: 100,
            ),
          );
        }
        double progress = snapshot.data['progress'];
        int correct = snapshot.data['totalCorrect'];
        int completed = snapshot.data['totalCompleted'];
        int eventXP = snapshot.data['xpEarned'];
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  'EVENT',
                  style: TextStyle(
                    fontFamily: 'MontereyFLF',
                    fontSize: 37,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'TRIGONOMETRY',
                  style: TextStyle(
                    fontFamily: 'OCR A',
                    fontSize: 25,
                    color: Color.fromARGB(255, 176, 232, 255),
                    shadows: [
                      Shadow(
                        blurRadius: 3,
                        offset: Offset(1, 1),
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Opacity(
                      opacity: 0.15,
                      child: Container(
                        width: 67,
                        height: 67,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/Trigonometry_Event_Icon.png',
                          ),
                        ),
                      ),
                    ),
                    CircularPercentIndicator(
                      radius: 41,
                      percent: progress / 100,
                      lineWidth: 7,
                      progressColor: Colors.white,
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 1000,
                      curve: Curves.easeOut,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Color.fromARGB(255, 57, 129, 169),
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'AgencyFB',
                                fontSize: 22,
                                color: Colors.white,
                                height: 0.9,
                                shadows: [
                                  Shadow(
                                    blurRadius: 3,
                                    color: Colors.black.withOpacity(0.8),
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              children: [
                                TextSpan(
                                  text: '${(progress).toStringAsFixed(1)}',
                                ),
                                TextSpan(
                                  text: '%',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Completed',
                            style: TextStyle(
                              height: 1,
                              fontSize: 12,
                              fontFamily: 'Cambria',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.8),
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _similarText('10', 'Stages'),
                      _similarText('105', 'Questions'),
                      Text(
                        'Golden Stage',
                        style: TextStyle(
                          fontFamily: 'Antipasto Pro Extralight',
                          fontSize: 27,
                          color: Color.fromARGB(255, 249, 224, 159),
                          height: 1.2,
                          shadows: [
                            Shadow(
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.7),
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _firstTwoRows('Accuracy', completed: completed, correct: correct),
            _firstTwoRows('XP Earned', eventXP: eventXP),
            Container(
              width: 260,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 97, 165, 194).withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Probability',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'AgencyFB',
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'of giving an answer correctly.',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'AgencyFB',
                            height: 0.8,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          ' In this event',
                          style: TextStyle(
                            fontSize: 19,
                            fontFamily: 'Lemon Jelly',
                            color: Color.fromARGB(255, 53, 25, 46),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder(
                            tween: Tween(
                              begin: 0.0,
                              end: completed != 0 ? 5 * correct / completed : 0.0,
                            ),
                            duration: Duration(seconds: 1),
                            builder: (_, probability, __) {
                              return Container(
                                width: 60,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'AgencyFB',
                                      fontSize: 25,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${(probability).toStringAsFixed(2)}',
                                      ),
                                      TextSpan(
                                        text: '/5',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          TweenAnimationBuilder(
                            tween: Tween(
                              begin: 0.0,
                              end: completed != 0 ? 5 * correct / completed : 0.0,
                            ),
                            duration: Duration(seconds: 1),
                            builder: (_, probability, __) {
                              return RatingBarIndicator(
                                rating: probability,
                                itemBuilder: (context, index) {
                                  return Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  );
                                },
                                itemCount: 5,
                                itemSize: 22,
                                direction: Axis.horizontal,
                                unratedColor: Colors.black,
                              );
                            },
                          ),
                        ],
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
        );
      },
    );
  }

  Widget _similarText(String first, String last) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'AgencyFB',
          fontSize: 30,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 3,
              color: Colors.black.withOpacity(0.7),
              offset: Offset(1, 1),
            ),
          ],
        ),
        children: [
          TextSpan(
            text: '$first ',
          ),
          TextSpan(
            text: last,
            style: TextStyle(
              fontFamily: 'Antipasto Pro Extralight',
              fontSize: 27,
            ),
          ),
        ],
      ),
    );
  }

  Widget _firstTwoRows(String topic, {int correct, int completed, int eventXP}) {
    return Container(
      width: 260,
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 97, 165, 194).withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'AgencyFB',
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                Text(
                  ' In this event',
                  style: TextStyle(
                    fontSize: 19,
                    fontFamily: 'Lemon Jelly',
                    color: Color.fromARGB(255, 53, 25, 46),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              TweenAnimationBuilder(
                  tween: Tween(
                    begin: 0.0,
                    end: correct ?? eventXP,
                  ),
                  duration: Duration(seconds: 1),
                  builder: (_, data, __) {
                    return Container(
                      width: 55,
                      height: 36,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Niagara Solid',
                              fontSize: eventXP == null ? 25 : 20,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '${data.toStringAsFixed(0)}',
                              ),
                              TextSpan(
                                text: '/${completed ?? '10000'}',
                                style: TextStyle(
                                  fontSize: eventXP == null ? 19 : 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              CircularPercentIndicator(
                radius: 20,
                percent: eventXP == null
                    ? (completed != 0 ? correct / completed : 0)
                    : eventXP < 10001
                        ? eventXP / 10000
                        : 1,
                lineWidth: 4,
                progressColor: Colors.white,
                animation: true,
                animateFromLastPercent: true,
                animationDuration: 1000,
                curve: Curves.easeOut,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.black,
                center: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'AgencyFB',
                      fontSize: 13,
                      color: Colors.white,
                      height: 1,
                    ),
                    children: [
                      TextSpan(
                        text: eventXP == null
                            ? (completed != 0
                                ? '${(100 * correct / completed).toStringAsFixed(0)}'
                                : '0')
                            : '${(100 * eventXP / 10000).toStringAsFixed(0)}',
                      ),
                      TextSpan(
                        text: '%',
                        style: TextStyle(
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EventBottomShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    var path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.45);
    path.quadraticBezierTo(size.width * 0.65, size.height * 0.82, 0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
