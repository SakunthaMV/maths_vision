import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> loginDetails(DocumentSnapshot loginData, User user) async {
  DocumentReference time = FirebaseFirestore.instance.collection('Users').doc(user.uid);
  if (DateTime.now().month - loginData['LogIn_Details.month'] == 0) {
    if (DateTime.now().day - loginData['LogIn_Details.day'] == 0) {
      return null;
    } else if (DateTime.now().day - loginData['LogIn_Details.day'] == 1) {
      if (loginData['LogIn_Details.loginDays'] >= 7) {
        await time.update({
          'LogIn_Details.loginDays': 1,
          'LogIn_Details.day': DateTime.now().day,
          'LogIn_Details.Owned_Days': {
            '1': false,
            '2': false,
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
          },
        });
      } else {
        await time.update({
          'LogIn_Details.loginDays': FieldValue.increment(1),
          'LogIn_Details.day': DateTime.now().day,
        });
      }
    } else {
      await time.update({
        'LogIn_Details.loginDays': 1,
        'LogIn_Details.day': DateTime.now().day,
        'LogIn_Details.Owned_Days': {
          '1': false,
          '2': false,
          '3': false,
          '4': false,
          '5': false,
          '6': false,
          '7': false,
        },
      });
    }
  } else if (DateTime.now().month - loginData['LogIn_Details.month'] == 1 ||
      DateTime.now().month - loginData['LogIn_Details.month'] == -11) {
    if (DateTime.now().day == 1) {
      if (loginData['LogIn_Details.loginDays'] >= 7) {
        await time.update({
          'LogIn_Details.loginDays': 1,
          'LogIn_Details.day': DateTime.now().day,
          'LogIn_Details.month': DateTime.now().month,
          'LogIn_Details.Owned_Days': {
            '1': false,
            '2': false,
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
          },
        });
      } else {
        await time.update({
          'LogIn_Details.loginDays': FieldValue.increment(1),
          'LogIn_Details.day': DateTime.now().day,
          'LogIn_Details.month': DateTime.now().month,
        });
      }
    } else {
      await time.update({
        'LogIn_Details.loginDays': 1,
        'LogIn_Details.day': DateTime.now().day,
        'LogIn_Details.month': DateTime.now().month,
        'LogIn_Details.Owned_Days': {
          '1': false,
          '2': false,
          '3': false,
          '4': false,
          '5': false,
          '6': false,
          '7': false,
        },
      });
    }
  } else {
    await time.update({
      'LogIn_Details.loginDays': 1,
      'LogIn_Details.day': DateTime.now().day,
      'LogIn_Details.month': DateTime.now().month,
      'LogIn_Details.Owned_Days': {
        '1': false,
        '2': false,
        '3': false,
        '4': false,
        '5': false,
        '6': false,
        '7': false,
      },
    });
  }
}