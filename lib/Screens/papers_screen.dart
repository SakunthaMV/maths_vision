import 'dart:async';

import 'package:clip_shadow/clip_shadow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maths_vision/Support_Classes/event_errors_and_loading.dart';
import 'package:maths_vision/Splash_Screens/went_home_splash_screen.dart';
import 'package:maths_vision/Screens/paper_content.dart';

import 'navigation_drawer.dart';

class PapersScreen extends StatefulWidget {
  final String paperType;
  final String subjectS;
  final String subjectE;

  const PapersScreen(this.paperType, this.subjectS, this.subjectE);

  @override
  _PapersScreenState createState() => _PapersScreenState();
}

class _PapersScreenState extends State<PapersScreen> {
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

  String _subject;

  @override
  void initState() {
    super.initState();
    checkInternet();
    _subject = widget.subjectE.split(' ').join('_');
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
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
                    // ignore: dead_code
                    if(false) {_paperUpdate();}
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
          drawer: NavigationDrawer(),
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: FittedBox(
                  child: Text(
                    '${widget.paperType.split('_').join(' ')}',
                    style: TextStyle(
                      fontSize: 43,
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      letterSpacing: -0.7,
                      wordSpacing: 1,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 3,
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  widget.subjectS,
                  style: TextStyle(
                    fontSize: 29,
                    fontFamily: 'Abhaya Libre',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 3,
                        offset: Offset(1, 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 4, bottom: 12),
                child: Text(
                  widget.subjectE,
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Dancing Script',
                    color: Colors.white,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 3,
                        offset: Offset(1, 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.white,
                indent: 30,
                endIndent: 30,
                height: 1,
                thickness: 1,
              ),
              Expanded(
                child: Builder(
                  builder: (context){
                    if(_hasConnection==null){
                      return EventLoading();
                    }
                    if(!_hasConnection){
                      return Center(
                        child: NetworkError(Colors.white),
                      );
                    }
                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Papers')
                          .doc('Papers')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return _itemList(snapshot.data);
                        } else {
                          return EventLoading();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _itemList(DocumentSnapshot data) {
    final width = MediaQuery.of(context).size.width;
    Map docs = data['Categorised.${widget.paperType}.$_subject'];
    List sorted = docs.keys.toList()..sort();
    List sortedKeys = sorted.reversed.toList();
    return Scrollbar(
      thumbVisibility: true,
      thickness: 7,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 15),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          List year = docs[sortedKeys[index]]['year'].split(' ');
          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                ClipShadow(
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
                    width: width * 0.84,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 231, 231, 222),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              if (widget.paperType == 'Past_Papers') {
                                return PaperContent(
                                  '${widget.paperType}/$_subject/${sortedKeys[index]}.jpg',
                                  widget.subjectS,
                                  docs[sortedKeys[index]]['year'],
                                  'Question',
                                  docs[sortedKeys[index]]['time'],
                                );
                              } else {
                                return PaperContent(
                                  '${widget.paperType}/$_subject/${sortedKeys[index]}.jpg',
                                  widget.subjectS,
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
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: year[0],
                                    style: TextStyle(
                                      fontFamily: 'Constan',
                                      color: Color.fromARGB(255, 0, 88, 122),
                                      fontSize: 30,
                                      letterSpacing: -0.5,
                                      wordSpacing: -2,
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
                                    text: year.length == 3
                                        ? ' ${year[1]}'
                                        : year.length == 2
                                            ? year[1] == 'New' || year[1] == 'Old'
                                                ? ' ${year[1]}'
                                                : ''
                                            : '',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      color: Color.fromARGB(255, 0, 88, 122),
                                      fontSize: 18,
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
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      color: Color.fromARGB(255, 0, 88, 122),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.paperType == 'Past_Papers'
                                        ? ' Question'
                                        : ' Answer',
                                    style: TextStyle(
                                      fontFamily: 'Constan',
                                      color: Color.fromARGB(255, 0, 88, 122),
                                      fontSize: 13,
                                      wordSpacing: 1,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _paperUpdate() {
    String subject = "Work, Energy, Power";
    int markingHeight = 1364;
    int marks = 25;
    String yearStr = "2020N";
    int paperHeight = 225;

    String time = "00:00";
    switch (marks) {
      case 25:
        {
          time = "4:30";
        }
        break;
      case 50:
        {
          time = "9:00";
        }
        break;
      case 55:
        {
          time = "10:00";
        }
        break;
      case 60:
        {
          time = "11:00";
        }
        break;
      case 65:
        {
          time = "12:00";
        }
        break;
      case 70:
        {
          time = "13:00";
        }
        break;
      case 75:
        {
          time = "13:30";
        }
        break;
      case 80:
        {
          time = "14:30";
        }
        break;
      case 85:
        {
          time = "15:30";
        }
        break;
      case 90:
        {
          time = "16:30";
        }
        break;
      case 95:
        {
          time = "17:30";
        }
        break;
      case 100:
        {
          time = "18:00";
        }
        break;
      case 150:
        {
          time = "27:00";
        }
        break;
    }
    String subjectPath = subject.split(' ').join('_');
    String yearStrPath =
        yearStr.split('-').join(' (') + '${yearStr.split('-').length > 1 ? ')' : ''}';
    print(time);


    CollectionReference markingRef = FirebaseFirestore.instance
        .collection('Past Papers and Marking Schemes')
        .doc('Marking Schemes')
        .collection(subject);
    markingRef.doc(yearStr).set({
      'height': markingHeight,
      'marks': "$marks",
      'path': "Marking_Schemes/$subjectPath/$yearStr.jpg",
      'type': "Answer",
      'year': yearStrPath
    });
    CollectionReference paperRef = FirebaseFirestore.instance
        .collection('Past Papers and Marking Schemes')
        .doc('Past Papers')
        .collection(subject);
    paperRef.doc(yearStr).set({
      'height': "$paperHeight",
      'path': "Past_Papers/$subjectPath/$yearStr.jpg",
      'time': time,
      'year': yearStrPath
    });

    String yearNewStr =
        '2020 ${yearStr.split('-').first.split('').removeLast()=='N'? 'New' : 'Old'}' + '${yearStr.split('-').length > 1 ? ' (${yearStr.split('-').last})' : ''}';
    print(yearNewStr);
    DocumentReference ref = FirebaseFirestore.instance.collection('Papers').doc('Papers');
    ref.set({
      'Categorised': {
        'Marking_Schemes': {
          '$subjectPath': {
            '$yearStr': {
              'marks': "$marks",
              'year': yearNewStr,
            }
          }
        },
        'Past_Papers': {
          '$subjectPath': {
            '$yearStr': {
              'time': time,
              'year': yearNewStr,
            }
          }
        }
      }
    }, SetOptions(merge: true));

    CollectionReference fullMarkingRef = FirebaseFirestore.instance.collection('Full Past Papers and Marking Schemes').doc('2020').collection('Marking Scheme');
    int page = 87;
    fullMarkingRef.doc("$page").set({
      'pageNo': page,
      'path': "Full_Papers/2020/Marking_Scheme/Pure/${page-47}.jpg"
    });

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

class NetworkError extends StatelessWidget {
  final Color color;

  const NetworkError(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 4),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/Network_Error_Icon.png',
            width: 150,
            color: color,
          ),
          Text(
            'Please check\nyour internet\nconnection ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Gothic',
              fontSize: 20,
              color: color,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  blurRadius: 3,
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(1, 1),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
