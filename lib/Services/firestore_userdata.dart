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
        '1': false,
        '2': false,
        '3': false,
        '4': false,
        '5': false,
        '6': false,
        '7': false,
      },
    },
    'Collection': {
      'Coupons': {
        'Answer_Coupons': {},
        'Video_Coupons': {},
      },
      'Double_XP_Cards': {
        'Silver_Double_XP': {
          'available': 0,
          'used': 0,
        },
        'Golden_Double_XP': {
          'available': 0,
          'used': 0,
        },
      },
      'Vouchers': {
        'Answer_Vouchers': {
          'available': 0,
          'used': 0,
        },
        'Video_Vouchers': {
          'available': 0,
          'used': 0,
        },
      },
      'Bonus_Cards': {
        'available': 0,
        'used': 0,
      },
    },
  });
}

void initializeUserEvent(String userId) async {
  if (userId != null) {
    await users
        .doc(userId)
        .collection('Trigonometry_Event')
        .doc('Golden_Stage')
        .get()
        .then((doc) {
      if (!doc.exists) {
        users.doc(userId).collection('Trigonometry_Event').doc('Golden_Stage').set({
          'Entry_Tasks': {
            'accuracyTask': false,
            'leaderboardTask': false,
            'loginTask': false,
            'rulesDialog': false,
          },
          'Stage_Info': {
            'completed': 0,
            'correct': 0,
            'xpEarned': 0,
          },
        });
      }
    });
    await users
        .doc(userId)
        .collection('Trigonometry_Event')
        .doc('Event_Info')
        .get()
        .then((doc) {
      if (!doc.exists) {
        users.doc(userId).collection('Trigonometry_Event').doc('Event_Info').set({
          'progress': 0.0,
          'totalCompleted': 0,
          'totalCorrect': 0,
          'xpEarned': 0,
          'currentRank': 0,
          'bestRank': 0,
          'goldenStageUnlocked': false,
        });
      }
    });
    await users.doc(userId).collection('Trigonometry_Event').doc('Stages').get().then((doc) {
      if (!doc.exists) {
        for (int i = 1; i <= 10; i++) {
          users.doc(userId).collection('Trigonometry_Event').doc('Stages').set({
            'Stage_$i': {
              'Info': {
                'completed': 0,
                'correct': 0,
                'xpEarned': 0,
                'stage': i,
                'Video': {
                  'purchased': false,
                  'liked': false,
                  'commented': false,
                }
              },
              'Questions_Details': {
                'Question_1': {
                  'correct': false,
                  'done': false,
                  'xpDoubleUsed': false,
                  'answerBought': false,
                  'question': 1,
                  'selectedValue': '',
                }
              }
            }
          }, SetOptions(merge: true));
        }
      }
    });
  }
}

void updateEventData() {
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
