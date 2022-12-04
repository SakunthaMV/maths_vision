import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FacebookSignInProvider extends ChangeNotifier {
  Map<String,dynamic> _userData;
  AccessToken _accessToken;

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
    final LoginResult result = await FacebookAuth.instance.login();
    isSigningIn = true;

    switch (result.status) {
      case LoginStatus.success:
        _accessToken = result.accessToken;
        final userData = await FacebookAuth.instance.getUserData();
        _userData = userData;
        final AuthCredential credential = FacebookAuthProvider.credential(_accessToken.token);
        final UserCredential resultUser = await FirebaseAuth.instance.signInWithCredential(credential);
        User userFireStore = resultUser.user;

        isSigningIn = false;
        String name = _userData['name'];
        String firstName = name.split(' ')[0];
        String lastName = name.split(' ')[1];
        print(_userData);

        users.doc(userFireStore.uid).get().then((doc) {
          if (!doc.exists) {
            users.doc(userFireStore.uid).set({
              'User_Details': {
                'userId': userFireStore.uid,
                'signUpWith': 'Facebook',
                'completePercentage': 0.0,
                'firstName': firstName,
                'lastName': lastName,
                'dateOfBirth': null,
                'gender': null,
                'email': _userData['email'],
                'phoneNumber': null,
                'photoURL': _userData['picture']['data']['url'],
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
      case LoginStatus.cancelled:
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
      case LoginStatus.failed:
        isSigningIn = false;
        Fluttertoast.showToast(
          msg:
              'Something went wrong with the login process.\nHere is the error Facebook gave us: \'userFacebook.errorMessage\'',
          timeInSecForIosWeb: 3,
          gravity: ToastGravity.TOP,
          fontSize: 17,
          backgroundColor: Color.fromARGB(255, 34, 34, 47),
          textColor: Colors.white,
        );
        break;
      case LoginStatus.operationInProgress:
        break;
    }
  }
}
