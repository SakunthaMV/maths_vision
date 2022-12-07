import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maths_vision/Providers/play_store_provider.dart';
import 'package:maths_vision/Screens/Splashes/open_splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PlayStoreProvider>(create: (context) {
          return PlayStoreProvider();
        }),
        StreamProvider<InternetConnectionStatus>(
          initialData: InternetConnectionStatus.connected,
          create: (context) {
            return InternetConnectionChecker().onStatusChange;
          },
        )
      ],
      child: MathsVision(),
    ),
  );
}

class MathsVision extends StatelessWidget {
  TextStyle _style(
    String family,
    double fontSize,
    FontWeight weight,
    Color color, {
    Shadow shadow,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: fontSize,
      fontWeight: weight,
      color: color,
      letterSpacing: 0.0,
      wordSpacing: 1.0,
      shadows: [shadow],
    );
  }

  TextTheme _textTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.normal,
        fontSize: 20.0,
        color: Colors.black,
        letterSpacing: 0.0,
        wordSpacing: 1.0,
        shadows: [],
      ),
      displayMedium: _style(
        'Rockwell',
        20.0,
        FontWeight.normal,
        Color.fromARGB(255, 72, 73, 75),
        shadow: Shadow(
          blurRadius: 1.0,
          color: Colors.black.withOpacity(0.3),
          offset: Offset(1, 1),
        ),
      ),
      displaySmall: _style(
        'Roboto',
        12.0,
        FontWeight.normal,
        Colors.white,
        shadow: Shadow(
          blurRadius: 2,
          color: Colors.black.withOpacity(0.6),
          offset: Offset(0.5, 0.5),
        ),
      ),
      headlineLarge: _style(
        'Gabriola',
        22.0,
        FontWeight.bold,
        Colors.white,
        shadow: Shadow(
          blurRadius: 3,
          color: Colors.black,
          offset: Offset(1.0, 1.0),
        ),
      ),
      headlineMedium: GoogleFonts.abhayaLibre(
        fontSize: 30.0,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        letterSpacing: 0.0,
        wordSpacing: 1.0,
        shadows: [
          Shadow(
            blurRadius: 5.0,
            color: Colors.black.withOpacity(0.6),
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
      headlineSmall: _style(
        'Constan',
        30.0,
        FontWeight.normal,
        Color.fromARGB(255, 0, 88, 122),
        shadow: Shadow(
          blurRadius: 1,
          color: Colors.black.withOpacity(0.4),
          offset: Offset(1.0, 1.0),
        ),
      ),
      titleLarge: _style('Pristina', 30.0, FontWeight.bold, Color.fromARGB(255, 0, 88, 122)),
      titleMedium: _style('Gothic', 20.0, FontWeight.normal, Colors.white),
      titleSmall: _style(
        'Niagara Solid',
        25.0,
        FontWeight.normal,
        Color.fromARGB(255, 115, 111, 114),
      ),
      bodyLarge: GoogleFonts.philosopher(
        fontSize: 30.0,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.0,
        wordSpacing: 1.0,
        color: Color.fromARGB(255, 89, 89, 89),
        shadows: [],
      ),
      bodyMedium: _style('Iskola Potha', 17.0, FontWeight.normal, Colors.black),
      bodySmall: _style('AgencyFB', 25.0, FontWeight.normal, Colors.black),
      labelLarge: _style('Scriptina', 25.0, FontWeight.bold, Colors.white),
      labelMedium: _style(
        'Lemon Jelly',
        20.0,
        FontWeight.normal,
        Color.fromARGB(255, 200, 62, 77),
      ),
    );
  }

  TextTheme _primaryTextTheme() {
    return TextTheme(
      displayLarge: _style(
        'Dancing Script',
        26.0,
        FontWeight.normal,
        Colors.white,
        shadow: Shadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 3,
          offset: Offset(1, 1.5),
        ),
      ),
      displayMedium: _style(
        'Falcon',
        35.0,
        FontWeight.normal,
        Colors.white,
        shadow: Shadow(
          color: Colors.black.withOpacity(0.6),
          offset: Offset(2, 2),
          blurRadius: 5,
        ),
      ),
      displaySmall: _style('Crash', 17.0, FontWeight.bold, Colors.black),
      headlineLarge: _style(
        'Lemon Jelly',
        16.0,
        FontWeight.normal,
        Color.fromARGB(255, 0, 135, 145),
      ),
      headlineMedium: _style(
        'Warna',
        27.0,
        FontWeight.bold,
        Color.fromARGB(255, 72, 73, 75),
        shadow: Shadow(
          color: Colors.grey.shade600,
          blurRadius: 2,
          offset: Offset(1, 1),
        ),
      ),
    );
  }

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
          background: Color.fromARGB(255, 0, 135, 145),
          onBackground: Color.fromARGB(255, 1, 79, 134),
          error: Colors.red,
          onError: Color.fromARGB(255, 200, 62, 77),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 63, 129, 176),
        ),
        textTheme: _textTheme(),
        primaryTextTheme: _primaryTextTheme(),
      ),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    var provider = Provider.of<PlayStoreProvider>(context, listen: false);
    provider.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    var provider = Provider.of<PlayStoreProvider>(context, listen: false);
    provider.subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return OpenSplashScreen();
  }
}
