import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final forgotPasswordKey = GlobalKey<FormState>();

  String _email;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
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
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FIND YOUR',
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
                  height: 40,
                ),
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Opacity(
                      opacity: 0.0,
                      child: Container(
                        width: size.width * 0.85,
                        height: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      width: size.width * 0.85,
                      height: 230,
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
                      key: forgotPasswordKey,
                      child: Column(
                        children: [
                          Text(
                            'Enter Your Email Address',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 2,
                                  offset: Offset(1, 1.5),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: size.width * 0.72,
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              onChanged: (text) {
                                setState(() {
                                  _email = text.trim();
                                });
                              },
                              validator: (text) {
                                final emailPattern =
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                final regExp = RegExp(emailPattern);
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
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                color: Colors.white,
                              ),
                              cursorColor: Color.fromARGB(
                                  255, 45, 45, 45),
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
                                  top: 12,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: 'example@xyz.com',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            width: 170,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                final isValid =
                                    forgotPasswordKey.currentState.validate();
                                if (isValid) {
                                  try {
                                    auth.sendPasswordResetEmail(email: _email);
                                    Fluttertoast.showToast(
                                      msg:
                                          'We just send an email to $_email. Go and check your inbox.',
                                      timeInSecForIosWeb: 3,
                                      gravity: ToastGravity.TOP,
                                      fontSize: 17,
                                      backgroundColor:
                                          Color.fromARGB(255, 34, 34, 47),
                                      textColor: Colors.white,
                                    );
                                    Navigator.of(context).pop();
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
                                'SEND REQUEST',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 90, 90, 90),
                                  fontFamily: 'Open Sans',
                                  fontSize: 18,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
