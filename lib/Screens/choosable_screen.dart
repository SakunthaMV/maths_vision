import 'package:flutter/material.dart';
import 'package:maths_vision/Splash_Screens/went_home_splash_screen.dart';
import 'package:maths_vision/Screens/papers_screen.dart';

import 'subject_content.dart';
import 'navigation_drawer.dart';

class ChooseScreen extends StatefulWidget {
  final String subjectE;
  final String subjectS;

  const ChooseScreen(this.subjectE, this.subjectS);

  @override
  _ChooseScreenState createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          color: Color.fromARGB(255, 0, 135, 145),
        ),
        Opacity(
          opacity: 0.12,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/HomeBackground.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  iconSize: 35,
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    return Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 70,
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
                    Navigator.of(context).push(
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
          ),
          backgroundColor: Colors.transparent,
          drawer: NavigationDrawer(),
          body: Center(
            child: Column(
              children: [
                Text(
                  widget.subjectS,
                  style: TextStyle(
                    fontFamily: 'Abhaya Libre',
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    wordSpacing: 1,
                    shadows: [
                      Shadow(
                        color: Colors.grey.shade900,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.subjectE,
                  style: TextStyle(
                    fontFamily: 'Gabriola',
                    fontSize: 25,
                    color: Color.fromARGB(255, 125, 249, 255),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    wordSpacing: 1,
                    shadows: [
                      Shadow(
                        color: Colors.grey.shade900,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.075),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final List levels = [
                        ['සටහන', 'NOTE'],
                        ['පසුගිය ප්‍රශ්න', 'QUESTIONS'],
                        ['පිළිතුරු', 'MARKING SCHEMES']
                      ];
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (index == 0) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return NotePage(widget.subjectE);
                                },
                              ),
                            );
                          } else if (index == 1) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return PapersScreen(
                                    'Past_Papers',
                                    widget.subjectS,
                                    widget.subjectE,
                                  );
                                },
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return PapersScreen(
                                    'Marking_Schemes',
                                    widget.subjectS,
                                    widget.subjectE,
                                  );
                                },
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            padding: EdgeInsets.only(left: 25),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 246, 246, 246),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  color: Colors.black.withOpacity(0.4),
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      levels[index][0],
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Abhaya Libre',
                                        color: Color.fromARGB(255, 72, 73, 75),
                                        height: 1,
                                        letterSpacing: 1,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 1,
                                            color: Colors.black.withOpacity(0.5),
                                            offset: Offset(0.5, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      levels[index][1],
                                      style: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 119, 123, 126),
                                        letterSpacing: 1.5,
                                        height: 1.5,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 1,
                                            color: Colors.black.withOpacity(0.5),
                                            offset: Offset(0.5, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: SizedBox(
                                    height: 90,
                                    child: Image.asset('assets/Choosable_Pic.jpg'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
