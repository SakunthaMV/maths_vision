import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Screens/papers_screen.dart';
import 'package:maths_vision/Widgets/home_app_bar.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
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

  int _currentRank;
  User user;
  List _usersData;

  Query data = FirebaseFirestore.instance
      .collection('Users')
      .orderBy(
        'User_Details.xp',
        descending: true,
      );

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    initConnectivity();
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    data.snapshots().listen((docs) {
      _usersData = docs.docs.toList();
      for (int i = 0; i < _usersData.length; i++) {
        if (_usersData[i]['User_Details.userId'] == user.uid) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 136, 205),
      appBar: HomeAppBar(page: 'Leaderboard',),
      body: _connectionStatus == 'ConnectivityResult.wifi' ||
              _connectionStatus == 'ConnectivityResult.mobile'
          ? Stack(
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
                              SizedBox(
                                width: 4,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 25, right: 10),
                                child: SizedBox(
                                  width: 31,
                                  height: 31,
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
                                            sigmaX: 4.0,
                                            sigmaY: 4.0,
                                          ),
                                          child: Image.asset('assets/Leaderboard_Icon.png'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 42,
                                height: 42,
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
                                          sigmaX: 5.0,
                                          sigmaY: 5.0,
                                        ),
                                        child: Image.asset('assets/Leaderboard_Icon.png'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 25, left: 10),
                                child: SizedBox(
                                  width: 31,
                                  height: 31,
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
                                            sigmaX: 4.0,
                                            sigmaY: 4.0,
                                          ),
                                          child: Image.asset('assets/Leaderboard_Icon.png'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
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
                      SizedBox(
                        height: 3,
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
                                        SizedBox(
                                          width: width * 0.14,
                                          child: Center(
                                            child: Text(
                                              'Rank',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontFamily: 'Lemon Jelly',
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.55,
                                          child: Center(
                                            child: Text(
                                              'Account',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontFamily: 'Lemon Jelly',
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.16,
                                          child: Center(
                                            child: Image.asset('assets/XP.png'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
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
                        height: width * 0.05 + 47,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: width * 0.05,
                  child: Container(
                    width: width * 0.9,
                    height: 50,
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
                    child: _userDataRaw(),
                  ),
                ),
              ],
            )
          : Center(
              child: NetworkError(Colors.white),
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
        '${_currentRank == null ? 'ENM' : _currentRank}',
        style: TextStyle(
          fontFamily: 'Sylfaen',
          fontSize: _currentRank == null ? 18 : 27,
          height: 1,
        ),
      );
      _userPhotoBackground = Colors.white;
    }
    final double width = MediaQuery.of(context).size.width;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot userData = snapshot.data;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * 0.14,
                child: Center(
                  child: _userRank,
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
                            color: _userPhotoBackground,
                          ),
                        ),
                        userData['User_Details.photoURL'] != null
                            ? ClipOval(
                                child: SizedBox(
                                  width: 33,
                                  height: 33,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: userData['User_Details.photoURL'],
                                    placeholder: (_, url) {
                                      return CircularProgressIndicator();
                                    },
                                    errorWidget: (context, url, error) {
                                      return Icon(Icons.error);
                                    },
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.account_circle_rounded,
                                size: 37,
                                color: Colors.grey.shade600,
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
                              Text(
                                '${userData['User_Details.firstName']} ${userData['User_Details.lastName']}',
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
                              Container(
                                width: 35,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    'Lv ${userData['User_Details.level']}',
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
                                .doc(user.uid)
                                .collection('Trigonometry_Event')
                                .doc('Event_Info')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                DocumentSnapshot eventData = snapshot.data;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                'Accuracy: ${(eventData['totalCompleted'] != 0 ? (100 * eventData['totalCorrect'] / eventData['totalCompleted']) : 0).toStringAsFixed(0)}',
                                          ),
                                          TextSpan(
                                            text: '%',
                                            style: TextStyle(
                                              fontSize: 8,
                                            ),
                                          ),
                                        ],
                                        style: TextStyle(
                                          fontFamily: 'AgencyFB',
                                          fontSize: 12,
                                          height: 1,
                                          color: Color.fromARGB(255, 38, 50, 56),
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                'Completed: ${(eventData['progress']).toStringAsFixed(0)}',
                                          ),
                                          TextSpan(
                                            text: '%',
                                            style: TextStyle(
                                              fontSize: 8,
                                            ),
                                          ),
                                        ],
                                        style: TextStyle(
                                          fontFamily: 'AgencyFB',
                                          fontSize: 12,
                                          height: 1,
                                          color: Color.fromARGB(255, 38, 50, 56),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    LoadingBouncingLine.circle(
                                      size: 20,
                                      backgroundColor: Color.fromARGB(255, 0, 136, 205),
                                    ),
                                    SizedBox(
                                      width: width * 0.2,
                                    ),
                                    LoadingBouncingLine.circle(
                                      size: 20,
                                      backgroundColor: Color.fromARGB(255, 0, 136, 205),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
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
                    '${userData['User_Details.xp']}',
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
        } else {
          return LoadingBouncingLine.circle(
            backgroundColor: Color.fromARGB(255, 0, 136, 205),
          );
        }
      },
    );
  }

  Widget _leaderboardList() {
    final double width = MediaQuery.of(context).size.width;
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
        if (snapshot.hasData) {
          List users = snapshot.data.docs;
          return ListView.builder(
            itemCount: users.length > 50 ? 50 : users.length,
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
                    height: 1,
                  ),
                );
                _photoBackground = Colors.white;
              }
              return Container(
                color: Color.fromARGB(255, 176, 185, 178).withOpacity(0.35),
                height: 45,
                margin: EdgeInsets.only(bottom: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: width * 0.14,
                      child: Center(
                        child: _rank,
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
                                  color: _photoBackground,
                                ),
                              ),
                              users[index]['User_Details.photoURL'] != null
                                  ? ClipOval(
                                      child: SizedBox(
                                        width: 33,
                                        height: 33,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: users[index]['User_Details.photoURL'],
                                          placeholder: (_, url) {
                                            return CircularProgressIndicator();
                                          },
                                          errorWidget: (context, url, error) {
                                            return Icon(Icons.error);
                                          },
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.account_circle_rounded,
                                      size: 38,
                                      color: Colors.grey.shade600,
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
                                          '${users[index]['User_Details.firstName']} ${users[index]['User_Details.lastName']}',
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
                                          'Lv ${users[index]['User_Details.level']}',
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
                                        .doc(users[index]['User_Details.userId'])
                                        .collection('Trigonometry_Event')
                                        .doc('Event_Info')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        int completed = snapshot.data['totalCompleted'];
                                        int correct = snapshot.data['totalCorrect'];
                                        double progress = snapshot.data['progress'];
                                        double accuracy =
                                            completed != 0 ? 100 * correct / completed : 0.0;
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        'Accuracy: ${accuracy.toStringAsFixed(0)}',
                                                  ),
                                                  TextSpan(
                                                    text: '%',
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ],
                                                style: TextStyle(
                                                  fontFamily: 'AgencyFB',
                                                  fontSize: 12,
                                                  height: 1,
                                                  color: Color.fromARGB(255, 38, 50, 56),
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        'Completed: ${progress.toStringAsFixed(0)}',
                                                  ),
                                                  TextSpan(
                                                    text: '%',
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ],
                                                style: TextStyle(
                                                  fontFamily: 'AgencyFB',
                                                  fontSize: 12,
                                                  height: 1,
                                                  color: Color.fromARGB(255, 38, 50, 56),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            LoadingBouncingLine.circle(
                                              size: 20,
                                              backgroundColor:
                                                  Color.fromARGB(255, 0, 136, 205),
                                            ),
                                            SizedBox(
                                              width: width * 0.2,
                                            ),
                                            LoadingBouncingLine.circle(
                                              size: 20,
                                              backgroundColor:
                                                  Color.fromARGB(255, 0, 136, 205),
                                            ),
                                          ],
                                        );
                                      }
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
                          '${users[index]['User_Details.xp']}',
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
                ),
              );
            },
          );
        } else {
          return Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                color: Color.fromARGB(255, 0, 136, 205),
              ),
            ),
          );
        }
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
