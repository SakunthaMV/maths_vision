import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maths_vision/Log_In/email_verification.dart';
import 'package:maths_vision/Log_In/facebook_sign_in_provider.dart';
import 'package:maths_vision/Log_In/forgot_password.dart';
import 'package:maths_vision/Splash_Screens/log_in_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up_screen.dart';
import 'google_sign_in_provider.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final logInFormKey = GlobalKey<FormState>();

  String _email;
  String _password;

  bool _emailTapped = false;
  bool _passwordTapped = false;
  bool _passwordInvisible = true;

  double _formContainerHeight = 320.0;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  int _emailAddressCount = 0;
  int _passwordCount = 0;

  final auth = FirebaseAuth.instance;

  Future<void> sharedPreferenceSaver(userId) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('userId', userId);
  }

  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (context) {
            return GoogleSignInProvider();
          },
        ),
        ChangeNotifierProvider<FacebookSignInProvider>(
          create: (context) {
            return FacebookSignInProvider();
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 136, 145),
        body: StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final googleProvider = Provider.of<GoogleSignInProvider>(context);
            final facebookProvider = Provider.of<FacebookSignInProvider>(context);
            final user = FirebaseAuth.instance.currentUser;
            if (googleProvider.isSigningIn || facebookProvider.isSigningIn) {
              return Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 7,
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              sharedPreferenceSaver(user.uid);
              if (user.providerData[0].providerId == 'google.com' ||
                  user.providerData[0].providerId == 'facebook.com' ||
                  user.emailVerified) {
                return LogInSplashScreen();
              } else {
                return EmailVerification();
              }
            } else {
              return Stack(
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
                            padding: const EdgeInsets.only(top: 45),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/HomeButton.jpg',
                                  width: 170,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              'Welcome To',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.grey.shade900,
                                    blurRadius: 1,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(
                              'MATHS VISION',
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Roboto Regular',
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(
                                    color: Colors.grey.shade900,
                                    blurRadius: 1,
                                    offset: Offset(1, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Opacity(
                                opacity: 0.0,
                                child: Container(
                                  width: size.width * 0.8,
                                  height: _formContainerHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Positioned(
                                width: size.width * 0.8,
                                height: _formContainerHeight,
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
                              Form(
                                key: logInFormKey,
                                child: Column(
                                  children: [
                                    Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontFamily: 'Cambria',
                                        fontSize: 30,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.5),
                                            blurRadius: 1,
                                            offset: Offset(1, 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.67,
                                      padding: EdgeInsets.only(top: 15),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _emailController,
                                        onTap: () {
                                          setState(() {
                                            _emailTapped = true;
                                          });
                                        },
                                        onFieldSubmitted: (text) {
                                          setState(() {
                                            _emailTapped = false;
                                            FocusScope.of(context).nextFocus();
                                          });
                                        },
                                        onChanged: (text) {
                                          setState(() {
                                            _email = text.trim();
                                          });
                                        },
                                        validator: (text) {
                                          final emailPattern =
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                          final regExp = RegExp(emailPattern);
                                          if (!regExp.hasMatch(text)) {
                                            if (_emailAddressCount < 1) {
                                              setState(() {
                                                _formContainerHeight =
                                                    _formContainerHeight + 24.0;
                                                _emailAddressCount += 1;
                                              });
                                            }
                                          } else {
                                            if (_formContainerHeight != 300.0) {
                                              if (_emailAddressCount == 1) {
                                                setState(() {
                                                  _formContainerHeight =
                                                      _formContainerHeight - 24.0;
                                                  _emailAddressCount = 0;
                                                });
                                              }
                                            }
                                          }
                                          if (text.isEmpty) {
                                            return 'Enter Your Email Address';
                                          } else if (!regExp.hasMatch(text)) {
                                            return 'Enter a Valid Email Address';
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.emailAddress,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'Open Sans',
                                          color: Colors.white,
                                        ),
                                        cursorColor: Color.fromARGB(255, 45, 45, 45),
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(255, 255, 51, 51),
                                            ),
                                          ),
                                          errorStyle: TextStyle(
                                            color: Color.fromARGB(255, 234, 234, 234),
                                            fontSize: 13,
                                            fontFamily: 'Philosopher',
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(1),
                                                blurRadius: 4,
                                                offset: Offset(1.5, 1.5),
                                              ),
                                            ],
                                          ),
                                          contentPadding: EdgeInsets.only(
                                            bottom: 0,
                                            top: 0,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          labelText: 'Email',
                                          labelStyle: TextStyle(
                                            fontSize: 23,
                                            color: Colors.white,
                                            fontFamily: 'Roboto Regular',
                                            letterSpacing: 1,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(1),
                                                blurRadius: 4,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          suffixIcon: _emailTapped
                                              ? IconButton(
                                                  color: Color.fromARGB(255, 45, 45, 45),
                                                  splashRadius: 1,
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    setState(() {
                                                      _emailController.text = '';
                                                    });
                                                  },
                                                )
                                              : Icon(
                                                  Icons.mail_outline,
                                                  color: Color.fromARGB(255, 45, 45, 45),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.67,
                                      padding: EdgeInsets.only(top: 20),
                                      child: TextFormField(
                                        obscureText: _passwordInvisible,
                                        controller: _passwordController,
                                        onTap: () {
                                          _passwordTapped = true;
                                        },
                                        onFieldSubmitted: (text) {
                                          setState(() {
                                            _passwordTapped = false;
                                          });
                                        },
                                        onChanged: (text) {
                                          setState(() {
                                            _passwordTapped = true;
                                            _password = text.trim();
                                          });
                                        },
                                        validator: (text) {
                                          if (text.length < 8) {
                                            if (_passwordCount < 1) {
                                              setState(() {
                                                _formContainerHeight =
                                                    _formContainerHeight + 24.0;
                                                _passwordCount += 1;
                                              });
                                            }
                                          } else {
                                            if (_formContainerHeight != 300.0) {
                                              if (_passwordCount == 1) {
                                                setState(() {
                                                  _formContainerHeight =
                                                      _formContainerHeight - 24.0;
                                                  _passwordCount = 0;
                                                });
                                              }
                                            }
                                          }
                                          if (text.isEmpty) {
                                            return 'Enter Your Password';
                                          } else if (text.length < 8) {
                                            return 'Password must have at least 8 characters';
                                          } else {
                                            return null;
                                          }
                                        },
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'Open Sans',
                                          color: Colors.white,
                                        ),
                                        cursorColor: Color.fromARGB(255, 45, 45, 45),
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(255, 255, 51, 51),
                                            ),
                                          ),
                                          errorStyle: TextStyle(
                                            color: Color.fromARGB(255, 234, 234, 234),
                                            fontSize: 13,
                                            fontFamily: 'Philosopher',
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(1),
                                                blurRadius: 4,
                                                offset: Offset(1.5, 1.5),
                                              ),
                                            ],
                                          ),
                                          contentPadding: EdgeInsets.only(
                                            bottom: 0,
                                            top: 0,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                            fontSize: 23,
                                            color: Colors.white,
                                            fontFamily: 'Roboto Regular',
                                            letterSpacing: 1,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(1),
                                                blurRadius: 4,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          suffixIcon: _passwordTapped
                                              ? GestureDetector(
                                                  child: Icon(
                                                    Icons.remove_red_eye_outlined,
                                                    color:
                                                        Color.fromARGB(255, 45, 45, 45),
                                                  ),
                                                  onTapDown: (tapDetails) {
                                                    setState(() {
                                                      _passwordInvisible =
                                                          !_passwordInvisible;
                                                    });
                                                  },
                                                  onTapUp: (tapDetails) {
                                                    setState(() {
                                                      _passwordInvisible =
                                                          !_passwordInvisible;
                                                    });
                                                  },
                                                )
                                              : Icon(
                                                  Icons.vpn_key_outlined,
                                                  color: Color.fromARGB(255, 45, 45, 45),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.67,
                                      height: 38,
                                      alignment: Alignment.centerRight,
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
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          primary: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      width: 120,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final isValid =
                                              logInFormKey.currentState.validate();
                                          if (isValid) {
                                            try {
                                              await auth.signInWithEmailAndPassword(
                                                  email: _email, password: _password);
                                            } on FirebaseAuthException catch (error) {
                                              Fluttertoast.showToast(
                                                msg: error.message,
                                                timeInSecForIosWeb: 3,
                                                gravity: ToastGravity.TOP,
                                                fontSize: 17,
                                                backgroundColor:
                                                    Color.fromARGB(255, 34, 34, 47),
                                                textColor: Colors.white,
                                              );
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          primary: Colors.white,
                                        ),
                                        child: Text(
                                          'LOG IN',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 90, 90, 90),
                                            fontFamily: 'Open Sans',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.5),
                                                blurRadius: 2,
                                                offset: Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.67,
                                      margin: EdgeInsets.only(left: 7),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Don't Have an Account?",
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Container(
                                            width: 80,
                                            height: 40,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) {
                                                      return SignUpScreen();
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'SIGN UP',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Open Sans',
                                                  color:
                                                      Color.fromARGB(255, 231, 231, 222),
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
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 1.5,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 9, 66, 71),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(0.2, 0.5),
                                      blurRadius: 0.25,
                                      spreadRadius: 0.25,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'SIGN IN WITH',
                                style: TextStyle(
                                  fontFamily: 'Cambria',
                                  fontSize: 20,
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1.5,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 9, 66, 71),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(0.2, 0.5),
                                      blurRadius: 0.25,
                                      spreadRadius: 0.25,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  final facebookProvider =
                                      Provider.of<FacebookSignInProvider>(context,
                                          listen: false);
                                  facebookProvider.loginFacebook();
                                },
                                icon: Image.asset(
                                  'assets/Facebook_Login_Icon.png',
                                ),
                                iconSize: 55,
                                splashRadius: 30,
                                splashColor: Colors.transparent,
                              ),
                              SizedBox(
                                width: size.width * 0.04,
                              ),
                              IconButton(
                                onPressed: () {
                                  final provider = Provider.of<GoogleSignInProvider>(
                                    context,
                                    listen: false,
                                  );
                                  provider.login();
                                },
                                icon: Image.asset('assets/Google_Login_Icon.png'),
                                iconSize: 55,
                                splashRadius: 30,
                                splashColor: Colors.transparent,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
