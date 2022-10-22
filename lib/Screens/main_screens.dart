import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/home_screen.dart';
import '../Widgets/common_background.dart';
import 'content.dart';

class MainScreen extends StatefulWidget {
  final String screen;
  final String dataStatus;

  const MainScreen(this.screen, {this.dataStatus});

  @override
  _MainScreenState createState() => _MainScreenState(screen);
}

class _MainScreenState extends State<MainScreen> {
  String screen;

  _MainScreenState(this.screen);

  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  String _subject;
  String _titleSubject;
  double _fontSize = 35;
  double _titleFontSize = 27;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        closeTopContainer = controller.offset > 10;
      });
    });
    if (screen == 'Pure') {
      setState(() {
        _subject = 'PURE\nMATHS';
        _titleSubject = 'PURE MATHS';
      });
    } else if (screen == 'Applied') {
      setState(() {
        _subject = 'APPLIED\nMATHS';
        _titleSubject = 'APPLIED MATHS';
      });
    } else {
      setState(() {
        _subject = 'PAST PAPERS\n& MARKING\nSCHEMES';
        _titleSubject = 'PAST PAPERS &\nMARKING SCHEMES';
        _fontSize = 25;
        _titleFontSize = 20;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CommonBackground(
      appBarTitle: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: closeTopContainer ? 1 : 0,
        child: Text(
          _titleSubject,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            height: 0.8,
            fontFamily: 'Gabriola',
            fontSize: _titleFontSize,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: closeTopContainer ? 0 : 1,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: closeTopContainer ? 0 : size.height,
              child: Stack(
                children: [
                  Align(
                    child: Transform.rotate(
                      angle: pi / 15,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.89,
                        child: CustomPaint(
                          painter: ShapeDrawer(),
                          child: Container(),
                        ),
                      ),
                    ),
                    alignment: Alignment(4, -1.3),
                  ),
                  Align(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.47,
                      child: Image.asset('assets/Main_Screen_Icon.png'),
                    ),
                    alignment: Alignment(0.7, -0.77),
                  ),
                  Align(
                    child: Text(
                      _subject,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'Falcon',
                        fontSize: _fontSize,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              color: Colors.grey.shade800,
                              offset: Offset(2, 2),
                              blurRadius: 5)
                        ],
                      ),
                    ),
                    alignment: Alignment(-0.8, -0.95),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: closeTopContainer ? 0 : size.height * 0.375,
                ),
                AnimatedContainer(
                  onEnd: () {
                    setState(() {
                      controller.dispose();
                    });
                  },
                  duration: Duration(milliseconds: 500),
                  width: size.width * 0.95,
                  height: closeTopContainer ? size.height * 0.87 : size.height * 0.49,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: screen == 'Pure'
                        ? Content('Pure')
                        : screen == 'Applied'
                        ? Content('Applied')
                        : PastPapersAndMarkingSchemes(widget.dataStatus),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade900.withOpacity(0.3),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
