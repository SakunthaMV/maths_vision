import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:countdown_timer_simple/countdown_timer_simple.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:shimmer/shimmer.dart';

import '../Widgets/common_background.dart';

class PaperContent extends StatelessWidget {
  final String imagePath;
  final String subjectS;
  final String year;
  final String type;
  final String timeOrMarks;

  const PaperContent(this.imagePath, this.subjectS, this.year, this.type, this.timeOrMarks);

  Stream<int> waitingCounter() async* {
    int seconds = 11;
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield --seconds;
      if (seconds == 0) break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CommonBackground(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: size.width * 0.85,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 231, 231, 222),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            subjectS,
                            style: TextStyle(
                              fontFamily: 'Abhaya Libre',
                              fontSize: 28,
                              color: Color.fromARGB(255, 0, 88, 122),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            year + ' ' + type,
                            style: TextStyle(
                              fontFamily: 'Pristina',
                              fontSize: 30,
                              color: Color.fromARGB(255, 0, 88, 122),
                            ),
                          ),
                        ),
                        Text(
                          type == 'Question'
                              ? 'Time : ' + timeOrMarks + ' min'
                              : 'Marks : ' + timeOrMarks,
                          style: TextStyle(
                            fontFamily: 'Pristina',
                            fontSize: 27,
                            color: Color.fromARGB(255, 0, 88, 122),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              StreamBuilder<int>(
                  stream: waitingCounter(),
                  builder: (context, snapshot) {
                    double counterOpacity = 0.0;
                    double paperHeight = 102;
                    if (!snapshot.hasData) {
                      return SizedBox(
                        height: paperHeight + 35,
                      );
                    }
                    if (type != 'Question') {
                      return SizedBox(
                        height: 25,
                      );
                    }
                    if (snapshot.data < 10 && snapshot.data > 0) {
                      counterOpacity = 1.0;
                    }
                    if (snapshot.data == 0) {
                      paperHeight = 75;
                    }
                    int time = snapshot.data;
                    return Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 500),
                              opacity: counterOpacity,
                              child: SizedBox(
                                height: 25,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.7),
                                          blurRadius: 4,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Your time will start in ',
                                      ),
                                      TextSpan(
                                        text: '$time',
                                        style: TextStyle(
                                          color: time > 3 ? Colors.white : Colors.red,
                                          shadows: [
                                            Shadow(
                                              color: time > 3
                                                  ? Colors.black.withOpacity(0.7)
                                                  : Colors.grey.shade600.withOpacity(0.7),
                                              blurRadius: 4,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' seconds',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(seconds: 3),
                          height: paperHeight,
                        ),
                      ],
                    );
                  }),
              StreamBuilder<String>(
                stream: FirebaseStorage.instance
                    .ref()
                    .child(imagePath)
                    .getDownloadURL()
                    .asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        width: size.width * 0.95,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: InteractiveViewer(
                            minScale: 1.0,
                            maxScale: 4.0,
                            child: SingleChildScrollView(
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data,
                                placeholder: (context, url) {
                                  if (type == 'Question') {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: LoadingBumpingLine.circle(
                                        size: 100,
                                        backgroundColor: Colors.transparent,
                                        borderColor: Colors.black,
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    width: size.width * 0.8,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.transparent,
                                      highlightColor: Colors.grey,
                                      child: Image.asset('assets/Loading_Icon.png'),
                                    ),
                                  );
                                },
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      width: size.width * 0.8,
                      child: Shimmer.fromColors(
                        baseColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        child: Image.asset('assets/Loading_Icon.png'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          StreamBuilder<int>(
            stream: waitingCounter(),
            builder: (context, snapshot) {
              double positionX = 1.0;
              double positionY = -1.14;
              int min = int.parse(timeOrMarks.split(':').first);
              int sec = int.parse(timeOrMarks.split(':').last);
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }
              if (type != 'Question') {
                return SizedBox.shrink();
              }
              if (snapshot.data > 3) {
                positionX = 3.0;
              }
              if (snapshot.data > 0) {
                positionY = -1.0;
              }
              return AnimatedContainer(
                duration: Duration(seconds: 3),
                alignment: Alignment(positionX, positionY),
                child: Padding(
                  padding: const EdgeInsets.only(top: 180),
                  child: Container(
                    width: 180,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 88, 122),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        bottomLeft: Radius.circular(35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 0),
                          blurRadius: 12,
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: CountdownTimerSimple(
                      endTime: DateTime.now().millisecondsSinceEpoch +
                          1000 * ((60 * min) + 1 + sec),
                      showHour: false,
                      textStyle: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.8),
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
