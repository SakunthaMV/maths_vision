import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Screens/choosable_screen.dart';
import 'package:maths_vision/Screens/paper_or_markig.dart';
import 'package:maths_vision/Screens/papers_screen.dart';

import 'subject_content.dart';

class PureContent extends StatefulWidget {
  @override
  _PureContentState createState() => _PureContentState();
}

class _PureContentState extends State<PureContent> {
  var items = [
    [
      "ගණිත අභ්‍යුහන මූලධර්මය",
      "assets/Mathematical_Induction_Icon.png",
      'Mathematical Induction'
    ],
    ["අසමානතා", "assets/Inequalities_Icon.png", 'Inequalities'],
    ["ද්විපද ප්‍රසාරණය", "assets/Binomial_Expansion_Icon.png", 'Binomial Expansion'],
    ["සීමා", "assets/Limits_Icon.png", 'Limits'],
    ["බහුපද ශ්‍රිත", "assets/Polynomial_Equations_Icon.png", 'Polynomial Equations'],
    ["වර්ග සමීකරණ", "assets/Quadratic_Functions_Icon.png", 'Quadratic Functions'],
    [
      "සංකරණ හා සං‍යෝජන",
      "assets/Permutations_and_Combinations_Icon.png",
      'Permutations and Combinations'
    ],
    ["ශ්‍රේණි", "assets/Series_Icon.png", 'Series'],
    ["න්‍යාස", "assets/Matrices_Icon.png", 'Matrices'],
    ["සංකීර්ණ සංඛ්‍යා", "assets/Complex_Numbers_Icon.png", 'Complex Numbers'],
    ["අවකලනය", "assets/Differentiation_Icon.png", 'Differentiation'],
    ["අනුකලනය", "assets/Integration_Icon.png", 'Integration'],
    ["සරල රේඛාව", "assets/Straight_Line_Icon.png", 'Straight Line'],
    ["වෘත්තය", "assets/Circle_Icon.png", 'Circle'],
    ["ත්‍රිකෝණමිතිය", "assets/Trigonometry_Icon.png", 'Trigonometry'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: items
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

class AppliedContent extends StatefulWidget {
  @override
  _AppliedContentState createState() => _AppliedContentState();
}

class _AppliedContentState extends State<AppliedContent> {
  var items = [
    ["ගැටුම්", "assets/Collisions_Icon.png", 'Collisions'],
    ["ප්‍රක්ශිප්ත", "assets/Projectiles_Icon.png", 'Projectiles'],
    ["ඝර්ෂණය", "assets/Friction_Icon.png", 'Friction'],
    ["කාර්යය, ශක්තිය, ජවය", "assets/Work_Energy_Power_Icon.png", 'Work, Energy, Power'],
    ["දෛශික", "assets/Vectors_Icon.png", 'Vectors'],
    ["ඒකතල බල පද්ධති", "assets/Coplanar_Forces_Icon.png", 'Coplanar Forces'],
    ["බල සමතුලිතතාවය", "assets/Equilibrium_of_Forces_Icon.png", 'Equilibrium of Forces'],
    ["ප්‍රවේග-කාල ප්‍රස්තාර", "assets/Velocity-Time_Graphs_Icon.png", 'Velocity-Time Graphs'],
    ["සාපේක්ෂ ප්‍රාවේගය", "assets/Relative_Velocity_Icon.png", 'Relative Velocity'],
    ["සාපේක්ෂ ත්වරණය", "assets/Relative_Acceleration_Icon.png", 'Relative Acceleration'],
    ["වෘත්ත චලිතය", "assets/Circular_Motion_Icon.png", 'Circular Motion'],
    [
      "සරල අනුවර්තීය චලිතය",
      "assets/Simple_Harmonic_Motion_Icon.png",
      'Simple Harmonic Motion'
    ],
    ["රාමු සැකිලි", "assets/Frame_Works_Icon.png", 'Frame Works'],
    ["සන්දි කල දඬු", "assets/Jointed_Rods_Icon.png", 'Jointed Rods'],
    ["ගුරුත්ව කේන්ද්‍රය", "assets/Center_of_Gravity_Icon.png", 'Center of Gravity'],
    ["සම්භාවිතාව", "assets/Probability_Icon.png", 'Probability'],
    ["සංඛ්‍යානය", "assets/Statistics_Icon.png", 'Statistics'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: items
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

  final List items = [
    [
      "ගණිත අභ්‍යුහන මූලධර්මය",
      "assets/Mathematical_Induction_Icon.png",
      'Mathematical Induction'
    ],
    ["අසමානතා", "assets/Inequalities_Icon.png", 'Inequalities'],
    ["ද්විපද ප්‍රසාරණය", "assets/Binomial_Expansion_Icon.png", 'Binomial Expansion'],
    ["සීමා", "assets/Limits_Icon.png", 'Limits'],
    ["බහුපද ශ්‍රිත", "assets/Polynomial_Equations_Icon.png", 'Polynomial Equations'],
    ["වර්ග සමීකරණ", "assets/Quadratic_Functions_Icon.png", 'Quadratic Functions'],
    [
      "සංකරණ හා සං‍යෝජන",
      "assets/Permutations_and_Combinations_Icon.png",
      'Permutations and Combinations'
    ],
    ["ශ්‍රේණි", "assets/Series_Icon.png", 'Series'],
    ["න්‍යාස", "assets/Matrices_Icon.png", 'Matrices'],
    ["සංකීර්ණ සංඛ්‍යා", "assets/Complex_Numbers_Icon.png", 'Complex Numbers'],
    ["අවකලනය", "assets/Differentiation_Icon.png", 'Differentiation'],
    ["අනුකලනය", "assets/Integration_Icon.png", 'Integration'],
    ["සරල රේඛාව", "assets/Straight_Line_Icon.png", 'Straight Line'],
    ["වෘත්තය", "assets/Circle_Icon.png", 'Circle'],
    ["ත්‍රිකෝණමිතිය", "assets/Trigonometry_Icon.png", 'Trigonometry'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: items
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

  final List items = [
    ["ගැටුම්", "assets/Collisions_Icon.png", 'Collisions'],
    ["ප්‍රක්ශිප්ත", "assets/Projectiles_Icon.png", 'Projectiles'],
    ["ඝර්ෂණය", "assets/Friction_Icon.png", 'Friction'],
    ["කාර්යය, ශක්තිය, ජවය", "assets/Work_Energy_Power_Icon.png", "Work, Energy, Power"],
    ["දෛශික", "assets/Vectors_Icon.png", 'Vectors'],
    ["ඒකතල බල පද්ධති", "assets/Coplanar_Forces_Icon.png", 'Coplanar Forces'],
    ["බල සමතුලිතතාවය", "assets/Equilibrium_of_Forces_Icon.png", 'Equilibrium of Forces'],
    ["ප්‍රවේග-කාල ප්‍රස්තාර", "assets/Velocity-Time_Graphs_Icon.png", 'Velocity-Time Graphs'],
    ["සාපේක්ෂ ප්‍රවේගය", "assets/Relative_Velocity_Icon.png", 'Relative Velocity'],
    ["සාපේක්ෂ ත්වරණය", "assets/Relative_Acceleration_Icon.png", 'Relative Acceleration'],
    ["වෘත්ත චලිතය", "assets/Circular_Motion_Icon.png", 'Circular Motion'],
    [
      "සරල අනුවර්තීය චලිතය",
      "assets/Simple_Harmonic_Motion_Icon.png",
      'Simple Harmonic Motion'
    ],
    ["රාමු සැකිලි", "assets/Frame_Works_Icon.png", 'Frame Works'],
    ["සන්දි කල දඬු", "assets/Jointed_Rods_Icon.png", 'Jointed Rods'],
    ["ගුරුත්ව කේන්ද්‍රය", "assets/Center_of_Gravity_Icon.png", 'Center of Gravity'],
    ["සම්භාවිතාව", "assets/Probability_Icon.png", 'Probability'],
    ["සංඛ්‍යානය", "assets/Statistics_Icon.png", 'Statistics'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: items
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
