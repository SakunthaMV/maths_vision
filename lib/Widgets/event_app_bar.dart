import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../Event_1/account_screen.dart';
import '../Event_1/leaderboard.dart';
import '../Event_1/store.dart';
import '../Splash_Screens/went_home_splash_screen.dart';

class EventAppBar extends StatefulWidget implements PreferredSizeWidget {
  final backgroundColor;
  const EventAppBar({Key key, this.backgroundColor}) : super(key: key);

  @override
  State<EventAppBar> createState() => _EventAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _EventAppBarState extends State<EventAppBar> {
  bool _hasConnection;
  StreamSubscription _subscription;

  User user;

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

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: widget.backgroundColor?? Colors.transparent,
      elevation: 0,
      toolbarHeight: 60,
      leadingWidth: (_hasConnection?? true)? 70: 0,
      title: Builder(
        builder: (context) {
          if(_hasConnection?? true){
            return SizedBox.shrink();
          }
          return Center(
            child: Text(
              'No Internet Connection',
              style: GoogleFonts.openSans(
                fontSize: 18,
                color: Colors.white,
                letterSpacing: 0.2,
                shadows: [
                  Shadow(
                    blurRadius: 1,
                    offset: Offset(1,1),
                    color: Colors.black.withOpacity(0.4),
                  )
                ]
              ),
            ),
          );
        }
      ),
      leading: Builder(
        builder: (context) {
          if(_hasConnection==null){
            return SizedBox.shrink();
          }
          if(!_hasConnection){
            return SizedBox.shrink();
          }
          return InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return LeaderBoard();
                  },
                ),
              );
            },
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Leaderboard_Icon.png'),
                      fit: BoxFit.fill,
                      scale: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
      actions: [
        Builder(builder: (context) {
          if (!(_hasConnection ?? false)) {
            return SizedBox.shrink();
          }
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }
              int coins = snapshot.data['User_Details.coins'];
              int level = snapshot.data['User_Details.level'];
              String imgURL = snapshot.data['User_Details.photoURL'];
              int xp = snapshot.data['User_Details.xp'];
              int sumOfN = 0;
              int sumOfBeforeN = 0;
              int currentLevelXP;
              int currentLevelTotalXP;
              for (int i = 1; i < 150; i += 1) {
                sumOfN += i;
                sumOfBeforeN += i - 1;
                int levelNValue = sumOfN * 10;
                int levelBeforeNValue = sumOfBeforeN * 10;
                if (levelNValue > xp) {
                  currentLevelXP = xp - levelBeforeNValue;
                  currentLevelTotalXP = levelNValue - levelBeforeNValue;
                  break;
                }
              }
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return Store();
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 25,
                      width: 95,
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(12.5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: SizedBox(
                              child: Image.asset('assets/Coin.png'),
                              height: 20,
                              width: 20,
                            ),
                          ),
                          Text(
                            '$coins',
                            style: TextStyle(
                              fontFamily: 'Forte',
                              fontSize: 17,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 139, 205, 250),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 15,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 55, 82, 100),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$level',
                        style: TextStyle(
                          fontFamily: 'Cambria',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.4),
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  LinearPercentIndicator(
                    width: 80.0,
                    lineHeight: 15.0,
                    percent: currentLevelXP / currentLevelTotalXP,
                    barRadius: Radius.circular(7.5),
                    progressColor: Color.fromARGB(255, 111, 164, 200),
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(0.0),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return AccountScreen();
                              },
                            ),
                          );
                        },
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return WentHomeSplashScreen();
                              },
                            ),
                          );
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            ClipOval(
                              child: SizedBox(
                                width: 43,
                                height: 43,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: imgURL,
                                  placeholder: (_, url) {
                                    return CircularProgressIndicator();
                                  },
                                  errorWidget: (context, url, error) {
                                    return Icon(
                                      Icons.account_circle_rounded,
                                      size: 43,
                                      color: Color.fromARGB(255, 202, 202, 202),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ],
    );
  }
}
