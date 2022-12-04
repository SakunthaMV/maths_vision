import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Screens/Special/Collection/collection.dart';
import 'package:maths_vision/Models/questions_data.dart';

class DailyBonusTab extends StatefulWidget {
  const DailyBonusTab({Key key}) : super(key: key);

  @override
  _DailyBonusTabState createState() => _DailyBonusTabState();
}

class _DailyBonusTabState extends State<DailyBonusTab> {
  List<String> days = ['two', 'three', 'four', 'five', 'six', 'seven'];
  User user;
  CollectionReference _bonusData = FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: width * 0.05,
        ),
        Expanded(
          child: Container(
            width: width * 0.9,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 110, 187, 192),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -10.2,
                  bottom: 70.5,
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: Container(
                      width: 3,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 120,
                  child: Container(
                    width: 3,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 3.6,
                  bottom: 219,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -10.2,
                  top: 70.5,
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: Container(
                      width: 3,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 120,
                  child: Container(
                    width: 3,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 3.6,
                  top: 219,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: _bonusData.doc(user.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      int dayCount = snapshot.data['LogIn_Details.loginDays'];
                      Map ownData = snapshot.data['LogIn_Details.Owned_Days'];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.05,
                          right: width * 0.05,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            top: 20,
                            bottom: 20,
                            left: width * 0.02,
                            right: width * 0.02,
                          ),
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color.fromARGB(255, 106, 197, 254),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'DAY 0${index + 1}',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 30,
                                            letterSpacing: 0.7,
                                            color: Colors.black,
                                            height: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 2.3),
                                          width: width * 0.4,
                                          child: Text(
                                            index == 0
                                                ? 'Logged in one day.'
                                                : 'Logged in for ${days[index - 1]} days consecutively',
                                            style: TextStyle(
                                              fontFamily: 'Roboto Regular',
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 2,
                                                  offset: Offset(0.5, 0.5),
                                                  color: Colors.black.withOpacity(0.4),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      height: 40,
                                      width: 90,
                                      child: ElevatedButton(
                                        onPressed:
                                            dayCount > (index) && !ownData['${index + 1}']
                                                ? () {
                                                    _loginPopup(context, index);
                                                  }
                                                : null,
                                        child: Container(
                                          height: 40,
                                          width: 90,
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40),
                                            gradient: dayCount > (index)
                                                ? !ownData['${index + 1}']
                                                    ? LinearGradient(
                                                        colors: [
                                                          Color.fromARGB(255, 239, 197, 1),
                                                          Color.fromARGB(255, 249, 224, 159),
                                                          Color.fromARGB(255, 239, 197, 1),
                                                        ],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      )
                                                    : LinearGradient(
                                                        colors: [
                                                          Color.fromARGB(255, 154, 143, 151),
                                                          Color.fromARGB(255, 229, 229, 229),
                                                          Color.fromARGB(255, 154, 143, 151),
                                                        ],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      )
                                                : LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(255, 197, 197, 197),
                                                      Color.fromARGB(255, 229, 229, 229),
                                                      Color.fromARGB(255, 197, 197, 197),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3,
                                                color: Colors.black.withOpacity(0.4),
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: FittedBox(
                                              child: Text(
                                                ownData['${index + 1}'] ? 'OWNED' : 'CLAIM',
                                                style: TextStyle(
                                                  fontFamily: 'Open Sans',
                                                  fontSize: ownData['${index + 1}'] ? 16 : 18,
                                                  color: Colors.white,
                                                  letterSpacing: 2,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 2,
                                                      offset: Offset(1, 1),
                                                      color: Colors.black.withOpacity(0.9),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(0),
                                          shape: StadiumBorder(),
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
                    } else {
                      return LoadingBouncingLine.circle(
                        size: 100,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: width * 0.05,
        ),
      ],
    );
  }

  Future<void> _loginPopup(BuildContext context, int index) async {
    int stage;
    int question;
    if (index == 0) {
      stage = Random().nextInt(4) + 2;
      question = Random().nextInt(questions['stage$stage'].length) + 1;
    } else if (index == 2) {
      stage = Random().nextInt(5) + 6;
      question = Random().nextInt(questions['stage$stage'].length) + 1;
    } else if (index == 3) {
      stage = Random().nextInt(9) + 2;
      question = Random().nextInt(questions['stage$stage'].length) + 1;
    } else if (index == 4) {
      stage = Random().nextInt(9) + 2;
    }
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 15),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Login Bonus',
                  style: TextStyle(
                    fontFamily: 'Perpetua Titling MT Light',
                    letterSpacing: 0.7,
                    fontSize: 22,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 30),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Niagara Solid',
                        letterSpacing: 0.3,
                      ),
                      children: [
                        TextSpan(
                          text: '${index + 1}',
                        ),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(1.0, -10.0),
                            child: Text(
                              '${index == 0 ? 'st' : index == 1 ? 'nd' : index == 2 ? 'rd' : 'th'}',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Niagara Solid',
                                letterSpacing: 0.3,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: ' Day Reword',
                        ),
                      ],
                    ),
                  ),
                ),
                index == 1 || index == 5 || index == 6
                    ? Center(
                        child: Transform.scale(
                          scale: 1.5,
                          child: SizedBox(
                            width: 160,
                            child: Stack(
                              children: [
                                index == 6
                                    ? Image.asset('assets/Double_Coin_Bonus_Card.png')
                                    : Image.asset('assets/Double_XP_Card.png'),
                                index == 5
                                    ? Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '2',
                                              style: TextStyle(
                                                fontFamily: 'Blenda Script',
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Transform.scale(
                          scale: 1.5,
                          child: SizedBox(
                            width: 160,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                index == 4
                                    ? Image.asset('assets/Video_Coupon.png')
                                    : index == 3
                                        ? Image.asset('assets/Answer_Coupon_60.png')
                                        : Image.asset('assets/Answer_Coupon_40.png'),
                                index == 4
                                    ? Positioned(
                                        left: stage == 10 ? 20 : 25,
                                        child: Transform.scale(
                                          scale: 0.65,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 36,
                                                  fontFamily: 'Ateeca',
                                                  letterSpacing: 2,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: 'S',
                                                  ),
                                                  WidgetSpan(
                                                    child: Transform.translate(
                                                      offset: const Offset(1.0, 3.0),
                                                      child: Text(
                                                        '$stage',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17,
                                                          fontFamily: 'Ateeca',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Positioned(
                                        left: question > 9 || stage == 10 ? 22 : 25,
                                        top: 17,
                                        child: Transform.scale(
                                          scale: 0.45,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 36,
                                                    fontFamily: 'Ateeca',
                                                    letterSpacing: 2,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'S',
                                                    ),
                                                    WidgetSpan(
                                                      child: Transform.translate(
                                                        offset: const Offset(1.0, 3.0),
                                                        child: Text(
                                                          '$stage',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 17,
                                                            fontFamily: 'Ateeca',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 36,
                                                    fontFamily: 'Ateeca',
                                                    letterSpacing: 2,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'Q',
                                                    ),
                                                    WidgetSpan(
                                                      child: Transform.translate(
                                                        offset: const Offset(1.0, 3.0),
                                                        child: Text(
                                                          '$question',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 17,
                                                            fontFamily: 'Ateeca',
                                                          ),
                                                        ),
                                                      ),
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              if (index == 0 || index == 2 || index == 3) {
                                _loginUpdates(index, stage: stage, question: question);
                              } else if (index == 1 || index == 5 || index == 6) {
                                _loginUpdates(index);
                              } else {
                                _loginUpdates(index, stage: stage);
                              }
                              Navigator.pop(context, false);
                            },
                            child: Text(
                              'Collect',
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: OutlinedButton(
                            onPressed: () {
                              if (index == 0 || index == 2 || index == 3) {
                                _loginUpdates(index, stage: stage, question: question);
                              } else if (index == 1 || index == 5 || index == 6) {
                                _loginUpdates(index);
                              } else {
                                _loginUpdates(index, stage: stage);
                              }
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) {
                                    return Collection();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Collect and go to Collection',
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 0.3,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(),
                              side: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _loginUpdates(int index, {int stage, int question}) async {
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    CollectionReference eventData = FirebaseFirestore.instance.collection('Events');
    String L = 'LogIn_Details';
    String O = 'Owned_Days';
    String G = 'Collection';
    String C = 'Coupons';
    String cA = 'Answer_Coupons';
    String cV = 'Video_Coupons';
    String D = 'Double_XP_Cards';
    String dS = 'Silver_Double_XP';
    String B = 'Bonus_Cards';
    if (index == 0) {
      userData.update({
        '$L.$O.1': true,
        '$G.$C.$cA.S${stage}Q${question}T40.stage': stage,
        '$G.$C.$cA.S${stage}Q${question}T40.question': question,
        '$G.$C.$cA.S${stage}Q${question}T40.quantity': FieldValue.increment(1),
        '$G.$C.$cA.S${stage}Q${question}T40.forty': true,
      });
      eventData.doc('All_Events').update({
        'LogIn_Own_Details.AllFirstDayOwned': FieldValue.increment(1),
      });
      eventData.doc('Trigonometry').update({
        'LogIn_Own_Details.TotalFirstDayOwned': FieldValue.increment(1),
      });
    } else if (index == 1) {
      userData.update({
        '$L.$O.2': true,
        '$G.$D.$dS.available': FieldValue.increment(1),
      });
      eventData.doc('All_Events').update({
        'LogIn_Own_Details.AllSecondDayOwned': FieldValue.increment(1),
      });
      eventData.doc('Trigonometry').update({
        'LogIn_Own_Details.TotalSecondDayOwned': FieldValue.increment(1),
      });
    } else if (index == 2) {
      userData.update({
        '$L.$O.3': true,
        '$G.$C.$cA.S${stage}Q${question}T40.stage': stage,
        '$G.$C.$cA.S${stage}Q${question}T40.question': question,
        '$G.$C.$cA.S${stage}Q${question}T40.quantity': FieldValue.increment(1),
        '$G.$C.$cA.S${stage}Q${question}T40.forty': true,
      });
      eventData.doc('All_Events').update({
        'LogIn_Own_Details.AllThirdDayOwned': FieldValue.increment(1),
      });
      eventData.doc('Trigonometry').update({
        'LogIn_Own_Details.TotalThirdDayOwned': FieldValue.increment(1),
      });
    } else if (index == 3) {
      userData.update({
        '$L.$O.4': true,
        '$G.$C.$cA.S${stage}Q${question}T60.stage': stage,
        '$G.$C.$cA.S${stage}Q${question}T60.question': question,
        '$G.$C.$cA.S${stage}Q${question}T60.quantity': FieldValue.increment(1),
        '$G.$C.$cA.S${stage}Q${question}T60.forty': false,
      });
      eventData.doc('All_Events').update({
        'LogIn_Own_Details.AllFourthDayOwned': FieldValue.increment(1),
      });
      eventData.doc('Trigonometry').update({
        'LogIn_Own_Details.TotalFourthDayOwned': FieldValue.increment(1),
      });
    } else if (index == 4) {
      userData.update({
        '$L.$O.5': true,
        '$G.$C.$cV.S$stage.stage': stage,
        '$G.$C.$cV.S$stage.quantity': FieldValue.increment(1),
      });
      eventData.doc('All_Events').update({
        'LogIn_Own_Details.AllFifthDayOwned': FieldValue.increment(1),
      });
      eventData.doc('Trigonometry').update({
        'LogIn_Own_Details.TotalFifthDayOwned': FieldValue.increment(1),
      });
    } else if (index == 5) {
      userData.update({
        '$L.$O.6': true,
        '$G.$D.$dS.available': FieldValue.increment(2),
      });
      eventData.doc('All_Events').update({
        'LogIn_Own_Details.AllSixthDayOwned': FieldValue.increment(1),
      });
      eventData.doc('Trigonometry').update({
        'LogIn_Own_Details.TotalSixthDayOwned': FieldValue.increment(1),
      });
    } else if (index == 6) {
      userData.update({
        '$L.$O.7': true,
        '$G.$B.available': FieldValue.increment(1),
      });
      eventData.doc('All_Events').update({
        'LogIn_Own_Details.AllSeventhDayOwned': FieldValue.increment(1),
      });
      eventData.doc('Trigonometry').update({
        'LogIn_Own_Details.TotalSeventhDayOwned': FieldValue.increment(1),
      });
    }
  }
}
