import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GoldenSheetTab extends StatefulWidget {
  const GoldenSheetTab({Key key}) : super(key: key);

  @override
  _GoldenSheetTabState createState() => _GoldenSheetTabState();
}

class _GoldenSheetTabState extends State<GoldenSheetTab> {
  List icons = [
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

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: width * 0.05,
        ),
        Expanded(
          child: Container(
            width: width * 0.9,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 110, 187, 192),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -10.2,
                  bottom: 70.5,
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: Container(
                      width: 3,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 120,
                  child: Container(
                    width: 3,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 3.6,
                  bottom: 219,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -10.2,
                  top: 70.5,
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: Container(
                      width: 3,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 120,
                  child: Container(
                    width: 3,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 3.6,
                  top: 219,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Best Timing',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Lucida Bright Italic',
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
                    ),
                    Container(
                      height: 2,
                      width: width * 0.75,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Events')
                              .doc('Trigonometry')
                              .collection('Stages')
                              .doc('Golden_Stage')
                              .snapshots(),
                          builder: (context, event) {
                            if (event.hasData) {
                              String Q = 'Questions_Info';
                              String B = 'BestTiming';
                              return ListView.builder(
                                padding:
                                    EdgeInsets.fromLTRB(width * 0.075, 10, width * 0.075, 10),
                                itemCount: icons.length,
                                itemBuilder: (context, index) {
                                  String qNow = 'Question_${icons[index]}';
                                  String userId = event.data['$Q.$qNow.$B.UserID'];
                                  if (userId != null) {
                                    return StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(userId)
                                            .snapshots(),
                                        builder: (context, user) {
                                          if (user.hasData) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 10, bottom: 10),
                                              child: ClipRRect(
                                                clipBehavior: Clip.hardEdge,
                                                borderRadius: BorderRadius.circular(15),
                                                child: listItem(index, true,
                                                    user: user.data,
                                                    bestTime: event.data['$Q.$qNow.$B.Time']),
                                              ),
                                            );
                                          } else {
                                            return LoadingFadingLine.circle(
                                              size: 70,
                                              backgroundColor: Colors.white,
                                            );
                                          }
                                        });
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                                      child: ClipRRect(
                                        clipBehavior: Clip.hardEdge,
                                        borderRadius: BorderRadius.circular(15),
                                        child: listItem(index, false),
                                      ),
                                    );
                                  }
                                },
                              );
                            } else {
                              return LoadingBouncingLine.circle(
                                size: 100,
                                backgroundColor: Colors.white,
                              );
                            }
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: width * 0.05,
        ),
      ],
    );
  }

  Widget listItem(int index, bool hasData, {DocumentSnapshot user, int bestTime}) {
    final double width = MediaQuery.of(context).size.width;
    if (hasData) {
      String time = StopWatchTimer.getDisplayTime(bestTime, milliSecond: false, hours: false);
      String timeMil = StopWatchTimer.getDisplayTimeMillisecond(bestTime);
      String name = '${user['User_Details.firstName']} ${user['User_Details.lastName']}';
      return Container(
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            OverflowBox(
              maxHeight: 120,
              maxWidth: 160,
              minHeight: 0,
              minWidth: 0,
              alignment: Alignment(-1.9, 0.4),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 181, 226, 255),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 143, 211, 254),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 106, 197, 254),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40),
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/${icons[index]}_Black.png'),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    width: width * 0.48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 25,
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Color.fromARGB(255, 69, 182, 254),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: time,
                                      ),
                                      TextSpan(
                                        text: ':$timeMil',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 13,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Color.fromARGB(255, 106, 197, 254),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Lv ${user['User_Details.level']}',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontFamily: 'Gothic',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: 13,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Color.fromARGB(255, 106, 197, 254),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${user['User_Details.currentRank']}',
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontFamily: 'Gothic',
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Icon(
                                          Icons.emoji_events_rounded,
                                          size: 9,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 181, 226, 255),
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: user['User_Details.photoURL'] != null
                                ? CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: user['User_Details.photoURL'],
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
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  width: width * 0.75,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 69, 182, 254),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Gothic',
                        fontSize: 13,
                        height: 1.2,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      String time = StopWatchTimer.getDisplayTime(
        0,
        milliSecond: false,
        hours: false,
      );
      String timeMil = StopWatchTimer.getDisplayTimeMillisecond(0);
      return Container(
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            OverflowBox(
              maxHeight: 120,
              maxWidth: 160,
              minHeight: 0,
              minWidth: 0,
              alignment: Alignment(-1.9, 0.4),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 181, 226, 255),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 143, 211, 254),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 106, 197, 254),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40),
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/${icons[index]}_Black.png'),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    width: width * 0.48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 25,
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Color.fromARGB(255, 69, 182, 254),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: time,
                                      ),
                                      TextSpan(
                                        text: ':$timeMil',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 13,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Color.fromARGB(255, 106, 197, 254),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Lv 0',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontFamily: 'Gothic',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: 13,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Color.fromARGB(255, 106, 197, 254),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '0',
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontFamily: 'Gothic',
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Icon(
                                          Icons.emoji_events_rounded,
                                          size: 9,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 181, 226, 255),
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset('assets/HomeButton.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  width: width * 0.75,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 69, 182, 254),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Text(
                      'No one has solved the problem correctly yet',
                      style: TextStyle(
                        fontFamily: 'Gothic',
                        fontSize: 10,
                        height: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
