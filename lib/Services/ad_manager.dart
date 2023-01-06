import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544~3347511713";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get bannerNote {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get bannerAnswerDisplay {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get bannerEventQuestion {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get bannerFullPaper {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get bannerMarkingScheme {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialLevelUp {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialFullPaper {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialLessonVideo {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get rewardedAnswerDisplay {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}