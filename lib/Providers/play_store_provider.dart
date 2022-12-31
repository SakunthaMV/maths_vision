import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PlayStoreProvider with ChangeNotifier {
  InAppPurchase _iap = InAppPurchase.instance;
  bool available = true;
  StreamSubscription subscription;
  final String coins_40 = 'coins_40';
  final String coins_100 = 'coins_100';
  final String coins_225 = 'coins_225';
  final String coins_500 = 'coins_500';
  final String doubleCoins_40 = 'double_coins_40';
  final String doubleCoins_100 = 'double_coins_100';
  final String doubleCoins_225 = 'double_coins_225';
  final String doubleCoins_500 = 'double_coins_500';
  final String doubleXPCards_5 = 'double_xp_cards_5';
  final String doubleXPCards_12 = 'double_xp_cards_12';
  final String goldenDoubleXPCards_1 = 'golden_double_xp_cards_1';
  final String goldenDoubleXPCards_2 = 'golden_double_xp_cards_2';
  final String videoVoucher = 'video_voucher';
  final String answerVoucher_1 = 'answer_voucher';
  final String answerVoucher_2 = 'answer_voucher_2';
  final String answerVoucher_5 = 'answer_voucher_5';

  bool _isPurchased = false;

  bool get isPurchased => _isPurchased;

  set isPurchased(bool value) {
    _isPurchased = value;
    notifyListeners();
  }

  List<PurchaseDetails> _purchases = [];

  List get purchases => _purchases;

  set purchases(List value) {
    _purchases = value;
    notifyListeners();
  }

  List _products = [];

  List get products => _products;

  set products(List value) {
    _products = value;
    notifyListeners();
  }

  void initialize() async {
    available = await _iap.isAvailable();
    if (available) {
      await _getProducts();
      verifyPurchase();
      subscription = _iap.purchaseStream.listen((data) {
        purchases.addAll(data);
        verifyPurchase();
      }, onDone: () {
        subscription.cancel();
      });
    }
  }

  void verifyPurchase() {
    String C = 'Collection';
    String D = 'Double_XP_Cards';
    String gD = 'Golden_Double_XP';
    String sD = 'Silver_Double_XP';
    String V = 'Vouchers';
    String aV = 'Answer_Vouchers';
    String vV = 'Video_Vouchers';
    String a = 'available';
    String S = 'Store_Info';
    User user;
    user = FirebaseAuth.instance.currentUser;
    if(user!=null && purchases.isNotEmpty){
      DocumentReference userData =
      FirebaseFirestore.instance.collection('Users').doc(user.uid);
      DocumentReference eventData = FirebaseFirestore.instance.collection('Events').doc('All_Events');
      if (purchases.last != null &&
          purchases.last.status == PurchaseStatus.purchased) {
        if (purchases.last.pendingCompletePurchase) {
          _iap.completePurchase(purchases.last);
          isPurchased = true;
          switch (purchases.last.productID) {
            case 'coins_40':
              userData.update({'User_Details.coins': FieldValue.increment(40)});
              eventData.update({'$S.Coins.40': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 40 Maths vision Coins.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'coins_100':
              userData.update({'User_Details.coins': FieldValue.increment(100)});
              eventData.update({'$S.Coins.100': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 100 Maths vision Coins.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'coins_225':
              userData.update({'User_Details.coins': FieldValue.increment(225)});
              eventData.update({'$S.Coins.225': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 225 Maths vision Coins.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'coins_500':
              userData.update({'User_Details.coins': FieldValue.increment(500)});
              eventData.update({'$S.Coins.500': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 500 Maths vision Coins.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'double_coins_40':
              userData.update({
                'User_Details.coins': FieldValue.increment(80),
                '$C.Bonus_Cards.$a': FieldValue.increment(-1),
              });
              eventData.update({'$S.Coins.80': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 80 Maths vision Coins.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'double_coins_100':
              userData.update({
                'User_Details.coins': FieldValue.increment(200),
                '$C.Bonus_Cards.$a': FieldValue.increment(-1),
              });
              eventData.update({'$S.Coins.200': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 200 Maths vision Coins.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'double_coins_225':
              userData.update({
                'User_Details.coins': FieldValue.increment(450),
                '$C.Bonus_Cards.$a': FieldValue.increment(-1),
              });
              eventData.update({'$S.Coins.450': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 450 Maths vision Coins.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'double_coins_500':
              userData.update({
                'User_Details.coins': FieldValue.increment(1000),
                '$C.Bonus_Cards.$a': FieldValue.increment(-1),
              });
              eventData.update({'$S.Coins.1000': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 1000 Maths vision Coins.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'double_xp_cards_5':
              userData.update({'$C.$D.$sD.$a': FieldValue.increment(5)});
              eventData.update({'$S.$D.$sD.Five': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 5 Silver Double XP Cards.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'double_xp_cards_12':
              userData.update({'$C.$D.$sD.$a': FieldValue.increment(12)});
              eventData.update({'$S.$D.$sD.Twelve': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 12 Silver Double XP Cards.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'golden_double_xp_cards_1':
              userData.update({'$C.$D.$gD.$a': FieldValue.increment(1)});
              eventData.update({'$S.$D.$gD.One': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased a Golden Double XP Card.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'golden_double_xp_cards_2':
              userData.update({'$C.$D.$gD.$a': FieldValue.increment(2)});
              eventData.update({'$S.$D.$gD.Two': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 2 Golden Double XP Cards.',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'video_voucher':
              userData.update({'$C.$V.$vV.$a': FieldValue.increment(1)});
              eventData.update({'$S.$V.$vV': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased a Video Voucher',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'answer_voucher':
              userData.update({'$C.$V.$aV.$a': FieldValue.increment(1)});
              eventData.update({'$S.$V.$aV.One': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased a Answer Voucher',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'answer_voucher_2':
              userData.update({'$C.$V.$aV.$a': FieldValue.increment(2)});
              eventData.update({'$S.$V.$aV.Two': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 2 Answer Vouchers',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
            case 'answer_voucher_5':
              userData.update({'$C.$V.$aV.$a': FieldValue.increment(5)});
              eventData.update({'$S.$V.$aV.Five': FieldValue.increment(1)});
              Fluttertoast.showToast(
                msg: 'You have successfully purchased 5 Answer Vouchers',
                backgroundColor: Color.fromARGB(255, 0, 136, 145),
                textColor: Colors.white,
                fontSize: 16,
              );
              break;
          }
        }
      }
    }
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([
      coins_40,
      coins_100,
      coins_225,
      coins_500,
      doubleCoins_40,
      doubleCoins_100,
      doubleCoins_225,
      doubleCoins_500,
      doubleXPCards_5,
      doubleXPCards_12,
      goldenDoubleXPCards_1,
      goldenDoubleXPCards_2,
      videoVoucher,
      answerVoucher_1,
      answerVoucher_2,
      answerVoucher_5,
    ]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    products = response.productDetails;
  }
}
