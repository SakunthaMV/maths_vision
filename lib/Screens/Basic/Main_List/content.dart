import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Models/subjects_data.dart';
import 'package:maths_vision/Screens/Basic/Paths/choosable_screen.dart';
import 'package:maths_vision/Screens/Basic/Papers/Full_Choose/paper_or_markig.dart';
import 'package:maths_vision/Screens/Basic/Papers/Categorized_List/papers_screen.dart';

import '../Note/subject_content.dart';

class Content extends StatelessWidget {
  final String category;

  const Content(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: (category == 'Pure' ? pureSubjects : appliedSubjects)
            .map(
              (val) => Column(
                children: [
                  SizedBox(
                    height: 55,
                    child: Container(
                      height: double.infinity,
                      child: Center(
                        heightFactor: 100.0,
                        child: ListTile(
                          title: Text(
                            val[0],
                            style: GoogleFonts.abhayaLibre(
                              fontSize: 23.0,
                              color: Color.fromARGB(255, 72, 73, 75),
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.0,
                              wordSpacing: 1.0,
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
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Color.fromARGB(255, 119, 123, 126),
                              fontFamily: 'Gabriola',
                              letterSpacing: 0.5,
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
                          onLongPress: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return NotePage(val[2]);
                                },
                              ),
                            );
                          },
                        ),
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
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: (category == 'Pure' ? pureSubjects : appliedSubjects)
            .map(
              (val) => SizedBox(
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          val[0],
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'Abhaya Libre',
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
                        color: Colors.black,
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
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return NotePage(val[2]);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// Past Papers and Making Scheme Content

class PastPapersAndMarkingSchemes extends StatefulWidget {
  const PastPapersAndMarkingSchemes();

  @override
  State<PastPapersAndMarkingSchemes> createState() => _PastPapersAndMarkingSchemesState();
}

class _PastPapersAndMarkingSchemesState extends State<PastPapersAndMarkingSchemes> {
  bool _hasConnection;
  StreamSubscription _subscription;

  Future<void> checkInternet() async {
    bool status = await InternetConnectionChecker().hasConnection;
    setState(() {
      _hasConnection = status;
    });
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      status = await InternetConnectionChecker().hasConnection;
      setState(() {
        _hasConnection = status;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Builder(builder: (context) {
        if (_hasConnection == null) {
          return LoadingBouncingLine.circle(
            size: 100,
            borderColor: Colors.black,
            backgroundColor: Colors.transparent,
          );
        }
        if (!_hasConnection) {
          return Center(
            child: NetworkError(Colors.black),
          );
        }
        return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('Papers').doc('Papers').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map docs = snapshot.data['Full_Papers'];
                List sorted = docs.keys.toList()..sort();
                List sortedKeys = sorted.reversed.toList();
                return Column(
                  children: [
                    Column(
                      children: List.generate(
                        docs.length,
                        (index) {
                          List year = sortedKeys[index].split(" ");
                          return Column(
                            children: [
                              SizedBox(
                                height: 55,
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 35,
                                        fontFamily: 'Constan',
                                        color: Color.fromARGB(255, 72, 73, 75),
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.4),
                                            blurRadius: 1,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
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
                                  leading: SizedBox(
                                    width: 60,
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromARGB(255, 0, 88, 122),
                                          ),
                                        ),
                                        Container(
                                          width: 49,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: FittedBox(
                                              child: Text(
                                                '#${year[0][2]}${year[0][3]}',
                                                style: GoogleFonts.freehand(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(255, 0, 88, 122),
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Constan',
                            wordSpacing: 1.0,
                            letterSpacing: 0.2,
                            color: Color.fromARGB(255, 72, 73, 75),
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 1,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        leading: SizedBox(
                          width: 60,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 0, 88, 122),
                                ),
                              ),
                              Container(
                                width: 49,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: FittedBox(
                                    child: Text(
                                      '#?',
                                      style: GoogleFonts.freehand(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 0, 88, 122),
                                        letterSpacing: 5.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return LoadingBouncingLine.circle(
                  size: 100,
                  borderColor: Colors.black,
                  backgroundColor: Colors.transparent,
                );
              }
            });
      }),
    );
  }
}
