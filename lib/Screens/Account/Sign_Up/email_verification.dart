import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Account/Common_Widgets/common_background.dart';
import 'package:maths_vision/Screens/Account/Common_Widgets/widgets.dart';
import 'package:maths_vision/Screens/Splashes/log_in_splash_screen.dart';

import '../../../Widgets/Dialogs/will_pop_dialog.dart';
import 'local_widgets.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key key}) : super(key: key);

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  User user;
  bool resendEmail = false;
  Timer _timer;

  Future<void> _checkEmailVerified() async {
    await user.reload();
    user = FirebaseAuth.instance.currentUser;
    if (user.emailVerified) {
      _controller.dispose();
      _timer.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return LogInSplashScreen();
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    user.sendEmailVerification();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _checkEmailVerified();
    });
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme primaryTextTheme = Theme.of(context).primaryTextTheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        return await willPopDialog(
          context,
          'You need to verify your email account to proceed.',
          actions: [
            cancelDialogActions(context, 'OK'),
            cancelDialogActions(context, 'Back to Sign Up'),
          ],
          dismiss: false,
        ).then((value) {
          if (value != false) {
            _controller.dispose();
            _timer.cancel();
          }
          return;
        });
      },
      child: commonScaffold(
        context,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: width * 0.075, vertical: 30.0),
          children: [
            pageTitle(context),
            backgroundContainer(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'VERIFICATION',
                      style: primaryTextTheme.titleLarge.copyWith(
                        fontSize: 40.0,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: FittedBox(
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: primaryTextTheme.titleLarge
                              .copyWith(fontSize: 20, color: colorScheme.primary, height: 1.3),
                          children: [
                            TextSpan(
                              text: 'An email has been sent to',
                            ),
                            TextSpan(
                              text: '\n${user.email}\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
                              ),
                            ),
                            TextSpan(
                              text: 'please verify.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      "Didn't you receive the verification email?",
                      style: textTheme.displayLarge.copyWith(
                        fontSize: 13.0,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  Center(
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
                        style: textTheme.displayLarge.copyWith(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          shadows: [
                            Shadow(
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                if (user.emailVerified) {
                  return FittedBox(
                    child: Icon(
                      Icons.check_circle_outline_outlined,
                      color: colorScheme.onPrimary,
                    ),
                  );
                }
                return AnimatedBuilder(
                  animation: Tween(begin: 0.0, end: 1.0).animate(_controller),
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(2 * pi * _controller.value),
                      child: FittedBox(
                        child: Icon(
                          Icons.help_outline_outlined,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
