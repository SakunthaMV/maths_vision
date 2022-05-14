import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import 'golden_stage_home_screen.dart';

class GoldenLevelUpScreen extends StatefulWidget {
  final int newLevel;
  final int pastLevelXP;
  final int toLevelUpEarnedXP;

  const GoldenLevelUpScreen(this.newLevel, this.pastLevelXP, this.toLevelUpEarnedXP, {Key key})
      : super(key: key);

  @override
  _GoldenLevelUpScreenState createState() => _GoldenLevelUpScreenState();
}

class _GoldenLevelUpScreenState extends State<GoldenLevelUpScreen>
    with TickerProviderStateMixin {
  Map<String, List> quotes = {
    'topQuote': [
      'Good effort!',
      'Good going!',
      'Good work!',
      'Keep it up!',
      'Keep on trying!',
      'Keep working on it',
      'Much better!',
      'Nice work!',
      'Right on!',
      'Super Duper!',
      'Superior work.',
      'Terrific!',
      'That’s better.',
      'That’s good!',
      'Very interesting.',
      'Wonderful!',
    ],
    'bottomQuote': [
      'You are doing a good job!',
      'You are learning a lot.',
      'You are learning fast.',
      'You must have been practicing.',
      'You’re doing a great job',
      'You’re getting better and better.',
      'You’re on the right track now.',
      'You’re really improving.',
      'Now you’ve figured it out.',
    ]
  };

  int _topQuote;
  int _bottomQuote;
  double _percent = 0.0;
  double _opacity = 0.0;
  double _numberOpacity = 0.0;
  double _buttonPosition = 1.2;
  double _buttonOpacity = 0.0;
  Color _shimmerColor = Color.fromARGB(255, 63, 129, 176);
  AnimationController _numberController;
  AnimationController _scaleController;
  AnimationController _textController;
  Animation<double> _scaleAnimation;
  Animation _numberScaleAnimation;
  Animation _textAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInQuart,
    );
    _numberController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _numberScaleAnimation = Tween(begin: 20.0, end: 1.0).animate(
      CurvedAnimation(parent: _numberController, curve: Curves.elasticOut),
    );
    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _textAnimation = Tween(
      begin: 0,
      end: (widget.toLevelUpEarnedXP).toDouble(),
    ).animate(_textController);
    _topQuote = Random().nextInt(quotes['topQuote'].length);
    _bottomQuote = Random().nextInt(quotes['bottomQuote'].length);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _numberController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return GoldenStageHomeScreen();
            },
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 1, 79, 134),
        body: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.1,
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 3,
                              bottom: 1,
                              top: 21,
                              right: 5,
                            ),
                            child: CircularPercentIndicator(
                              radius: 170,
                              percent: _percent,
                              backgroundColor: Colors.transparent,
                              animation: true,
                              animationDuration: 1500,
                              progressColor: Colors.white,
                              circularStrokeCap: CircularStrokeCap.round,
                              lineWidth: 6,
                            ),
                          ),
                          TweenAnimationBuilder(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 1500),
                            curve: Curves.linearToEaseOut,
                            builder: (_, scale, __) {
                              return Transform.scale(
                                scale: scale,
                                child: SizedBox(
                                  width: width,
                                  child: Image.asset('assets/Level_Up_Star.png'),
                                ),
                              );
                            },
                            onEnd: () {
                              setState(() {
                                _percent = 1.0;
                                _opacity = 1.0;
                              });
                              _scaleController.forward();
                            },
                          ),
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 1500),
                            opacity: _numberOpacity,
                            curve: Curves.fastOutSlowIn,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 3,
                                bottom: 1,
                                top: 29,
                                right: 5,
                              ),
                              child: AnimatedBuilder(
                                animation: _numberScaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _numberScaleAnimation.value,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white.withOpacity(0.0),
                                  child: Center(
                                    child: Text(
                                      '${widget.newLevel}',
                                      style: TextStyle(
                                        fontFamily: 'MontereyFLF',
                                        fontSize: 80,
                                        color: Colors.black,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        height: 90,
                      ),
                      TweenAnimationBuilder(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.linearToEaseOut,
                        builder: (_, scale, __) {
                          return Transform.scale(
                            scale: scale,
                            child: Shimmer.fromColors(
                              baseColor: Color.fromARGB(255, 0, 136, 145),
                              highlightColor: _shimmerColor,
                              child: Text(
                                'Congratulations !',
                                style: TextStyle(
                                  fontFamily: 'Blenda Script',
                                  fontSize: 42,
                                  color: Color.fromARGB(255, 0, 136, 145),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 1500),
                        opacity: _opacity,
                        onEnd: () {
                          _numberController.forward();
                          setState(() {
                            _numberOpacity = 1.0;
                            _buttonPosition = 0.8;
                            _buttonOpacity = 1.0;
                            _shimmerColor = Colors.white;
                          });
                          _textController.forward();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 30),
                          child: Text(
                            '${quotes['topQuote'][_topQuote]}\n${quotes['bottomQuote'][_bottomQuote]}',
                            style: TextStyle(
                              fontFamily: 'Dubai Regular',
                              fontSize: 23,
                              color: Colors.white,
                              height: 1.1,
                              letterSpacing: 0.7,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(1, 1),
                                )
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'LEVEL UP',
                        style: TextStyle(
                          fontSize: 42,
                          fontFamily: 'MontereyFLF',
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) {
                          return RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'AgencyFB',
                                fontSize: 23,
                                letterSpacing: 1,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 3,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ],
                              ),
                              children: [
                                TextSpan(
                                  text: '${widget.pastLevelXP}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 144, 146, 147),
                                  ),
                                ),
                                TextSpan(
                                  text: ' + ${(_textAnimation.value).toStringAsFixed(0)}',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 1500),
                alignment: Alignment(0, _buttonPosition),
                curve: Curves.fastOutSlowIn,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 1500),
                  opacity: _buttonOpacity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) {
                            return GoldenStageHomeScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 23,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.black,
                      padding: EdgeInsets.only(top: 3, bottom: 3, left: 20, right: 20),
                      elevation: 7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
