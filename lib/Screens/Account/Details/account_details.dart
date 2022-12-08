import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Screens/Account/Edit/account_edit_screen.dart';
import 'package:maths_vision/Screens/Splashes/log_out_splash_screen.dart';
import 'package:maths_vision/Widgets/Main_App_Bar/home_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common_Widgets/profile_picture.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onSurface,
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
            physics: BouncingScrollPhysics(),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                ProfilePicture(),
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
                      child: _accountBody(context),
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

  Widget _accountBody(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return LoadingAnimationWidget.threeArchedCircle(
            color: Colors.black,
            size: 100.0,
          );
        }
        final Divider divider = Divider(
          color: colorScheme.onPrimary,
          thickness: 1,
        );
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
              style: textTheme.displayLarge.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            Text(
              email,
              style: textTheme.displaySmall.copyWith(
                fontSize: 10,
                height: 1.2,
                color: Colors.black,
                shadows: [],
              ),
            ),
            divider,
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
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.background,
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
                      _detailRow(context, 'XP Earned', xp),
                      _detailRow(context, 'Completed', progress, sub: ' %'),
                      _detailRow(context, 'Accuracy', accuracy, sub: ' %'),
                      _detailRow(context, 'Probability', probability, sub: '/5'),
                      _detailRow(context, 'Best Rank', bestRank),
                      _detailRow(context, 'Current Rank', currentRank),
                    ],
                  );
                },
              ),
            ),
            divider,
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _bottomButtons(context, Icons.settings, 'Edit Profile'),
                    _bottomButtons(context, Icons.logout, 'Logout'),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _bottomButtons(BuildContext context, IconData icon, String name) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 150,
      child: ElevatedButton.icon(
        onPressed: () {
          if (name == 'Logout') {
            _logoutFunction(context);
          } else {
            _editProfileFunction(context);
          }
        },
        icon: Icon(
          icon,
          color: colorScheme.primary,
        ),
        label: Text(
          name,
          style: textTheme.bodySmall.copyWith(
            fontSize: 20,
            color: colorScheme.primary,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          backgroundColor: colorScheme.background,
        ),
      ),
    );
  }

  void _editProfileFunction(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return AccountEditScreen();
        },
      ),
    );
  }

  void _logoutFunction(BuildContext context) async {
    bool hasConnection = Provider.of<InternetConnectionStatus>(context, listen: false) ==
        InternetConnectionStatus.connected;
    if (hasConnection) {
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

  Widget _detailRow(BuildContext context, String rowTopic, var value, {String sub}) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).primaryTextTheme;
    final TextStyle style = textTheme.headlineSmall.copyWith(height: 1.5);
    return Container(
      margin: EdgeInsets.only(top: 7),
      padding: EdgeInsets.only(left: 9, right: 9),
      height: 25,
      decoration: BoxDecoration(
        color: colorScheme.onTertiary.withOpacity(0.6),
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
              color: colorScheme.onPrimary,
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
