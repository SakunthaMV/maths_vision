import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maths_vision/Providers/play_store_provider.dart';
import 'package:maths_vision/Screens/Splashes/open_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import 'Models/theme_data.dart';
import 'Providers/facebook_sign_in_provider.dart';
import 'Providers/google_sign_in_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // TODO: remove debug things before release app.
  await FlutterDownloader.initialize(debug: true);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  await Appodeal.initialize(
    appKey: '3691fbfffc57f6e17eb13ea66f7e77dc65477cd8abb03f8f',
    adTypes: [Appodeal.BANNER, Appodeal.INTERSTITIAL, Appodeal.REWARDED_VIDEO],
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (context) {
            return GoogleSignInProvider();
          },
        ),
        ChangeNotifierProvider<FacebookSignInProvider>(
          create: (context) {
            return FacebookSignInProvider();
          },
        ),
        ChangeNotifierProvider<PlayStoreProvider>(create: (context) {
          return PlayStoreProvider();
        }),
        StreamProvider<InternetConnectionStatus>(
          initialData: InternetConnectionStatus.connected,
          create: (context) {
            return InternetConnectionChecker().onStatusChange;
          },
        ),
      ],
      child: MathsVision(),
    ),
  );
}

class MathsVision extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Color.fromARGB(255, 239, 197, 1),
          onSecondary: Color.fromARGB(255, 72, 73, 75),
          secondaryContainer: Color.fromARGB(255, 20, 14, 94),
          onSecondaryContainer: Color.fromARGB(255, 139, 205, 250),
          tertiary: Color.fromARGB(255, 119, 123, 126),
          onTertiary: Color.fromARGB(255, 231, 231, 222),
          tertiaryContainer: Color.fromARGB(255, 0, 88, 122),
          onTertiaryContainer: Color.fromARGB(255, 162, 156, 156),
          surface: Color.fromARGB(255, 1, 170, 255),
          onSurface: Color.fromARGB(255, 183, 183, 183),
          surfaceVariant: Color.fromARGB(255, 0, 70, 98),
          inverseSurface: Color.fromARGB(255, 249, 224, 159),
          background: Color.fromARGB(255, 0, 135, 145),
          onBackground: Color.fromARGB(255, 1, 79, 134),
          error: Colors.red,
          onError: Color.fromARGB(255, 200, 62, 77),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 63, 129, 176),
        ),
        textTheme: textTheme(),
        primaryTextTheme: primaryTextTheme(),
      ),
      home: OpenSplashScreen(),
    );
  }
}