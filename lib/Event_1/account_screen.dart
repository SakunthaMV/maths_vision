import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:maths_vision/Diary/diary_home_screen.dart';
import 'package:maths_vision/Event_1/account_edit_screen.dart';
import 'package:maths_vision/Event_1/store.dart';
import 'package:maths_vision/Screens/papers_screen.dart';
import 'package:maths_vision/Splash_Screens/log_out_splash_screen.dart';
import 'package:maths_vision/Splash_Screens/went_home_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event_errors_and_loading.dart';
import 'leaderboard.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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

  int _coins;
  int _level;
  DocumentSnapshot _userData;
  DocumentSnapshot _userEventData;
  User user;
  double _labelFontSize = 24;
  double _valueFontSize = 19;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    initConnectivity();
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    userData.snapshots().listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        _coins = event['User_Details.coins'];
        _level = event['User_Details.level'];
        _userData = event;
      });
    });
    userData.collection('Trigonometry_Event').doc('Event_Info').snapshots().listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        _userEventData = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 183, 183, 183),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return WentHomeSplashScreen();
                },
              ),
            );
          },
          splashRadius: 20,
          splashColor: Colors.grey.shade600,
          highlightColor: Colors.black.withOpacity(0.2),
          iconSize: 30,
          color: Colors.white,
        ),
        actions: [
          _connectionStatus == 'ConnectivityResult.wifi' ||
                  _connectionStatus == 'ConnectivityResult.mobile'
              ? _userData != null
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10),
                          child: InkWell(
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
                                    '$_coins',
                                    style: TextStyle(
                                      fontFamily: 'Forte',
                                      fontSize: 17,
                                      color: Colors.black,
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
                        ),
                        Container(
                          width: 60,
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'lv $_level',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black, fontFamily: 'Forte'),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox()
              : SizedBox(),
          IconButton(
            icon: Icon(Icons.article),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return DiaryHomeScreen();
                  },
                ),
              );
            },
            splashRadius: 20,
            splashColor: Colors.grey.shade600,
            highlightColor: Colors.black.withOpacity(0.2),
            iconSize: 30,
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return LeaderBoard();
                  },
                ),
              );
            },
            splashRadius: 20,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          IconButton(
            icon: IconShadowWidget(
              Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
              shadowColor: Colors.black,
            ),
            onPressed: () {},
            splashRadius: 20,
            splashColor: Colors.grey.shade600,
            highlightColor: Colors.black.withOpacity(0.2),
            iconSize: 30,
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          SizedBox(
            height: height,
            width: width,
            child: CustomPaint(
              painter: BackContainer(),
              child: Container(),
            ),
          ),
          _connectionStatus == 'ConnectivityResult.wifi' ||
                  _connectionStatus == 'ConnectivityResult.mobile'
              ? _userData != null && _userEventData != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  ClipOval(
                                    child: SizedBox(
                                      width: 130,
                                      height: 130,
                                      child: _userData['User_Details.photoURL'] != null
                                          ? CachedNetworkImage(
                                              imageUrl: _userData['User_Details.photoURL'],
                                              placeholder: (_, url) {
                                                return CircularProgressIndicator();
                                              },
                                              errorWidget: (context, url, error) {
                                                return Icon(Icons.error);
                                              },
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.account_circle_rounded,
                                              size: 130,
                                              color: Color.fromARGB(255, 202, 202, 202),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 70,
                                ),
                                SizedBox(
                                  height: 480,
                                  width: width * 0.8,
                                  child: CustomPaint(
                                    painter: DetailContainer(),
                                    child: Container(),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 160,
                                ),
                                Text(
                                  '${_userData['User_Details.firstName']} ${_userData['User_Details.lastName']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${_userData['User_Details.email']}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Roboto',
                                    height: 1.2,
                                    color: Colors.black,
                                  ),
                                ),
                                Divider(
                                  color: Color.fromARGB(255, 112, 112, 112),
                                  thickness: 1,
                                  endIndent: width * 0.15,
                                  indent: width * 0.15,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: width * 0.15, right: width * 0.15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Account Details',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Roboto Regular',
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 136, 145),
                                          height: 1,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 1,
                                              offset: Offset(1, 1),
                                              color: Colors.black.withOpacity(0.2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 7),
                                        padding: EdgeInsets.only(left: 9, right: 9),
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 238, 238, 238),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'XP Earned',
                                              style: TextStyle(
                                                fontSize: _labelFontSize,
                                                fontFamily: 'Microsoft',
                                                color: Colors.black,
                                                height: 1.1,
                                              ),
                                            ),
                                            Text(
                                              '${_userData['User_Details.xp']}',
                                              style: TextStyle(
                                                fontSize: _valueFontSize,
                                                fontFamily: 'Sylfaen',
                                                color: Colors.black,
                                                height: 1.35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 7),
                                        padding: EdgeInsets.only(left: 9, right: 9),
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 238, 238, 238),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Completed',
                                              style: TextStyle(
                                                fontSize: _labelFontSize,
                                                fontFamily: 'Microsoft',
                                                color: Colors.black,
                                                height: 1.1,
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: _valueFontSize,
                                                  fontFamily: 'Sylfaen',
                                                  color: Colors.black,
                                                  height: 1.35,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          '${(_userEventData['progress']).toStringAsFixed(1)}'),
                                                  TextSpan(
                                                    text: '%',
                                                    style: TextStyle(fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 7),
                                        padding: EdgeInsets.only(left: 9, right: 9),
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 238, 238, 238),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Accuracy',
                                              style: TextStyle(
                                                fontSize: _labelFontSize,
                                                fontFamily: 'Microsoft',
                                                color: Colors.black,
                                                height: 1.1,
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: _valueFontSize,
                                                  fontFamily: 'Sylfaen',
                                                  color: Colors.black,
                                                  height: 1.35,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          '${(_userEventData['totalCompleted'] != 0 ? (100 * _userEventData['totalCorrect'] / _userEventData['totalCompleted']) : 0).toStringAsFixed(1)}'),
                                                  TextSpan(
                                                    text: '%',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 7),
                                        padding: EdgeInsets.only(left: 9, right: 9),
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 238, 238, 238),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Probability',
                                              style: TextStyle(
                                                fontSize: _labelFontSize,
                                                fontFamily: 'Microsoft',
                                                color: Colors.black,
                                                height: 1.1,
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: _valueFontSize,
                                                  fontFamily: 'Sylfaen',
                                                  color: Colors.black,
                                                  height: 1.35,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          '${(_userEventData['totalCompleted'] != 0 ? (5 * _userEventData['totalCorrect'] / _userEventData['totalCompleted']) : 0).toStringAsFixed(2)}'),
                                                  TextSpan(
                                                    text: '/5',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 7),
                                        padding: EdgeInsets.only(left: 9, right: 9),
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 238, 238, 238),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Best Rank',
                                              style: TextStyle(
                                                fontSize: _labelFontSize,
                                                fontFamily: 'Microsoft',
                                                color: Colors.black,
                                                height: 1.1,
                                              ),
                                            ),
                                            Text(
                                              '${_userEventData['bestRank']}',
                                              style: TextStyle(
                                                fontSize: _valueFontSize,
                                                fontFamily: 'Sylfaen',
                                                color: Colors.black,
                                                height: 1.35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 7),
                                        padding: EdgeInsets.only(left: 9, right: 9),
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 238, 238, 238),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Current Rank',
                                              style: TextStyle(
                                                fontSize: _labelFontSize,
                                                fontFamily: 'Microsoft',
                                                color: Colors.black,
                                                height: 1.1,
                                              ),
                                            ),
                                            Text(
                                              '${_userEventData['currentRank']}',
                                              style: TextStyle(
                                                fontSize: _valueFontSize,
                                                fontFamily: 'Sylfaen',
                                                color: Colors.black,
                                                height: 1.35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Color.fromARGB(255, 112, 112, 112),
                                  thickness: 1,
                                  endIndent: width * 0.15,
                                  indent: width * 0.15,
                                  height: 20,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: width * 0.15, right: width * 0.15),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) {
                                                    return AccountEditScreen();
                                                  },
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.settings),
                                            label: Text(
                                              'Edit Profile',
                                              style: TextStyle(
                                                fontFamily: 'AgencyFB',
                                                fontSize: 20,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: StadiumBorder(),
                                              primary: Color.fromARGB(255, 0, 136, 145),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              initConnectivity().then((value) async {
                                                if (_connectionStatus == 'ConnectivityResult.wifi' ||
                                                    _connectionStatus ==
                                                        'ConnectivityResult.mobile') {
                                                  final auth = FirebaseAuth.instance;
                                                  if (auth.currentUser.providerData[0].providerId ==
                                                      'google.com') {
                                                    final googleSignIn = GoogleSignIn();
                                                    await googleSignIn.disconnect();
                                                  } else if (auth.currentUser.providerData[0].providerId ==
                                                      'facebook.com') {
                                                    await FacebookAuth.instance.logOut();
                                                    print('Facebook Logged Out');
                                                  }
                                                  auth.signOut();
                                                  final SharedPreferences sharedPreferences =
                                                      await SharedPreferences.getInstance();
                                                  sharedPreferences.remove('userId');
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) {
                                                        return LogOutSplashScreen();
                                                      },
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                            icon: Icon(Icons.logout),
                                            label: Text(
                                              'Logout',
                                              style: TextStyle(
                                                fontFamily: 'AgencyFB',
                                                fontSize: 20,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: StadiumBorder(),
                                              primary: Color.fromARGB(255, 0, 136, 145),
                                            ),
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
                      ),
                    )
                  : EventLoading()
              : Center(
                  child: NetworkError(Colors.white),
                ),
        ],
      ),
    );
  }
}

class DetailContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    var path = Path();

    canvas.drawShadow(
      Path.combine(
        PathOperation.difference,
        path
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, size.width, size.height),
              Radius.circular(28),
            ),
          ),
        Path()
          ..addOval(
            Rect.fromCenter(
              center: Offset(size.width * 0.5, 0),
              width: 150,
              height: 150,
            ),
          ),
      ),
      Colors.grey.shade700,
      3,
      true,
    );
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        path
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTRB(size.width, 0, 0, size.height),
              Radius.circular(28),
            ),
          ),
        Path()
          ..addOval(
            Rect.fromCenter(
              center: Offset(size.width * 0.5, 0),
              width: 160,
              height: 160,
            ),
          ),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BackContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color.fromARGB(255, 0, 136, 145);
    paint.style = PaintingStyle.fill;
    var path = Path();

    path.moveTo(0, size.height * 0.2);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.42);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
