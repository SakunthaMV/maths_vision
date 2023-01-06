import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static String get bannerNote {
    if (Platform.isAndroid) {
      return "ca-app-pub-2445637094519371/7550193125";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get bannerAnswerDisplay {
    if (Platform.isAndroid) {
      return "ca-app-pub-2445637094519371/1581333539";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get bannerEventQuestion {
    if (Platform.isAndroid) {
      return "ca-app-pub-2445637094519371/4540886403";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get bannerMarkingScheme {
    if (Platform.isAndroid) {
      return "ca-app-pub-2445637094519371/5582505336";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialLevelUp {
    if (Platform.isAndroid) {
      return "ca-app-pub-2445637094519371/3886280288";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialFullPaper {
    if (Platform.isAndroid) {
      return "ca-app-pub-2445637094519371/7167049746";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialDownload {
    if (Platform.isAndroid) {
      return "ca-app-pub-2445637094519371/7964910494";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialLessonVideo {
    if (Platform.isAndroid) {
      return "ca-app-pub-2445637094519371/1451688639";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get rewardedAnswerDisplay {
    if (Platform.isAndroid) {
      return "ca-app-pub-2445637094519371/5199361950";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static Widget bannerAdShow(BannerAd bannerAd, {double margin}){
    if (bannerAd != null){
      return Container(
        width: bannerAd.size.width.toDouble(),
        height: bannerAd.size.height.toDouble(),
        margin: EdgeInsets.only(top: margin?? 10.0),
        child: AdWidget(ad: bannerAd),
      );
    }
    return SizedBox.shrink();
  }
}