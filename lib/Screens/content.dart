import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Data_Directory/subjects_data.dart';
import 'package:maths_vision/Screens/choosable_screen.dart';
import 'package:maths_vision/Screens/paper_or_markig.dart';
import 'package:maths_vision/Screens/papers_screen.dart';

import 'subject_content.dart';

class PureContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: pureSubjects
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
                            style: TextStyle(
                              fontSize: 23.0,
                              color: Color.fromARGB(255, 72, 73, 75),
                              fontFamily: 'Abhaya Libre',
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

class AppliedContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: pureSubjects
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
                            style: TextStyle(
                              fontSize: 23.0,
                              color: Color.fromARGB(255, 72, 73, 75),
                              fontFamily: 'Abhaya Libre',
                              letterSpacing: 0.5,
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

class PureContentNavigation extends StatelessWidget {
  PureContentNavigation({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: pureSubjects
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

class AppliedContentNavigation extends StatelessWidget {
  AppliedContentNavigation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: appliedSubjects
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
  final String dataStatus;

  const PastPapersAndMarkingSchemes(this.dataStatus);

  @override
  _PastPapersAndMarkingSchemesState createState() => _PastPapersAndMarkingSchemesState();
}

class _PastPapersAndMarkingSchemesState extends State<PastPapersAndMarkingSchemes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: widget.dataStatus == 'ConnectivityResult.wifi' ||
              widget.dataStatus == 'ConnectivityResult.mobile'
          ? StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Papers')
                .doc('Papers')
                .snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
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
                                      children: [
                                        TextSpan(
                                          text: year[0],
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
                                        ),
                                        TextSpan(
                                          text: year.length > 1 ? ' ${year[1]}' : '',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Constan',
                                            color: Color.fromARGB(255, 72, 73, 75),
                                            wordSpacing: 4,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.4),
                                                blurRadius: 1,
                                                offset: Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  leading: Image.asset(
                                    'assets/${year[0]}.png',
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return PaperOrMarking(
                                            sortedKeys[index],
                                            docs[sortedKeys[index]]['Past_Paper']['size'],
                                            'Full_Papers'
                                                '/${year[0]}${year.length>1?'_${year[1]}':''}'
                                                '/Past_Paper'
                                                '/${year[0]}${year.length>1?'_${year[1]}':''}'
                                                '_Past_Paper.pdf',
                                            docs[sortedKeys[index]]['Marking_Scheme']['size'],
                                            'Full_Papers'
                                                '/${year[0]}${year.length>1?'_${year[1]}':''}'
                                                '/Marking_Scheme'
                                                '/${year[0]}${year.length>1?'_${year[1]}':''}'
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
                        leading: Image.asset(
                          'assets/Paper_Soon_Icon.png',
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
            }
          )
          : NetworkError(Colors.black),
    );
  }
}
