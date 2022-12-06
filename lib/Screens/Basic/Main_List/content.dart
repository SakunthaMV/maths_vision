import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Models/subjects_data.dart';
import 'package:maths_vision/Screens/Basic/Paths/choosable_screen.dart';
import 'package:maths_vision/Screens/Basic/Papers/Full_Choose/paper_or_markig.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/event_errors_and_loading.dart';

class Content extends StatelessWidget {
  final String category;
  const Content(this.category);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: (category == 'Pure' ? pureSubjects : appliedSubjects)
            .map(
              (val) => Column(
                children: [
                  SizedBox(
                    height: 55,
                    child: Center(
                      heightFactor: 100.0,
                      child: ListTile(
                        title: Text(
                          val[0],
                          style: textTheme.headlineMedium.copyWith(
                            fontSize: 23.0,
                            color: colorScheme.onSecondary,
                            shadows: [
                              Shadow(
                                color: Colors.grey.shade600,
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          val[2],
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
                        ),
                        leading: Image.asset(
                          val[1],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return ChooseScreen(val[2], val[0]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    indent: 88,
                    endIndent: 20,
                  )
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

// Navigation Bar Content

class ContentNavigation extends StatelessWidget {
  final String category;
  const ContentNavigation(this.category);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: (category == 'Pure' ? pureSubjects : appliedSubjects)
          .map(
            (val) => SizedBox(
              height: 55,
              child: ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        val[0],
                        style: textTheme.headlineMedium.copyWith(
                          fontSize: 20,
                          color: colorScheme.onPrimary,
                          shadows: [],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    )
                  ],
                ),
                leading: SizedBox(
                  height: 45,
                  child: Image.asset(
                    val[1],
                    color: colorScheme.onPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return ChooseScreen(val[2], val[0]);
                      },
                    ),
                  );
                },
              ),
            ),
          )
          .toList(),
    );
  }
}

// Past Papers and Making Scheme Content

class PastPapersAndMarkingSchemes extends StatelessWidget {
  const PastPapersAndMarkingSchemes();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Builder(builder: (context) {
        final bool hasConnection = Provider.of<InternetConnectionStatus>(context) ==
            InternetConnectionStatus.connected;
        if (!hasConnection) {
          return Center(
            child: NetworkError(color: colorScheme.onPrimary),
          );
        }
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('Papers').doc('Papers').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingBouncingLine.circle(
                size: 100,
                borderColor: colorScheme.onPrimary,
                backgroundColor: Colors.transparent,
              );
            }
            final Map docs = snapshot.data['Full_Papers'];
            final List sorted = docs.keys.toList()..sort();
            final List sortedKeys = sorted.reversed.toList();
            return Column(
              children: [
                Column(
                  children: List.generate(
                    docs.length,
                    (index) {
                      final List year = sortedKeys[index].split(" ");
                      return Column(
                        children: [
                          SizedBox(
                            height: 55,
                            child: ListTile(
                              title: RichText(
                                text: TextSpan(
                                  style: textTheme.headlineSmall.copyWith(
                                    fontSize: 35,
                                    color: colorScheme.onSecondary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: year[0],
                                    ),
                                    TextSpan(
                                      text: year.length > 1 ? ' ${year[1]}' : '',
                                      style: TextStyle(
                                        fontSize: 20,
                                        wordSpacing: 4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              leading: _leading(context, '#${year[0][2]}${year[0][3]}', 1.0),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return PaperOrMarking(
                                        sortedKeys[index],
                                        docs[sortedKeys[index]]['Past_Paper']['size'],
                                        'Full_Papers'
                                            '/${year[0]}${year.length > 1 ? '_${year[1]}' : ''}'
                                            '/Past_Paper'
                                            '/${year[0]}${year.length > 1 ? '_${year[1]}' : ''}'
                                            '_Past_Paper.pdf',
                                        docs[sortedKeys[index]]['Marking_Scheme']['size'],
                                        'Full_Papers'
                                            '/${year[0]}${year.length > 1 ? '_${year[1]}' : ''}'
                                            '/Marking_Scheme'
                                            '/${year[0]}${year.length > 1 ? '_${year[1]}' : ''}'
                                            '_Marking_Scheme.pdf',
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            indent: 87,
                            endIndent: 20,
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Opacity(
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
                    leading: _leading(context, '#?', 5.0),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _leading(BuildContext context, String topic, double spacing) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 60,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.tertiaryContainer,
            ),
          ),
          Container(
            width: 49,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary,
            ),
            child: Center(
              child: FittedBox(
                child: Text(
                  topic,
                  style: GoogleFonts.freehand(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.tertiaryContainer,
                    letterSpacing: spacing,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
