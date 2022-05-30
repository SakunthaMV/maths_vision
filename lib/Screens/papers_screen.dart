import 'package:clip_shadow/clip_shadow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maths_vision/Event_1/event_errors_and_loading.dart';
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
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  String _subject;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    List parts = widget.subjectE.split(' ');
    if (parts.length > 2) {
      setState(() {
        _subject = '${parts[0]}_${parts[1]}_${parts[2]}';
      });
    } else if (parts.length > 1) {
      setState(() {
        _subject = '${parts[0]}_${parts[1]}';
      });
    } else {
      setState(() {
        _subject = parts[0];
      });
    }
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
                    // DocumentReference ref =
                    //     FirebaseFirestore.instance.collection('Papers').doc('Papers');
                    // ref.set({
                    //   'Categorised': {
                    //     'Marking_Schemes': {
                    //       'Work,_Energy,_Power': {}
                    //     },
                    //     'Past_Papers': {
                    //       'Work,_Energy,_Power': {}
                    //     }
                    //   }
                    // }, SetOptions(merge: true));
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
                    '${widget.paperType.split('_').first} ${widget.paperType.split('_').last}',
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
              _connectionStatus == 'ConnectivityResult.wifi' ||
                      _connectionStatus == 'ConnectivityResult.mobile'
                  ? Expanded(
                      child: StreamBuilder<DocumentSnapshot>(
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
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: NetworkError(Colors.white),
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
                        primary: Color.fromARGB(255, 231, 231, 222),
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
