import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maths_vision/Screens/Account/Common_Widgets/widgets.dart';
import 'package:maths_vision/Screens/Account/Sign_Up/email_verification.dart';
import 'package:maths_vision/Providers/facebook_sign_in_provider.dart';
import 'package:maths_vision/Screens/Account/Log_In/forgot_password.dart';
import 'package:maths_vision/Screens/Splashes/log_in_splash_screen.dart';
import 'package:maths_vision/Utilities/check_internet.dart';
import 'package:maths_vision/Utilities/validators.dart';
import 'package:maths_vision/Widgets/event_errors_and_loading.dart';
import 'package:maths_vision/Widgets/toast.dart';
import 'package:provider/provider.dart';
import '../../../Widgets/maths_vision_logo.dart';
import '../Common_Widgets/common_background.dart';
import '../Common_Widgets/decorations.dart';
import '../Common_Widgets/other_signin_options.dart';
import '../Sign_Up/sign_up_screen.dart';
import '../../../Providers/google_sign_in_provider.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final logInFormKey = GlobalKey<FormState>();

  String _email;
  String _password;
  bool _passwordInvisible = true;

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if(user!=null){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              if (user.providerData[0].providerId == 'google.com' ||
                  user.providerData[0].providerId == 'facebook.com' ||
                  user.emailVerified) {
                return LogInSplashScreen();
              } else {
                return EmailVerification();
              }
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return commonScaffold(
      context,
      child: Builder(
        builder: (context) {
          final googleProvider = Provider.of<GoogleSignInProvider>(context);
          final facebookProvider = Provider.of<FacebookSignInProvider>(context);
          User user = FirebaseAuth.instance.currentUser;
          if (googleProvider.isSigningIn || facebookProvider.isSigningIn || user!=null) {
            return EventLoading();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 25, bottom: 25),
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                roundedLogo(context),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 2),
                  child: Text(
                    'Welcome To',
                    style: textTheme.displaySmall.copyWith(
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.7),
                          blurRadius: 1,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'MATHS VISION',
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                backgroundContainer(
                  context,
                  child: Form(
                    key: logInFormKey,
                    child: Column(
                      children: [
                        Text(
                          'Sign In',
                          style: Theme.of(context).primaryTextTheme.titleLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onSaved: (text) {
                              _email = text.trim();
                            },
                            validator: (text) {
                              return emailValidator(text);
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: textTheme.displayLarge.copyWith(
                              fontSize: 17,
                              color: colorScheme.primary,
                            ),
                            cursorColor: colorScheme.onPrimary,
                            decoration: inputDeco(context, 'Email'),
                          ),
                        ),
                        TextFormField(
                          obscureText: _passwordInvisible,
                          onSaved: (text) {
                            _password = text.trim();
                          },
                          validator: (text) {
                            if (text.isEmpty) {
                              return 'Enter Your Password';
                            } else if (text.length < 8) {
                              return 'Password must have at least 8 characters';
                            }
                            return null;
                          },
                          style: textTheme.displayLarge.copyWith(
                            fontSize: 17,
                            color: colorScheme.primary,
                          ),
                          cursorColor: colorScheme.onPrimary,
                          decoration: inputDeco(context, 'Password').copyWith(
                            suffixIcon: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                _passwordInvisible = !_passwordInvisible;
                                setState(() {});
                              },
                              child: Icon(
                                _passwordInvisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 35,
                            margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return ForgotPasswordScreen();
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: textTheme.displayLarge.copyWith(
                                  fontSize: 11.0,
                                  letterSpacing: 0.2,
                                  color: colorScheme.primary,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () async {
                              final bool isValid = logInFormKey.currentState.validate();
                              if (isValid) {
                                logInFormKey.currentState.save();
                                if(!oneTimeCheck(context)){
                                  toast('Please Connect to Internet.');
                                  return;
                                }
                                try {
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: _email,
                                    password: _password,
                                  );
                                } on FirebaseAuthException catch (error) {
                                  toast(error.message);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              backgroundColor: colorScheme.primary,
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              'LOG IN',
                              style: textTheme.displayLarge.copyWith(
                                color: colorScheme.onSecondary,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 1,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't Have an Account?",
                                style: textTheme.displayLarge.copyWith(
                                  color: colorScheme.primary,
                                  fontSize: 15,
                                ),
                              ),
                              Container(
                                height: 35,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return SignUpScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'SIGN UP',
                                    style: textTheme.displayLarge.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onTertiary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                OtherSignInOptions(),
              ],
            ),
          );
        },
      ),
    );
  }
}
