import 'package:flutter/material.dart';

class RewardClass {
  final double fontSize;
  const RewardClass({this.fontSize = 27.0});
  Widget coinReward(int coins){
    return Row(
      children: [
        Text(
          '$coins',
          style: TextStyle(
            fontFamily: 'Gothic',
            fontSize: fontSize,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.0,
            height: 1,
            shadows: [
              Shadow(
                blurRadius: 1,
                offset: Offset(1, 1),
                color: Colors.black.withOpacity(0.4),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 4,
        ),
        SizedBox(
          width: fontSize,
          child: Image.asset('assets/Coin.png'),
        ),
      ],
    );
  }

  Widget xpReward(int xp, bool questionScreen, {bool xpDoubleUsed}){
    return Row(
      children: [
        Builder(builder: (context) {
          if ((xpDoubleUsed?? false) && questionScreen) {
            return TweenAnimationBuilder(
              tween: Tween(begin: xp, end: xp * 2.0),
              duration: Duration(seconds: 1),
              builder: (_, value, __) {
                return Text(
                  '${value.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontFamily: 'Gothic',
                    fontSize: fontSize,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.0,
                    height: 1,
                    shadows: [
                      Shadow(
                        blurRadius: 1,
                        offset: Offset(1, 1),
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Text(
            '$xp',
            style: TextStyle(
              fontFamily: 'Gothic',
              fontSize: fontSize,
              color: Colors.black,
              fontWeight: FontWeight.normal,
              height: 1,
              letterSpacing: 0.0,
              shadows: [
                Shadow(
                  blurRadius: 1,
                  offset: Offset(1, 1),
                  color: Colors.black.withOpacity(0.4),
                ),
              ],
            ),
          );
        }),
        SizedBox(
          width: 4,
        ),
        SizedBox(
          width: fontSize,
          child: Image.asset('assets/XP.png'),
        ),
      ],
    );
  }
}