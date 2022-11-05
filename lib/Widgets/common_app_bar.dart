import 'package:flutter/material.dart';

import '../Splash_Screens/went_home_splash_screen.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;

  const CommonAppBar({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title ?? Text(''),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Builder(
        builder: (context) {
          return IconButton(
            iconSize: 30,
            icon: Icon(Icons.menu),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              return Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                color: Colors.grey.shade700,
                blurRadius: 10,
                spreadRadius: -9,
              ),
            ],
          ),
          child: IconButton(
            icon: ClipOval(
              child: Image.asset(
                'assets/HomeButton.jpg',
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) {
                    return WentHomeSplashScreen();
                  },
                ),
              );
            },
            iconSize: 35,
            splashRadius: 25,
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  // void _paperUpdate() {
  //   String subject = "Work, Energy, Power";
  //   int markingHeight = 1364;
  //   int marks = 25;
  //   String yearStr = "2020N";
  //   int paperHeight = 225;
  //
  //   String time = "00:00";
  //   switch (marks) {
  //     case 25:
  //       {
  //         time = "4:30";
  //       }
  //       break;
  //     case 50:
  //       {
  //         time = "9:00";
  //       }
  //       break;
  //     case 55:
  //       {
  //         time = "10:00";
  //       }
  //       break;
  //     case 60:
  //       {
  //         time = "11:00";
  //       }
  //       break;
  //     case 65:
  //       {
  //         time = "12:00";
  //       }
  //       break;
  //     case 70:
  //       {
  //         time = "13:00";
  //       }
  //       break;
  //     case 75:
  //       {
  //         time = "13:30";
  //       }
  //       break;
  //     case 80:
  //       {
  //         time = "14:30";
  //       }
  //       break;
  //     case 85:
  //       {
  //         time = "15:30";
  //       }
  //       break;
  //     case 90:
  //       {
  //         time = "16:30";
  //       }
  //       break;
  //     case 95:
  //       {
  //         time = "17:30";
  //       }
  //       break;
  //     case 100:
  //       {
  //         time = "18:00";
  //       }
  //       break;
  //     case 150:
  //       {
  //         time = "27:00";
  //       }
  //       break;
  //   }
  //   String subjectPath = subject.split(' ').join('_');
  //   String yearStrPath =
  //       yearStr.split('-').join(' (') + '${yearStr.split('-').length > 1 ? ')' : ''}';
  //   print(time);
  //
  //
  //   CollectionReference markingRef = FirebaseFirestore.instance
  //       .collection('Past Papers and Marking Schemes')
  //       .doc('Marking Schemes')
  //       .collection(subject);
  //   markingRef.doc(yearStr).set({
  //     'height': markingHeight,
  //     'marks': "$marks",
  //     'path': "Marking_Schemes/$subjectPath/$yearStr.jpg",
  //     'type': "Answer",
  //     'year': yearStrPath
  //   });
  //   CollectionReference paperRef = FirebaseFirestore.instance
  //       .collection('Past Papers and Marking Schemes')
  //       .doc('Past Papers')
  //       .collection(subject);
  //   paperRef.doc(yearStr).set({
  //     'height': "$paperHeight",
  //     'path': "Past_Papers/$subjectPath/$yearStr.jpg",
  //     'time': time,
  //     'year': yearStrPath
  //   });
  //
  //   String yearNewStr =
  //       '2020 ${yearStr.split('-').first.split('').removeLast()=='N'? 'New' : 'Old'}' + '${yearStr.split('-').length > 1 ? ' (${yearStr.split('-').last})' : ''}';
  //   print(yearNewStr);
  //   DocumentReference ref = FirebaseFirestore.instance.collection('Papers').doc('Papers');
  //   ref.set({
  //     'Categorised': {
  //       'Marking_Schemes': {
  //         '$subjectPath': {
  //           '$yearStr': {
  //             'marks': "$marks",
  //             'year': yearNewStr,
  //           }
  //         }
  //       },
  //       'Past_Papers': {
  //         '$subjectPath': {
  //           '$yearStr': {
  //             'time': time,
  //             'year': yearNewStr,
  //           }
  //         }
  //       }
  //     }
  //   }, SetOptions(merge: true));
  //
  //   CollectionReference fullMarkingRef = FirebaseFirestore.instance.collection('Full Past Papers and Marking Schemes').doc('2020').collection('Marking Scheme');
  //   int page = 87;
  //   fullMarkingRef.doc("$page").set({
  //     'pageNo': page,
  //     'path': "Full_Papers/2020/Marking_Scheme/Pure/${page-47}.jpg"
  //   });
  //
  // }
}
