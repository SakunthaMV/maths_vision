import 'package:firebase_auth/firebase_auth.dart';
import 'package:maths_vision/Utilities/validation_patterns.dart';

String nameValidator(String text, String name) {
  if (text.isEmpty) {
    return 'Enter Your $name';
  } else if (text.length < 3) {
    return 'Enter a Valid $name';
  }
  return null;
}

String emailValidator(String text) {
  if (text.isEmpty) {
    return 'Enter Your Email Address';
  } else if (!emailValidity(text)) {
    return 'Enter a Valid Email Address';
  }
  return null;
}

String phoneValidator(String text) {
  if (text.isEmpty) {
    return null;
  } else if (!phoneValidity(text)) {
    return 'Enter a Valid Phone Number';
  }
  return null;
}

String createPasswordValidator(String password) {
  if (password.isEmpty) {
    return 'Enter Your New Password';
  } else if (password.length < 8) {
    return 'Password Must Have at Least 8 Characters';
  } else if (!RegExp(r'\d').hasMatch(password)) {
    return 'Password Must have at Least One Number';
  } else if (!RegExp(r'[a-z]').hasMatch(password)) {
    return 'Password Must Have at Least One Letter';
  } else if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
    return 'Password Must Have at Least One Special Character';
  }
  return null;
}

String confirmPasswordValidator(String password, String createdPassword) {
  if (password.isEmpty) {
    return 'Re-Enter Your New Password';
  } else if (password != createdPassword) {
    return 'Your Password Does Not Match';
  }
  return null;
}

String previousPasswordValidator(String password, User user) {
  if (password.isEmpty) {
    return 'Enter Your Old Password';
  }
  return null;
}
