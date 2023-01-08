import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final CollectionReference users = FirebaseFirestore.instance.collection('Users');
final CollectionReference events = FirebaseFirestore.instance.collection('Events');

Future<void> initializeUser(
  String uid,
  String firstName,
  String lastName,
  String dateOfBirth,
  String gender,
  String email,
  String phoneNumber, {
  String photoURL,
  String signUpMethod,
}) async {
  return await users.doc(uid).set({
    'User_Details': {
      'userId': uid,
      'signUpWith': signUpMethod?? 'Email and Password',
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'email': email,
      'phoneNumber': phoneNumber?? '0110000000',
      'photoURL': photoURL?? 'No Image',
    },
  }, SetOptions(merge: true));
}

Future<void> removeUserDate(User user) async {
  for (int i = 1; i < 11; i++) {
    events.doc('Trigonometry').collection('Stages').doc('Stage_$i').update({
      'TotalUnlocked': FieldValue.increment(-1),
    });
    events
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Stage_$i')
        .collection('Questions')
        .doc('Question_1')
        .update({
      'Unlocked': FieldValue.increment(-1),
    });
  }
  events.doc('Trigonometry').update({
    'TotalUnlocked': FieldValue.increment(-10),
  });
  events.doc('All_Events').update({
    'AllUnlocked': FieldValue.increment(-10),
  });
  return await users.doc(user.uid).delete();
}

// Future<void> createEvent() async {
//   List questionIcons = [
//     'Alpha',
//     'Beta',
//     'Gamma',
//     'Delta',
//     'Epsilon',
//     'Lambda',
//     'Mu',
//     'Tau',
//     'Phi',
//     'Psi',
//   ];
//   CollectionReference eventsInfo = FirebaseFirestore.instance.collection('Test_Events');
//   CollectionReference stagesInfo = FirebaseFirestore.instance
//       .collection('Test_Events')
//       .doc('Trigonometry')
//       .collection('Stages');
//   await eventsInfo.doc('All_Events').set({
//     'AllCompleted': 0,
//     'AllCorrect': 0,
//     'AllXPDoubleUsed': 0,
//     'AllAnswersBought': 0,
//     'AllUnlocked': 0,
//     'Golden_Stages': {
//       'AllCompleted': 0,
//       'AllCorrect': 0,
//       'AllGoldenDoubleXPUsed': 0,
//       'AllStageUnlocks': 0,
//       'AllStepOneBought': 0,
//       'AllStepOneCompleted': 0,
//       'AllStepOneCorrect': 0,
//       'AllStepTwoBought': 0,
//       'AllStepTwoCompleted': 0,
//       'AllStepTwoCorrect': 0,
//       'AllTimeElapsed': 0,
//       'AllUnlocked': 0,
//     }
//   });
//   await eventsInfo.doc('Trigonometry').set({
//     'TotalCompleted': 0,
//     'TotalCorrect': 0,
//     'TotalXPDoubleUsed': 0,
//     'TotalAnswersBought': 0,
//     'TotalUnlocked': 0,
//     'Event': 'Trigonometry Event',
//   });
//   await stagesInfo.doc('Golden_Stage').set({
//     'Stage_Info': {
//       'TotalCompleted': 0,
//       'TotalCorrect': 0,
//       'TotalGoldenDoubleXPUsed': 0,
//       'TotalStageUnlocks': 0,
//       'TotalStepOneBought': 0,
//       'TotalStepOneCompleted': 0,
//       'TotalStepOneCorrect': 0,
//       'TotalStepTwoBought': 0,
//       'TotalStepTwoCompleted': 0,
//       'TotalStepTwoCorrect': 0,
//       'TotalTimeElapsed': 0,
//       'TotalUnlocked': 0,
//     }
//   });
//   for (int i = 0; i < questionIcons.length; i++) {
//     await stagesInfo.doc('Golden_Stage').set(
//       {
//         'Questions_Info': {
//           'Question_${questionIcons[i]}': {
//             'BestTiming': {
//               'Time': 86400000,
//               'UserID': null,
//             },
//             'Completed': 0,
//             'Correct': 0,
//             'GoldenDoubleXPUsed': 0,
//             'StepOneBought': 0,
//             'StepOneCompleted': 0,
//             'StepOneCorrect': 0,
//             'StepTwoBought': 0,
//             'StepTwoCompleted': 0,
//             'StepTwoCorrect': 0,
//             'TimeElapsed': 0,
//             'Unlocked': 0,
//           }
//         }
//       },
//       SetOptions(merge: true),
//     );
//   }
//   for (int i = 1; i <= 10; i++) {
//     await stagesInfo.doc('Stage_$i').set({
//       'TotalCompleted': 0,
//       'TotalCorrect': 0,
//       'TotalXPDoubleUsed': 0,
//       'TotalAnswersBought': 0,
//       'TotalUnlocked': 0,
//       'Stage': i,
//       'Video': {
//         'LikeCount': 0,
//         'CommentCount': 0,
//         'PurchaseCount': 0,
//         'Comments': null,
//       },
//     });
//     for (int j = 1; j <= questions['stage$i'].length; j++) {
//       await stagesInfo.doc('Stage_$i').collection('Questions').doc('Question_$j').set({
//         'Completed': 0,
//         'Correct': 0,
//         'XPDoubleUsed': 0,
//         'AnswersBought': 0,
//         'Question': j,
//         'Unlocked': 0,
//       });
//     }
//   }
// }