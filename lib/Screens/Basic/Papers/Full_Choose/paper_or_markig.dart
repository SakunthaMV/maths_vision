import 'dart:ui';

import 'package:external_path/external_path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maths_vision/Screens/Basic/Papers/Full_Display/paper_or_marking_watch.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../Widgets/common_background.dart';

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

  void paperDownload(String link, String type) async {
    final externalDir =
        await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    Fluttertoast.showToast(
      msg: 'Downloading...',
    );
    FlutterDownloader.enqueue(
      url: link,
      savedDir: externalDir,
      fileName: '${widget.year} Full $type.pdf',
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
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return CommonBackground(
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          children: [
            Center(
              child: RichText(
                text: TextSpan(
                  style: textTheme.titleMedium.copyWith(
                    fontSize: 60,
                    height: 1,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.4),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  children: [
                    TextSpan(
                      text: _year[0],
                    ),
                    TextSpan(
                      text: _year.length > 1 ? ' ${_year[1]}' : '',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _listItem('Past Paper'),
            _listItem('Marking Scheme'),
          ],
        ),
      ),
    );
  }

  Widget _listItem(String type) {
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String uType = type.split(' ').join('_');
    return Container(
      width: width * 0.8,
      height: 150,
      margin: const EdgeInsets.only(top: 25.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 7,
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onLongPress: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                return PaperOrMarkingWatch(
                  widget.year,
                  type,
                );
              },
            ),
          );
        },
        onPressed: () {
          _paperDialog(context, type);
        },
        child: Stack(
          children: [
            Opacity(
              opacity: 0.15,
              child: Container(
                padding: EdgeInsets.only(left: 100, top: 20),
                child: Image.asset('assets/$uType\_Icon.jpg'),
                width: width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type == 'Past Paper' ? 'ප්‍රශ්න පත්‍රය' : 'ලකුණු දීමේ ක්‍රමවේදය',
                    style: textTheme.headlineMedium.copyWith(
                      fontSize: 35,
                      color: colorScheme.tertiaryContainer,
                      fontWeight: FontWeight.bold,
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
                      type,
                      style: textTheme.titleLarge.copyWith(
                        fontSize: 25,
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
    );
  }

  Future<void> _paperDialog(BuildContext context, String type) async {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  child: Text(
                    '${widget.year} $type',
                    style: textTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7, bottom: 15),
                  child: Text(
                    type == 'Past Paper'
                        ? 'Download Size : ${widget.paperSize}'
                        : 'Download Size : ${widget.markingSize}',
                    style: textTheme.titleMedium
                        .copyWith(fontSize: 13, color: colorScheme.onPrimary),
                  ),
                ),
                _dialogButton(context, 'Watch Now', Icons.chrome_reader_mode, type),
                _dialogButton(context, 'Download', Icons.download_sharp, type)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dialogButton(BuildContext context, String buttonName, IconData icon, String type) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 210,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        onPressed: () {
          if (buttonName == 'Watch Now') {
            return Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) {
                  return PaperOrMarkingWatch(
                    widget.year,
                    type,
                  );
                },
              ),
            );
          }
          bool hasConnection = Provider.of<InternetConnectionStatus>(context, listen: false) ==
              InternetConnectionStatus.connected;
          if (!hasConnection) {
            return Fluttertoast.showToast(
              msg: 'Please connect to the Internet.',
            );
          }
          print(widget.paperPath);
          _downloadSource(type).then((url) async {
            final status = await Permission.storage.request();
            if (status.isGranted) {
              paperDownload(url, type);
            } else {
              Permission.storage.request();
            }
          });
        },
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            buttonName,
            style: textTheme.displayLarge.copyWith(
              color: colorScheme.primary,
              fontSize: 25,
            ),
          ),
        ),
        icon: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            icon,
            color: colorScheme.primary,
            size: 25,
          ),
        ),
      ),
    );
  }

  Future<String> _downloadSource(String type) async {
    return type == 'Past Paper'
        ? await FirebaseStorage.instance.ref().child(widget.paperPath).getDownloadURL()
        : await FirebaseStorage.instance.ref().child(widget.markingPath).getDownloadURL();
  }
}
