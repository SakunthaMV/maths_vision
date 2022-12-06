import 'package:clip_shadow/clip_shadow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maths_vision/Widgets/event_errors_and_loading.dart';
import 'package:maths_vision/Screens/Basic/Papers/Categorized_Display/paper_content.dart';
import 'package:provider/provider.dart';

import '../../../../Widgets/common_background.dart';

class PapersScreen extends StatelessWidget {
  final String paperType;
  final String subjectS;
  final String subjectE;

  const PapersScreen(this.paperType, this.subjectS, this.subjectE);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return CommonBackground(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, bottom: 12, right: 30),
            child: FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${paperType.split('_').join(' ')}',
                    style: textTheme.displaySmall.copyWith(
                      fontSize: 43,
                      letterSpacing: -0.7,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 3,
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    subjectS,
                    style: textTheme.headlineMedium.copyWith(
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 3,
                          offset: Offset(1, 1.5),
                        ),
                      ],
                    ),
                  ),
                  Text(subjectE, style: Theme.of(context).primaryTextTheme.displayLarge),
                ],
              ),
            ),
          ),
          Divider(
            color: colorScheme.primary,
            indent: 30,
            endIndent: 30,
            height: 1,
            thickness: 1,
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                bool _hasConnection = Provider.of<InternetConnectionStatus>(context) ==
                    InternetConnectionStatus.connected;
                if (_hasConnection == null) {
                  return EventLoading();
                }
                if (!_hasConnection) {
                  return Center(
                    child: NetworkError(),
                  );
                }
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Papers')
                      .doc('Papers')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return EventLoading();
                    }
                    return _itemList(context, snapshot.data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemList(BuildContext context, DocumentSnapshot data) {
    final String subject = subjectE.split(' ').join('_');
    final Map docs = data['Categorised.$paperType.$subject'];
    final List sorted = docs.keys.toList()..sort();
    final List sortedKeys = sorted.reversed.toList();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scrollbar(
      thumbVisibility: true,
      interactive: true,
      radius: Radius.circular(3.5),
      thickness: 7,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          List year = docs[sortedKeys[index]]['year'].split(' ');
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: ClipShadow(
              clipper: ButtonShape(),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(5, 5),
                  spreadRadius: 0,
                  blurRadius: 10,
                )
              ],
              child: Container(
                height: 68,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.onTertiary,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          if (paperType == 'Past_Papers') {
                            return PaperContent(
                              '$paperType/$subject/${sortedKeys[index]}.jpg',
                              subjectS,
                              docs[sortedKeys[index]]['year'],
                              'Question',
                              docs[sortedKeys[index]]['time'],
                            );
                          } else {
                            return PaperContent(
                              '$paperType/$subject/${sortedKeys[index]}.jpg',
                              subjectS,
                              docs[sortedKeys[index]]['year'],
                              'Answer',
                              docs[sortedKeys[index]]['marks'],
                            );
                          }
                        },
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment(-1.2, 0),
                        child: ClipRRect(
                          child: Image.asset('assets/Paper_Icon.jpg'),
                          borderRadius: BorderRadius.all(
                            Radius.circular(17),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 85, top: 25),
                        child: FittedBox(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: year[0],
                                  style: textTheme.headlineSmall.copyWith(
                                    letterSpacing: -0.5,
                                    wordSpacing: -2,
                                  ),
                                ),
                                TextSpan(
                                  text: year.length > 1
                                      ? year[1] == 'New' || year[1] == 'Old'
                                          ? ' ${year[1]}'
                                          : ''
                                      : '',
                                  style: textTheme.displayLarge.copyWith(
                                    color: colorScheme.tertiaryContainer,
                                    fontSize: 18.0,
                                  ),
                                ),
                                TextSpan(
                                  text: year.length == 3
                                      ? ' ${year[2]}'
                                      : year.length == 2
                                          ? year[1] == 'New' || year[1] == 'Old'
                                              ? ''
                                              : ' ${year[1]}'
                                          : '',
                                  style: textTheme.displayLarge.copyWith(
                                    color: colorScheme.tertiaryContainer,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                TextSpan(
                                  text: paperType == 'Past_Papers' ? ' Question' : ' Answer',
                                  style: textTheme.headlineSmall.copyWith(
                                    fontSize: 13,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 1,
                                        offset: Offset(0.5, 0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ButtonShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = size.height * 0.25;

    Path path = Path();
    path.moveTo(radius, 0);
    path.lineTo(size.width * 14 / 20, 0);
    path.quadraticBezierTo(
        size.width * 15.2 / 20, size.height * 0, size.width * 16 / 20, size.height * 1 / 7);
    path.lineTo(size.width * 23.3 / 25, size.height * 3.3 / 5);
    path.quadraticBezierTo(size.width, size.height * 0.92, size.width * 19 / 20, size.height);
    path.lineTo(radius, size.height);
    path.arcToPoint(Offset(0, size.height - radius), radius: Radius.circular(radius));
    path.lineTo(0, radius);
    path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
