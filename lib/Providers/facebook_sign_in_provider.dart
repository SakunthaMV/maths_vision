import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:maths_vision/Services/firestore_userdata.dart';
import 'package:maths_vision/Widgets/toast.dart';

class FacebookSignInProvider extends ChangeNotifier {
  bool _isSigningIn;

  FacebookSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future<void> login() async {
    isSigningIn = true;
    final LoginResult result = await FacebookAuth.instance.login();
    switch (result.status) {
      case LoginStatus.success:
        final AccessToken accessToken = result.accessToken;
        final Map<String, dynamic> userData = await FacebookAuth.instance.getUserData();
        final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
        final UserCredential resultUser =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User user = resultUser.user;
        isSigningIn = false;
        final List names = userData['name'].split(' ');
        users.doc(user.uid).get().then((doc) {
          if (!doc.exists) {
            initializeUser(
              user.uid,
              names[0],
              names[1],
              DateTime.now().toString(),
              null,
              userData['email'],
              null,
              signUpMethod: 'Facebook',
              photoURL: userData['picture']['data']['url'],
            );
          }
        });
        break;
      case LoginStatus.cancelled:
        isSigningIn = false;
        toast('You have been denied login via Facebook');
        break;
      case LoginStatus.failed:
        isSigningIn = false;
        toast('Something went wrong with the login process.');
        break;
      case LoginStatus.operationInProgress:
        break;
    }
  }
}
