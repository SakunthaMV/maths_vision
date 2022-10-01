import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:maths_vision/Event_1/account_screen.dart';
import 'package:maths_vision/Event_1/store.dart';
import 'package:maths_vision/Splash_Screens/went_home_splash_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:shimmer/shimmer.dart';

import 'event_front_screen.dart';
import 'event_errors_and_loading.dart';
import 'leaderboard.dart';

class EventHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return WentHomeSplashScreen();
            },
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 1, 170, 255),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              width: width,
              height: height * 0.41,
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
            Align(
              alignment: Alignment(0, -0.8),
              child: Container(
                width: 160,
                height: 160,
                child: Image.asset('assets/Event_Home_Top_Clip.png'),
              ),
            ),
            Align(
              alignment: Alignment(0, -0.45),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'T',
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
                    ),
                    TextSpan(
                      text: 'HE BATTLE BEGAN',
                      style: TextStyle(
                        fontSize: 21,
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
                        children: [
                          TextSpan(
                            text: '"',
                            style: TextStyle(
                              fontFamily: 'Juice ITC',
                              fontSize: 20,
                              color: Colors.black,
                              height: 1,
                            ),
                          ),
                          TextSpan(
                            text: 'Guidance for the Combat with\n   The Examination.',
                            style: TextStyle(
                              height: 1,
                              fontFamily: 'Lemon Jelly',
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '"',
                            style: TextStyle(
                              fontFamily: 'Juice ITC',
                              fontSize: 20,
                              color: Colors.black,
                              height: 1,
                            ),
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
  double _listHeight = 380.0;
  double _listWidth = 300.0;

  User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        DocumentSnapshot userData = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return EventLoading();
        } else if (snapshot.hasData) {
          int sumOfN = 0;
          int xp = userData['User_Details.xp'];
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
          return Stack(
            alignment: AlignmentDirectional.topCenter,
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
                                    '${userData['User_Details.coins']}',
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
                                                child: userData['User_Details.photoURL'] !=
                                                        null
                                                    ? CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            userData['User_Details.photoURL'],
                                                        placeholder: (_, url) {
                                                          return CircularProgressIndicator();
                                                        },
                                                        errorWidget: (context, url, error) {
                                                          return Icon(Icons.error);
                                                        },
                                                      )
                                                    : Icon(
                                                        Icons.account_circle_rounded,
                                                        size: 45,
                                                        color:
                                                            Color.fromARGB(255, 202, 202, 202),
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
                margin: EdgeInsets.only(top: height * 0.31),
                height: _listHeight * 1.1,
                child: Column(
                  children: [
                    Expanded(
                      child: ScrollSnapList(
                        onItemFocus: (int) {},
                        itemSize: _listWidth,
                        itemCount: 2,
                        dynamicItemSize: true,
                        itemBuilder: (context, index) {
                          return Container(
                            width: _listWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: index == 0
                                      ? () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) {
                                                return EventFrontScreen();
                                              },
                                            ),
                                          );
                                        }
                                      : null,
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
                                    child: index == 1
                                        ? Center(
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
                                          )
                                        : TrigonometryEventDetails(user.uid),
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
            ],
          );
        } else {
          return UnknownError();
        }
      },
    );
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
        DocumentSnapshot eventData = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return EventLoading();
        } else if (snapshot.hasData) {
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
                        percent: eventData['progress'] / 100,
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
                                children: [
                                  TextSpan(
                                    text: '${(eventData['progress']).toStringAsFixed(1)}',
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
                                  ),
                                  TextSpan(
                                    text: '%',
                                    style: TextStyle(
                                      fontFamily: 'AgencyFB',
                                      fontSize: 15,
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
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '10 ',
                                style: TextStyle(
                                  fontFamily: 'AgencyFB',
                                  fontSize: 30,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.8),
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: 'Stages',
                                style: TextStyle(
                                  fontFamily: 'Antipasto Pro Extralight',
                                  fontSize: 27,
                                  color: Colors.white,
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
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '105 ',
                                style: TextStyle(
                                  fontFamily: 'AgencyFB',
                                  fontSize: 30,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.8),
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: 'Questions',
                                style: TextStyle(
                                  fontFamily: 'Antipasto Pro Extralight',
                                  fontSize: 27,
                                  color: Colors.white,
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
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '',
                                style: TextStyle(
                                  fontFamily: 'AgencyFB',
                                  fontSize: 30,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.8),
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: 'Golden Stage',
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
                  ),
                ],
              ),
              Container(
                width: 260,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 97, 165, 194).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Accuracy',
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
                      ],
                    ),
                    Row(
                      children: [
                        TweenAnimationBuilder(
                            tween: Tween(
                              begin: 0.0,
                              end: eventData['totalCorrect'],
                            ),
                            duration: Duration(seconds: 1),
                            builder: (_, correct, __) {
                              return Container(
                                width: 55,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${correct.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontFamily: 'Niagara Solid',
                                            fontSize: 25,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '/${eventData['totalCompleted']}',
                                          style: TextStyle(
                                            fontFamily: 'Niagara Solid',
                                            fontSize: 19,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                        SizedBox(
                          width: 15,
                        ),
                        CircularPercentIndicator(
                          radius: 20,
                          percent: eventData['totalCompleted'] != 0
                              ? eventData['totalCorrect'] / eventData['totalCompleted']
                              : 0,
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
                              children: [
                                TextSpan(
                                  text: eventData['totalCompleted'] != 0
                                      ? '${(100 * eventData['totalCorrect'] / eventData['totalCompleted']).toStringAsFixed(0)}'
                                      : '0',
                                  style: TextStyle(
                                    fontFamily: 'AgencyFB',
                                    fontSize: 13,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                TextSpan(
                                  text: '%',
                                  style: TextStyle(
                                    fontFamily: 'AgencyFB',
                                    fontSize: 9,
                                    color: Colors.white,
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
              ),
              Container(
                width: 260,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 97, 165, 194).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'XP Earned',
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
                      ],
                    ),
                    Row(
                      children: [
                        TweenAnimationBuilder(
                          tween: Tween(
                            begin: 0.0,
                            end: eventData['xpEarned'],
                          ),
                          duration: Duration(seconds: 1),
                          builder: (_, xp, __) {
                            return Container(
                              width: 55,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${xp.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontFamily: 'Niagara Solid',
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '/10000',
                                        style: TextStyle(
                                          fontFamily: 'Niagara Solid',
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        CircularPercentIndicator(
                          radius: 20,
                          percent: eventData['xpEarned'] < 10001
                              ? eventData['xpEarned'] / 10000
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
                              children: [
                                TextSpan(
                                  text:
                                      '${(100 * eventData['xpEarned'] / 10000).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontFamily: 'AgencyFB',
                                    fontSize: 13,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                TextSpan(
                                  text: '%',
                                  style: TextStyle(
                                    fontFamily: 'AgencyFB',
                                    fontSize: 9,
                                    color: Colors.white,
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
              ),
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
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Column(
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
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TweenAnimationBuilder(
                              tween: Tween(
                                begin: 0.0,
                                end: eventData['totalCompleted'] != 0
                                    ? 5 *
                                        eventData['totalCorrect'] /
                                        eventData['totalCompleted']
                                    : 0.0,
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
                                  ),
                                );
                              },
                            ),
                            TweenAnimationBuilder(
                              tween: Tween(
                                begin: 0.0,
                                end: eventData['totalCompleted'] != 0
                                    ? 5 *
                                        eventData['totalCorrect'] /
                                        eventData['totalCompleted']
                                    : 0.0,
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
        } else {
          return UnknownError();
        }
      },
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
