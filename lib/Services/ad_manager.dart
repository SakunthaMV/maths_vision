import 'package:flutter/material.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class AdManager {

  static Future<bool> canShowBanner() async {
    final bool isCanShow = await Appodeal.canShow(Appodeal.BANNER);
    final bool isLoaded = await Appodeal.isLoaded(Appodeal.BANNER);
    if (isLoaded && isCanShow) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> showInterstitial(String placement) async {
    final bool isCanShow = await Appodeal.canShow(Appodeal.INTERSTITIAL);
    final bool isLoaded = await Appodeal.isLoaded(Appodeal.INTERSTITIAL);
    if (isLoaded && isCanShow) {
      await Appodeal.show(Appodeal.INTERSTITIAL, placement);
    } else {
      print('Interstitial ad unable to load');
    }
  }

  static Future<void> showReward(String placement) async {
    final bool isCanShow = await Appodeal.canShow(Appodeal.REWARDED_VIDEO);
    final bool isLoaded = await Appodeal.isLoaded(Appodeal.REWARDED_VIDEO);
    if (isLoaded && isCanShow) {
      await Appodeal.show(Appodeal.REWARDED_VIDEO, placement);
    } else {
      print('Reward ad unable to load');
    }
  }

  static Widget showBottomBanner(String placement) {
    return FutureBuilder<bool>(
      future: canShowBanner(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return SizedBox.shrink();
        }
        if (!snapshot.data) {
          return SizedBox.shrink();
        }
        return Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: AppodealBanner(adSize: AppodealBannerSize.BANNER, placement: placement),
        );
      },
    );
  }
}
