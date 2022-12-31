import 'package:flutter/material.dart';

import '../Screens/Navigation_Drawer/navigation_drawer.dart';
import 'common_app_bar.dart';

class CommonBackground extends StatelessWidget{
  final Widget body;
  final Widget appBarTitle;

  const CommonBackground({
    Key key,
    this.body,
    this.appBarTitle
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Theme.of(context).colorScheme.background,
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
        Scaffold(
          appBar: CommonAppBar(
            title: appBarTitle,
          ),
          backgroundColor: Colors.transparent,
          drawer: NavigationDrawer(),
          body: body?? SizedBox.shrink(),
        ),
      ],
    );
  }
}