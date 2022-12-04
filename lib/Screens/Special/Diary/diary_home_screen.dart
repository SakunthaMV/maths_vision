import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Special/Diary/daily_bonus_tab.dart';
import 'package:maths_vision/Screens/Special/Diary/golden_sheet_tab.dart';
import 'package:maths_vision/Screens/Special/Diary/notice_tab.dart';
import 'package:maths_vision/Screens/Special/Diary/wall_tab.dart';
import 'package:maths_vision/Widgets/home_app_bar.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class DiaryHomeScreen extends StatefulWidget {
  const DiaryHomeScreen({Key key}) : super(key: key);

  @override
  _DiaryHomeScreenState createState() => _DiaryHomeScreenState();
}

class _DiaryHomeScreenState extends State<DiaryHomeScreen>
    with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this,initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 136, 145),
      appBar: HomeAppBar(page: 'Notice',),
      body: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                width: double.infinity,
                height: 115,
                padding: EdgeInsets.only(left: 20, top: 5),
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
                        _tab('NOTICE'),
                        _tab('WALL'),
                        _tab('DAILY BONUS'),
                        _tab('GOLDEN SHEET')
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
              color: Colors.white,
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
  
  Widget _tab(String tabName){
    return Tab(
      child: Text(
        tabName,
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
    );
  }
}
