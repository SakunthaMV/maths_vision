import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class FacebookSignInProvider extends ChangeNotifier {
  final facebookSignIn = FacebookLogin();

  bool _isSigningIn;

  FacebookSignInProvider() {
    _isSigningIn = false;
  }

  final CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final CollectionReference events = FirebaseFirestore.instance.collection('Events');

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  loginFacebook() async {
    final userFacebook = await facebookSignIn.logIn(['email']);
    isSigningIn = true;

    switch (userFacebook.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken fbToken = userFacebook.accessToken;
        final AuthCredential credential = FacebookAuthProvider.credential(fbToken.token);
        final UserCredential result =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User userFireStore = result.user;

        isSigningIn = false;

        var graphResponse = await http.get(
          Uri.parse(
              'https://graph.facebook.com/${fbToken.userId}?fields=first_name,last_name,birthday,gender,email,picture.height(700)&access_token=${fbToken.token}'),
        );

        var profile = jsonDecode(graphResponse.body);

        users.doc(userFireStore.uid).get().then((doc) {
          if (!doc.exists) {
            users.doc(userFireStore.uid).set({
              'User_Details': {
                'userId': userFireStore.uid,
                'signUpWith': 'Facebook',
                'completePercentage': 0.0,
                'firstName': profile['first_name'],
                'lastName': profile['last_name'],
                'dateOfBirth': profile['birthday'],
                'gender': profile['gender'],
                'email': profile['email'],
                'phoneNumber': null,
                'photoURL': profile['picture']['data']['url'],
                'coins': 50,
                'xp': 0,
                'level': 1,
                'currentRank': 0,
                'bestRank': 0,
                'average_time': 0,
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
          }
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        isSigningIn = false;
        Fluttertoast.showToast(
          msg: 'You have been denied login via Facebook',
          timeInSecForIosWeb: 3,
          gravity: ToastGravity.TOP,
          fontSize: 17,
          backgroundColor: Color.fromARGB(255, 34, 34, 47),
          textColor: Colors.white,
        );
        break;
      case FacebookLoginStatus.error:
        isSigningIn = false;
        Fluttertoast.showToast(
          msg:
              'Something went wrong with the login process.\nHere is the error Facebook gave us: ${userFacebook.errorMessage}',
          timeInSecForIosWeb: 3,
          gravity: ToastGravity.TOP,
          fontSize: 17,
          backgroundColor: Color.fromARGB(255, 34, 34, 47),
          textColor: Colors.white,
        );
        break;
    }
  }
}
