import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Event_1/collection.dart';
import 'package:maths_vision/Event_1/play_store_provider.dart';
import 'package:maths_vision/Screens/papers_screen.dart';
import 'package:provider/provider.dart';

import '../Support_Classes/event_errors_and_loading.dart';

class Store extends StatefulWidget {
  const Store({Key key}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
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

  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  User user;
  DocumentSnapshot _data;

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    initConnectivity();
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    userData.snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _data = doc;
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
                      child: _storeContent(),
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
                        'MV Store',
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
                                  return Collection();
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
                              Icons.style_outlined,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeContent() {
    String C = 'Collection';
    String D = 'Double_XP_Cards';
    String sD = 'Silver_Double_XP';
    String a = 'available';
    String S = 'Store_Info';
    final double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<PlayStoreProvider>(context);
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    DocumentReference eventData = FirebaseFirestore.instance.collection('Events').doc('All_Events');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: width * 0.18,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 0, 136, 145),
                      Color.fromARGB(255, 183, 183, 183),
                    ],
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Text(
                  'COINS',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 183, 183, 183),
                          Color.fromARGB(255, 0, 136, 145),
                        ],
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: width*0.45,
                    height: 185,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 75,
                          height: 75,
                          child: Image.asset('assets/Store_Coins.png'),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '40',
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
                                  _buyProduct(provider.products[5]);
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
                                          text: '100',
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
                  ),
                  Container(
                    width: width*0.45,
                    height: 185,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              '100',
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
                                  _buyProduct(provider.products[3]);
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
                                          text: '200',
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
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: width*0.45,
                    height: 185,
                    padding: EdgeInsets.only(top: 5),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 5),
                              child: SizedBox(
                                width: 75,
                                height: 75,
                                child: Image.asset('assets/Store_Coins.png'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 60, top: 10),
                              child: SizedBox(
                                width: 75,
                                height: 75,
                                child: Image.asset('assets/Store_Coins.png'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 60, top: 12),
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
                              '225',
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
                                  _buyProduct(provider.products[4]);
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
                                          text: '400',
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
                  ),
                  Container(
                    width: width*0.45,
                    height: 185,
                    padding: EdgeInsets.only(top: 3),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 0),
                              child: SizedBox(
                                width: 75,
                                height: 75,
                                child: Image.asset('assets/Store_Coins.png'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 70, top: 0),
                              child: SizedBox(
                                width: 75,
                                height: 75,
                                child: Image.asset('assets/Store_Coins.png'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 70, top: 16),
                              child: SizedBox(
                                width: 75,
                                height: 75,
                                child: Image.asset('assets/Store_Coins.png'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 47, top: 18),
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
                              '500',
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
                                  _buyProduct(provider.products[6]);
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
                                          text: '800',
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
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: width * 0.18,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 136, 145),
                        Color.fromARGB(255, 183, 183, 183),
                      ],
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Text(
                  'DOUBLE XP',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 183, 183, 183),
                        Color.fromARGB(255, 0, 136, 145),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 10,
                ),
                child: Text(
                  'SILVER DOUBLE XP CARDS',
                  style: TextStyle(
                    fontFamily: 'Roboto Regular',
                    fontSize: 11,
                    color: Colors.white,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: Colors.black
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: width*0.425,
                height: 185,
                margin: EdgeInsets.fromLTRB(width*0.05, 15, 0, 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: 150,
                        height: 90,
                        child: Image.asset('assets/Double_XP_Card.png'),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          color: Colors.black,
                          letterSpacing: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'X',
                            style: TextStyle(
                              fontSize: 17 ,
                            )
                          ),
                          TextSpan(
                            text: ' 1'
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        width: 90,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            if(_data['User_Details.coins']>15){
                              userData.update({
                                'User_Details.coins': FieldValue.increment(-15),
                                '$C.$D.$sD.$a': FieldValue.increment(1),
                              });
                              eventData.update({
                                '$S.$D.$sD.One': FieldValue.increment(1),
                              });
                              Fluttertoast.showToast(
                                msg: 'You have successfully purchased 1 Double XP Card',
                                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                                textColor: Colors.white,
                                fontSize: 16,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'You Don\'t have enough coins.',
                                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                                textColor: Colors.white,
                                fontSize: 16,
                              );
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '15',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 17,
                                      color: Colors.white,
                                      height: 1.3,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 17,
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
              ),
              Container(
                width: width*0.425,
                height: 185,
                margin: EdgeInsets.fromLTRB(width*0.05, 15, 0, 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: 150,
                        height: 90,
                        child: Image.asset('assets/Double_XP_Card.png'),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          color: Colors.black,
                          letterSpacing: 1.5,
                        ),
                        children: [
                          TextSpan(
                              text: 'X',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                          ),
                          TextSpan(
                              text: ' 2',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        width: 90,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            if(_data['User_Details.coins']>25){
                              userData.update({
                                'User_Details.coins': FieldValue.increment(-25),
                                '$C.$D.$sD.$a': FieldValue.increment(2),
                              });
                              eventData.update({
                                '$S.$D.$sD.Two': FieldValue.increment(1),
                              });
                              Fluttertoast.showToast(
                                msg: 'You have successfully purchased 2 Double XP Cards',
                                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                                textColor: Colors.white,
                                fontSize: 16,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'You Don\'t have enough coins.',
                                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                                textColor: Colors.white,
                                fontSize: 16,
                              );
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '25',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 17,
                                      color: Colors.white,
                                      height: 1.3,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 17,
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
              ),
              Container(
                width: width*0.425,
                height: 185,
                margin: EdgeInsets.fromLTRB(width*0.05, 15, 0, 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: 150,
                        height: 90,
                        child: Image.asset('assets/Double_XP_Card.png'),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          color: Colors.black,
                          letterSpacing: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'X',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          TextSpan(
                            text: ' 5',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 70,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                if(_data['User_Details.coins']>50){
                                  userData.update({
                                    'User_Details.coins': FieldValue.increment(-50),
                                    '$C.$D.$sD.$a': FieldValue.increment(5),
                                  });
                                  eventData.update({
                                    '$S.$D.$sD.Five': FieldValue.increment(1),
                                  });
                                  Fluttertoast.showToast(
                                    msg: 'You have successfully purchased 5 Double XP Cards',
                                    backgroundColor: Color.fromARGB(255, 0, 136, 145),
                                    textColor: Colors.white,
                                    fontSize: 16,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'You Don\'t have enough coins.',
                                    backgroundColor: Color.fromARGB(255, 0, 136, 145),
                                    textColor: Colors.white,
                                    fontSize: 16,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 1, 79, 134),
                                padding: EdgeInsets.only(left: 3, right: 3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                    width: 3, color: Colors.black),
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
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '50',
                                        style: TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontSize: 17,
                                          color: Colors.white,
                                          height: 1.3,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: 17,
                                        child: Image.asset('assets/Coin.png'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!provider.available) {
                                  Fluttertoast.showToast(
                                    msg: 'Google Store is Unavailable',
                                    fontSize: 16,
                                  );
                                } else {
                                  _buyProduct(provider.products[12]);
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
                                          text: '100',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width*0.425,
                height: 185,
                margin: EdgeInsets.fromLTRB(width*0.05, 15, width*0.05, 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: 150,
                        height: 90,
                        child: Image.asset('assets/Double_XP_Card.png'),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          color: Colors.black,
                          letterSpacing: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'X',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          TextSpan(
                            text: ' 12',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 70,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                if(_data['User_Details.coins']>120){
                                  userData.update({
                                    'User_Details.coins': FieldValue.increment(-120),
                                    '$C.$D.$sD.$a': FieldValue.increment(12),
                                  });
                                  eventData.update({
                                    '$S.$D.$sD.Twelve': FieldValue.increment(1),
                                  });
                                  Fluttertoast.showToast(
                                    msg: 'You have successfully purchased 12 Double XP Cards',
                                    backgroundColor: Color.fromARGB(255, 0, 136, 145),
                                    textColor: Colors.white,
                                    fontSize: 16,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'You Don\'t have enough coins.',
                                    backgroundColor: Color.fromARGB(255, 0, 136, 145),
                                    textColor: Colors.white,
                                    fontSize: 16,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 1, 79, 134),
                                padding: EdgeInsets.only(left: 3, right: 3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                    width: 3, color: Colors.black),
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
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '120',
                                        style: TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontSize: 17,
                                          color: Colors.white,
                                          height: 1.3,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      SizedBox(
                                        width: 17,
                                        child:
                                        Image.asset('assets/Coin.png'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!provider.available) {
                                  Fluttertoast.showToast(
                                    msg: 'Google Store is Unavailable',
                                    fontSize: 16,
                                  );
                                } else {
                                  _buyProduct(provider.products[11]);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 1, 79, 134),
                                padding: EdgeInsets.only(left: 3, right: 3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                    width: 3, color: Colors.black),
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
                                          text: '200',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 10,
                ),
                child: Text(
                  'GOLDEN DOUBLE XP CARDS',
                  style: TextStyle(
                    fontFamily: 'Roboto Regular',
                    fontSize: 11,
                    color: Colors.white,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                      color: Colors.black
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              width: width*0.425,
              height: 185,
              margin: EdgeInsets.fromLTRB(width*0.05, 15, 0, 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 7,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: 150,
                      height: 90,
                      child: Image.asset('assets/Golden_Double_XP_Card.png'),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 22,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                      children: [
                        TextSpan(
                            text: 'X',
                            style: TextStyle(
                              fontSize: 17 ,
                            )
                        ),
                        TextSpan(
                            text: ' 1'
                        )
                      ],
                    ),
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
                            _buyProduct(provider.products[13]);
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
                                    text: '100',
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
            ),
            Container(
              width: width*0.425,
              height: 185,
              margin: EdgeInsets.fromLTRB(width*0.05, 15, 0, 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 7,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: 150,
                      height: 90,
                      child: Image.asset('assets/Golden_Double_XP_Card.png'),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 22,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                      children: [
                        TextSpan(
                            text: 'X',
                            style: TextStyle(
                              fontSize: 17 ,
                            ),
                        ),
                        TextSpan(
                            text: ' 2',
                        ),
                      ],
                    ),
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
                            _buyProduct(provider.products[14]);
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
                                    text: '200',
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
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: width * 0.18,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 136, 145),
                        Color.fromARGB(255, 183, 183, 183),
                      ],
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Text(
                  'VOUCHERS',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 183, 183, 183),
                        Color.fromARGB(255, 0, 136, 145),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 10,
                ),
                child: Text(
                  'VIDEO VOUCHERS',
                  style: TextStyle(
                    fontFamily: 'Roboto Regular',
                    fontSize: 11,
                    color: Colors.white,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                      color: Colors.black
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: width*0.425,
          height: 200,
          margin: EdgeInsets.fromLTRB(width*0.05, 15, 0, 15),
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 7,
                spreadRadius: 1,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                  width: 150,
                  height: 90,
                  child: Image.asset('assets/Video_Voucher.png'),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 22,
                    color: Colors.black,
                    letterSpacing: 1.5,
                  ),
                  children: [
                    TextSpan(
                        text: 'X',
                        style: TextStyle(
                          fontSize: 17 ,
                        ),
                    ),
                    TextSpan(
                        text: ' 1',
                    ),
                  ],
                ),
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
                        _buyProduct(provider.products[15]);
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
                                text: '500',
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
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 10,
                ),
                child: Text(
                  'ANSWER VOUCHERS',
                  style: TextStyle(
                    fontFamily: 'Roboto Regular',
                    fontSize: 11,
                    color: Colors.white,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                      color: Colors.black
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: width*0.425,
                height: 200,
                margin: EdgeInsets.fromLTRB(width*0.05, 15, 0, 15),
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: 150,
                        height: 90,
                        child: Image.asset('assets/Answer_Voucher.png'),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          color: Colors.black,
                          letterSpacing: 1.5,
                        ),
                        children: [
                          TextSpan(
                              text: 'X',
                              style: TextStyle(
                                fontSize: 17 ,
                              )
                          ),
                          TextSpan(
                              text: ' 1'
                          )
                        ],
                      ),
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
                              _buyProduct(provider.products[0]);
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
                                      text: '150',
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
              ),
              Container(
                width: width*0.425,
                height: 200,
                margin: EdgeInsets.fromLTRB(width*0.05, 15, 0, 15),
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: 150,
                        height: 90,
                        child: Image.asset('assets/Answer_Voucher.png'),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          color: Colors.black,
                          letterSpacing: 1.5,
                        ),
                        children: [
                          TextSpan(
                              text: 'X',
                              style: TextStyle(
                                fontSize: 17 ,
                              )
                          ),
                          TextSpan(
                              text: ' 2'
                          )
                        ],
                      ),
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
                              _buyProduct(provider.products[1]);
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
                                      text: '250',
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
              ),
              Container(
                width: width*0.425,
                height: 200,
                margin: EdgeInsets.fromLTRB(width*0.05, 15, width*0.05, 15),
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: 150,
                        height: 90,
                        child: Image.asset('assets/Answer_Voucher.png'),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 22,
                          color: Colors.black,
                          letterSpacing: 1.5,
                        ),
                        children: [
                          TextSpan(
                              text: 'X',
                              style: TextStyle(
                                fontSize: 17 ,
                              )
                          ),
                          TextSpan(
                              text: ' 5'
                          )
                        ],
                      ),
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
                              _buyProduct(provider.products[2]);
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
                                      text: '500',
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
