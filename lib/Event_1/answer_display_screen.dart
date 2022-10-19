import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maths_vision/Support_Classes/event_errors_and_loading.dart';

class AnswerDisplayScreen extends StatefulWidget {
  final int stage;
  final int question;

  const AnswerDisplayScreen(this.stage, this.question, {Key key}) : super(key: key);

  @override
  _AnswerDisplayScreenState createState() => _AnswerDisplayScreenState();
}

class _AnswerDisplayScreenState extends State<AnswerDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 79, 134),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 63, 129, 176),
        elevation: 9,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'Ateeca',
                        shadows: [
                          Shadow(
                            blurRadius: 1,
                            offset: Offset(1, 1),
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      children: [
                        TextSpan(
                          text: 'S',
                        ),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(1.0, 0.0),
                            child: Text(
                              '${widget.stage}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Ateeca',
                                shadows: [
                                  Shadow(
                                    blurRadius: 1,
                                    offset: Offset(1, 1),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'Ateeca',
                        shadows: [
                          Shadow(
                            blurRadius: 1,
                            offset: Offset(1, 1),
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      children: [
                        TextSpan(
                          text: 'Q',
                        ),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(1.0, 0),
                            child: Text(
                              '${widget.question}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Ateeca',
                                shadows: [
                                  Shadow(
                                    blurRadius: 1,
                                    offset: Offset(1, 1),
                                    color: Colors.black.withOpacity(0.5),
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
              SizedBox(
                width: 30,
              ),
              Text(
                'Answer',
                style: TextStyle(
                  fontFamily: 'Scriptina',
                  fontSize: 25,
                  color: Colors.white,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 1,
                      offset: Offset(1, 1),
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: width * 0.025,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 5.0,
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: width * 0.95,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: StreamBuilder(
                      stream: FirebaseStorage.instance
                          .ref('Events/Trigonometry/Stage_${widget.stage}/Q${widget.question}.jpg')
                          .getDownloadURL()
                          .asStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data,
                              placeholder: (_, url) {
                                return SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: LoadingBumpingLine.circle(
                                    backgroundColor: Colors.transparent,
                                    borderColor: Colors.black,
                                    borderSize: 10,
                                    size: 100,
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Icon(Icons.error);
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return UnknownError();
                        } else {
                          return EventLoading();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: width * 0.025,
            ),
          ],
        ),
      ),
    );
  }
}
