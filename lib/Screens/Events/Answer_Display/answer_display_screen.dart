import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Screens/Events/Common_Widgets/question_notation.dart';
import 'package:maths_vision/Services/ad_manager.dart';
import 'package:maths_vision/Widgets/event_errors_and_loading.dart';

class AnswerDisplayScreen extends StatefulWidget {
  final int stage;
  final int question;

  const AnswerDisplayScreen(this.stage, this.question, {Key key}) : super(key: key);

  @override
  State<AnswerDisplayScreen> createState() => _AnswerDisplayScreenState();
}

class _AnswerDisplayScreenState extends State<AnswerDisplayScreen> {

  BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdManager.bannerAnswerDisplay,
      request: AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 79, 134),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 63, 129, 176),
        elevation: 4,
        leading: SizedBox.shrink(),
        leadingWidth: 0.0,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QuestionNotation(
                widget.stage,
                widget.question,
                color: Colors.white,
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                'Answer',
                style: TextStyle(
                  fontFamily: 'Scriptina',
                  fontSize: 25,
                  color: Colors.white,
                  height: 1.7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: width * 0.95,
              height: height,
              margin: EdgeInsets.all(width * 0.025),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: StreamBuilder<String>(
                  stream: FirebaseStorage.instance
                      .ref('Events/Trigonometry/Stage_${widget.stage}/Q${widget.question}.jpg')
                      .getDownloadURL()
                      .asStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: LoadingAnimationWidget.twoRotatingArc(
                          color: Colors.black,
                          size: 100,
                        ),
                      );
                    }
                    return Align(
                      alignment: Alignment.topCenter,
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 4.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data,
                              placeholder: (_, url) {
                                return Center(
                                  child: LoadingAnimationWidget.horizontalRotatingDots(
                                    color: Colors.black,
                                    size: 70,
                                  ),
                                );
                              },
                              errorWidget: (_, url, error) {
                                return UnknownError();
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          AdManager.bannerAdShow(_bannerAd, margin: 0.0),
        ],
      ),
    );
  }
}
