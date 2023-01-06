import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:maths_vision/Services/ad_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Models/event_data.dart';

class LevelUpScreen extends StatefulWidget {
  final int newLevel;
  final int pastLevelXP;
  final int toLevelUpEarnedXP;

  const LevelUpScreen(this.newLevel, this.pastLevelXP, this.toLevelUpEarnedXP, {Key key})
      : super(key: key);

  @override
  _LevelUpScreenState createState() => _LevelUpScreenState();
}

class _LevelUpScreenState extends State<LevelUpScreen> with TickerProviderStateMixin {
  int _topQuote;
  int _bottomQuote;
  double _percent = 0.0;
  double _opacity = 0.0;
  double _numberOpacity = 0.0;
  double _buttonOpacity = 0.0;
  Color _shimmerColor = Color.fromARGB(255, 63, 129, 176);
  AnimationController _numberController;
  AnimationController _scaleController;
  AnimationController _textController;
  Animation<double> _scaleAnimation;
  Animation _numberScaleAnimation;
  Animation _textAnimation;

  InterstitialAd _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdManager.interstitialLevelUp,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
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
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _numberController.dispose();
    _textController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 79, 134),
      body: Center(
        child: FittedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                      radius: 85,
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
                          padding: EdgeInsets.only(right: widget.newLevel >= 100 ? 9 : 0),
                          child: Center(
                            child: FittedBox(
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
                  ),
                ],
              ),
              ScaleTransition(
                scale: _scaleAnimation,
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
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.3),
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
                              fontSize: 25,
                              letterSpacing: 1,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.6),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 1500),
                  curve: Curves.linearToEaseOut,
                  builder: (_, scale, __) {
                    return Transform.scale(
                      scale: scale,
                      child: Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 0, 136, 145),
                        highlightColor: _shimmerColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: FittedBox(
                            child: Text(
                              'Congratulations !',
                              style: TextStyle(
                                fontFamily: 'Blenda Script',
                                fontSize: 42,
                                color: Color.fromARGB(255, 0, 136, 145),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 1500),
                opacity: _opacity,
                onEnd: () {
                  _numberController.forward();
                  setState(() {
                    _numberOpacity = 1.0;
                    _buttonOpacity = 1.0;
                    _shimmerColor = Colors.white;
                  });
                  _textController.forward();
                },
                child: Text(
                  '${quotes['topQuote'][_topQuote]}\n${quotes['bottomQuote'][_bottomQuote]}',
                  style: TextStyle(
                    fontFamily: 'Dubai Regular',
                    fontSize: 23,
                    color: Colors.white,
                    height: 1.1,
                    letterSpacing: 0.0,
                    wordSpacing: 1.0,
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
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 1500),
                  opacity: _buttonOpacity,
                  child: ElevatedButton(
                    onPressed: () {
                      if(_interstitialAd!=null){
                        _interstitialAd.show();
                      }
                      Navigator.pop(context, false);
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 23,
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.black,
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
