import 'package:flutter/material.dart';
import 'package:maths_vision/Widgets/toast.dart';
import 'package:provider/provider.dart';

import '../../../Providers/facebook_sign_in_provider.dart';
import '../../../Providers/google_sign_in_provider.dart';
import '../../../Utilities/check_internet.dart';

class OtherSignInOptions extends StatelessWidget {
  const OtherSignInOptions({Key key}) : super(key: key);

  Widget _divider(Color color) {
    return Expanded(
      child: Container(
        height: 1.5,
        decoration: BoxDecoration(
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _divider(colorScheme.onPrimary),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Text(
                'SIGN IN WITH',
                style: Theme.of(context).primaryTextTheme.titleLarge.copyWith(fontSize: 20.0),
              ),
            ),
            _divider(colorScheme.onPrimary),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _button(context, 'Facebook'),
            _button(context, 'Google'),
          ],
        )
      ],
    );
  }

  IconButton _button(BuildContext context, String type) {
    return IconButton(
      onPressed: () {
        if(!oneTimeCheck(context)){
          toast('You Don\'t have Internet connection. Please connect to the Internet.');
          return;
        }
        if (type == 'Facebook') {
          Provider.of<FacebookSignInProvider>(context, listen: false).login();
        } else {
          Provider.of<GoogleSignInProvider>(context, listen: false).login();
        }
      },
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      icon: Image.asset('assets/$type\_Login_Icon.png'),
      iconSize: 55,
      splashRadius: 30,
      splashColor: Colors.transparent,
    );
  }
}
