import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:maths_vision/Splash_Screens/log_in_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation_drawer.dart';

class NotePage extends StatefulWidget {
  final String subject;

  const NotePage(this.subject);

  @override
  _NotePageState createState() => _NotePageState(subject);
}

class _NotePageState extends State<NotePage> {
  String subject;

  _NotePageState(this.subject);

  Future<List<String>> numberOfImages() async {
    int images;
    String pathName = widget.subject.split(' ').join('_');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    images = prefs.getInt(pathName);
    List<String> allImages = List.generate(images, (index) {
      String imageName = pathName + '_${index + 1}';
      return prefs.getString(imageName);
    });
    return allImages;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          color: Color.fromARGB(255, 0, 135, 145),
        ),
        Opacity(
          opacity: 0.12,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/HomeBackground.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              subject,
              style: TextStyle(
                fontFamily: 'Gabriola',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
                shadows: [
                  Shadow(
                    color: Theme.of(context).colorScheme.onPrimary,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  iconSize: 35,
                  color: Theme.of(context).colorScheme.primary,
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    return Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 70,
            toolbarHeight: 70,
            actions: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      color: Colors.grey.shade700,
                      blurRadius: 10,
                      spreadRadius: -9,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: ClipOval(
                    child: Image.asset(
                      'assets/HomeButton.jpg',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return LogInSplashScreen();
                        },
                      ),
                    );
                  },
                  iconSize: 35,
                  splashRadius: 25,
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          drawer: NavigationDrawer(),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: size.width * 0.95,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: FutureBuilder<List<String>>(
                    future: numberOfImages(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: List.generate(
                            snapshot.data.length,
                            (index) {
                              Uint8List _bytes = Base64Decoder().convert(snapshot.data[index]);
                              return Image.memory(_bytes);
                            },
                          ),
                        );
                      }
                      return Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
