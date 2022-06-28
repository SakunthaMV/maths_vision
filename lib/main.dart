import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:maths_vision/Event_1/play_store_provider.dart';
import 'package:maths_vision/Splash_Screens/open_splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  InAppPurchaseConnection.enablePendingPurchases();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true);
  runApp(
    ChangeNotifierProvider(
      create: (context) => PlayStoreProvider(),
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
          background: Color.fromARGB(255, 0, 135, 145),
          onBackground: Color.fromARGB(255, 0, 135, 145),
          secondary: Color.fromARGB(255, 1, 79, 134),
          surface: Color.fromARGB(255, 162, 156, 156),
          error: Colors.redAccent,
          onError: Colors.redAccent,
          onSecondary: Color.fromARGB(255, 0, 135, 145),
          onSurface: Color.fromARGB(255, 0, 135, 145),
          shadow: Colors.black.withOpacity(0.3),
          tertiary: Color.fromARGB(255, 3, 130, 139),
        ),
        textTheme: TextTheme(
          headlineSmall: GoogleFonts.roboto(
            fontSize: 12,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 2,
                color: Colors.black.withOpacity(0.6),
                offset: Offset(0.5, 0.5),
              ),
            ],
          ),
          titleMedium: TextStyle(
            color: Color.fromARGB(255, 72, 73, 75),
            fontSize: 27.0,
            fontFamily: 'Warna',
            fontWeight: FontWeight.bold,
            wordSpacing: -6,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: Colors.grey.shade600,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
          ),
          titleSmall: TextStyle(
            fontFamily: 'Gabriola',
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 119, 123, 126),
            shadows: [
              Shadow(
                color: Colors.grey.shade600,
                blurRadius: 1,
                offset: Offset(0.5, 0.5),
              ),
            ],
          ),
          labelMedium: TextStyle(
            height: 1.5,
            fontFamily: 'Rockwell',
            fontSize: 20,
            color: Color.fromARGB(255, 72, 73, 75),
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 1,
                offset: Offset(0.5, 1),
              ),
            ],
          ),
        )
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
