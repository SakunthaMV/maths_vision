import 'package:flutter/material.dart';

class QuestionNotation extends StatelessWidget {
  final int stage;
  final int question;
  final Color color;
  const QuestionNotation(this.stage, this.question, {Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: color?? Colors.black,
              fontSize: 36,
              fontFamily: 'Ateeca',
            ),
            children: [
              TextSpan(
                text: 'S',
              ),
              WidgetSpan(
                child: Transform.translate(
                  offset: Offset(1.0, 0.0),
                  child: Text(
                    '$stage',
                    style: TextStyle(
                      color: color?? Colors.black,
                      fontSize: 17,
                      fontFamily: 'Ateeca',
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
              color: color?? Colors.black,
              fontSize: 36,
              fontFamily: 'Ateeca',
            ),
            children: [
              TextSpan(
                text: 'Q',
              ),
              WidgetSpan(
                child: Transform.translate(
                  offset: Offset(1.0, 0.0),
                  child: Text(
                    '$question',
                    style: TextStyle(
                      color: color?? Colors.black,
                      fontSize: 17,
                      fontFamily: 'Ateeca',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
