import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Screens/Home/background.dart';
import 'package:maths_vision/Screens/Home/local_widgets.dart';
import 'package:maths_vision/Screens/Special/Collection/collection.dart';
import 'package:maths_vision/Screens/Special/Store/store.dart';
import 'package:maths_vision/Screens/Account/Log_In/log_in_screen.dart';
import 'package:maths_vision/Screens/Splashes/go_event_splash_screen.dart';
import 'package:maths_vision/Widgets/Main_App_Bar/home_app_bar.dart';
import 'package:maths_vision/Widgets/toast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../Basic/Main_List/main_screens.dart';
import '../Navigation_Drawer/navigation_drawer.dart';
import 'login_update.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasConnection;
  Color _fabBackgroundColor = Color.fromARGB(255, 1, 79, 134);
  User user;

  Future<void> checkInternet() async {
    bool status = await InternetConnectionChecker().hasConnection;
    setState(() {
      _hasConnection = status;
    });
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    checkInternet().whenComplete(() {
      if (_hasConnection) {
        if (user != null) {
          FirebaseFirestore.instance.collection('Users').doc(user.uid).get().then((doc) {
            loginDetails(doc, user);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return HomeBackground(
      body: WillPopScope(
        onWillPop: () => showDialog<bool>(
          context: context,
          builder: (c) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
              content: Text(
                'Are you sure you want to quit Maths Vision?',
                style: textTheme.displayMedium.copyWith(
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                quitDialogActions(context, 'Yes, Quit Now'),
                quitDialogActions(context, 'No'),
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
          body: ListView(
            padding: EdgeInsets.only(left: width * 0.035, right: width * 0.035, top: 15),
            physics: BouncingScrollPhysics(),
            children: [
              homeTitles(context, 'LATEST EVENT'),
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
                          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
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
                                  color: Colors.black.withOpacity(0.2),
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
                                      color: colorScheme.background,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 60,
                                  right: 8,
                                  child: Text(
                                    'Guidance for the Combat with',
                                    style: Theme.of(context).primaryTextTheme.headlineLarge,
                                  ),
                                ),
                                Positioned(
                                  bottom: 46,
                                  right: 82,
                                  child: Text(
                                    'the Examination',
                                    style: Theme.of(context).primaryTextTheme.headlineLarge,
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
                        color: colorScheme.onTertiaryContainer,
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
                                          style: textTheme.displayLarge.copyWith(
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
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: homeTitles(context, 'THEORY AND PAPERS'),
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
                _fabBackgroundColor = colorScheme.onBackground;
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
          width: 170,
          height: 35,
          decoration: BoxDecoration(
            color: colorScheme.onBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 3,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              name,
              style: textTheme.displaySmall.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainScreenButtons(String sinhalaName, String englishName, String screen) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
                  style: Theme.of(context).primaryTextTheme.headlineMedium.copyWith(
                        wordSpacing: -6,
                        letterSpacing: 1.5,
                      ),
                ),
                Text(
                  englishName,
                  style: Theme.of(context).textTheme.headlineLarge.copyWith(
                    fontSize: 19,
                    color: colorScheme.tertiary,
                    shadows: [
                      Shadow(
                        color: Colors.grey.shade600,
                        blurRadius: 1,
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
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
            backgroundColor: colorScheme.onTertiary.withOpacity(0.4),
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ),
        Opacity(
          opacity: 0.7,
          child: Container(
            width: 65,
            height: 65,
            child: ClipOval(
              child: Image.asset('assets/Trigonometry_Event_Icon.png'),
            ),
          ),
        ),
      ],
    );
  }

  void _fabChildPress(Widget screen) {
    _hasConnection = Provider.of<InternetConnectionStatus>(context, listen: false) ==
        InternetConnectionStatus.connected;
    if (_hasConnection) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return screen;
          },
        ),
      );
    } else {
      toast('You need internet connection to continue.');
    }
  }

  void _eventButtonPress() {
    _hasConnection = Provider.of<InternetConnectionStatus>(context, listen: false) ==
        InternetConnectionStatus.connected;
    if (!_hasConnection) {
      toast('You need internet connection to continue.');
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
