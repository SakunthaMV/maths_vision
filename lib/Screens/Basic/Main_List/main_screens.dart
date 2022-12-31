import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maths_vision/Models/subjects_data.dart';
import 'package:maths_vision/Screens/Home/home_screen.dart';
import 'package:maths_vision/Utilities/check_internet.dart';
import '../../../Widgets/common_background.dart';
import '../../../Widgets/event_errors_and_loading.dart';
import 'content.dart';

class MainScreen extends StatefulWidget {
  final String screen;

  const MainScreen(this.screen);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _controller = ScrollController();
  bool closeTopContainer = false;
  String _subject;
  String _titleSubject;
  double _fontSize = 35;
  double _titleFontSize = 27;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        closeTopContainer = _controller.offset > 10;
      });
    });
    if (widget.screen == 'Pure') {
      setState(() {
        _subject = 'PURE\nMATHS';
        _titleSubject = 'PURE MATHS';
      });
    } else if (widget.screen == 'Applied') {
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return CommonBackground(
      appBarTitle: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: closeTopContainer ? 1 : 0,
        child: Text(
          _titleSubject,
          textAlign: TextAlign.center,
          style: textTheme.headlineLarge.copyWith(
            height: 0.8,
            fontSize: _titleFontSize,
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
              height: closeTopContainer ? 0 : height,
              child: Stack(
                children: [
                  Align(
                    child: Transform.rotate(
                      angle: pi / 15,
                      child: SizedBox(
                        height: height * 0.4,
                        width: width * 0.89,
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
                      height: height * 0.25,
                      width: width * 0.47,
                      child: Image.asset('assets/Main_Screen_Icon.png'),
                    ),
                    alignment: Alignment(0.7, -0.77),
                  ),
                  Align(
                    child: Text(
                      _subject,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).primaryTextTheme.displayMedium.copyWith(
                            fontSize: _fontSize,
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
                  height: closeTopContainer ? 0 : height * 0.375,
                ),
                AnimatedContainer(
                  onEnd: () {
                    setState(() {
                      _controller.dispose();
                    });
                  },
                  duration: Duration(milliseconds: 500),
                  width: width * 0.95,
                  height: closeTopContainer ? height * 0.87 : height * 0.49,
                  child: Builder(builder: (context) {
                    int itemCount;
                    if (widget.screen == 'Pure') {
                      itemCount = pureSubjects.length;
                    } else if (widget.screen == 'Applied') {
                      itemCount = appliedSubjects.length;
                    } else {
                      if (!oneTimeCheck(context)) {
                        return Center(
                          child: NetworkError(color: colorScheme.onPrimary),
                        );
                      }
                      return pastPaperItemList(context, _controller);
                    }
                    return ListView.separated(
                      physics: BouncingScrollPhysics(),
                      controller: _controller,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      itemCount: itemCount,
                      itemBuilder: (BuildContext context, int index) {
                        return lesson(context, index, widget.screen);
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 1,
                          height: 1,
                          indent: width * 0.225,
                          endIndent: width * 0.03,
                        );
                      },
                    );
                  }),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
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
