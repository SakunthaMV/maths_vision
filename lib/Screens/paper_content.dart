import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:countdown_timer_simple/countdown_timer_simple.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Splash_Screens/went_home_splash_screen.dart';

import 'navigation_drawer.dart';

class PaperContent extends StatefulWidget {
  final String imagePath;
  final String subjectS;
  final String year;
  final String type;
  final String timeOrMarks;

  const PaperContent(this.imagePath, this.subjectS, this.year, this.type, this.timeOrMarks);

  @override
  _PaperContentState createState() => _PaperContentState();
}

class _PaperContentState extends State<PaperContent> with TickerProviderStateMixin {
  Timer initTimer;
  int _start = 10;
  double _counterOpacity = 1.0;
  double _positionX = 3;
  double _positionY = -1.0;
  double _paperHeight = 102;
  List _time;
  int _min;
  int _sec;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const oneSec = const Duration(seconds: 1);
    if (widget.type == 'Question') {
      _time = widget.timeOrMarks.split(':');
      _min = int.parse(_time[0]);
      _sec = int.parse(_time[1]);
      initTimer = new Timer.periodic(
        oneSec,
        (Timer timer) {
          if (_start == 0) {
            setState(() {
              initTimer.cancel();
            });
          } else if (_start == 1) {
            setState(() {
              _counterOpacity = 0.0;
              _positionY = -1.14;
              _paperHeight = 75;
              _start--;
            });
          } else if (_start == 4) {
            setState(() {
              _positionX = 1;
              _start--;
            });
          } else {
            setState(() {
              _start--;
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    initTimer.cancel();
  }

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
          drawer: NavigationDrawer(),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: size.width * 0.85,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 231, 231, 222),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                widget.subjectS,
                                style: TextStyle(
                                  fontFamily: 'Abhaya Libre',
                                  fontSize: 28,
                                  color: Color.fromARGB(255, 0, 88, 122),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text(
                                widget.year + ' ' + widget.type,
                                style: TextStyle(
                                  fontFamily: 'Pristina',
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 0, 88, 122),
                                ),
                              ),
                            ),
                            Text(
                              widget.type == 'Question'
                                  ? 'Time : ' + widget.timeOrMarks + ' min'
                                  : 'Marks : ' + widget.timeOrMarks,
                              style: TextStyle(
                                fontFamily: 'Pristina',
                                fontSize: 27,
                                color: Color.fromARGB(255, 0, 88, 122),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  widget.type == 'Question'
                      ? Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 700),
                                  opacity: _counterOpacity,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Your time will start in ',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.7),
                                                blurRadius: 4,
                                                offset: Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextSpan(
                                          text: '$_start',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 20,
                                            color: _start > 3 ? Colors.white : Colors.red,
                                            fontWeight: FontWeight.w600,
                                            shadows: [
                                              Shadow(
                                                color: _start > 3
                                                    ? Colors.black.withOpacity(0.7)
                                                    : Colors.grey.shade600.withOpacity(0.7),
                                                blurRadius: 4,
                                                offset: Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' seconds',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.7),
                                                blurRadius: 4,
                                                offset: Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(seconds: 3),
                              height: _paperHeight,
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 25,
                        ),
                  StreamBuilder<String>(
                    stream: FirebaseStorage.instance
                        .ref()
                        .child(widget.imagePath)
                        .getDownloadURL()
                        .asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: Container(
                            alignment: Alignment.topCenter,
                            width: size.width * 0.95,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: InteractiveViewer(
                                minScale: 1.0,
                                maxScale: 4.0,
                                child: SingleChildScrollView(
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data,
                                    placeholder: (context, url) {
                                      return SizedBox(
                                        width: 200,
                                        child: LoadingBumpingLine.circle(
                                          size: 100,
                                          backgroundColor: Colors.transparent,
                                          borderColor: Colors.black,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return LoadingBumpingLine.circle(
                          size: 100,
                          backgroundColor: Colors.transparent,
                          borderColor: Colors.black,
                        );
                      }
                    },
                  ),
                ],
              ),
              widget.type == 'Question'
                  ? AnimatedContainer(
                      duration: Duration(seconds: 3),
                      alignment: Alignment(_positionX, _positionY),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 180),
                        child: Container(
                          width: 180,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 88, 122),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              bottomLeft: Radius.circular(35),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(0, 0),
                                blurRadius: 12,
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: CountdownTimerSimple(
                            endTime: DateTime.now().millisecondsSinceEpoch +
                                1000 * ((60 * _min) + 1 + _sec),
                            showHour: false,
                            textStyle: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.8),
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
