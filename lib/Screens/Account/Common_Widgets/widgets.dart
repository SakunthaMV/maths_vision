import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Container backgroundContainer(BuildContext context, {@required Widget child}){
  final double width = MediaQuery.of(context).size.width;
  return Container(
    width: width * 0.85,
    margin: const EdgeInsets.symmetric(vertical: 20.0),
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: width * 0.05),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.25),
          Colors.black.withOpacity(0.15),
          Colors.black.withOpacity(0.15),
          Colors.black.withOpacity(0.25),
        ],
      ),
    ),
    child: child,
  );
}

RichText pageTitle(BuildContext context, {String top, String bottom1, String bottom2}){
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final TextTheme textTheme = Theme.of(context).textTheme;
  return RichText(
    text: TextSpan(
      style: textTheme.displaySmall.copyWith(
        fontSize: 24.0,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 4,
            offset: Offset(1.5, 1.5),
          ),
        ],
      ),
      children: [
        TextSpan(text: '${top?? 'CREATE A'}\n'),
        TextSpan(
          text: bottom1?? 'MATHS VISION',
          style: GoogleFonts.roboto(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            color: colorScheme.primary,
            height: 1.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                offset: Offset(1.5, 1.5),
              ),
            ],
          ),
        ),
        TextSpan(text: bottom2?? ' ACCOUNT'),
      ],
    ),
  );
}