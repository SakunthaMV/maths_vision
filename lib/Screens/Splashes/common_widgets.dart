import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget splashCommon(BuildContext context, {Widget middle}) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final TextTheme textTheme = Theme.of(context).textTheme;
  return WillPopScope(
    onWillPop: () {
      return Future.value(false);
    },
    child: Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
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
          Align(
            alignment: Alignment(0, -0.35),
            child: Container(
              width: 230,
              height: 230,
              child: Image.asset('assets/Loading_Icon.png'),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(builder: (context) {
                if (middle == null) {
                  return SizedBox(
                    height: 120.0,
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 140.0,
                    bottom: 20.0,
                  ),
                  child: middle,
                );
              }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Text(
                        'MATHS VISION',
                        style: TextStyle(
                          fontFamily: 'Aquire Bold',
                          fontSize: 45,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1.2
                            ..color = colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        'MATHS VISION',
                        style: TextStyle(
                          fontFamily: 'Aquire Bold',
                          fontSize: 45,
                          color: colorScheme.surfaceVariant,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.4),
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 130,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          spreadRadius: 0,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Shimmer.fromColors(
                      baseColor: colorScheme.onPrimary,
                      highlightColor: colorScheme.primary,
                      child: Text(
                        'NEXT LEVEL',
                        style: textTheme.bodySmall.copyWith(
                          fontSize: 30,
                          color: colorScheme.onTertiary,
                          shadows: [
                            Shadow(
                              blurRadius: 1,
                              color: Colors.black.withOpacity(0.6),
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
