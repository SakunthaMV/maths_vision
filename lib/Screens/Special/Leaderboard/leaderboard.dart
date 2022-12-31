import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Widgets/Main_App_Bar/home_app_bar.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  int _currentRank;
  User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 136, 205),
      appBar: HomeAppBar(page: 'Leaderboard'),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    SizedBox(
                      width: width * 0.85,
                      height: 80,
                      child: CustomPaint(
                        painter: TriangleClipper(),
                        child: Container(),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25, right: 10, left: 5),
                          child: _leaderboardIcon(31, 4.0),
                        ),
                        _leaderboardIcon(42, 5.0),
                        Padding(
                          padding: const EdgeInsets.only(top: 25, left: 10),
                          child: _leaderboardIcon(31, 4.0),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 3,
                  ),
                  child: Text(
                    'LEADERBOARD',
                    style: TextStyle(
                      fontFamily: 'Rockwell',
                      fontSize: 30,
                      color: Color.fromARGB(255, 38, 50, 56),
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          offset: Offset(1, 1),
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: width * 0.85,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 225, 253, 223),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: width * 0.14,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 214, 213, 213),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                            ),
                            Container(
                              width: width * 0.55,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 225, 227, 250),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 30,
                              child: Row(
                                children: [
                                  _columnHeaders(0.14, 'Rank'),
                                  _columnHeaders(0.55, 'Account'),
                                  _columnHeaders(0.16, 'XP'),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              height: 1,
                              thickness: 1,
                            ),
                            SizedBox(height: 3),
                            Expanded(
                              child: _leaderboardList(),
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
            ),
          ),
          Positioned(
            bottom: width * 0.05,
            child: Transform.scale(
              scale: 1.05,
              child: Container(
                width: width * 0.85,
                height: 45,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 236, 236, 236),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.4),
                      offset: Offset(0, 1),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .where('User_Details.xp', isGreaterThan: 0)
                        .orderBy('User_Details.xp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return LoadingBouncingLine.circle(
                          backgroundColor: Color.fromARGB(255, 0, 136, 205),
                        );
                      }
                      List users = snapshot.data.docs;
                      if (_currentRank == null) {
                        for (int i = 0; i < users.length; i++) {
                          if (users[i]['User_Details.userId'] == user.uid) {
                            _currentRank = i + 1;
                            break;
                          }
                        }
                      }
                      return _userDataRaw();
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _columnHeaders(double percentage, String header) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * percentage,
      child: Center(
        child: Text(
          header,
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Lemon Jelly',
          ),
        ),
      ),
    );
  }

  Widget _leaderboardIcon(double size, double sigma) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Opacity(
            child: Image.asset(
              'assets/Leaderboard_Icon.png',
              color: Colors.black,
            ),
            opacity: 0.2,
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: sigma,
                sigmaY: sigma,
              ),
              child: Image.asset('assets/Leaderboard_Icon.png'),
            ),
          )
        ],
      ),
    );
  }

  Widget _leaderboardList() {
    Color _photoBackground = Colors.white;
    Widget _rank;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('User_Details.xp', isGreaterThan: 0)
          .orderBy(
            'User_Details.xp',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: Color.fromARGB(255, 0, 136, 205),
              size: 120.0,
            ),
          );
        }
        List users = snapshot.data.docs;
        return ListView.builder(
          itemCount: users.length > 51 ? 51 : users.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              _rank = Image.asset('assets/LeaderBoard_First_Batch.png');
              _photoBackground = Color.fromARGB(255, 255, 199, 14);
            } else if (index == 1) {
              _rank = Image.asset('assets/LeaderBoard_Second_Batch.png');
              _photoBackground = Color.fromARGB(255, 190, 195, 199);
            } else if (index == 2) {
              _rank = Image.asset('assets/LeaderBoard_Third_Batch.png');
              _photoBackground = Color.fromARGB(255, 223, 108, 2);
            } else {
              _rank = Text(
                '${index + 1}',
                style: TextStyle(
                  fontFamily: 'Sylfaen',
                  fontSize: 27,
                  height: 1.7,
                ),
              );
              _photoBackground = Colors.white;
            }
            return Container(
              color: Color.fromARGB(255, 176, 185, 178).withOpacity(0.35),
              height: 45,
              margin: EdgeInsets.only(bottom: 3),
              child: _leaderboardRow(users, _rank, _photoBackground, index: index),
            );
          },
        );
      },
    );
  }

  Widget _leaderboardRow(var data, Widget rank, Color background, {int index}) {
    final double width = MediaQuery.of(context).size.width;
    String photoURL;
    String name;
    int level;
    String userId;
    int xp;
    if (index != null) {
      photoURL = data[index]['User_Details.photoURL'];
      name = '${data[index]['User_Details.firstName']} '
          '${data[index]['User_Details.lastName']}';
      level = data[index]['User_Details.level'];
      userId = data[index]['User_Details.userId'];
      xp = data[index]['User_Details.xp'];
    } else {
      photoURL = data['User_Details.photoURL'];
      name = '${data['User_Details.firstName']} '
          '${data['User_Details.lastName']}';
      level = data['User_Details.level'];
      userId = data['User_Details.userId'];
      xp = data['User_Details.xp'];
    }
    return Row(
      children: [
        SizedBox(
          width: width * 0.14,
          child: Center(
            child: rank,
          ),
        ),
        SizedBox(
          width: width * 0.55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    width: 37,
                    height: 37,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: background,
                    ),
                  ),
                  ClipOval(
                    child: SizedBox(
                      width: 33,
                      height: 33,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: photoURL,
                        placeholder: (_, url) {
                          return CircularProgressIndicator();
                        },
                        errorWidget: (_, url, error) {
                          return Icon(
                            Icons.account_circle_rounded,
                            size: 33,
                            color: Colors.grey.shade600,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: width * 0.41,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              name,
                              style: TextStyle(
                                fontFamily: 'Emoji',
                                fontSize: 12,
                                height: 1,
                                color: Color.fromARGB(255, 38, 50, 56),
                                shadows: [
                                  Shadow(
                                    blurRadius: 1,
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0.5, 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          width: 35,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              'Lv $level',
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Emoji',
                                height: 1.3,
                                color: Color.fromARGB(255, 38, 50, 56),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(userId)
                            .collection('Trigonometry_Event')
                            .doc('Event_Info')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            final Widget loading = LoadingAnimationWidget.prograssiveDots(
                              color: Color.fromARGB(255, 0, 136, 205),
                              size: 20.0,
                            );
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                loading,
                                SizedBox(
                                  width: width * 0.15,
                                ),
                                loading,
                              ],
                            );
                          }
                          int completed = snapshot.data['totalCompleted'];
                          int correct = snapshot.data['totalCorrect'];
                          double progress = snapshot.data['progress'] > 100
                              ? 100.0
                              : snapshot.data['progress'];
                          double accuracy = completed != 0 ? 100 * correct / completed : 0.0;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _bottomRow('Accuracy', accuracy),
                              _bottomRow('Completed', progress),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: width * 0.16,
          child: Center(
            child: Text(
              '$xp',
              style: TextStyle(
                fontSize: 21,
                fontFamily: 'AgencyFB',
                letterSpacing: 0.6,
                color: Color.fromARGB(255, 38, 50, 56),
                shadows: [
                  Shadow(
                    blurRadius: 0.5,
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomRow(String topic, double value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'AgencyFB',
          fontSize: 12,
          height: 1,
          color: Color.fromARGB(255, 38, 50, 56),
        ),
        children: [
          TextSpan(
            text: '$topic: ${value.toStringAsFixed(0)}',
          ),
          TextSpan(
            text: '%',
            style: TextStyle(
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userDataRaw() {
    Color _userPhotoBackground = Colors.white;
    Widget _userRank;
    if (_currentRank == 1) {
      _userRank = Image.asset('assets/LeaderBoard_First_Batch.png');
      _userPhotoBackground = Color.fromARGB(255, 255, 199, 14);
    } else if (_currentRank == 2) {
      _userRank = Image.asset('assets/LeaderBoard_Second_Batch.png');
      _userPhotoBackground = Color.fromARGB(255, 190, 195, 199);
    } else if (_currentRank == 3) {
      _userRank = Image.asset('assets/LeaderBoard_Third_Batch.png');
      _userPhotoBackground = Color.fromARGB(255, 223, 108, 2);
    } else {
      _userRank = Text(
        '${_currentRank ?? 'ENM'}',
        style: TextStyle(
          fontFamily: 'Sylfaen',
          fontSize: _currentRank == null ? 18 : 27,
          height: 1.8,
        ),
      );
      _userPhotoBackground = Colors.white;
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingBouncingLine.circle(
            backgroundColor: Color.fromARGB(255, 0, 136, 205),
          );
        }
        DocumentSnapshot userData = snapshot.data;
        return _leaderboardRow(userData, _userRank, _userPhotoBackground);
      },
    );
  }
}

class TriangleClipper extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color.fromARGB(255, 65, 191, 255);
    paint.style = PaintingStyle.fill;
    var path = Path();

    path.moveTo(size.width * 0.48, size.height * 0.04);
    path.quadraticBezierTo(size.width * 0.5, 0, size.width * 0.52, size.height * 0.04);
    path.lineTo(size.width * 0.85, size.height * 0.72);
    path.quadraticBezierTo(
        size.width * 0.97, size.height * 0.99, size.width * 0.85, size.height);
    path.lineTo(size.width * 0.15, size.height);
    path.quadraticBezierTo(
        size.width * 0.03, size.height * 0.99, size.width * 0.15, size.height * 0.72);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.5), 3.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
