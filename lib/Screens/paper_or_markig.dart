import 'dart:ui';

import 'package:ext_storage/ext_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maths_vision/Splash_Screens/went_home_splash_screen.dart';
import 'package:maths_vision/Screens/paper_or_marking_watch.dart';
import 'package:permission_handler/permission_handler.dart';

import 'navigation_drawer.dart';

class PaperOrMarking extends StatefulWidget {
  final String year;
  final String paperSize;
  final String paperPath;
  final String markingSize;
  final String markingPath;

  const PaperOrMarking(
      this.year, this.paperSize, this.paperPath, this.markingSize, this.markingPath);

  @override
  _PaperOrMarkingState createState() => _PaperOrMarkingState();
}

class _PaperOrMarkingState extends State<PaperOrMarking> {
  List _year;

  void pastPaperDownload(String link) async {
    final externalDir =
        await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    Fluttertoast.showToast(
      msg: 'Downloading...',
      fontSize: 16,
    );
    FlutterDownloader.enqueue(
      url: link,
      savedDir: externalDir,
      fileName: '${widget.year} Full Past Paper.pdf',
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  void markingDownload(String link) async {
    final externalDir =
        await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    Fluttertoast.showToast(
      msg: 'Downloading...',
      fontSize: 16,
    );
    FlutterDownloader.enqueue(
      url: link,
      savedDir: externalDir,
      fileName: '${widget.year} Full Marking Scheme.pdf',
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _year = widget.year.split(" ");
    });
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
            leading: Builder(
              builder: (context) {
                return IconButton(
                  iconSize: 35,
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
                          return WentHomeSplashScreen();
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
          backgroundColor: Colors.transparent,
          drawer: NavigationDrawer(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _year[0],
                          style: TextStyle(
                            fontSize: 60,
                            fontFamily: 'Gothic',
                            color: Colors.white,
                            height: 1,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: _year.length > 1 ? ' ${_year[1]}' : '',
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Georgia',
                            color: Colors.white,
                            height: 1,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: size.width * 0.8,
                  height: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      primary: Colors.white,
                    ),
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return PaperOrMarkingWatch(
                              widget.year,
                              'Past Paper',
                            );
                          },
                        ),
                      );
                    },
                    onPressed: () {
                      _paperDialog(context, 'Past_Paper');
                    },
                    child: Stack(
                      children: [
                        Opacity(
                          child: Container(
                            padding: EdgeInsets.only(left: 100, top: 20),
                            child: Image.asset('assets/Past_Paper_Icon.jpg'),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                            ),
                          ),
                          opacity: 0.15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ප්‍රශ්න පත්‍රය',
                                style: TextStyle(
                                  fontFamily: 'Abhaya Libre',
                                  fontSize: 35,
                                  color: Color.fromARGB(255, 0, 88, 122),
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      offset: Offset(1, 1),
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'Past Paper',
                                  style: TextStyle(
                                    fontFamily: 'Pristina',
                                    fontSize: 25,
                                    color: Color.fromARGB(255, 0, 88, 122),
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1,
                                        offset: Offset(0.5, 0.5),
                                        color: Colors.black.withOpacity(0.3),
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
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: size.width * 0.8,
                  height: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      primary: Colors.white,
                    ),
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return PaperOrMarkingWatch(
                              widget.year,
                              'Marking Scheme',
                            );
                          },
                        ),
                      );
                    },
                    onPressed: () {
                      _paperDialog(context, 'Marking_Scheme');
                    },
                    child: Stack(
                      children: [
                        Opacity(
                          child: Container(
                            padding: EdgeInsets.only(left: 100, top: 20),
                            child: Image.asset('assets/Marking_Scheme_Icon.jpg'),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                            ),
                          ),
                          opacity: 0.15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ලකුණු දීමේ ක්‍රමවේදය',
                                style: TextStyle(
                                  fontFamily: 'Abhaya Libre',
                                  fontSize: 35,
                                  color: Color.fromARGB(255, 0, 88, 122),
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      offset: Offset(1, 1),
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'Marking Scheme',
                                  style: TextStyle(
                                    fontFamily: 'Pristina',
                                    fontSize: 25,
                                    color: Color.fromARGB(255, 0, 88, 122),
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1,
                                        offset: Offset(0.5, 0.5),
                                        color: Colors.black.withOpacity(0.3),
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _paperDialog(BuildContext context, String type) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  type == 'Past_Paper'
                      ? '${widget.year} Past Paper'
                      : '${widget.year} Marking Scheme',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Gothic',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(1, 1.5),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    type == 'Past_Paper'
                        ? 'Download Size : ${widget.paperSize}'
                        : 'Download Size : ${widget.markingSize}',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Gothic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 210,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 0, 136, 145),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) {
                            if (type == 'Past_Paper') {
                              return PaperOrMarkingWatch(
                                widget.year,
                                'Past Paper',
                              );
                            } else {
                              return PaperOrMarkingWatch(
                                widget.year,
                                'Marking Scheme',
                              );
                            }
                          },
                        ),
                      );
                    },
                    label: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        'Watch Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Open Sans',
                        ),
                      ),
                    ),
                    icon: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.chrome_reader_mode,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<String>(
                  stream: type == 'Past_Paper'
                      ? FirebaseStorage.instance
                          .ref()
                          .child(widget.paperPath)
                          .getDownloadURL()
                          .asStream()
                      : FirebaseStorage.instance
                          .ref()
                          .child(widget.markingPath)
                          .getDownloadURL()
                          .asStream(),
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: 210,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 0, 136, 145),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        onPressed: () async {
                          if(snapshot.hasData){
                            final status = await Permission.storage.request();
                            if (status.isGranted) {
                              if (type == 'Past_Paper') {
                                pastPaperDownload(snapshot.data);
                              } else {
                                markingDownload(snapshot.data);
                              }
                            } else if (status.isRestricted) {
                              Permission.storage.request();
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Please wait while data loads...',
                              fontSize: 16,
                            );
                          }
                        },
                        label: Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                          child: Text(
                            'Download',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'Open Sans',
                            ),
                          ),
                        ),
                        icon: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.download_sharp,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
