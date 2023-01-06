import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Widgets/event_errors_and_loading.dart';

import '../../../../Services/ad_manager.dart';
import '../../../../Widgets/common_background.dart';

class PaperOrMarkingWatch extends StatefulWidget {
  final String yearString;
  final String type;
  const PaperOrMarkingWatch(this.yearString, this.type);

  @override
  State<PaperOrMarkingWatch> createState() => _PaperOrMarkingWatchState();
}

class _PaperOrMarkingWatchState extends State<PaperOrMarkingWatch> {
  InterstitialAd _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdManager.interstitialFullPaper,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: (){
        if(_interstitialAd!=null){
          _interstitialAd.show();
        }
        return Future.value(true);
      },
      child: CommonBackground(
        appBarTitle: Text(
          '${widget.yearString} ${widget.type}',
          style: textTheme.headlineLarge,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('Papers').doc('Papers').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: LoadingBouncingLine.circle(
                  size: 100,
                  backgroundColor: Colors.transparent,
                  borderColor: colorScheme.onPrimary,
                ),
              );
            }
            final String t = '${widget.type.split(' ').join('_')}';
            final int purePages = snapshot.data['Full_Papers.${widget.yearString}.$t.purePages'];
            final int appliedPages = snapshot.data['Full_Papers.${widget.yearString}.$t.appliedPages'];
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
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
                      ),
                      child: ListView.builder(
                        itemCount: purePages + appliedPages + 2,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              _page(index, purePages),
                              Container(
                                height: 30,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: Column(
                                  children: [
                                    Divider(
                                      height: 3,
                                      thickness: 3,
                                      color: colorScheme.onPrimary,
                                      indent: 25,
                                      endIndent: 25,
                                    ),
                                    Divider(
                                      height: 5,
                                      thickness: 1,
                                      color: colorScheme.onPrimary,
                                      indent: 25,
                                      endIndent: 25,
                                    ),
                                    Text(
                                      '-${index + 1}-',
                                      textAlign: TextAlign.right,
                                      style: Theme.of(context).primaryTextTheme.displaySmall,
                                    ),
                                  ],
                                ),
                                width: width,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
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
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _page(int index, int purePages) {
    final List yearSplit = widget.yearString.split(' ');
    final String year = '${widget.yearString.split(' ').join('_')}';
    final String t = '${widget.type.split(' ').join('_')}';
    final String purePath = 'Full_Papers/$year/$t/Pure/$index.jpg';
    final String pureFrontPath =
        'Full_Papers/$year/$t/Pure/'
        '${yearSplit[0]}${yearSplit.length > 1 ? yearSplit[1][0] : ''}.jpg';
    final String appliedPath = 'Full_Papers/$year/$t/Applied/${index - purePages - 1}.jpg';
    final String appliedFrontPath =
        'Full_Papers/$year/$t/Applied/'
        '${yearSplit[0]}${yearSplit.length > 1 ? yearSplit[1][0] : ''}.jpg';
    if (index == 0) {
      return _pageLoad(pureFrontPath);
    } else if (index > 0 && index <= purePages) {
      return _pageLoad(purePath);
    } else if (index == purePages + 1) {
      return _pageLoad(appliedFrontPath);
    } else {
      return _pageLoad(appliedPath);
    }
  }

  Widget _pageLoad(String path){
    const AspectRatio aspectRatio = const AspectRatio(
      child: BlurHash(hash: 'L4Ss50D%_3~q_3IUWB%M~qRkIUt7'),
      aspectRatio: 1080 / 1555,
    );
    return StreamBuilder<String>(
      stream: FirebaseStorage.instance.ref().child(path).getDownloadURL().asStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return aspectRatio;
        }
        return CachedNetworkImage(
          imageUrl: snapshot.data,
          placeholder: (context, url) {
            return aspectRatio;
          },
          errorWidget: (context, url, error) => UnknownError(),
        );
      },
    );
  }
}
