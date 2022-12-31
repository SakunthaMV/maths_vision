import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maths_vision/Models/subjects_data.dart';
import 'package:maths_vision/Screens/Basic/Paths/choosable_screen.dart';
import 'package:maths_vision/Screens/Basic/Papers/Full_Choose/paper_or_markig.dart';

import '../../../Widgets/event_errors_and_loading.dart';
import 'common_widgets.dart';

Widget lesson(BuildContext context, int index, String screen, {bool main}) {
  final TextTheme textTheme = Theme.of(context).textTheme;
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  String sinhala;
  String english;
  if (screen == 'Pure') {
    sinhala = pureSubjects[index][0];
    english = pureSubjects[index][1];
  } else {
    sinhala = appliedSubjects[index][0];
    english = appliedSubjects[index][1];
  }
  return ListTile(
    title: Text(
      sinhala,
      style: textTheme.headlineMedium.copyWith(
        fontSize: main == null ? 23.0 : 20.0,
        color: main == null ? colorScheme.onSecondary : colorScheme.onPrimary,
        shadows: main == null
            ? [Shadow(color: Colors.grey.shade600, blurRadius: 2, offset: Offset(1, 1))]
            : [],
      ),
    ),
    subtitle: main == null
        ? Text(
            english,
            style: textTheme.headlineLarge.copyWith(
              fontSize: 20.0,
              color: colorScheme.tertiary,
              letterSpacing: 0.5,
              fontWeight: FontWeight.normal,
              shadows: [
                Shadow(
                  color: Colors.grey.shade600,
                  blurRadius: 1,
                  offset: Offset(0.5, 0.5),
                ),
              ],
            ),
          )
        : null,
    leading: Image.asset(
      "assets/${english.split(' ').join('_')}_Icon.png",
      width: main == null ? 55.0 : 45.0,
      color: main == null ? null : colorScheme.onPrimary,
    ),
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return ChooseScreen(english, sinhala);
          },
        ),
      );
    },
  );
}

StreamBuilder pastPaperItemList(BuildContext context, ScrollController controller) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final TextTheme textTheme = Theme.of(context).textTheme;
  final double width = MediaQuery.of(context).size.width;
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('Papers').doc('Papers').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return EventLoading(size: 100, color: colorScheme.onPrimary);
      }
      final Map docs = snapshot.data['Full_Papers'];
      final List sortedMap = docs.keys.toList()..sort();
      final List order = sortedMap.reversed.toList();
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        controller: controller,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        itemCount: docs.length + 1,
        itemBuilder: (context, index) {
          if (index == docs.length) {
            return Opacity(
              opacity: 0.6,
              child: ListTile(
                title: Text(
                  'Coming Soon...',
                  style: textTheme.headlineSmall.copyWith(
                    fontSize: 20.0,
                    color: colorScheme.onSecondary,
                    letterSpacing: 0.2,
                  ),
                ),
                leading: leadingPastPaper(context, '#?', 5.0),
              ),
            );
          }
          final List year = order[index].split(" ");
          final String pSize = docs[order[index]]['Past_Paper']['size'];
          final String pPath = 'Full_Papers/${year.join('_')}/Past_Paper'
              '/${year.join('_')}_Past_Paper.pdf';
          final String mSize = docs[order[index]]['Marking_Scheme']['size'];
          final String mPath = 'Full_Papers/${year.join('_')}'
              '/Marking_Scheme/${year.join('_')}_Marking_Scheme.pdf';
          return ListTile(
            title: RichText(
              text: TextSpan(
                children: List.generate(year.length, (i) {
                  return TextSpan(
                    text: i > 0 ? ' ' + year[i] : year[i],
                    style: textTheme.headlineSmall.copyWith(
                      fontSize: i > 0 ? 20.0 : 35.0,
                      wordSpacing: i > 0 ? 4.0 : 1.0,
                      color: colorScheme.onSecondary,
                    ),
                  );
                }),
              ),
            ),
            leading: leadingPastPaper(context, '#${year[0][2]}${year[0][3]}', 1.0),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return PaperOrMarking(order[index], pSize, pPath, mSize, mPath);
                  },
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(thickness: 1, indent: width * 0.225, endIndent: width * 0.03);
        },
      );
    },
  );
}
