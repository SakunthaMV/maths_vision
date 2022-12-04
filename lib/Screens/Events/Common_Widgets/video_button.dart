import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../Models/event_data.dart';
import '../../Special/Store/store.dart';
import '../Video_Display/video_display_screen.dart';

class VideoButton extends StatefulWidget {
  final int stage;
  final bool dialog;

  const VideoButton(this.stage, this.dialog, {Key key}) : super(key: key);

  @override
  State<VideoButton> createState() => _VideoButtonState();
}

class _VideoButtonState extends State<VideoButton> {
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

  User user;

  @override
  void initState() {
    super.initState();
    checkInternet();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  Widget loading = SizedBox(
    height: 70,
    child: LoadingAnimationWidget.threeArchedCircle(
      color: Colors.white,
      size: 40,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (!(_hasConnection ?? false)) {
        return loading;
      }
      return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .collection('Trigonometry_Event')
              .doc('Stages')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loading;
            }
            bool videoPurchased = snapshot.data['Stage_${widget.stage}.Info.Video.purchased'];
            return InkWell(
              onTap: () {
                if (widget.dialog) {
                  return null;
                }
                if (videoPurchased) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return VideoDisplayScreen(widget.stage);
                      },
                    ),
                  );
                } else {
                  videoBuyDialog(context);
                }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    width: 120,
                    height: 70,
                    padding: EdgeInsets.fromLTRB(0, 5, 12, 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 172, 140, 92),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          spreadRadius: 0.5,
                          color: Colors.black.withOpacity(widget.dialog ? 0.3 : 0.7),
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 65,
                          height: 13,
                          margin: EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 111, 136, 147),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.3),
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Trigonometry',
                              style: TextStyle(
                                fontSize: 8,
                                fontFamily: 'Blenda Script',
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.0,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0.5, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Stage',
                                style: TextStyle(
                                  fontFamily: 'Copperplate Gothic Light',
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0.0,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.35),
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${widget.stage == 10 ? '' : '0'}${widget.stage}',
                                    style: TextStyle(
                                      fontFamily: 'Blenda Script',
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0.0,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 2,
                                          color: Colors.black.withOpacity(0.35),
                                          offset: Offset(0.5, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Builder(builder: (context) {
                              double opacity = 0.0;
                              if (videoPurchased) {
                                opacity = 1.0;
                              }
                              if (widget.dialog) {
                                opacity = 1.0;
                              }
                              return Opacity(
                                opacity: opacity,
                                child: Stack(
                                  alignment: AlignmentDirectional.centerStart,
                                  children: [
                                    Transform.rotate(
                                      angle: pi / 2,
                                      child: Container(
                                        width: 24,
                                        height: 19,
                                        margin: EdgeInsets.only(
                                          left: 1.5,
                                          bottom: 1,
                                        ),
                                        child: Image.asset(
                                          'assets/Play_Triangle.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.play_arrow,
                                      color: Colors.black,
                                      size: 23,
                                    )
                                  ],
                                ),
                              );
                            }),
                            Text(
                              'Lesson',
                              style: TextStyle(
                                fontFamily: 'Colonna MT',
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.0,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.4),
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Builder(builder: (context) {
                    if (videoPurchased) {
                      return SizedBox.shrink();
                    }
                    if (widget.dialog) {
                      return SizedBox.shrink();
                    }
                    return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          width: 120,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 1, 79, 134).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Transform.scale(
                          scale: 1.3,
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              Transform.rotate(
                                angle: pi / 2,
                                child: Container(
                                  width: 24,
                                  height: 19,
                                  margin: EdgeInsets.only(
                                    left: 1.5,
                                    bottom: 1,
                                  ),
                                  child: Image.asset(
                                    'assets/Play_Triangle.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                                size: 23,
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            );
          });
    });
  }

  Future<void> videoBuyDialog(BuildContext context) {
    CollectionReference userData = FirebaseFirestore.instance.collection('Users');
    DocumentReference stageData =
        userData.doc(user.uid).collection('Trigonometry_Event').doc('Stages');
    CollectionReference eventInfo = FirebaseFirestore.instance.collection('Events');
    DocumentReference stageInfo =
        eventInfo.doc('Trigonometry').collection('Stages').doc('Stage_${widget.stage}');
    int videoPrice = videoPrices[widget.stage - 1];
    return showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 60, 20, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 2,
                  child: VideoButton(widget.stage, true),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 55, 10, 15),
                  child: Text(
                    'This Video will help you to solve the questions of the Stage '
                    '${widget.stage < 10 ? '0' : ''}${widget.stage}.',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.0,
                      wordSpacing: 1.0,
                      color: Colors.black,
                      shadows: [],
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.9,
                  child: SizedBox(
                    width: 110,
                    height: 50,
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(user.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed: () async {
                              if (!_hasConnection) {
                                Fluttertoast.showToast(
                                  msg: "You don't have internet connection.",
                                );
                                return;
                              }
                              if (snapshot.hasData) {
                                int coins = snapshot.data['User_Details.coins'];
                                if (coins > videoPrice) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return VideoDisplayScreen(widget.stage);
                                      },
                                    ),
                                  );
                                  await userData.doc(user.uid).update({
                                    'User_Details.coins': FieldValue.increment(-videoPrice),
                                  });
                                  await stageData.update({
                                    'Stage_${widget.stage}.Info.Video.purchased': true,
                                  });
                                  await eventInfo.doc('All_Events').update({
                                    'AllVideoBought': FieldValue.increment(1),
                                  });
                                  await eventInfo.doc('Trigonometry').update({
                                    'TotalVideoBought': FieldValue.increment(1),
                                  });
                                  await stageInfo.update({
                                    'Video.PurchaseCount': FieldValue.increment(1),
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "You don't have enough coins.",
                                  );
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return Store();
                                      },
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 1, 79, 134),
                              padding: EdgeInsets.only(left: 3, right: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(width: 3, color: Colors.black),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  height: 35,
                                  width: 110,
                                  color: Colors.black,
                                ),
                                Builder(builder: (context) {
                                  if (widget.stage == 1) {
                                    return Text(
                                      'Free',
                                      style: TextStyle(
                                        fontFamily: 'Crash',
                                        fontSize: 23,
                                        color: Colors.white,
                                        height: 0.9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${videoPrices[widget.stage - 1]}',
                                        style: TextStyle(
                                          fontFamily: 'Crash',
                                          fontSize: 23,
                                          color: Colors.white,
                                          height: 0.9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: 23,
                                        child: Image.asset('assets/Coin.png'),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
