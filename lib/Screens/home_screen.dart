import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Diary/diary_home_screen.dart';
import 'package:maths_vision/Event_1/account_screen.dart';
import 'package:maths_vision/Event_1/collection.dart';
import 'package:maths_vision/Event_1/store.dart';
import 'package:maths_vision/Log_In/log_in_screen.dart';
import 'package:maths_vision/Splash_Screens/go_event_splash_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'main_screens.dart';
import 'navigation_drawer.dart';
import 'package:maths_vision/Event_1/leaderboard.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasConnection;
  StreamSubscription _subscription;
  Color _fabBackgroundColor = Color.fromARGB(255, 1, 79, 134);
  double _progress = 0.0;
  double sizeEvent = 80.0;

  final auth = FirebaseAuth.instance;
  DocumentSnapshot userData;
  DocumentSnapshot _loginData;
  int _coins;
  int _level;

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

  Future<void> _getUserData() async {
    userData = user != null
        ? await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Trigonometry_Event')
            .doc('Event_Info')
            .get()
        : null;
  }

  Future<void> _loginDetails() async {
    DocumentReference time = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    if (DateTime.now().month - _loginData['LogIn_Details.month'] == 0) {
      if (DateTime.now().day - _loginData['LogIn_Details.day'] == 0) {
        return null;
      } else if (DateTime.now().day - _loginData['LogIn_Details.day'] == 1) {
        if (_loginData['LogIn_Details.loginDays'] >= 7) {
          await time.update({
            'LogIn_Details.loginDays': 1,
            'LogIn_Details.day': DateTime.now().day,
            'LogIn_Details.Owned_Days': {
              '1': false,
              '2': false,
              '3': false,
              '4': false,
              '5': false,
              '6': false,
              '7': false,
            },
          });
        } else {
          await time.update({
            'LogIn_Details.loginDays': FieldValue.increment(1),
            'LogIn_Details.day': DateTime.now().day,
          });
        }
      } else {
        await time.update({
          'LogIn_Details.loginDays': 1,
          'LogIn_Details.day': DateTime.now().day,
          'LogIn_Details.Owned_Days': {
            '1': false,
            '2': false,
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
          },
        });
      }
    } else if (DateTime.now().month - _loginData['LogIn_Details.month'] == 1 ||
        DateTime.now().month - _loginData['LogIn_Details.month'] == -11) {
      if (DateTime.now().day == 1) {
        if (_loginData['LogIn_Details.loginDays'] >= 7) {
          await time.update({
            'LogIn_Details.loginDays': 1,
            'LogIn_Details.day': DateTime.now().day,
            'LogIn_Details.month': DateTime.now().month,
            'LogIn_Details.Owned_Days': {
              '1': false,
              '2': false,
              '3': false,
              '4': false,
              '5': false,
              '6': false,
              '7': false,
            },
          });
        } else {
          await time.update({
            'LogIn_Details.loginDays': FieldValue.increment(1),
            'LogIn_Details.day': DateTime.now().day,
            'LogIn_Details.month': DateTime.now().month,
          });
        }
      } else {
        await time.update({
          'LogIn_Details.loginDays': 1,
          'LogIn_Details.day': DateTime.now().day,
          'LogIn_Details.month': DateTime.now().month,
          'LogIn_Details.Owned_Days': {
            '1': false,
            '2': false,
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
          },
        });
      }
    } else {
      await time.update({
        'LogIn_Details.loginDays': 1,
        'LogIn_Details.day': DateTime.now().day,
        'LogIn_Details.month': DateTime.now().month,
        'LogIn_Details.Owned_Days': {
          '1': false,
          '2': false,
          '3': false,
          '4': false,
          '5': false,
          '6': false,
          '7': false,
        },
      });
    }
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    checkInternet().whenComplete(() {
      if (_hasConnection) {
        if (user != null) {
          DocumentReference userData =
              FirebaseFirestore.instance.collection('Users').doc(user.uid);
          userData.snapshots().listen((doc) {
            setState(() {
              _coins = doc['User_Details.coins'];
              _level = doc['User_Details.level'];
            });
          });
          userData.get().then((doc) {
            setState(() {
              _loginData = doc;
            });
          }).then((value) {
            return _loginDetails();
          });
          _getUserData();
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    Timer(Duration(microseconds: 300), () {
      setState(() {
        user == null
            ? _progress = 0.0
            : userData == null
                ? _progress = 0.0
                : _progress = userData['progress'];
      });
    });
    return Stack(
      children: [
        Container(
          color: colorScheme.background,
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
        Transform.rotate(
          angle: pi,
          child: SizedBox(
            height: height * 0.55,
            width: width,
            child: CustomPaint(
              painter: BackgroundColor(),
              child: Container(),
            ),
          ),
        ),
        WillPopScope(
          onWillPop: () => showDialog<bool>(
            context: context,
            builder: (c) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: colorScheme.onPrimary),
                ),
                contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
                content: Text(
                  'Are you sure you want to quit Maths Vision?',
                  style: textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Yes, Quit Now',
                      style: textTheme.labelMedium.copyWith(
                        fontSize: 16,
                        color: Color.fromARGB(255, 20, 14, 94),
                      ),
                    ),
                    onPressed: () => SystemNavigator.pop(),
                  ),
                  TextButton(
                    child: Text(
                      'No',
                      style: textTheme.labelMedium.copyWith(
                        fontSize: 16,
                        color: Color.fromARGB(255, 20, 14, 94),
                      ),
                    ),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              ),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    iconSize: 30,
                    icon: Icon(
                      Icons.menu,
                      color: colorScheme.primary,
                      size: 30,
                    ),
                    onPressed: () {
                      // return Scaffold.of(context).openDrawer();
                      print(user);
                    },
                  );
                },
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                Builder(
                  builder: (context) {
                    if (user == null) {
                      return SizedBox.shrink();
                    }
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
                                    '$_coins',
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
                              'lv $_level',
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
                ),
                IconButton(
                  icon: IconShadowWidget(
                    Icon(
                      Icons.article,
                      color: colorScheme.primary,
                      size: 30,
                    ),
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  onPressed: () {
                    if (user != null) {
                      if (_hasConnection) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return DiaryHomeScreen();
                            },
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'You need internet connection to continue.',
                          fontSize: 16,
                        );
                      }
                    } else {
                      _logInErrorPopUp(context);
                    }
                  },
                  splashRadius: 20,
                  splashColor: Colors.grey.shade600,
                  highlightColor: Colors.black.withOpacity(0.2),
                  iconSize: 30,
                  color: colorScheme.primary,
                ),
                IconButton(
                  icon: IconShadowWidget(
                    Icon(
                      Icons.emoji_events_rounded,
                      color: colorScheme.primary,
                      size: 30,
                    ),
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  onPressed: () {
                    if (user != null) {
                      if (_hasConnection) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return LeaderBoard();
                            },
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'You need internet connection to continue.',
                          fontSize: 16,
                        );
                      }
                    } else {
                      _logInErrorPopUp(context);
                    }
                  },
                  splashRadius: 20,
                  splashColor: Colors.grey.shade600,
                  highlightColor: Colors.black.withOpacity(0.2),
                  iconSize: 30,
                  color: colorScheme.primary,
                ),
                IconButton(
                  icon: IconShadowWidget(
                    Icon(
                      Icons.person,
                      color: colorScheme.primary,
                      size: 30,
                    ),
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  onPressed: () {
                    if (user != null) {
                      if (_hasConnection) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return AccountScreen();
                            },
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'You need internet connection to continue.',
                          fontSize: 16,
                        );
                      }
                    } else {
                      _logInErrorPopUp(context);
                    }
                  },
                  splashRadius: 20,
                  splashColor: Colors.grey.shade600,
                  highlightColor: Colors.black.withOpacity(0.2),
                  iconSize: 30,
                  color: colorScheme.primary,
                ),
              ],
              leadingWidth: 70,
            ),
            backgroundColor: Colors.transparent,
            drawer: NavigationDrawer(),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.035, right: width * 0.035, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LATEST EVENT',
                      style: textTheme.headlineSmall.copyWith(
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            if (_hasConnection) {
                              if (user != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return GoEventSplashScreen('Stage');
                                    },
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return LogInScreen();
                                    },
                                  ),
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: 'You need internet connection to continue.',
                                fontSize: 16,
                              );
                            }
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 25,
                                  bottom: 25,
                                  left: 5,
                                  right: 5,
                                ),
                                child: Container(
                                  width: 220,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        color: colorScheme.shadow,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 120,
                                        child: Transform.rotate(
                                          angle: pi,
                                          child: ClipRRect(
                                            child: Image.asset(
                                                'assets/Trigonometry_Home_Decoration.png'),
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 12,
                                        right: 12,
                                        child: Text(
                                          'TRIGONOMETRY',
                                          style: TextStyle(
                                            fontFamily: 'Verdana Bold',
                                            color: colorScheme.tertiary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 60,
                                        right: 8,
                                        child: Text(
                                          'Guidance for the Combat with',
                                          style: TextStyle(
                                            fontFamily: 'Lemon Jelly',
                                            color: colorScheme.tertiary,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 46,
                                        right: 82,
                                        child: Text(
                                          'the Examination',
                                          style: TextStyle(
                                            fontFamily: 'Lemon Jelly',
                                            color: colorScheme.tertiary,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -15,
                                left: 105,
                                child: SizedBox(
                                  width: 125,
                                  child: Image.asset('assets/Event_Home_Top_Clip.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            if (_hasConnection) {
                              if (user != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return GoEventSplashScreen('Stage');
                                    },
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return LogInScreen();
                                    },
                                  ),
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: 'You need internet connection to continue.',
                                fontSize: 16,
                              );
                            }
                          },
                          child: Container(
                            height: 150,
                            width: 90,
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      height: 80,
                                      child: CircularPercentIndicator(
                                        radius: 40,
                                        lineWidth: 6,
                                        percent: _progress / 100,
                                        progressColor: colorScheme.primary,
                                        animation: true,
                                        animateFromLastPercent: true,
                                        animationDuration: 1000,
                                        curve: Curves.easeOut,
                                        backgroundColor: Color.fromARGB(255, 200, 197, 201)
                                            .withOpacity(0.5),
                                        circularStrokeCap: CircularStrokeCap.round,
                                      ),
                                    ),
                                    Opacity(
                                      opacity: 0.7,
                                      child: Container(
                                        width: 65,
                                        height: 65,
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/Trigonometry_Event_Icon.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                user != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                                        child: Center(
                                          child: userData != null
                                              ? TweenAnimationBuilder(
                                                  tween: Tween(begin: 0.0, end: _progress),
                                                  duration: Duration(seconds: 1),
                                                  builder: (_, progress, __) {
                                                    return Text(
                                                      '${(progress).toStringAsFixed(2)}%',
                                                      style: TextStyle(
                                                        fontSize: 21,
                                                        fontFamily: 'Open Sans',
                                                        fontWeight: FontWeight.bold,
                                                        color: colorScheme.primary,
                                                        shadows: [
                                                          Shadow(
                                                            blurRadius: 1,
                                                            color:
                                                                Colors.black.withOpacity(0.8),
                                                            offset: Offset(0.5, 1.5),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                              : LoadingBouncingLine.circle(
                                                  backgroundColor:
                                                      Colors.white.withOpacity(0.8),
                                                ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                                        child: Text(
                                          'Log In',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontFamily: 'Typo Round Demo',
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.primary,
                                            height: 1,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 1,
                                                color: Colors.black.withOpacity(0.8),
                                                offset: Offset(0.5, 1.5),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Text(
                        'THEORY AND PAPERS',
                        style: textTheme.headlineSmall.copyWith(
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 300,
                            height: 80,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 8,
                                backgroundColor: colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return MainScreen('Pure');
                                    },
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Align(
                                    child: Text(
                                      'ශුද්ධ ගණිතය',
                                      style: textTheme.titleMedium,
                                    ),
                                    alignment: Alignment(-0.9, -0.7),
                                  ),
                                  Align(
                                    child: Text(
                                      'PURE MATHS',
                                      style: textTheme.titleSmall,
                                    ),
                                    alignment: Alignment(-0.92, 0.7),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 300,
                            height: 80,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 8,
                                backgroundColor: colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return MainScreen('Applied');
                                    },
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Align(
                                    child: Text(
                                      'ව්‍යවහාරික ගණිතය',
                                      style: textTheme.titleMedium,
                                    ),
                                    alignment: Alignment(-0.86, -0.7),
                                  ),
                                  Align(
                                    child: Text(
                                      'APPLIED MATHS',
                                      style: textTheme.titleSmall,
                                    ),
                                    alignment: Alignment(-0.92, 0.7),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 300,
                            height: 115,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 8,
                                backgroundColor: colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return MainScreen(
                                        'Past Papers And Marking Schemes',
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Align(
                                    child: Text(
                                      'පසුගිය විභාග ප්‍රශ්න පත්‍ර සහ පිළිතුරු',
                                      style: textTheme.titleMedium,
                                    ),
                                    alignment: Alignment(-0.86, -0.7),
                                  ),
                                  Align(
                                    child: Text(
                                      'PAST PAPERS & MARKING SCHEMES',
                                      style: textTheme.titleSmall,
                                    ),
                                    alignment: Alignment(-0.92, 0.8),
                                  ),
                                ],
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
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_home,
              buttonSize: Size(60.0, 60.0),
              visible: user != null ? true : false,
              animatedIconTheme: IconThemeData(
                size: 25,
                color: colorScheme.primary,
              ),
              backgroundColor: _fabBackgroundColor,
              onOpen: () {
                setState(() {
                  _fabBackgroundColor = colorScheme.background;
                });
              },
              onClose: () {
                setState(() {
                  _fabBackgroundColor = colorScheme.secondary;
                });
              },
              curve: Curves.easeIn,
              elevation: 2,
              overlayOpacity: 0.5,
              overlayColor: Colors.black26,
              children: [
                SpeedDialChild(
                  onTap: () {
                    if (_hasConnection) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return GoEventSplashScreen('Event');
                          },
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: 'You need internet connection to continue.',
                        fontSize: 16,
                      );
                    }
                  },
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  child: Icon(
                    Icons.event,
                    size: 32,
                  ),
                  labelWidget: GestureDetector(
                    onTap: () {
                      if (_hasConnection) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return GoEventSplashScreen('Event');
                            },
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'You are not connected to the Internet.',
                          fontSize: 16,
                        );
                      }
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          'EVENT',
                          style: textTheme.headlineSmall.copyWith(
                              fontSize: 20, fontWeight: FontWeight.w200, letterSpacing: 1.2),
                        ),
                      ),
                      width: 170,
                      height: 35,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 3,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SpeedDialChild(
                  onTap: () {
                    if (_hasConnection) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return Store();
                          },
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: 'You need internet connection to continue.',
                        fontSize: 16,
                      );
                    }
                  },
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  child: Icon(
                    Icons.store,
                    size: 32,
                  ),
                  labelWidget: GestureDetector(
                    onTap: () {
                      if (_hasConnection) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return Store();
                            },
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'You need internet connection to continue.',
                          fontSize: 16,
                        );
                      }
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          'STORE',
                          style: textTheme.headlineSmall.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      width: 170,
                      height: 35,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 3,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SpeedDialChild(
                  onTap: () {
                    if (_hasConnection) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return Collection();
                          },
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: 'You need internet connection to continue.',
                        fontSize: 16,
                      );
                    }
                  },
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  child: Icon(
                    Icons.style_outlined,
                    size: 32,
                  ),
                  labelWidget: GestureDetector(
                    onTap: () {
                      if (_hasConnection) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return Collection();
                            },
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'You are not connected to the Internet.',
                          fontSize: 16,
                        );
                      }
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          'COLLECTION',
                          style: textTheme.headlineSmall.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      width: 170,
                      height: 35,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 3,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
                      fontWeight: FontWeight.normal,
                      color: Colors.black.withOpacity(0.8),
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
                              fontSize: 22, fontFamily: 'Philosopher', color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Color.fromARGB(255, 0, 88, 122),
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
                              fontSize: 22, fontFamily: 'Philosopher', color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Color.fromARGB(255, 0, 88, 122),
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

class ShapeDrawer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    var path = Path();

    path.moveTo(size.width * 0.23, size.height * 0.65);
    path.lineTo(size.width * 0.345, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.1, size.width * 0.655, size.height * 0.4);
    path.lineTo(size.width * 0.77, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.96, size.width * 0.66, size.height * 0.98);
    path.lineTo(size.width * 0.34, size.height * 0.98);
    path.quadraticBezierTo(
        size.width * 0.1, size.height * 0.96, size.width * 0.23, size.height * 0.65);

    canvas.drawShadow(path, Colors.grey.shade700, 8.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BackgroundColor extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color.fromARGB(255, 183, 183, 183);
    paint.style = PaintingStyle.fill;
    var path = Path();

    path.moveTo(0, size.height * 0.2);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.42);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
