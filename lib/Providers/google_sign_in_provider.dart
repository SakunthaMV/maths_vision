import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:maths_vision/Services/firestore_userdata.dart';

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

  Future<void> login() async {
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

      final UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = result.user;
      isSigningIn = false;

      await FirebaseFirestore.instance.collection('Users').doc(user.uid).get().then((doc) {
        if (!doc.exists) {
          final List names = userGoogle.displayName.split(' ');
          initializeUser(
            user.uid,
            names[0],
            names[1],
            DateTime.now().toString(),
            null,
            user.email,
            user.phoneNumber,
            signUpMethod: 'Google',
            photoURL: user.photoURL,
          );
          updateEventData();
        }
      });
    }
  }
}
