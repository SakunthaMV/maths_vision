import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maths_vision/Screens/Account/Common_Widgets/common_background.dart';
import 'package:maths_vision/Screens/Account/Common_Widgets/decorations.dart';
import 'package:maths_vision/Screens/Account/Common_Widgets/widgets.dart';
import 'package:maths_vision/Utilities/validators.dart';
import 'package:maths_vision/Widgets/snackbar.dart';
import 'package:maths_vision/Widgets/toast.dart';

//ignore: must_be_immutable
class ForgotPasswordScreen extends StatelessWidget {
  final forgotPasswordKey = GlobalKey<FormState>();
  String _email;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return commonScaffold(
      context,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            pageTitle(context, top: 'FIND YOUR'),
            backgroundContainer(
              context,
              child: Form(
                key: forgotPasswordKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        onSaved: (text) {
                          _email = text.trim();
                        },
                        validator: (text) {
                          return emailValidator(text);
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: textTheme.displayLarge.copyWith(
                          fontSize: 17,
                          color: colorScheme.primary,
                        ),
                        cursorColor: colorScheme.onPrimary,
                        decoration: inputDeco(context, 'Enter Your Email Address'),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      margin: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          final isValid = forgotPasswordKey.currentState.validate();
                          if (isValid) {
                            forgotPasswordKey.currentState.save();
                            try {
                              FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
                              snackBar(
                                context,
                                massage: 'We just send an email to $_email. '
                                    'Go and check your inbox.\n \n'
                                    'The email that we sent, may be in your spam folder.',
                              );
                              Navigator.of(context).pop();
                            } on FirebaseAuthException catch (error) {
                              toast(error.message);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: colorScheme.primary,
                          shape: StadiumBorder(),
                        ),
                        child: Text(
                          'SEND REQUEST',
                          style: textTheme.displayLarge.copyWith(
                            color: colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 1,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
