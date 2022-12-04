import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Account/Sign_Up/sign_up_screen.dart';
import 'package:maths_vision/Screens/Splashes/log_in_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key key}) : super(key: key);

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  bool resendEmail = false;

  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      controller.dispose();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return LogInSplashScreen();
          },
        ),
      );
    }
  }

  Animation rotateAnim;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    user.sendEmailVerification();
    timer = Timer.periodic(
      Duration(seconds: 2),
      (timer) {
        checkEmailVerified();
      },
    );
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    rotateAnim = Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: Colors.black),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 25, 20, 5),
            content: Text(
              'You need to verify your email account to proceed.',
              style: TextStyle(
                height: 1.5,
                fontFamily: 'Rockwell',
                fontSize: 20,
                color: Colors.red,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 1,
                    offset: Offset(0.5, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(
                    height: 1.5,
                    fontFamily: 'Rockwell',
                    fontSize: 16,
                    color: Color.fromARGB(255, 20, 14, 94),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 1,
                        offset: Offset(0.5, 1),
                      ),
                    ],
                  ),
                ),
                onPressed: () => Navigator.pop(c, false),
              ),
              TextButton(
                child: Text(
                  'Back to Sign Up',
                  style: TextStyle(
                    height: 1.5,
                    fontFamily: 'Rockwell',
                    fontSize: 16,
                    color: Color.fromARGB(255, 20, 14, 94),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 1,
                        offset: Offset(0.5, 1),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  timer.cancel();
                  controller.dispose();
                  auth.signOut();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return SignUpScreen();
                      },
                    ),
                  );
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove('userId');
                },
              ),
            ],
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 136, 145),
        body: Stack(
          children: [
            Opacity(
              opacity: 0.1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Log_In_Background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CREATE A',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 4,
                                  offset: Offset(1.5, 1.5),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'MATHS VISION',
                                  style: TextStyle(
                                    fontSize: 31,
                                    fontFamily: 'Roboto Regular',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 4,
                                        offset: Offset(1.5, 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                                TextSpan(
                                  text: ' ACCOUNT',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 4,
                                        offset: Offset(1.5, 1.5),
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
                    SizedBox(
                      height: 30,
                    ),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Opacity(
                          opacity: 0.05,
                          child: Container(
                            width: size.width * 0.85,
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Positioned(
                          width: size.width * 0.85,
                          height: 280,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                              child: Container(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  'VERIFICATION',
                                  style: TextStyle(
                                    fontFamily: 'Cambria',
                                    fontSize: 40,
                                    color: Colors.black,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 2,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 60, right: 60),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'An email has been sent to',
                                      style: TextStyle(
                                        fontFamily: 'Cambria',
                                        fontSize: 22,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.6),
                                            blurRadius: 2,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\n${user.email}\n',
                                      style: TextStyle(
                                        fontFamily: 'Cambria',
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.6),
                                            blurRadius: 2,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\nplease verify.',
                                      style: TextStyle(
                                        fontFamily: 'Cambria',
                                        fontSize: 22,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.6),
                                            blurRadius: 2,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 60, right: 60, top: 25),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Didn't you receive the verification email?",
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 52,
                                right: 60,
                              ),
                              child: Container(
                                height: 35,
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: resendEmail
                                      ? null
                                      : () {
                                          user.sendEmailVerification();
                                          setState(() {
                                            resendEmail = true;
                                          });
                                        },
                                  child: Text(
                                    "Resend Verification Email",
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 188, 188, 172),
                                      shadows: [
                                        Shadow(
                                          blurRadius: 2,
                                          color: Colors.black.withOpacity(0.8),
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: GestureDetector(
                        onTapDown: (tapDetails) {
                          controller.stop();
                        },
                        onTapUp: (tapDetails) {
                          controller.repeat();
                        },
                        child: user.emailVerified != true
                            ? AnimatedBuilder(
                                animation: controller,
                                builder: (context, child) {
                                  return Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..rotateY(2 * pi * rotateAnim.value),
                                    child: Container(
                                      width: 250,
                                      height: 250,
                                      child:
                                          Image.asset('assets/Pending_Verification_Icon.png'),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 250,
                                height: 250,
                                child: Image.asset('assets/Verified_Icon.png'),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
