import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Support_Classes/event_errors_and_loading.dart';
import 'package:maths_vision/Event_1/play_store_provider.dart';
import 'package:maths_vision/Event_1/questions_map.dart';
import 'package:maths_vision/Event_1/store.dart';
import 'package:maths_vision/Screens/papers_screen.dart';
import 'package:provider/provider.dart';

class Collection extends StatefulWidget {
  const Collection({Key key}) : super(key: key);

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
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

  User user;
  DocumentSnapshot _data;
  DocumentSnapshot _stageData;
  InAppPurchase _iap = InAppPurchase.instance;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    initConnectivity();
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    DocumentReference stageData = userData.collection('Trigonometry_Event').doc('Stages');
    userData.snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _data = doc;
      });
    });
    stageData.snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _stageData = doc;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 136, 145),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          _connectionStatus == 'ConnectivityResult.wifi' ||
                  _connectionStatus == 'ConnectivityResult.mobile'
              ? _data != null
                  ? SingleChildScrollView(
                      padding: EdgeInsets.only(top: height * 0.13),
                      child: _content(context),
                    )
                  : EventLoading()
              : Center(
                  child: NetworkError(Colors.white),
                ),
          Container(
            width: width,
            height: height * 0.13,
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 183, 183, 183),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 0,
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        'My Collection',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Blenda Script',
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 5,
                              color: Colors.black.withOpacity(0.6),
                              offset: Offset(1, 2.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _data!=null? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
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
                                '${_data['User_Details.coins']}',
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
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return Store();
                                },
                              ),
                            );
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  offset: Offset(0,1.5),
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.store_mall_directory_outlined,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ):SizedBox(
                      width: 100,
                      child: LoadingBouncingLine.circle(
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    String G = 'Collection';
    String C = 'Coupons';
    String cA = 'Answer_Coupons';
    String cV = 'Video_Coupons';
    String D = 'Double_XP_Cards';
    String dG = 'Golden_Double_XP';
    String dS = 'Silver_Double_XP';
    String a = 'available';
    String V = 'Vouchers';
    String vA = 'Answer_Vouchers';
    String vV = 'Video_Vouchers';
    String B = 'Bonus_Cards';
    return (_data['$G.$C.$cA'].length>0 || _data['$G.$C.$cV'].length>0) ||
            (_data['$G.$D.$dG.$a'] > 0 || _data['$G.$D.$dS.$a'] > 0) ||
        (_data['$G.$V.$vA.$a'] > 0 || _data['$G.$V.$vV.$a'] > 0) ||
        _data['$G.$B.$a'] >0
        ? Column(
            children: [
              _data['$G.$C.$cA'].length>0 || _data['$G.$C.$cV'].length>0
                  ? Column(
                      children: [
                        Container(
                          width: width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 183, 183, 183),
                                Color.fromARGB(255, 0, 136, 145),
                              ],
                            ),
                          ),
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          padding: EdgeInsets.fromLTRB(30, 3, 10, 3),
                          child: Text(
                            'COUPONS',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Roboto Regular',
                              color: Colors.white,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),
                        _data['$G.$C.$cA'].length>0
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          child: Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5),
                                          child: Text(
                                            'ANSWER COUPONS',
                                            style: TextStyle(
                                              fontFamily: 'Roboto Regular',
                                              fontSize: 11,
                                              color: Colors.white,
                                              letterSpacing: 2.5,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: _data['$G.$C.$cA'].length > 1 ? 340 : 170,
                                    child: GridView(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: _data['$G.$C.$cA'].length > 1 ? 2 : 1,
                                        mainAxisExtent: width * 0.5,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                        _data['$G.$C.$cA'].length,
                                        (index) {
                                          return _answerCouponsItem(context, index);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        _data['$G.$C.$cV'].length>0
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          child: Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5),
                                          child: Text(
                                            'VIDEO COUPONS',
                                            style: TextStyle(
                                              fontFamily: 'Roboto Regular',
                                              fontSize: 11,
                                              color: Colors.white,
                                              letterSpacing: 2.5,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 170,
                                    child: ListView.builder(
                                      itemCount: _data['$G.$C.$cV'].length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return _videoCouponsItem(index);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    )
                  : SizedBox(),
              _data['$G.$D.$dG.$a'] > 0 || _data['$G.$D.$dS.$a'] > 0
                  ? Column(
                      children: [
                        Container(
                          width: width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 183, 183, 183),
                                Color.fromARGB(255, 0, 136, 145),
                              ],
                            ),
                          ),
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          padding: EdgeInsets.fromLTRB(30, 3, 10, 3),
                          child: Text(
                            'DOUBLE XP CARDS',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Roboto Regular',
                              color: Colors.white,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 110,
                          child: Row(
                            children: [
                              _data['$G.$D.$dS.$a'] > 0
                                  ? SizedBox(
                                      width: width * 0.5,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 160,
                                            child: Stack(
                                              children: [
                                                Image.asset('assets/Double_XP_Card.png'),
                                                _data['$G.$D.$dS.$a'] > 1
                                                    ? Positioned(
                                                        top: 5,
                                                        right: 3,
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.black,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '${_data['$G.$D.$dS.$a']}',
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
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              _data['$G.$D.$dG.$a'] > 0
                                  ? SizedBox(
                                      width: width * 0.5,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 160,
                                            child: Stack(
                                              children: [
                                                Image.asset(
                                                    'assets/Golden_Double_XP_Card.png'),
                                                _data['$G.$D.$dG.$a'] > 1
                                                    ? Positioned(
                                                        top: 5,
                                                        right: 3,
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.black),
                                                          child: Center(
                                                            child: Text(
                                                              '${_data['$G.$D.$dG.$a']}',
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
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              _data['$G.$V.$vA.$a'] > 0 || _data['$G.$V.$vV.$a'] > 0
                  ? Column(
                      children: [
                        Container(
                          width: width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 183, 183, 183),
                                Color.fromARGB(255, 0, 136, 145),
                              ],
                            ),
                          ),
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          padding: EdgeInsets.fromLTRB(30, 3, 10, 3),
                          child: Text(
                            'VOUCHERS',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Roboto Regular',
                              color: Colors.white,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 160,
                          child: Row(
                            children: [
                              _data['$G.$V.$vA.$a'] > 0
                                  ? SizedBox(
                                      width: width * 0.5,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 160,
                                            child: Stack(
                                              children: [
                                                Image.asset('assets/Answer_Voucher.png'),
                                                _data['$G.$V.$vA.$a'] > 1
                                                    ? Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.black,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '${_data['$G.$V.$vA.$a']}',
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
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 70,
                                            height: 25,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _answerVoucherPopup(context);
                                              },
                                              child: Text(
                                                'USE',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.4,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                shape: StadiumBorder(),
                                                backgroundColor: Color.fromARGB(255, 0, 88, 122),
                                                elevation: 3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              _data['$G.$V.$vV.$a'] > 0
                                  ? SizedBox(
                                      width: width * 0.5,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 160,
                                            child: Stack(
                                              children: [
                                                Image.asset('assets/Video_Voucher.png'),
                                                _data['$G.$V.$vV.$a'] > 1
                                                    ? Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.black,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '${_data['$G.$V.$vV.$a']}',
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
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 70,
                                            height: 25,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _videoVoucherPopup(context);
                                              },
                                              child: Text(
                                                'USE',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.4,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                shape: StadiumBorder(),
                                                backgroundColor: Color.fromARGB(255, 0, 88, 122),
                                                elevation: 3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              _data['$G.$B.$a'] >0
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 183, 183, 183),
                                Color.fromARGB(255, 0, 136, 145),
                              ],
                            ),
                          ),
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          padding: EdgeInsets.fromLTRB(30, 3, 10, 3),
                          child: Text(
                            'BONUS CARDS',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Roboto Regular',
                              color: Colors.white,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.5,
                          height: 170,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 160,
                                child: Stack(
                                  children: [
                                    Image.asset('assets/Double_Coin_Bonus_Card.png'),
                                    _data['$G.$B.$a']>1? Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle, color: Colors.black,),
                                        child: Center(
                                          child: Text(
                                            '${_data['$G.$B.$a']}',
                                            style: TextStyle(
                                                fontFamily: 'Blenda Script',
                                                fontSize: 12,
                                                color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ):SizedBox(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: 70,
                                height: 25,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _bonusCardPopup(context);
                                  },
                                  child: Text(
                                    'USE',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    backgroundColor: Color.fromARGB(255, 0, 88, 122),
                                    elevation: 3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : SizedBox(),
            ],
          )
        : SizedBox(
            height: height - height * 0.13,
            child: Center(
              child: Text(
                'There are no items in your collection',
                style: TextStyle(
                  fontFamily: 'Philosopher',
                  fontSize: 30,
                  color: Colors.black.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }

  Widget _answerCouponsItem(BuildContext context,int index) {
    String G = 'Collection';
    String C = 'Coupons';
    String cA = 'Answer_Coupons';
    Map answerData =
        _data['$G.$C.$cA'].values.elementAt(_data['$G.$C.$cA'].length - 1 - index);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 160,
          child: Stack(
            children: [
              answerData['forty']
                  ? Image.asset('assets/Answer_Coupon_40.png')
                  : Image.asset('assets/Answer_Coupon_60.png'),
              Positioned(
                left: answerData['stage'] == 10 || answerData['question'] > 9 ? 22 : 25,
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
                                  '${answerData['stage']}',
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
                                  '${answerData['question']}',
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
              answerData['quantity'] > 1
                  ? Positioned(
                      top: 8,
                      right: 3,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Text(
                            '${answerData['quantity']}',
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
        SizedBox(
          width: 70,
          height: 25,
          child: ElevatedButton(
            onPressed: () {
              _answerCouponPopup(context, answerData);
            },
            child: Text(
              'USE',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: Color.fromARGB(255, 0, 88, 122),
              elevation: 3,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _answerCouponPopup(BuildContext context, Map answerData) async{
    int stage = answerData['stage'];
    int question = answerData['question'];
    int answerPrice = questions['stage$stage']['question$question']['answerBuyCoins'];
    int newAnswerPrice = answerData['forty']? (answerPrice*0.6).round():(answerPrice*0.4).round();
    return await showDialog(
      context: context,
      builder: (context){
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            contentPadding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 160,
                  child: Stack(
                    children: [
                      answerData['forty']
                          ? Image.asset('assets/Answer_Coupon_40.png')
                          : Image.asset('assets/Answer_Coupon_60.png'),
                      Positioned(
                        left: answerData['stage'] == 10 || answerData['question'] > 9 ? 22 : 25,
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
                                          '${answerData['stage']}',
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
                                          '${answerData['question']}',
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
                Container(
                  height: 40,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromARGB(255, 96, 170, 77),
                        Color.fromARGB(255, 159, 219, 155),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(0, 3),
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 36,
                                fontFamily: 'Ateeca',
                              ),
                              children: [
                                TextSpan(
                                  text: 'S',
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: Offset(1.0, 0.0),
                                    child: Text(
                                      '${answerData['stage']}',
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
                          SizedBox(
                            width: 7,
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 36,
                                fontFamily: 'Ateeca',
                              ),
                              children: [
                                TextSpan(
                                  text: 'Q',
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: Offset(1.0, 0.0),
                                    child: Text(
                                      '${answerData['question']}',
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
                      Text(
                        'Answer',
                        style: TextStyle(
                          fontFamily: 'Scriptina',
                          fontSize: 25,
                          color: Colors.black,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'This coupon will deduct the price of this answer by ${answerData['forty']?'40':'60'}%',
                    style: TextStyle(
                      fontFamily: 'Blenda Script',
                      fontSize: 12,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Transform.scale(
                          scale: 0.6,
                          child: SizedBox(
                            width: 110,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
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
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '$answerPrice',
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: pi/8,
                          child: Container(
                            height: 1,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.red.shade800,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: -pi/8,
                          child: Container(
                            height: 1,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.red.shade800,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        Container(
                          width: 110,
                          height: 50,
                          color: Colors.transparent,
                        ),
                      ],
                    ),
                    Transform.scale(
                      scale: 0.9,
                      child: SizedBox(
                        width: 110,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _answerCouponUpdates(answerData);
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$newAnswerPrice',
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Future<void> _answerCouponUpdates(Map answerData) async {
    String G = 'Collection';
    String C = 'Coupons';
    String cA = 'Answer_Coupons';
    int stage = answerData['stage'];
    int question = answerData['question'];
    String Q = 'Questions_Details';
    int answerPrice = questions['stage$stage']['question$question']['answerBuyCoins'];
    int newAnswerPrice = answerData['forty']? (answerPrice*0.6).round():(answerPrice*0.4).round();
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    DocumentReference stageData = userData.collection('Trigonometry_Event').doc('Stages');
    CollectionReference eventsInfo = FirebaseFirestore.instance.collection('Events');
    CollectionReference stagesInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages');
    CollectionReference questionsInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Stage_$stage')
        .collection('Questions');
    if(_data['User_Details.coins']>newAnswerPrice){
      if(_stageData['Stage_$stage.$Q'].length==questions['stage$stage'].length){
        if(question==questions['stage$stage'].length){
          if(_stageData['Stage_$stage.$Q.Question_$question.done']){
            if(_stageData['Stage_$stage.$Q.Question_$question.answerBought']){
              Fluttertoast.showToast(
                msg: "You have already purchased that answer. You can use this coupon in the next event.",
                fontSize: 16,
              );
            } else {
              if(answerData['quantity']>1){
                if(answerData['forty']){
                  userData.update({
                    'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                    '$G.$C.$cA.S${stage}Q${question}T40.quantity': FieldValue.increment(-1),
                  });
                } else {
                  userData.update({
                    'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                    '$G.$C.$cA.S${stage}Q${question}T60.quantity': FieldValue.increment(-1),
                  });
                }
              } else {
                if(answerData['forty']){
                  userData.update({
                    'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                    '$G.$C.$cA.S${stage}Q${question}T40': FieldValue.delete(),
                  });
                } else {
                  userData.update({
                    'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                    '$G.$C.$cA.S${stage}Q${question}T60': FieldValue.delete(),
                  });
                }
              }
              stageData.update({
                'Stage_$stage.$Q.Question_$question.answerBought': true,
              });
              eventsInfo.doc('Trigonometry').update({
                'TotalAnswersBought': FieldValue.increment(1),
              });
              stagesInfo.doc('Stage_$stage').update({
                'TotalAnswersBought': FieldValue.increment(1),
              });
              questionsInfo.doc('Question_$question').update({
                'AnswersBought': FieldValue.increment(1),
              });
              eventsInfo.doc('All_Events').update({
                'AllAnswersBought': FieldValue.increment(1),
              });
              Fluttertoast.showToast(
                msg: "You have successfully purchased the answer.",
                fontSize: 16,
              );
              Navigator.pop(context,false);
            }
          } else {
            Fluttertoast.showToast(
              msg: "You have not finished this question yet.",
              fontSize: 16,
            );
          }
        } else if (question<_stageData['Stage_$stage.$Q'].length){
          if(_stageData['Stage_$stage.$Q.Question_$question.answerBought']){
            Fluttertoast.showToast(
              msg: "You have already purchased that answer. You can use this coupon in the next event.",
              fontSize: 16,
            );
          } else {
            if(answerData['quantity']>1){
              if(answerData['forty']){
                userData.update({
                  'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                  '$G.$C.$cA.S${stage}Q${question}T40.quantity': FieldValue.increment(-1),
                });
              } else {
                userData.update({
                  'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                  '$G.$C.$cA.S${stage}Q${question}T60.quantity': FieldValue.increment(-1),
                });
              }
            } else {
              if(answerData['forty']){
                userData.update({
                  'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                  '$G.$C.$cA.S${stage}Q${question}T40': FieldValue.delete(),
                });
              } else {
                userData.update({
                  'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                  '$G.$C.$cA.S${stage}Q${question}T60': FieldValue.delete(),
                });
              }
            }
            stageData.update({
              'Stage_$stage.$Q.Question_$question.answerBought': true,
            });
            eventsInfo.doc('Trigonometry').update({
              'TotalAnswersBought': FieldValue.increment(1),
            });
            stagesInfo.doc('Stage_$stage').update({
              'TotalAnswersBought': FieldValue.increment(1),
            });
            questionsInfo.doc('Question_$question').update({
              'AnswersBought': FieldValue.increment(1),
            });
            eventsInfo.doc('All_Events').update({
              'AllAnswersBought': FieldValue.increment(1),
            });
            Fluttertoast.showToast(
              msg: "You have successfully purchased the answer.",
              fontSize: 16,
            );
            Navigator.pop(context,false);
          }
        } else {
          Fluttertoast.showToast(
            msg: "You have not finished this question yet.",
            fontSize: 16,
          );
        }
      } else if (question<_stageData['Stage_$stage.$Q'].length){
        if(_stageData['Stage_$stage.$Q.Question_$question.answerBought']){
          Fluttertoast.showToast(
            msg: "You have already purchased that answer. You can use this coupon in the next event.",
            fontSize: 16,
          );
        } else {
          if(answerData['quantity']>1){
            if(answerData['forty']){
              userData.update({
                'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                '$G.$C.$cA.S${stage}Q${question}T40.quantity': FieldValue.increment(-1),
              });
            } else {
              userData.update({
                'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                '$G.$C.$cA.S${stage}Q${question}T60.quantity': FieldValue.increment(-1),
              });
            }
          } else {
            if(answerData['forty']){
              userData.update({
                'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                '$G.$C.$cA.S${stage}Q${question}T40': FieldValue.delete(),
              });
            } else {
              userData.update({
                'User_Details.coins': FieldValue.increment(-newAnswerPrice),
                '$G.$C.$cA.S${stage}Q${question}T60': FieldValue.delete(),
              });
            }
          }
          stageData.update({
            'Stage_$stage.$Q.Question_$question.answerBought': true,
          });
          eventsInfo.doc('Trigonometry').update({
            'TotalAnswersBought': FieldValue.increment(1),
          });
          stagesInfo.doc('Stage_$stage').update({
            'TotalAnswersBought': FieldValue.increment(1),
          });
          questionsInfo.doc('Question_$question').update({
            'AnswersBought': FieldValue.increment(1),
          });
          eventsInfo.doc('All_Events').update({
            'AllAnswersBought': FieldValue.increment(1),
          });
          Fluttertoast.showToast(
            msg: "You have successfully purchased the answer.",
            fontSize: 16,
          );
          Navigator.pop(context,false);
        }
      } else {
        Fluttertoast.showToast(
          msg: "You have not finished this question yet.",
          fontSize: 16,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "You don't have enough coins.",
        fontSize: 16,
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

  Widget _videoCouponsItem(int index) {
    final double width = MediaQuery.of(context).size.width;
    String G = 'Collection';
    String C = 'Coupons';
    String cV = 'Video_Coupons';
    Map videoData = _data['$G.$C.$cV'].values.elementAt(_data['$G.$C.$cV'].length - 1 - index);
    return SizedBox(
      width: width * 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 160,
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Image.asset('assets/Video_Coupon.png'),
                Positioned(
                  left: videoData['stage'] == 10 ? 20 : 25,
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
                                  '${videoData['stage']}',
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
                ),
                videoData['quantity'] > 1
                    ? Positioned(
                        top: 8,
                        right: 3,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Text(
                              '${videoData['quantity']}',
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
          SizedBox(
            width: 70,
            height: 25,
            child: ElevatedButton(
              onPressed: () {
                _videoCouponPopup(context, videoData);
              },
              child: Text(
                'USE',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Color.fromARGB(255, 0, 88, 122),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _videoCouponPopup(BuildContext context, Map videoData) async {
    List prices = [0, 450, 160, 400, 300, 250, 300, 600, 230, 450];
    int stage = videoData['stage'];
    int videoPrice = prices[stage-1];
    int newVideoPrice = (videoPrice*0.6).round();
    return await showDialog(
      context: context,
      builder: (context){
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            contentPadding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 160,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Image.asset('assets/Video_Coupon.png'),
                      Positioned(
                        left: videoData['stage'] == 10 ? 20 : 25,
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
                                        '${videoData['stage']}',
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
                      ),
                      videoData['quantity'] > 1
                          ? Positioned(
                        top: 8,
                        right: 3,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Text(
                              '${videoData['quantity']}',
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Transform.scale(
                    scale: 1.5,
                    child: Container(
                      width: 120,
                      height: 70,
                      padding: EdgeInsets.fromLTRB(0, 5, 12, 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 172, 140, 92),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7,
                            spreadRadius: 0,
                            color: Colors.black.withOpacity(0.3),
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
                                      '${stage == 10 ? '' : '0'}$stage',
                                      style: TextStyle(
                                        fontFamily: 'Blenda Script',
                                        fontSize: 13,
                                        color: Colors.white,
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
                              Stack(
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
                              Text(
                                'Lesson',
                                style: TextStyle(
                                  fontFamily: 'Colonna MT',
                                  fontSize: 25,
                                  color: Colors.white,
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    'This coupon will deduct the price of this video by 40%',
                    style: TextStyle(
                      fontFamily: 'Blenda Script',
                      fontSize: 12,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Transform.scale(
                          scale: 0.6,
                          child: SizedBox(
                            width: 110,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
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
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '$videoPrice',
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: pi/8,
                          child: Container(
                            height: 1,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.red.shade800,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: -pi/8,
                          child: Container(
                            height: 1,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.red.shade800,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        Container(
                          width: 110,
                          height: 50,
                          color: Colors.transparent,
                        ),
                      ],
                    ),
                    Transform.scale(
                      scale: 0.9,
                      child: SizedBox(
                        width: 110,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _videoCouponUpdates(videoData);
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$newVideoPrice',
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Future<void> _videoCouponUpdates(Map videoData) async {
    List prices = [0, 450, 160, 400, 300, 250, 300, 600, 230, 450];
    int stage = videoData['stage'];
    int videoPrice = prices[stage-1];
    int newVideoPrice = (videoPrice*0.6).round();
    String G = 'Collection';
    String C = 'Coupons';
    String cV = 'Video_Coupons';
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    DocumentReference stageData = userData.collection('Trigonometry_Event').doc('Stages');
    CollectionReference eventsInfo = FirebaseFirestore.instance.collection('Events');
    CollectionReference stagesInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages');
    if(_data['User_Details.coins']>newVideoPrice){
      if(_stageData['Stage_$stage.Info.Video.purchased']){
        Fluttertoast.showToast(
          msg: "You have already purchased this video. You can use this coupon in the next event.",
          fontSize: 16,
        );
      } else {
        if(videoData['quantity']>1){
          userData.update({
            'User_Details.coins': FieldValue.increment(-newVideoPrice),
            '$G.$C.$cV.S$stage.quantity': FieldValue.increment(-1),
          });
        } else {
          userData.update({
            'User_Details.coins': FieldValue.increment(-newVideoPrice),
            '$G.$C.$cV.S$stage': FieldValue.delete(),
          });
        }
        stageData.update({
          'Stage_$stage.Info.Video.purchased': true,
        });
        eventsInfo.doc('Trigonometry').update({
          'TotalVideoBought': FieldValue.increment(1),
        });
        stagesInfo.doc('Stage_$stage').update({
          'Video.PurchaseCount': FieldValue.increment(1),
        });
        eventsInfo.doc('All_Events').update({
          'AllVideoBought': FieldValue.increment(1),
        });
        Fluttertoast.showToast(
          msg: "You have successfully purchased the video.",
          fontSize: 16,
        );
        Navigator.pop(context,false);
      }
    } else {
      Fluttertoast.showToast(
        msg: "You don't have enough coins.",
        fontSize: 16,
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

  Future<void> _answerVoucherPopup(BuildContext context) async {
    List stages = List.generate(10, (index) {
      return 'Stage ${index==9?'':'0'}${index+1}';
    });
    String _chosenStage = stages[0];
    String _chosenQuestion = 'Question 01';
    int question=1;
    int stage=1;
    int answerPrice = questions['stage$stage']['question$question']['answerBuyCoins'];
    return await showDialog(
      context: context,
      builder: (context){
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      child: Image.asset('assets/Answer_Voucher.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5,bottom: 5),
                      child: Text(
                        'Choose the answer you want to buy,',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 241, 238, 238),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Center(
                            child: DropdownButton(
                              dropdownColor: Color.fromARGB(255, 241, 238, 238),
                              value: _chosenStage,
                              items: stages.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value){
                                setState((){
                                  _chosenStage = value;
                                  stage = int.parse(value.split(' ').elementAt(1));
                                  answerPrice = questions['stage$stage']['question$question']['answerBuyCoins'];
                                });
                              },
                              onTap: (){
                                setState((){
                                  _chosenQuestion = 'Question 01';
                                  question = 1;
                                  answerPrice = questions['stage$stage']['question$question']['answerBuyCoins'];
                                });
                              },
                              style: TextStyle(
                                fontFamily: 'Century Gothic',
                                fontSize: 12,
                                color: Colors.black
                              ),
                              underline: Container(
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 241, 238, 238),
                              borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: DropdownButton(
                              dropdownColor: Color.fromARGB(255, 241, 238, 238),
                              value: _chosenQuestion,
                              items: List.generate(questions['stage${stages.indexOf(_chosenStage)+1}'].length, (index) {
                                return 'Question ${index>8?'':'0'}${index+1}';
                              }).map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value){
                                setState((){
                                  _chosenQuestion = value;
                                  question = int.parse(value.split(' ').elementAt(1));
                                  answerPrice = questions['stage$stage']['question$question']['answerBuyCoins'];
                                });
                              },
                              style: TextStyle(
                                  fontFamily: 'Century Gothic',
                                  fontSize: 12,
                                  color: Colors.black,
                              ),
                              underline: Container(
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 40,
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromARGB(255, 96, 170, 77),
                            Color.fromARGB(255, 159, 219, 155),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: Offset(0, 3),
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 36,
                                    fontFamily: 'Ateeca',
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'S',
                                    ),
                                    WidgetSpan(
                                      child: Transform.translate(
                                        offset: Offset(1.0, 0.0),
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
                              SizedBox(
                                width: 7,
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 36,
                                    fontFamily: 'Ateeca',
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Q',
                                    ),
                                    WidgetSpan(
                                      child: Transform.translate(
                                        offset: Offset(1.0, 0.0),
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
                          Text(
                            'Answer',
                            style: TextStyle(
                              fontFamily: 'Scriptina',
                              fontSize: 25,
                              color: Colors.black,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'You can buy this answer for free.',
                        style: TextStyle(
                          fontFamily: 'Blenda Script',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Transform.scale(
                              scale: 0.6,
                              child: SizedBox(
                                width: 110,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {},
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
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '$answerPrice',
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: pi/8,
                              child: Container(
                                height: 1,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade800,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: -pi/8,
                              child: Container(
                                height: 1,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade800,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                            Container(
                              width: 110,
                              height: 50,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                        Transform.scale(
                          scale: 0.9,
                          child: SizedBox(
                            width: 110,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _answerVoucherUpdates(stage, question);
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
                                  Text(
                                    'Free',
                                    style: TextStyle(
                                      fontFamily: 'Crash',
                                      fontSize: 23,
                                      color: Colors.white,
                                      height: 0.9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          ),
        );
      }
    );
  }

  Future<void> _answerVoucherUpdates(int stage, int question) async {
    String Q = 'Questions_Details';
    String G = 'Collection';
    String V = 'Vouchers';
    String vA = 'Answer_Vouchers';
    String a = 'available';
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    DocumentReference stageData = userData.collection('Trigonometry_Event').doc('Stages');
    CollectionReference eventsInfo = FirebaseFirestore.instance.collection('Events');
    CollectionReference stagesInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages');
    CollectionReference questionsInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Stage_$stage')
        .collection('Questions');
    if(_stageData['Stage_$stage.$Q'].length==questions['stage$stage'].length){
      if(question==questions['stage$stage'].length){
        if(_stageData['Stage_$stage.$Q.Question_$question.done']){
          if(_stageData['Stage_$stage.$Q.Question_$question.answerBought']){
            Fluttertoast.showToast(
              msg: "You have already purchased that answer. You can use this voucher for another question.",
              fontSize: 16,
            );
          } else {
            userData.update({
              '$G.$V.$vA.$a': FieldValue.increment(-1),
            });
            stageData.update({
              'Stage_$stage.$Q.Question_$question.answerBought': true,
            });
            eventsInfo.doc('Trigonometry').update({
              'TotalAnswersBought': FieldValue.increment(1),
            });
            stagesInfo.doc('Stage_$stage').update({
              'TotalAnswersBought': FieldValue.increment(1),
            });
            questionsInfo.doc('Question_$question').update({
              'AnswersBought': FieldValue.increment(1),
            });
            eventsInfo.doc('All_Events').update({
              'AllAnswersBought': FieldValue.increment(1),
            });
            Fluttertoast.showToast(
              msg: "You have successfully purchased the answer.",
              fontSize: 16,
            );
            Navigator.pop(context,false);
          }
        } else {
          Fluttertoast.showToast(
            msg: "You have not finished this question yet.",
            fontSize: 16,
          );
        }
      } else if (question<_stageData['Stage_$stage.$Q'].length){
        if(_stageData['Stage_$stage.$Q.Question_$question.answerBought']){
          Fluttertoast.showToast(
            msg: "You have already purchased that answer. You can use this voucher for another question.",
            fontSize: 16,
          );
        } else {
          userData.update({
            '$G.$V.$vA.$a': FieldValue.increment(-1),
          });
          stageData.update({
            'Stage_$stage.$Q.Question_$question.answerBought': true,
          });
          eventsInfo.doc('Trigonometry').update({
            'TotalAnswersBought': FieldValue.increment(1),
          });
          stagesInfo.doc('Stage_$stage').update({
            'TotalAnswersBought': FieldValue.increment(1),
          });
          questionsInfo.doc('Question_$question').update({
            'AnswersBought': FieldValue.increment(1),
          });
          eventsInfo.doc('All_Events').update({
            'AllAnswersBought': FieldValue.increment(1),
          });
          Fluttertoast.showToast(
            msg: "You have successfully purchased the answer.",
            fontSize: 16,
          );
          Navigator.pop(context,false);
        }
      } else {
        Fluttertoast.showToast(
          msg: "You have not finished this question yet.",
          fontSize: 16,
        );
      }
    } else if (question<_stageData['Stage_$stage.$Q'].length){
      if(_stageData['Stage_$stage.$Q.Question_$question.answerBought']){
        Fluttertoast.showToast(
          msg: "You have already purchased that answer. You can use this voucher for another question.",
          fontSize: 16,
        );
      } else {
        userData.update({
          '$G.$V.$vA.$a': FieldValue.increment(-1),
        });
        stageData.update({
          'Stage_$stage.$Q.Question_$question.answerBought': true,
        });
        eventsInfo.doc('Trigonometry').update({
          'TotalAnswersBought': FieldValue.increment(1),
        });
        stagesInfo.doc('Stage_$stage').update({
          'TotalAnswersBought': FieldValue.increment(1),
        });
        questionsInfo.doc('Question_$question').update({
          'AnswersBought': FieldValue.increment(1),
        });
        eventsInfo.doc('All_Events').update({
          'AllAnswersBought': FieldValue.increment(1),
        });
        Fluttertoast.showToast(
          msg: "You have successfully purchased the answer.",
          fontSize: 16,
        );
        Navigator.pop(context,false);
      }
    } else {
      Fluttertoast.showToast(
        msg: "You have not finished this question yet.",
        fontSize: 16,
      );
    }
  }

  Future<void> _videoVoucherPopup(BuildContext context) async {
    List videoPrice = [0, 450, 160, 400, 300, 250, 300, 600, 230, 450];
    List stages = List.generate(10, (index) {
      return 'Stage ${index==9?'':'0'}${index+1}';
    });
    String _chosenStage = stages[0];
    int stage=1;
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      child: Image.asset('assets/Video_Voucher.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5,bottom: 5),
                      child: Text(
                        'Choose the video you want to buy,',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.25,
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 238, 238),
                          borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: DropdownButton(
                          dropdownColor: Color.fromARGB(255, 241, 238, 238),
                          value: _chosenStage,
                          items: stages.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value){
                            setState((){
                              _chosenStage = value;
                              stage = int.parse(value.split(' ').elementAt(1));
                            });
                          },
                          style: TextStyle(
                              fontFamily: 'Century Gothic',
                              fontSize: 12,
                              color: Colors.black,
                          ),
                          underline: Container(
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Transform.scale(
                        scale: 1.5,
                        child: Container(
                          width: 120,
                          height: 70,
                          padding: EdgeInsets.fromLTRB(0, 5, 12, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 172, 140, 92),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 7,
                                spreadRadius: 0,
                                color: Colors.black.withOpacity(0.3),
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
                                          '${stage == 10 ? '' : '0'}$stage',
                                          style: TextStyle(
                                            fontFamily: 'Blenda Script',
                                            fontSize: 13,
                                            color: Colors.white,
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
                                  Stack(
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
                                  Text(
                                    'Lesson',
                                    style: TextStyle(
                                      fontFamily: 'Colonna MT',
                                      fontSize: 25,
                                      color: Colors.white,
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: Text(
                        'You can buy this video for free.',
                        style: TextStyle(
                          fontFamily: 'Blenda Script',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Transform.scale(
                              scale: 0.6,
                              child: SizedBox(
                                width: 110,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {},
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
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${videoPrice[stage-1]}',
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: pi/8,
                              child: Container(
                                height: 1,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade800,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: -pi/8,
                              child: Container(
                                height: 1,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade800,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                            Container(
                              width: 110,
                              height: 50,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                        Transform.scale(
                          scale: 0.9,
                          child: SizedBox(
                            width: 110,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _videoVoucherUpdates(stage);
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
                                  Text(
                                    'Free',
                                    style: TextStyle(
                                      fontFamily: 'Crash',
                                      fontSize: 23,
                                      color: Colors.white,
                                      height: 0.9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          ),
        );
      }
    );
  }

  Future<void> _videoVoucherUpdates(int stage) async {
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    DocumentReference stageData = userData.collection('Trigonometry_Event').doc('Stages');
    CollectionReference eventsInfo = FirebaseFirestore.instance.collection('Events');
    CollectionReference stagesInfo = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages');
    String G = 'Collection';
    String V = 'Vouchers';
    String vV = 'Video_Vouchers';
    String a = 'available';
    if(_stageData['Stage_$stage.Info.Video.purchased']){
      Fluttertoast.showToast(
        msg: "You have already purchased this video. You can use this voucher for anther video.",
        fontSize: 16,
      );
    } else {
      userData.update({
        '$G.$V.$vV.$a': FieldValue.increment(-1),
      });
      stageData.update({
        'Stage_$stage.Info.Video.purchased': true,
      });
      eventsInfo.doc('Trigonometry').update({
        'TotalVideoBought': FieldValue.increment(1),
      });
      stagesInfo.doc('Stage_$stage').update({
        'Video.PurchaseCount': FieldValue.increment(1),
      });
      eventsInfo.doc('All_Events').update({
        'AllVideoBought': FieldValue.increment(1),
      });
      Fluttertoast.showToast(
        msg: "You have successfully purchased the video.",
        fontSize: 16,
      );
      Navigator.pop(context,false);
    }
  }

  Future<void> _bonusCardPopup(BuildContext context) async {
    final provider = Provider.of<PlayStoreProvider>(context, listen: false);
    List coins = ['Coins 40', 'Coins 100', 'Coins 225', 'Coins 500'];
    String _chooseCoins = 'Coins 40';
    int coinsAmount = 40;
    return await showDialog(
      context: context,
      builder: (context){
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: StatefulBuilder(
            builder: (context, setState){
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 160,
                      child: Image.asset('assets/Double_Coin_Bonus_Card.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5,bottom: 5),
                      child: Text(
                        'Choose the number of coins you want to double,',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 30,
                        width: 100,
                        margin: EdgeInsets.only(left: 20, top: 5),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 238, 238),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: DropdownButton(
                            dropdownColor: Color.fromARGB(255, 241, 238, 238),
                            value: _chooseCoins,
                            items: coins.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value){
                              setState((){
                                _chooseCoins = value;
                                coinsAmount = int.parse(value.split(' ').elementAt(1));
                              });
                            },
                            style: TextStyle(
                              fontFamily: 'Century Gothic',
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            underline: Container(
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Transform.scale(
                              scale: 0.6,
                              child: Container(
                                width: 120,
                                height: 140,
                                padding: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      spreadRadius: 1,
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(0,2),
                                    ),
                                  ],
                                ),
                                child: Transform.scale(
                                  scale: 0.9,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 75,
                                        height: 75,
                                        child: Image.asset('assets/Store_Coins.png'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '$coinsAmount',
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontSize: 30,
                                                color: Colors.black,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            SizedBox(
                                              width: 30,
                                              child: Image.asset('assets/Coin.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: pi/4,
                              child: Container(
                                height: 2,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade800,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: -pi/4,
                              child: Container(
                                height: 2,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade800,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: Container(
                            width: 120,
                            height: 140,
                            padding: EdgeInsets.only(top: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  spreadRadius: 1,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0,2),
                                ),
                              ],
                            ),
                            child: Transform.scale(
                              scale: 0.9,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 40),
                                        child: SizedBox(
                                          width: 75,
                                          height: 75,
                                          child: Image.asset('assets/Store_Coins.png'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 40, top: 8),
                                        child: SizedBox(
                                          width: 75,
                                          height: 75,
                                          child: Image.asset('assets/Store_Coins.png'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${coinsAmount*2}',
                                        style: TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontSize: 30,
                                          color: Colors.black,
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
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: 30,
                                        child: Image.asset('assets/Coin.png'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        width: 90,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!provider.available) {
                              Fluttertoast.showToast(
                                msg: 'Google Store is Unavailable',
                                fontSize: 16,
                              );
                            } else {
                              if(coins.indexOf(_chooseCoins)==0){
                                _buyProduct(provider.products[9]);
                              } else if (coins.indexOf(_chooseCoins)==1){
                                _buyProduct(provider.products[7]);
                              } else if (coins.indexOf(_chooseCoins)==2){
                                _buyProduct(provider.products[8]);
                              } else if (coins.indexOf(_chooseCoins)==3){
                                _buyProduct(provider.products[10]);
                              }
                              Navigator.pop(context, false);
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
                                height: 27,
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.black,
                                ),
                              ),
                              RichText(
                                text:TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${100*pow(2, coins.indexOf(_chooseCoins))}',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Open Sans',
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' LKR',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Roboto Regular',
                                        color: Color.fromARGB(255, 232, 185, 35),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
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
      }
    );
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
  }
}
