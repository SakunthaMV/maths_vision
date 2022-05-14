import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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
      theme: ThemeData(brightness: Brightness.light),
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
