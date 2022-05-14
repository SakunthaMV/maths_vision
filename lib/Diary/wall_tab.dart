import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class WallTab extends StatefulWidget {
  const WallTab({Key key}) : super(key: key);

  @override
  _WallTabState createState() => _WallTabState();
}

class _WallTabState extends State<WallTab> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: width * 0.05,
        ),
        Expanded(
          child: Container(
            width: width * 0.9,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 110, 187, 192),
              borderRadius: BorderRadius.circular(25),
            ),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('Events').doc('Wall').snapshots(),
              builder: (context, event) {
                if (event.hasData) {
                  String T = 'Trigonometry_Posts';
                  if (event.data['Trigonometry_Posts'].length > 0) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: width * 0.05),
                      itemCount: event.data['$T'].length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(event.data['$T'][event.data['$T'].length - index - 1]
                                  ['UserID'])
                              .snapshots(),
                          builder: (context, user) {
                            if (user.hasData) {
                              return Align(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: (160 * width * 0.8 / 300) - 160 + width * 0.07,
                                  ),
                                  child: _wallListItem(index, event.data, user.data),
                                ),
                              );
                            } else {
                              return LoadingFadingLine.circle(
                                size: 70,
                                backgroundColor: Colors.white,
                              );
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        'There is no any post to show.',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Philosopher',
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                } else {
                  return LoadingBouncingLine.circle(
                    size: 100,
                    backgroundColor: Colors.white,
                  );
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: width * 0.05,
        ),
      ],
    );
  }

  Widget _wallListItem(int index, DocumentSnapshot event, DocumentSnapshot user) {
    final double width = MediaQuery.of(context).size.width;
    String T = 'Trigonometry_Posts';
    int latest = event['$T'].length - index - 1;
    String name = '${user['User_Details.firstName']} ${user['User_Details.lastName']}';
    Color frameColor = Color(int.parse(event['$T'][latest]['Color']));
    String time =
        StopWatchTimer.getDisplayTime(event['$T'][latest]['Time'], milliSecond: false);
    String timeMil = StopWatchTimer.getDisplayTimeMillisecond(event['$T'][latest]['Time']);
    String symbol = event['$T'][latest]['Symbol'];
    return Transform.scale(
      scale: width * 0.8 / 300,
      child: Container(
        width: 300,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: frameColor, width: 1),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black.withOpacity(0.4),
              offset: Offset(0,0),
              spreadRadius: 1.5,
            ),
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: 42,
              child: Container(
                height: 22,
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 239, 197, 1),
                      Color.fromARGB(255, 249, 224, 159),
                      Color.fromARGB(255, 239, 197, 1),
                      Color.fromARGB(255, 249, 224, 159),
                      Color.fromARGB(255, 239, 197, 1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      spreadRadius: -3.5,
                      color: Colors.black.withOpacity(0.4),
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$name',
                    style: TextStyle(
                      fontFamily: 'Javanese Text',
                      fontSize: 15,
                      letterSpacing: 0.2,
                      height: 1.8,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 25,
              top: 70,
              child: SizedBox(
                height: 85,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Congratulations',
                      style: TextStyle(
                        fontFamily: 'Hey October',
                        fontSize: 25,
                        letterSpacing: 0.7,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      width: 170,
                      height: 40,
                      padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromARGB(255, 106, 197, 254),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${event['$T'][latest]['Quote']}',
                            style: TextStyle(
                              fontFamily: 'Centaur',
                              fontSize: 12,
                              height: 1,
                              color: Colors.black,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Text(
                                '- MATHS VISION -',
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 7,
                                  height: 1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: Offset(0.5, 0.5),
                                    ),
                                  ],
                                ),
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
              width: 300,
              height: 160,
              child: Image.asset(
                'assets/Share_Frame.png',
                fit: BoxFit.fill,
                color: frameColor,
              ),
            ),
            Positioned(
              top: 5,
              left: 0,
              child: SizedBox(
                width: 170,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: time,
                        ),
                        TextSpan(
                          text: ':$timeMil',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('assets/${symbol}_Gold_Inner.png'),
              ),
            ),
            Positioned(
              top: 28,
              right: 15.5,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: frameColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: frameColor, width: 2.5),
                ),
                child: Center(
                  child: ClipOval(
                    child: user['User_Details.photoURL'] != null
                        ? CachedNetworkImage(
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                            imageUrl: user['User_Details.photoURL'],
                            placeholder: (_, url) {
                              return CircularProgressIndicator();
                            },
                            errorWidget: (context, url, error) {
                              return Icon(Icons.error);
                            },
                          )
                        : Icon(
                            Icons.account_circle_rounded,
                            size: 48,
                            color: Color.fromARGB(255, 202, 202, 202),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
