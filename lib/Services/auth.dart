import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<AuthCredential> authCredential(User user, {String password}) async {
  AuthCredential cred;
  if(user.providerData[0].providerId=='google.com'){
    final GoogleSignInAccount userGoogle = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await userGoogle.authentication;
    cred = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  } else if(user.providerData[0].providerId == 'facebook.com'){
    final LoginResult result = await FacebookAuth.instance.login();
    AccessToken facebookAuth = result.accessToken;
    cred = FacebookAuthProvider.credential(facebookAuth.token);
  } else {
    cred = EmailAuthProvider.credential(
      email: user.email,
      password: password,
    );
  }
  return cred;
}