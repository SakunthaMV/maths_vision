import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Support_Classes/event_errors_and_loading.dart';
import 'package:maths_vision/Golden_Stage/rewards_screen.dart';
import 'package:maths_vision/Screens/papers_screen.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GoldenBoard extends StatefulWidget {
  const GoldenBoard({Key key}) : super(key: key);

  @override
  _GoldenBoardState createState() => _GoldenBoardState();
}

class _GoldenBoardState extends State<GoldenBoard> {
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

  int _goldenRank = 0;
  List _goldenList;
  DocumentSnapshot _userData;
  User user;

  Query data = FirebaseFirestore.instance
      .collection('Users')
      .where('User_Details.average_time', isGreaterThan: 0)
      .orderBy(
        'User_Details.average_time',
      );

  @override
  void initState() {
    super.initState();
    initConnectivity();
    user = FirebaseAuth.instance.currentUser;
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    userData.snapshots().listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        _userData = event;
      });
    });
    data.snapshots().listen((docs) {
      _goldenList = docs.docs.toList();
      for (int i = 0; i < _goldenList.length; i++) {
        if (_goldenList[i]['User_Details.userId'] == user.uid) {
          if (!mounted) {
            return;
          }
          setState(() {
            _goldenRank = i + 1;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 79, 134),
      body: _connectionStatus == 'ConnectivityResult.wifi' ||
              _connectionStatus == 'ConnectivityResult.mobile'
          ? _userData != null
              ? Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Column(
                      children: [
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 233, 233, 233),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                        offset: Offset(0, 2),
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.arrow_back),
                                    color: Colors.black,
                                    splashRadius: 25,
                                  ),
                                ),
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 239, 197, 4),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                        offset: Offset(0, 2),
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return RewardScreen();
                                          },
                                        ),
                                      );
                                    },
                                    icon: Image.asset('assets/Rewords_Icon.png'),
                                    splashRadius: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.85,
                          height: 75,
                          child: CustomPaint(
                            painter: GoldenTriangleClipper(),
                            child: Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Center(
                                child: SizedBox(
                                  height: 65,
                                  child: Image.asset('assets/Average_Time_Leaderboard.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Text(
                            'GOLDENBOARD',
                            style: TextStyle(
                              fontFamily: 'Rockwell',
                              fontSize: 30,
                              color: Color.fromARGB(255, 239, 197, 6),
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
                        _goldenList != null
                            ? _goldenList.length < 20
                                ? Container(
                                    width: width * 0.8,
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Text(
                                      'After the number of users exceeds 20 competitors, reward begins.',
                                      style: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink()
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 3,
                        ),
                        Expanded(
                          child: Container(
                            width: width * 0.85,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 249, 224, 159),
                              borderRadius: _userData['User_Details.average_time'] != 0
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    )
                                  : BorderRadius.circular(20),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.topCenter,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: width * 0.14,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 255, 180, 4),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft:
                                                _userData['User_Details.average_time'] != 0
                                                    ? Radius.circular(0)
                                                    : Radius.circular(20)),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.47,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 255, 215, 0),
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
                                            width: width * 0.47,
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
                                            width: width * 0.24,
                                            child: Center(
                                              child: Text(
                                                'Avg Time',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily: 'Lemon Jelly',
                                                ),
                                              ),
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
                                    Expanded(
                                      child: _goldenList != null
                                          ? ListView.builder(
                                              itemCount: _goldenList.length > 15
                                                  ? 15
                                                  : _goldenList.length,
                                              padding: EdgeInsets.only(top: 3),
                                              itemBuilder: (context, index) {
                                                return _goldenBoardListItem(index);
                                              },
                                            )
                                          : LoadingBouncingLine.circle(
                                              size: 100,
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _userData['User_Details.average_time'] > 0
                              ? width * 0.05 + 47
                              : width * 0.075,
                        ),
                      ],
                    ),
                    _goldenList != null
                        ? _goldenUserDetails()
                        : LoadingBouncingLine.circle(
                            size: 40,
                          ),
                  ],
                )
              : EventLoading()
          : Center(
              child: NetworkError(Colors.white),
            ),
    );
  }

  Widget _goldenBoardListItem(int index) {
    final double width = MediaQuery.of(context).size.width;
    Widget rank;
    if (index == 0) {
      rank = Image.asset('assets/LeaderBoard_First_Batch.png');
    } else if (index == 1) {
      rank = Image.asset('assets/LeaderBoard_Second_Batch.png');
    } else if (index == 2) {
      rank = Image.asset('assets/LeaderBoard_Third_Batch.png');
    } else {
      rank = Text(
        '${index + 1}',
        style: TextStyle(
          fontFamily: 'Sylfaen',
          fontSize: 27,
          height: 1,
        ),
      );
    }
    String name =
        '${_goldenList[index]['User_Details.firstName']} ${_goldenList[index]['User_Details.lastName']}';
    int position = (100 * (index + 1) / _goldenList.length).round();
    String time = StopWatchTimer.getDisplayTime(
      _goldenList[index]['User_Details.average_time'],
      milliSecond: false,
      hours: false,
    );
    String timeMil = StopWatchTimer.getDisplayTimeMillisecond(
        _goldenList[index]['User_Details.average_time']);
    return Container(
      color: Color.fromARGB(255, 183, 153, 6).withOpacity(0.3),
      height: 45,
      margin: EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.14,
            child: Center(
              child: rank,
            ),
          ),
          SizedBox(
            width: width * 0.47,
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
                        color: Colors.white,
                      ),
                    ),
                    _goldenList[index]['User_Details.photoURL'] != null
                        ? ClipOval(
                            child: SizedBox(
                              width: 33,
                              height: 33,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: _goldenList[index]['User_Details.photoURL'],
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
                  width: width * 0.33,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          name,
                          style: TextStyle(
                            fontFamily: 'Emoji',
                            fontSize: 13,
                            height: 1,
                            color: Colors.black,
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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'Position: '),
                            TextSpan(
                              text: '$position',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: '%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontFamily: 'AgencyFB',
                            fontSize: 13,
                            height: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width * 0.24,
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Open Sans',
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
                  children: [
                    TextSpan(
                      text: time,
                    ),
                    TextSpan(
                        text: ':$timeMil',
                        style: TextStyle(
                          fontSize: 13,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goldenUserDetails() {
    if (_userData['User_Details.average_time'] > 0) {
      final double width = MediaQuery.of(context).size.width;
      Widget _userRank;
      if (_goldenRank == 1) {
        _userRank = Image.asset('assets/LeaderBoard_First_Batch.png');
      } else if (_goldenRank == 2) {
        _userRank = Image.asset('assets/LeaderBoard_Second_Batch.png');
      } else if (_goldenRank == 3) {
        _userRank = Image.asset('assets/LeaderBoard_Third_Batch.png');
      } else {
        _userRank = Text(
          '$_goldenRank',
          style: TextStyle(
            fontFamily: 'Sylfaen',
            fontSize: 27,
            height: 1,
          ),
        );
      }
      String name =
          '${_userData['User_Details.firstName']} ${_userData['User_Details.lastName']}';
      int position = (100 * _goldenRank / _goldenList.length).round();
      String time = StopWatchTimer.getDisplayTime(
        _userData['User_Details.average_time'],
        milliSecond: false,
        hours: false,
      );
      String timeMil =
          StopWatchTimer.getDisplayTimeMillisecond(_userData['User_Details.average_time']);
      return Positioned(
        bottom: width * 0.05,
        child: Container(
          width: width * 0.9,
          height: 50,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 215, 0),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * 0.14,
                child: Center(
                  child: _userRank,
                ),
              ),
              SizedBox(
                width: width * 0.47,
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
                            color: Colors.white,
                          ),
                        ),
                        _userData['User_Details.photoURL'] != null
                            ? ClipOval(
                                child: SizedBox(
                                  width: 33,
                                  height: 33,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: _userData['User_Details.photoURL'],
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
                      width: width * 0.33,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              name,
                              style: TextStyle(
                                fontFamily: 'Emoji',
                                fontSize: 13,
                                height: 1,
                                color: Colors.black,
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
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: 'Position: '),
                                TextSpan(
                                  text: '$position',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: '%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                              style: TextStyle(
                                fontFamily: 'AgencyFB',
                                fontSize: 13,
                                height: 1,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width * 0.24,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Open Sans',
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
                      children: [
                        TextSpan(
                          text: time,
                        ),
                        TextSpan(
                            text: ':$timeMil',
                            style: TextStyle(
                              fontSize: 13,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class GoldenTriangleClipper extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    var rect = Offset.zero & size;
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 239, 197, 1),
        Color.fromARGB(255, 249, 224, 159),
        Color.fromARGB(255, 239, 197, 1),
      ],
    ).createShader(rect);
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
