import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EventLoading extends StatelessWidget {
  final Color color;
  final double size;

  const EventLoading({Key key, this.color, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: color ?? Colors.white,
        size: size ?? 120,
      ),
    );
  }
}

class NetworkError extends StatelessWidget {
  final Color color;

  const NetworkError({this.color});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: 200,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: color ?? colorScheme.primary, width: 4),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/Network_Error_Icon.png',
            width: 150,
            color: color ?? colorScheme.primary,
          ),
          Text(
            'Please check\nyour internet\nconnection ',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium.copyWith(
              color: color ?? colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  blurRadius: 3,
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(1, 1),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UnknownError extends StatelessWidget {
  const UnknownError({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 80,
            child: Image.asset('assets/Network_Weak_Icon.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Something Went Wrong...',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontFamily: 'Open Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
