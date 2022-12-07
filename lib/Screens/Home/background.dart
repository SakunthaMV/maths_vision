import 'dart:math';

import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  final Widget body;

  const HomeBackground({Key key, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          color: colorScheme.background,
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
        Transform.rotate(
          angle: pi,
          child: SizedBox(
            height: height * 0.55,
            width: width,
            child: CustomPaint(
              painter: BackgroundColor(),
              child: Container(),
            ),
          ),
        ),
        body,
      ],
    );
  }
}

class BackgroundColor extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color.fromARGB(255, 183, 183, 183);
    paint.style = PaintingStyle.fill;
    var path = Path();

    path.moveTo(0, size.height * 0.2);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.42);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
