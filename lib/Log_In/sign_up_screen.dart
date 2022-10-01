import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maths_vision/Log_In/log_in_screen.dart';
import 'package:maths_vision/Splash_Screens/log_in_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'facebook_sign_in_provider.dart';
import 'google_sign_in_provider.dart';
import 'package:maths_vision/Log_In/email_verification.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final signUpFormKey = GlobalKey<FormState>();

  bool _createPasswordTapped = false;
  bool _createPasswordInvisible = true;
  bool _conformPasswordTapped = false;
  bool _conformPasswordInvisible = true;

  String _firstName;
  String _lastName;
  String _dateOfBirth;
  var _gender = 'Male';
  String _email;
  String _phoneNumber;
  String _createPassword;
  String _conformPassword;

  double _formContainerHeight = 520.0;
  double _topPadding = 8.0;

  int _firstNameCount = 0;
  int _lastNameCount = 0;
  int _emailAddressCount = 0;
  int _phoneNumberCount = 0;
  int _createPasswordCount = 0;
  int _conformPasswordCount = 0;

  final auth = FirebaseAuth.instance;

  final CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final CollectionReference events = FirebaseFirestore.instance.collection('Events');

  Future signUpUserData(
    String uid,
    String firstName,
    String lastName,
    String dateOfBirth,
    String gender,
    String email,
    String phoneNumber,
  ) async {
    return await users.doc(uid).set({
      'User_Details': {
        'userId': uid,
        'signUpWith': 'Email and Password',
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'email': email,
        'phoneNumber': phoneNumber,
        'photoURL': null,
        'coins': 50,
        'xp': 0,
        'level': 1,
        'currentRank': 0,
        'bestRank': 0,
        'average_time':0,
      },
      'LogIn_Details': {
        'day': DateTime.now().day,
        'month': DateTime.now().month,
        'loginDays': 1,
        'Owned_Days': {
          '1':false,
          '2':false,
          '3':false,
          '4':false,
          '5':false,
          '6':false,
          '7':false,
        },
      },
      'Collection': {
        'Coupons': {
          'Answer_Coupons': {},
          'Video_Coupons': {},
        },
        'Double_XP_Cards': {
          'Silver_Double_XP': {
            'available':0,
            'used':0,
          },
          'Golden_Double_XP': {
            'available':0,
            'used':0,
          },
        },
        'Vouchers': {
          'Answer_Vouchers': {
            'available':0,
            'used':0,
          },
          'Video_Vouchers': {
            'available':0,
            'used':0,
          },
        },
        'Bonus_Cards': {
          'available':0,
          'used':0,
        },
      },
    });
  }

  Future<void> sharedPreferenceSaver(userId) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('userId', userId);
  }

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
            final provider = Provider.of<GoogleSignInProvider>(context);
            final user = FirebaseAuth.instance.currentUser;
            if (provider.isSigningIn) {
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
              for (int i = 1; i < 11; i++) {
                events.doc('Trigonometry').collection('Stages').doc('Stage_$i').update({
                  'TotalUnlocked': FieldValue.increment(1),
                });
                events
                    .doc('Trigonometry')
                    .collection('Stages')
                    .doc('Stage_$i')
                    .collection('Questions')
                    .doc('Question_1')
                    .update({
                  'Unlocked': FieldValue.increment(1),
                });
              }
              events.doc('Trigonometry').update({
                'TotalUnlocked': FieldValue.increment(10),
              });
              events.doc('All_Events').update({
                'AllUnlocked': FieldValue.increment(10),
              });
              if (user.providerData[0].providerId == 'google.com' ||
                  user.providerData[0].providerId == 'facebook.com') {
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
                            height: 15,
                          ),
                          Stack(
                            alignment: AlignmentDirectional.topCenter,
                            children: [
                              Opacity(
                                opacity: 0.0,
                                child: Container(
                                  width: size.width * 0.85,
                                  height: _formContainerHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Positioned(
                                width: size.width * 0.85,
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
                                key: signUpFormKey,
                                child: Column(
                                  children: [
                                    Container(
                                      width: size.width * 0.7,
                                      padding: EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        validator: (text) {
                                          if (text.length < 3) {
                                            if (_firstNameCount < 1) {
                                              setState(() {
                                                _formContainerHeight =
                                                    _formContainerHeight + 24.0;
                                                _firstNameCount += 1;
                                              });
                                            }
                                          } else {
                                            if (_formContainerHeight != 520.0) {
                                              if (_firstNameCount == 1) {
                                                setState(() {
                                                  _formContainerHeight =
                                                      _formContainerHeight - 24.0;
                                                  _firstNameCount = 0;
                                                });
                                              }
                                            }
                                            setState(() {
                                              _firstName = text.trim();
                                            });
                                          }
                                          if (text.isEmpty) {
                                            return 'Enter Your First Name';
                                          } else if (text.length < 3) {
                                            return 'Enter a Valid First Name';
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.name,
                                        style: TextStyle(
                                          fontSize: 20,
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
                                            fontSize: 15,
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
                                            bottom: 3,
                                            top: 0,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          labelText: 'First Name',
                                          labelStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'Roboto Regular',
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: 1,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(.6),
                                                blurRadius: 4,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.7,
                                      padding: EdgeInsets.only(top: _topPadding),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        validator: (text) {
                                          if (text.length < 3) {
                                            if (_lastNameCount < 1) {
                                              setState(() {
                                                _formContainerHeight =
                                                    _formContainerHeight + 24.0;
                                                _lastNameCount += 1;
                                              });
                                            }
                                          } else {
                                            if (_formContainerHeight != 520.0) {
                                              if (_lastNameCount == 1) {
                                                setState(() {
                                                  _formContainerHeight =
                                                      _formContainerHeight - 24.0;
                                                  _lastNameCount = 0;
                                                });
                                              }
                                            }
                                            setState(() {
                                              _lastName = text.trim();
                                            });
                                          }
                                          if (text.isEmpty) {
                                            return 'Enter Your Last Name';
                                          } else if (text.length < 3) {
                                            return 'Enter a Valid Last Name';
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.name,
                                        style: TextStyle(
                                          fontSize: 20,
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
                                            fontSize: 15,
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
                                            bottom: 3,
                                            top: 0,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          labelText: 'Last Name',
                                          labelStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'Roboto Regular',
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: 1,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.6),
                                                blurRadius: 4,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.7,
                                      padding: EdgeInsets.only(top: _topPadding),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: size.width * 0.33,
                                            child: DateTimePicker(
                                              type: DateTimePickerType.date,
                                              dateMask: 'dd-MMM-yyyy',
                                              initialValue: DateTime.now().toString(),
                                              firstDate: DateTime(1960),
                                              lastDate: DateTime.now(),
                                              calendarTitle: 'Date of Birth',
                                              confirmText: 'Done',
                                              onChanged: (dob) {
                                                setState(() {
                                                  _dateOfBirth = dob;
                                                });
                                              },
                                              style: TextStyle(
                                                fontSize: 20,
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
                                                contentPadding: EdgeInsets.only(
                                                  bottom: 3,
                                                  top: 0,
                                                ),
                                                labelText: 'Date of Birth',
                                                labelStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontFamily: 'Roboto Regular',
                                                  fontStyle: FontStyle.italic,
                                                  letterSpacing: 1,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black.withOpacity(0.6),
                                                      blurRadius: 4,
                                                      offset: Offset(2, 2),
                                                    ),
                                                  ],
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: size.width * 0.25,
                                            child: DropdownButtonFormField(
                                              icon: Icon(
                                                Icons.wc,
                                                color: Color.fromARGB(255, 45, 45, 45),
                                              ),
                                              focusColor: Colors.blue,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Open Sans',
                                                color: Colors.white,
                                              ),
                                              decoration: InputDecoration(
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                labelText: 'Gender',
                                                labelStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontFamily: 'Roboto Regular',
                                                  fontStyle: FontStyle.italic,
                                                  letterSpacing: 1,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black.withOpacity(0.6),
                                                      blurRadius: 4,
                                                      offset: Offset(2, 2),
                                                    ),
                                                  ],
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                  bottom: 5,
                                                  top: 0,
                                                ),
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  value: 'Male',
                                                  child: Text('Male'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'female',
                                                  child: Text('Female'),
                                                ),
                                              ],
                                              value: _gender,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  this._gender = newValue;
                                                });
                                              },
                                              dropdownColor: Color.fromARGB(255, 34, 34, 47),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.7,
                                      padding: EdgeInsets.only(top: _topPadding),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
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
                                            if (_formContainerHeight != 520.0) {
                                              if (_emailAddressCount == 1) {
                                                setState(() {
                                                  _formContainerHeight =
                                                      _formContainerHeight - 24.0;
                                                  _emailAddressCount = 0;
                                                });
                                              }
                                            }
                                            setState(() {
                                              _email = text.trim();
                                            });
                                          }
                                          if (text.isEmpty) {
                                            return 'Enter an Email Address';
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
                                            fontSize: 15,
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
                                            bottom: 3,
                                            top: 0,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          labelText: 'Email Address',
                                          labelStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'Roboto Regular',
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: 1,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.6),
                                                blurRadius: 4,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.7,
                                      padding: EdgeInsets.only(top: _topPadding),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        validator: (text) {
                                          if (text.length > 0 && text.length < 10) {
                                            if (_phoneNumberCount < 1) {
                                              setState(() {
                                                _formContainerHeight =
                                                    _formContainerHeight + 24.0;
                                                _phoneNumberCount += 1;
                                              });
                                            }
                                          } else {
                                            if (_formContainerHeight != 520.0) {
                                              if (_phoneNumberCount == 1) {
                                                setState(() {
                                                  _formContainerHeight =
                                                      _formContainerHeight - 24.0;
                                                  _phoneNumberCount = 0;
                                                });
                                              }
                                            }
                                            setState(() {
                                              _phoneNumber = text;
                                            });
                                          }
                                          if (text.isEmpty) {
                                            return null;
                                          } else if (text.length != 10) {
                                            return 'Enter a Valid Phone Number';
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.phone,
                                        style: TextStyle(
                                          fontSize: 20,
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
                                            fontSize: 15,
                                            fontFamily: 'Philosopher',
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(1),
                                                blurRadius: 4,
                                                offset: Offset(1.5, 1.5),
                                              ),
                                            ],
                                          ),
                                          suffixText: 'Optional',
                                          suffixStyle: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Open Sans',
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                          ),
                                          contentPadding: EdgeInsets.only(
                                            bottom: 3,
                                            top: 0,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          labelText: 'Phone Number',
                                          labelStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'Roboto Regular',
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: 1,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.6),
                                                blurRadius: 4,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.7,
                                      padding: EdgeInsets.only(top: _topPadding),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        obscureText: _createPasswordInvisible,
                                        onTap: () {
                                          setState(() {
                                            _createPasswordTapped = true;
                                          });
                                        },
                                        onFieldSubmitted: (text) {
                                          setState(() {
                                            _createPasswordTapped = false;
                                          });
                                        },
                                        onChanged: (text) {
                                          setState(() {
                                            _createPasswordTapped = true;
                                          });
                                        },
                                        validator: (text) {
                                          if (text.length < 8) {
                                            if (_createPasswordCount < 1) {
                                              setState(() {
                                                _formContainerHeight =
                                                    _formContainerHeight + 24.0;
                                                _createPasswordCount += 1;
                                              });
                                            }
                                          } else {
                                            if (_formContainerHeight != 520.0) {
                                              if (_createPasswordCount == 1) {
                                                setState(() {
                                                  _formContainerHeight =
                                                      _formContainerHeight - 24.0;
                                                  _createPasswordCount = 0;
                                                });
                                              }
                                            }
                                            setState(() {
                                              _createPassword = text.trim();
                                            });
                                          }
                                          if (text.isEmpty) {
                                            return 'Enter a New Password';
                                          } else if (text.length < 8) {
                                            return 'Password must have at least 8 characters';
                                          } else {
                                            return null;
                                          }
                                        },
                                        style: TextStyle(
                                          fontSize: 20,
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
                                            fontSize: 15,
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
                                            bottom: 3,
                                            top: 0,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          labelText: 'Create Password',
                                          labelStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'Roboto Regular',
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: 1,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.6),
                                                blurRadius: 4,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          suffixIcon: _createPasswordTapped
                                              ? GestureDetector(
                                                  child: Icon(
                                                    Icons.remove_red_eye_outlined,
                                                    color: Color.fromARGB(255, 45, 45, 45),
                                                  ),
                                                  onTapDown: (tapDetails) {
                                                    setState(() {
                                                      _createPasswordInvisible =
                                                          !_createPasswordInvisible;
                                                    });
                                                  },
                                                  onTapUp: (tapDetails) {
                                                    setState(() {
                                                      _createPasswordInvisible =
                                                          !_createPasswordInvisible;
                                                    });
                                                  },
                                                )
                                              : Container(
                                                  width: 10,
                                                  height: 10,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.7,
                                      padding: EdgeInsets.only(top: _topPadding),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.done,
                                        obscureText: _conformPasswordInvisible,
                                        onTap: () {
                                          setState(() {
                                            _conformPasswordTapped = true;
                                          });
                                        },
                                        onFieldSubmitted: (text) {
                                          setState(() {
                                            _conformPasswordTapped = false;
                                          });
                                        },
                                        onChanged: (text) {
                                          setState(() {
                                            _conformPasswordTapped = true;
                                            _conformPassword = text.trim();
                                          });
                                        },
                                        validator: (text) {
                                          if (text.length < 8) {
                                            if (_conformPasswordCount < 1) {
                                              setState(() {
                                                _formContainerHeight =
                                                    _formContainerHeight + 24.0;
                                                _conformPasswordCount += 1;
                                              });
                                            }
                                          } else {
                                            if (_formContainerHeight != 520.0) {
                                              if (_conformPasswordCount == 1) {
                                                setState(() {
                                                  _formContainerHeight =
                                                      _formContainerHeight - 24.0;
                                                  _conformPasswordCount = 0;
                                                });
                                              }
                                            }
                                          }
                                          if (text.isEmpty) {
                                            return 'Re-Enter New Password';
                                          } else if (text.length < 8) {
                                            return 'Password must have at least 8 characters';
                                          } else if (text != _createPassword) {
                                            return 'Password does not match';
                                          } else {
                                            return null;
                                          }
                                        },
                                        style: TextStyle(
                                          fontSize: 20,
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
                                            fontSize: 15,
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
                                            bottom: 3,
                                            top: 0,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          labelText: 'Confirm Password',
                                          labelStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'Roboto Regular',
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: 1,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.6),
                                                blurRadius: 4,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          suffixIcon: _conformPasswordTapped
                                              ? GestureDetector(
                                                  child: Icon(
                                                    Icons.remove_red_eye_outlined,
                                                    color: Color.fromARGB(255, 45, 45, 45),
                                                  ),
                                                  onTapDown: (tapDetails) {
                                                    setState(() {
                                                      _conformPasswordInvisible =
                                                          !_conformPasswordInvisible;
                                                    });
                                                  },
                                                  onTapUp: (tapDetails) {
                                                    setState(() {
                                                      _conformPasswordInvisible =
                                                          !_conformPasswordInvisible;
                                                    });
                                                  },
                                                )
                                              : Container(
                                                  width: 10,
                                                  height: 10,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      width: 140,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final isValid =
                                              signUpFormKey.currentState.validate();
                                          if (isValid) {
                                            try {
                                              UserCredential result =
                                                  await auth.createUserWithEmailAndPassword(
                                                email: _email,
                                                password: _conformPassword,
                                              );
                                              User user = result.user;
                                              signUpUserData(user.uid, _firstName, _lastName,
                                                  _dateOfBirth, _gender, _email, _phoneNumber);
                                              final SharedPreferences sharedPreferences =
                                                  await SharedPreferences.getInstance();
                                              sharedPreferences.setString('userId', user.uid);
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
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        child: Text(
                                          'SIGN UP',
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
                                      width: size.width * 0.7,
                                      margin: EdgeInsets.only(
                                        left: 13,
                                        top: 3,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Already Have an Account?",
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
                                                      return LogInScreen();
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'LOG IN',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Open Sans',
                                                  color: Color.fromARGB(255, 231, 231, 222),
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
                            height: 15,
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
                                  final facebookProvider = Provider.of<FacebookSignInProvider>(
                                      context,
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
                                  final provider = Provider.of<GoogleSignInProvider>(context,
                                      listen: false);
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
