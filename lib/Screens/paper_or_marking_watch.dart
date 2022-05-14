import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Splash_Screens/went_home_splash_screen.dart';

import 'navigation_drawer.dart';

class PaperOrMarkingWatch extends StatefulWidget {
  final String year;
  final String type;

  const PaperOrMarkingWatch(this.year, this.type);

  @override
  _PaperOrMarkingWatchState createState() => _PaperOrMarkingWatchState();
}

class _PaperOrMarkingWatchState extends State<PaperOrMarkingWatch> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
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
              '${widget.year} ${widget.type}',
              style: TextStyle(
                fontFamily: 'Gabriola',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    color: Colors.black,
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
          drawer: NavigationDrawer(),
          backgroundColor: Colors.transparent,
          body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('Papers').doc('Papers').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List typeSplit = widget.type.split(' ');
                String t = '${typeSplit[0]}_${typeSplit[1]}';
                int purePages = snapshot.data['Full_Papers.${widget.year}.$t.purePages'];
                int appliedPages = snapshot.data['Full_Papers.${widget.year}.$t.appliedPages'];
                return Center(
                  child: Container(
                    width: width * 0.95,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 4.0,
                        child: ListView.builder(
                          itemCount: purePages + appliedPages + 2,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                _page(index, purePages),
                                Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      child: Column(
                                        children: [
                                          Divider(
                                            height: 3,
                                            thickness: 3,
                                            color: Colors.black,
                                            indent: 25,
                                            endIndent: 25,
                                          ),
                                          Divider(
                                            height: 5,
                                            thickness: 1,
                                            color: Colors.black,
                                            indent: 25,
                                            endIndent: 25,
                                          ),
                                          Text(
                                            '-${index + 1}-',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontFamily: 'Crash',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2,
                                            offset: Offset(0, 3),
                                            spreadRadius: 0,
                                            color: Colors.black.withOpacity(0.4),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: LoadingBouncingLine.circle(
                    size: 100,
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.black,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _page(int index, int purePages) {
    List yearSplit = widget.year.split(' ');
    String year = '${yearSplit[0]}${yearSplit.length > 1 ? '_${yearSplit[1]}' : ''}';
    List typeSplit = widget.type.split(' ');
    String t = '${typeSplit[0]}_${typeSplit[1]}';
    String purePath = 'Full_Papers/$year/$t/Pure/$index.jpg';
    String pureFrontPath =
        'Full_Papers/$year/$t/Pure/${yearSplit[0]}${yearSplit.length > 1 ? yearSplit[1][0] : ''}.jpg';
    String appliedPath = 'Full_Papers/$year/$t/Applied/${index - purePages - 1}.jpg';
    String appliedFrontPath =
        'Full_Papers/$year/$t/Applied/${yearSplit[0]}${yearSplit.length > 1 ? yearSplit[1][0] : ''}.jpg';
    if (index == 0) {
      return StreamBuilder<String>(
        stream:
            FirebaseStorage.instance.ref().child(pureFrontPath).getDownloadURL().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              imageUrl: snapshot.data,
              placeholder: (context, url) {
                return AspectRatio(
                  child: BlurHash(hash: 'L4Ss50D%_3~q_3IUWB%M~qRkIUt7'),
                  aspectRatio: 1080 / 1555,
                );
              },
              errorWidget: (context, url, error) => Icon(Icons.error),
            );
          } else {
            return AspectRatio(
              child: BlurHash(hash: 'L4Ss50D%_3~q_3IUWB%M~qRkIUt7'),
              aspectRatio: 1080 / 1555,
            );
          }
        },
      );
    } else if (index > 0 && index <= purePages) {
      return StreamBuilder<String>(
        stream: FirebaseStorage.instance.ref().child(purePath).getDownloadURL().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              imageUrl: snapshot.data,
              placeholder: (context, url) {
                return AspectRatio(
                  child: BlurHash(hash: 'L4Ss50D%_3~q_3IUWB%M~qRkIUt7'),
                  aspectRatio: 1080 / 1555,
                );
              },
              errorWidget: (context, url, error) => Icon(Icons.error),
            );
          } else {
            return AspectRatio(
              child: BlurHash(hash: 'L4Ss50D%_3~q_3IUWB%M~qRkIUt7'),
              aspectRatio: 1080 / 1555,
            );
          }
        },
      );
    } else if (index == purePages + 1) {
      return StreamBuilder<String>(
        stream:
            FirebaseStorage.instance.ref().child(appliedFrontPath).getDownloadURL().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              imageUrl: snapshot.data,
              placeholder: (context, url) {
                return AspectRatio(
                  child: BlurHash(hash: 'L4Ss50D%_3~q_3IUWB%M~qRkIUt7'),
                  aspectRatio: 1080 / 1555,
                );
              },
              errorWidget: (context, url, error) => Icon(Icons.error),
            );
          } else {
            return AspectRatio(
              child: BlurHash(hash: 'L4Ss50D%_3~q_3IUWB%M~qRkIUt7'),
              aspectRatio: 1080 / 1555,
            );
          }
        },
      );
    } else {
      return StreamBuilder<String>(
        stream: FirebaseStorage.instance.ref().child(appliedPath).getDownloadURL().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              imageUrl: snapshot.data,
              placeholder: (context, url) {
                return AspectRatio(
                  child: BlurHash(hash: 'L4Ss50D%_3~q_3IUWB%M~qRkIUt7'),
                  aspectRatio: 1080 / 1555,
                );
              },
              errorWidget: (context, url, error) => Icon(Icons.error),
            );
          } else {
            return AspectRatio(
              child: BlurHash(hash: 'L4Ss50D%_3~q_3IUWB%M~qRkIUt7'),
              aspectRatio: 1080 / 1555,
            );
          }
        },
      );
    }
  }
}
