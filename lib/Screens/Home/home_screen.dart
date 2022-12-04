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
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Screens/Special/Collection/collection.dart';
import 'package:maths_vision/Screens/Special/Store/store.dart';
import 'package:maths_vision/Screens/Account/Log_In/log_in_screen.dart';
import 'package:maths_vision/Screens/Splashes/go_event_splash_screen.dart';
import 'package:maths_vision/Widgets/home_app_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Basic/Main_List/main_screens.dart';
import '../Navigation_Drawer/navigation_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasConnection;
  StreamSubscription _subscription;
  Color _fabBackgroundColor = Color.fromARGB(255, 1, 79, 134);

  DocumentSnapshot _loginData;
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
          userData.get().then((doc) {
            setState(() {
              _loginData = doc;
            });
          }).then((value) {
            return _loginDetails();
          });
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
            appBar: HomeAppBar(
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
                      return Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
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
                          onTap: _eventButtonPress,
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
                          onTap: _eventButtonPress,
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
                            child: Builder(builder: (context) {
                              if (user == null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _eventCircularProgress(0.0),
                                    Padding(
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
                                );
                              }
                              return StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(user.uid)
                                      .collection('Trigonometry_Event')
                                      .doc('Event_Info')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return LoadingAnimationWidget.beat(
                                        color: Colors.white,
                                        size: 60,
                                      );
                                    }
                                    double progress = snapshot.data['progress'];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _eventCircularProgress(progress),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                                          child: Center(
                                            child: TweenAnimationBuilder(
                                              tween: Tween(begin: 0.0, end: progress),
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
                                                        color: Colors.black.withOpacity(0.8),
                                                        offset: Offset(0.5, 1.5),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            }),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
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
                          _mainScreenButtons(
                            'ශුද්ධ ගණිතය',
                            'PURE MATHS',
                            'Pure',
                          ),
                          _mainScreenButtons(
                            'ව්‍යවහාරික ගණිතය',
                            'APPLIED MATHS',
                            'Applied',
                          ),
                          _mainScreenButtons(
                            'පසුගිය විභාග ප්‍රශ්න පත්‍ර සහ පිළිතුරු',
                            'PAST PAPERS & MARKING SCHEMES',
                            'Past Papers And Marking Schemes',
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
                _fabChild(GoEventSplashScreen('Event'), Icons.event, 'EVENT'),
                _fabChild(Store(), Icons.store, 'STORE'),
                _fabChild(Collection(), Icons.style_outlined, 'COLLECTION'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SpeedDialChild _fabChild(Widget screen, IconData icon, String name) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SpeedDialChild(
      onTap: () {
        _fabChildPress(screen);
      },
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      child: Icon(
        icon,
        size: 32,
      ),
      labelWidget: GestureDetector(
        onTap: () {
          _fabChildPress(screen);
        },
        child: Container(
          child: Center(
            child: Text(
              name,
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
    );
  }

  Widget _mainScreenButtons(String sinhalaName, String englishName, String screen) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            alignment: Alignment.centerLeft,
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
                  return MainScreen(screen);
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 5.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sinhalaName,
                  style: textTheme.titleMedium,
                ),
                Text(
                  englishName,
                  style: textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventCircularProgress(double progress) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Stack(
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
            percent: progress / 100,
            progressColor: colorScheme.primary,
            animation: true,
            animateFromLastPercent: true,
            animationDuration: 1000,
            curve: Curves.easeOut,
            backgroundColor: Color.fromARGB(255, 200, 197, 201).withOpacity(0.5),
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
    );
  }

  void _fabChildPress(Widget screen) {
    if (_hasConnection) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return screen;
          },
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: 'You need internet connection to continue.',
        fontSize: 16,
      );
    }
  }

  void _eventButtonPress() {
    if (!(_hasConnection?? false)) {
      Fluttertoast.showToast(
        msg: 'You need internet connection to continue.',
        fontSize: 16,
      );
      return;
    }
    if (user == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return LogInScreen();
          },
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return GoEventSplashScreen('Stage');
        },
      ),
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