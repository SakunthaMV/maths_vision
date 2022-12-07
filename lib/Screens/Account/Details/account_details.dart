import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Screens/Account/Edit/account_edit_screen.dart';
import 'package:maths_vision/Screens/Splashes/log_out_splash_screen.dart';
import 'package:maths_vision/Widgets/Main_App_Bar/home_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common_Widgets/profile_picture.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
      backgroundColor: Color.fromARGB(255, 183, 183, 183),
      appBar: HomeAppBar(page: 'Account'),
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
          SingleChildScrollView(
            padding: EdgeInsets.only(top: width * 0.05),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                ProfilePicture(user.uid),
                Container(
                  width: width * 0.85,
                  height: 470,
                  margin: EdgeInsets.only(top: 70),
                  child: CustomPaint(
                    painter: DetailContainer(),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 90.0,
                        left: width * 0.05,
                        right: width * 0.05,
                      ),
                      child: _accountBody(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountBody() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return LoadingAnimationWidget.threeArchedCircle(
            color: Colors.black,
            size: 100.0,
          );
        }
        final String name = '${userSnapshot.data['User_Details.firstName']}'
            ' ${userSnapshot.data['User_Details.lastName']}';
        final String email = '${userSnapshot.data['User_Details.email']}';
        final int xp = userSnapshot.data['User_Details.xp'];
        final int currentRank = userSnapshot.data['User_Details.currentRank'];
        final int bestRank = userSnapshot.data['User_Details.bestRank'];
        return Column(
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.bold,
                height: 1,
                color: Colors.black,
              ),
            ),
            Text(
              email,
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
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user.uid)
                    .collection('Trigonometry_Event')
                    .doc('Event_Info')
                    .snapshots(),
                builder: (context, eventSnapshot) {
                  if (!eventSnapshot.hasData) {
                    return LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.black,
                      size: 100.0,
                    );
                  }
                  final double progress =
                      double.parse((eventSnapshot.data['progress']).toStringAsFixed(1));
                  final int completed = eventSnapshot.data['totalCompleted'];
                  final int correct = eventSnapshot.data['totalCorrect'];
                  final double accuracy = double.parse(
                      (completed != 0 ? (100 * correct / completed) : 0).toStringAsFixed(1));
                  final double probability = double.parse(
                      (completed != 0 ? (5 * correct / completed) : 0).toStringAsFixed(2));
                  return Column(
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
                      _detailRow('XP Earned', xp),
                      _detailRow('Completed', progress, sub: ' %'),
                      _detailRow('Accuracy', accuracy, sub: ' %'),
                      _detailRow('Probability', probability, sub: '/5'),
                      _detailRow('Best Rank', bestRank),
                      _detailRow('Current Rank', currentRank),
                    ],
                  );
                },
              ),
            ),
            Divider(
              color: Color.fromARGB(255, 112, 112, 112),
              thickness: 1,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _bottomButtons(Icons.settings, 'Edit Profile', _editProfileFunction),
                    _bottomButtons(Icons.logout, 'Logout', _logoutFunction),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _bottomButtons(IconData icon, String name, Function function) {
    return SizedBox(
      width: 150,
      child: ElevatedButton.icon(
        onPressed: function,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        label: Text(
          name,
          style: TextStyle(
            fontFamily: 'AgencyFB',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          backgroundColor: Color.fromARGB(255, 0, 136, 145),
        ),
      ),
    );
  }

  void _editProfileFunction() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return AccountEditScreen();
        },
      ),
    );
  }

  void _logoutFunction() async {
    if (_hasConnection ?? false) {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser.providerData[0].providerId == 'google.com') {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.disconnect();
      } else if (auth.currentUser.providerData[0].providerId == 'facebook.com') {
        await FacebookAuth.instance.logOut();
      }
      auth.signOut();
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.remove('userId');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return LogOutSplashScreen();
          },
        ),
      );
    }
  }

  Widget _detailRow(String rowTopic, var value, {String sub}) {
    final TextStyle style = TextStyle(
      fontSize: 19,
      fontFamily: 'Sylfaen',
      color: Colors.black,
      height: 1.5,
    );
    return Container(
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
            rowTopic,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Microsoft',
              color: Colors.black,
              height: 1.1,
            ),
          ),
          Builder(builder: (context) {
            if (sub != null) {
              return RichText(
                text: TextSpan(
                  style: style,
                  children: [
                    TextSpan(
                      text: '$value',
                    ),
                    TextSpan(
                      text: sub,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              );
            }
            return Text(
              '$value',
              style: style,
            );
          }),
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
