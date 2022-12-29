import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maths_vision/Screens/Account/Common_Widgets/common_background.dart';
import 'package:maths_vision/Screens/Account/Common_Widgets/other_signin_options.dart';
import 'package:maths_vision/Screens/Account/Common_Widgets/widgets.dart';
import 'package:maths_vision/Screens/Account/Log_In/log_in_screen.dart';
import 'package:maths_vision/Screens/Splashes/log_in_splash_screen.dart';
import 'package:maths_vision/Services/firestore_userdata.dart';
import 'package:maths_vision/Utilities/validators.dart';
import 'package:maths_vision/Widgets/event_errors_and_loading.dart';
import 'package:maths_vision/Widgets/toast.dart';
import 'package:provider/provider.dart';

import '../../../Providers/facebook_sign_in_provider.dart';
import '../../../Providers/google_sign_in_provider.dart';
import 'package:maths_vision/Screens/Account/Sign_Up/email_verification.dart';

import '../../../Widgets/date_picker.dart';
import '../Common_Widgets/decorations.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final signUpFormKey = GlobalKey<FormState>();

  bool _createPasswordInvisible = true;
  bool _confirmPasswordInvisible = true;

  String _firstName;
  String _lastName;
  DateTime _dateOfBirth = DateTime.now();
  String _gender = 'Male';
  String _email;
  String _phoneNumber;
  String _createPassword;
  String _confirmPassword;
  TextEditingController _dateController;

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
                  user.providerData[0].providerId == 'facebook.com') {
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
    final double width = MediaQuery.of(context).size.width;
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
          final List genderList = ['Male', 'Female'];
          if(_dateController==null){
            _dateController = TextEditingController(
              text: DateFormat('dd-MMM-yyyy').format(DateTime.now()),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 25, bottom: 25),
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                pageTitle(context),
                backgroundContainer(
                  context,
                  child: Form(
                    key: signUpFormKey,
                    child: Column(
                      children: [
                        _rows(context, 'First Name'),
                        _rows(context, 'Last Name'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              width: width * 0.4,
                              child: TextFormField(
                                controller: _dateController,
                                onTap: () async {
                                  _dateOfBirth = await datePicker(context, _dateController);
                                },
                                readOnly: true,
                                style: textTheme.displayLarge.copyWith(
                                  fontSize: 17,
                                  color: colorScheme.primary,
                                ),
                                cursorColor: colorScheme.onPrimary,
                                decoration: inputDeco(context, 'Date of Birth'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              width: width * 0.25,
                              child: DropdownButtonFormField(
                                icon: Icon(
                                  Icons.wc,
                                  color: colorScheme.onSecondary,
                                ),
                                style: textTheme.displayLarge.copyWith(
                                  fontSize: 17,
                                  color: colorScheme.primary,
                                ),
                                decoration: inputDeco(context, 'Gender'),
                                items: List.generate(genderList.length, (index) {
                                  return DropdownMenuItem(
                                    value: genderList[index],
                                    child: Text(genderList[index]),
                                  );
                                }),
                                value: _gender,
                                onChanged: (newValue) {
                                  setState(() {
                                    this._gender = newValue;
                                  });
                                },
                                dropdownColor: colorScheme.background,
                              ),
                            ),
                          ],
                        ),
                        _rows(context, 'Email Address'),
                        _rows(context, 'Phone Number'),
                        _rows(context, 'Create Password'),
                        _rows(context, 'Confirm Password'),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: 120,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              final isValid = signUpFormKey.currentState.validate();
                              if (isValid) {
                                signUpFormKey.currentState.save();
                                try {
                                  UserCredential result = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: _email,
                                    password: _confirmPassword,
                                  );
                                  User user = result.user;
                                  initializeUser(
                                    user.uid,
                                    _firstName,
                                    _lastName,
                                    _dateOfBirth.toString(),
                                    _gender,
                                    _email,
                                    _phoneNumber,
                                  );
                                  updateEventData();
                                  _dateController.dispose();
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
                              'SIGN UP',
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
                                "Already Have an Account?",
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
                                          return LogInScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'LOG IN',
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
                OtherSignInOptions()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _rows(BuildContext context, String rowName) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle style = textTheme.displayLarge.copyWith(
      fontSize: 17,
      color: colorScheme.primary,
    );
    bool password = false;
    TextInputType type;
    TextInputAction action = TextInputAction.next;
    InputDecoration decoration = inputDeco(context, rowName);
    if (rowName.contains('Name')) {
      type = TextInputType.name;
    } else if (rowName.contains('Email')) {
      type = TextInputType.emailAddress;
    } else if (rowName.contains('Phone')) {
      type = TextInputType.phone;
      decoration = inputDeco(context, rowName).copyWith(
        suffixText: 'Optional',
        suffixStyle: style.copyWith(fontSize: 15.0),
      );
    } else if (rowName == 'Create Password') {
      type = TextInputType.visiblePassword;
      password = _createPasswordInvisible;
      decoration = inputDeco(context, rowName).copyWith(
        suffixIcon: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            _createPasswordInvisible = !_createPasswordInvisible;
            setState(() {});
          },
          child: Icon(
            _createPasswordInvisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: colorScheme.primary,
          ),
        ),
      );
    } else if (rowName == 'Confirm Password') {
      action = TextInputAction.done;
      type = TextInputType.visiblePassword;
      password = _confirmPasswordInvisible;
      decoration = inputDeco(context, rowName).copyWith(
        suffixIcon: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            _confirmPasswordInvisible = !_confirmPasswordInvisible;
            setState(() {});
          },
          child: Icon(
            _confirmPasswordInvisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: colorScheme.primary,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        textInputAction: action,
        obscureText: password,
        onSaved: (text) {
          if (rowName == 'First Name') {
            _firstName = text.trim();
          } else if (rowName == 'Last Name') {
            _lastName = text.trim();
          } else if (rowName.contains('Email')) {
            _email = text.trim();
          } else if (rowName.contains('Phone')) {
            _phoneNumber = text.trim();
          } else if (rowName == 'Create Password') {
            _createPassword = text.trim();
          } else if (rowName == 'Confirm Password') {
            _confirmPassword = text.trim();
          }
        },
        onChanged: (text) {
          if (rowName == 'Create Password') {
            _createPassword = text.trim();
          }
        },
        onFieldSubmitted: (text){
          if (rowName == 'Create Password') {
            FocusScope.of(context).nextFocus();
          }
        },
        validator: (text) {
          if (rowName.contains('Name')) {
            return nameValidator(text, rowName);
          } else if (rowName.contains('Email')) {
            return emailValidator(text);
          } else if (rowName.contains('Phone')) {
            return phoneValidator(text);
          } else if (rowName == 'Create Password') {
            return createPasswordValidator(text);
          } else if (rowName == 'Confirm Password') {
            return confirmPasswordValidator(text, _createPassword);
          }
          return null;
        },
        keyboardType: type,
        style: style,
        cursorColor: colorScheme.onPrimary,
        decoration: decoration,
      ),
    );
  }
}
