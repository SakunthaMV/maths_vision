import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  final CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final CollectionReference events = FirebaseFirestore.instance.collection('Events');

  Future login() async {
    isSigningIn = true;

    final userGoogle = await googleSignIn.signIn();

    if (userGoogle == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await userGoogle.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
      User userFireStore = result.user;
      isSigningIn = false;

      users.doc(userFireStore.uid).get().then((doc) {
        if (!doc.exists) {
          List names = userGoogle.displayName.split(' ');
          users.doc(userFireStore.uid).set({
            'User_Details' : {
              'userId': userFireStore.uid,
              'signUpWith': 'Google',
              'firstName': names[0],
              'lastName': names[1],
              'dateOfBirth': null,
              'gender': null,
              'email': userGoogle.email,
              'phoneNumber': userFireStore.phoneNumber,
              'photoURL': userGoogle.photoUrl,
              'coins': 50,
              'xp': 0,
              'level':1,
              'currentRank': 0,
              'bestRank': 0,
              'average_time':0,
            },
            'LogIn_Details':{
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
    }
  }
}
