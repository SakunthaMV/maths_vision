import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../Diary/diary_home_screen.dart';
import '../Event_1/account_screen.dart';
import '../Event_1/leaderboard.dart';
import '../Event_1/store.dart';
import '../Log_In/log_in_screen.dart';
import '../Splash_Screens/went_home_splash_screen.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget leading;
  final String page;

  const HomeAppBar({Key key, this.leading, this.page}) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _HomeAppBarState extends State<HomeAppBar> {
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
    user = FirebaseAuth.instance.currentUser;
    checkInternet();
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
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: widget.leading ??
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) {
                    return WentHomeSplashScreen();
                  },
                ),
              );
            },
            splashRadius: 20,
            splashColor: Colors.grey.shade600,
            highlightColor: Colors.black.withOpacity(0.2),
            iconSize: 30,
            color: Colors.white,
          ),
      actions: [
        Builder(
          builder: (context) {
            if (user == null) {
              return SizedBox.shrink();
            }
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
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10),
                      child: InkWell(
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
                    ),
                    Container(
                      width: 60,
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'lv $level',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'Forte',
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        ),
        _actionButton(Icons.article, DiaryHomeScreen(), 'Notice'),
        _actionButton(Icons.emoji_events_rounded, LeaderBoard(), 'Leaderboard'),
        _actionButton(Icons.person, AccountScreen(), 'Account')
      ],
    );
  }

  Widget _actionButton(IconData icon, Widget screen, String page) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      splashRadius: 20,
      splashColor: Colors.grey.shade600,
      highlightColor: Colors.black.withOpacity(0.2),
      iconSize: 30,
      color: colorScheme.primary,
      icon: IconShadowWidget(
        Icon(
          icon,
          color: colorScheme.primary,
          size: 30,
        ),
        showShadow: widget.page == null
            ? true
            : widget.page == page
                ? true
                : false,
        shadowColor: widget.page == null
            ? Colors.black.withOpacity(0.3)
            : widget.page == page
                ? Colors.black
                : null,
      ),
      onPressed: () {
        if (widget.page == page) {
          return null;
        }
        if (user == null) {
          _logInErrorPopUp(context);
          return;
        }
        if (!_hasConnection) {
          if(widget.leading==null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) {
                  return WentHomeSplashScreen();
                },
              ),
            );
            Fluttertoast.showToast(
              msg: 'Your connection has been disconnected.',
              fontSize: 16,
            );
            return;
          }
          Fluttertoast.showToast(
            msg: 'You need an internet connection to continue.',
            fontSize: 16,
          );
          return;
        }
        if(widget.leading==null){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) {
                return screen;
              },
            ),
          );
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return screen;
            },
          ),
        );
      },
    );
  }

  Future<void> _logInErrorPopUp(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.asset('assets/Log_In_Error_Icon.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'You must be logged in to access this feature.',
                    style: TextStyle(
                      fontFamily: 'Philosopher',
                      fontSize: 20,
                      wordSpacing: 1.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black.withOpacity(0.8),
                      shadows: [],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) {
                                return LogInScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Philosopher',
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Color.fromARGB(255, 1, 79, 134),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text(
                          'Ok',
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Philosopher',
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Color.fromARGB(255, 1, 79, 134),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
