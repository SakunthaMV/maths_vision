import 'package:flutter/material.dart';

class EventLoading extends StatelessWidget {
  const EventLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          strokeWidth: 7,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
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

