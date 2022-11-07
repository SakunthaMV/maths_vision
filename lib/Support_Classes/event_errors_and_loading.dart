import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EventLoading extends StatelessWidget {
  final Color color;
  const EventLoading({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(color: color?? Colors.white, size: 120),
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

