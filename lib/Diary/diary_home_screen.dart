import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:maths_vision/Diary/daily_bonus_tab.dart';
import 'package:maths_vision/Diary/golden_sheet_tab.dart';
import 'package:maths_vision/Diary/notice_tab.dart';
import 'package:maths_vision/Diary/wall_tab.dart';
import 'package:maths_vision/Event_1/account_screen.dart';
import 'package:maths_vision/Event_1/leaderboard.dart';
import 'package:maths_vision/Splash_Screens/went_home_splash_screen.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class DiaryHomeScreen extends StatefulWidget {
  const DiaryHomeScreen({Key key}) : super(key: key);

  @override
  _DiaryHomeScreenState createState() => _DiaryHomeScreenState();
}

class _DiaryHomeScreenState extends State<DiaryHomeScreen>
    with SingleTickerProviderStateMixin {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  int _coins;
  int _level;
  User user;
  DocumentSnapshot _userData;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    initConnectivity();
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    userData.snapshots().listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        _userData = event;
      });
      setState(() {
        _coins = event['User_Details.coins'];
        _level = event['User_Details.level'];
      });
    });
    _tabController = TabController(length: 4, vsync: this,initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 136, 145),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).push(
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
          _connectionStatus == 'ConnectivityResult.wifi' ||
                  _connectionStatus == 'ConnectivityResult.mobile'
              ? _userData != null
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10),
                          child: InkWell(
                            onTap: () {
                              print('Coin Increased');
                            },
                            child: Container(
                              height: 25,
                              width: 95,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                      color: Colors.black,
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
                                        color: Colors.black,
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
                          height: 25,
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                                  fontSize: 20, color: Colors.black, fontFamily: 'Forte'),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox()
              : SizedBox(),
          IconButton(
            icon: IconShadowWidget(
              Icon(
                Icons.article,
                color: Colors.white,
                size: 30,
              ),
              shadowColor: Colors.black,
            ),
            onPressed: () {},
            splashRadius: 20,
            splashColor: Colors.grey.shade600,
            highlightColor: Colors.black.withOpacity(0.2),
            iconSize: 30,
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return LeaderBoard();
                  },
                ),
              );
            },
            splashRadius: 20,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return AccountScreen();
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
        ],
      ),
      body: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                width: double.infinity,
                height: 115,
                padding: EdgeInsets.only(left: 20, top: 5),
                color: Color.fromARGB(255, 0, 136, 145),
                child: Text(
                  'MV Diary',
                  style: TextStyle(
                    fontFamily: 'MontereyFLF Bold Italic',
                    fontSize: 42,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    color: Colors.white.withOpacity(0.2),
                    child: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      unselectedLabelColor: Colors.white.withOpacity(0.6),
                      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      indicator: MaterialIndicator(
                        height: 5,
                        color: Colors.white,
                        horizontalPadding: 20,
                        bottomLeftRadius: 5,
                        bottomRightRadius: 5,
                      ),
                      tabs: [
                        Tab(
                          child: Text(
                            'NOTICE',
                            style: TextStyle(
                              fontFamily: 'Roboto Regular',
                              fontSize: 20,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'WALL',
                            style: TextStyle(
                              fontFamily: 'Roboto Regular',
                              fontSize: 20,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'DAILY BONUS',
                            style: TextStyle(
                              fontFamily: 'Roboto Regular',
                              fontSize: 20,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'GOLDEN SHEET',
                            style: TextStyle(
                              fontFamily: 'Roboto Regular',
                              fontSize: 20,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 5,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  NoticeTab(),
                  WallTab(),
                  DailyBonusTab(),
                  GoldenSheetTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
