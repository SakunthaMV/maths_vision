import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Services/auth.dart';
import 'package:maths_vision/Services/firestore_userdata.dart';
import 'package:maths_vision/Utilities/check_internet.dart';
import 'package:maths_vision/Utilities/validators.dart';
import 'package:maths_vision/Widgets/event_errors_and_loading.dart';
import 'package:maths_vision/Widgets/snackbar.dart';
import 'package:maths_vision/Widgets/toast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Widgets/date_picker.dart';
import '../../Splashes/log_out_splash_screen.dart';
import '../Common_Widgets/profile_picture.dart';

class AccountEditScreen extends StatefulWidget {
  const AccountEditScreen({Key key}) : super(key: key);

  @override
  _AccountEditScreenState createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> with TickerProviderStateMixin {
  final editFormKey = GlobalKey<FormState>();
  final passwordChangeKey = GlobalKey<FormState>();
  User user;
  UploadTask task;

  String _name;
  String _phoneNumber;
  DateTime _dateOfBirth;

  String _previousPassword;
  String _newPassword;
  String _confirmPassword;
  bool _previousInvisible = true;
  bool _newInvisible = true;
  bool _confirmInvisible = true;
  bool _passwordVisible = false;
  AnimationController _animationController;

  bool _userDeleted = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _accountController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _accountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.onSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 50, bottom: 25),
          physics: BouncingScrollPhysics(),
          child: Builder(
            builder: (context) {
              if (_userDeleted) {
                return EventLoading();
              }
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: width * 0.85,
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: colorScheme.primary,
                        border: Border.all(color: colorScheme.onPrimary, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: editFormKey,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 110),
                              child: _formRows(context),
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 40,
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                final bool hasConnection = oneTimeCheck(context);
                                if (!hasConnection) {
                                  toast('You don\'t have Internet Connection.');
                                  return;
                                }
                                final DocumentReference userData = FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(user.uid);
                                final isValid = editFormKey.currentState.validate();
                                if (isValid) {
                                  editFormKey.currentState.save();
                                  userData.update({
                                    'User_Details.firstName': _name.split(' ').first,
                                    'User_Details.lastName': _name.split(' ').last,
                                    'User_Details.phoneNumber': _phoneNumber,
                                    'User_Details.dateOfBirth': _dateOfBirth.toString(),
                                  });
                                  toast('Your data has been saved.');
                                }
                              },
                              child: Text(
                                'Save',
                                style: textTheme.bodySmall.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: colorScheme.background,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: colorScheme.onPrimary,
                            height: 1,
                          ),
                          SizeTransition(
                            axisAlignment: 1.0,
                            sizeFactor:
                                Tween(begin: 0.0, end: 1.0).animate(_animationController),
                            child: Form(
                              key: passwordChangeKey,
                              child: _passwordRows(context),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                final bool hasConnection = oneTimeCheck(context);
                                if (!hasConnection) {
                                  toast('You don\'t have Internet Connection.');
                                  return;
                                }
                                if (_passwordVisible) {
                                  final isValid = passwordChangeKey.currentState.validate();
                                  if (isValid) {
                                    passwordChangeKey.currentState.save();
                                    EmailAuthCredential credential =
                                        EmailAuthProvider.credential(
                                      email: user.email,
                                      password: _previousPassword,
                                    );
                                    await user
                                        .reauthenticateWithCredential(credential)
                                        .then((value) {
                                      if (_newPassword == _previousPassword) {
                                        toast(
                                            'Your New Password Should be Different With Old Password');
                                      } else {
                                        user.updatePassword(_confirmPassword).whenComplete(() {
                                          toast('Password Updated Successfully.');
                                          setState(() {
                                            _passwordVisible = false;
                                          });
                                          _animationController.reverse();
                                        });
                                        return;
                                      }
                                    }).catchError((onError) {
                                      toast('Your Old Password is Incorrect.');
                                      return;
                                    });
                                  }
                                }
                                if(!_passwordVisible){
                                  if(user.providerData[0].providerId=='google.com'){
                                    snackBar(context,
                                      massage: 'You are signed in with a Google Account. '
                                        'Therefore change you password using google.',
                                    );
                                  } else if(user.providerData[0].providerId == 'facebook.com'){
                                    snackBar(context,
                                      massage: 'You are signed in with a Facebook Account. '
                                          'Therefore change you password using Facebook.',
                                    );
                                  }
                                  return;
                                }
                                setState(() {
                                  _passwordVisible = true;
                                });
                                if (_passwordVisible) {
                                  _animationController.forward();
                                }
                              },
                              child: AnimatedCrossFade(
                                duration: const Duration(seconds: 1),
                                firstChild: _passwordButtonText(context, 'Save Password'),
                                secondChild: _passwordButtonText(context, 'Change Password'),
                                crossFadeState: _passwordVisible
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: colorScheme.background,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                final bool hasConnection = oneTimeCheck(context);
                                if (!hasConnection) {
                                  toast('You don\'t have Internet Connection.');
                                  return;
                                }
                                _deleteAccountDialog(context);
                              },
                              child: Text(
                                'Delete Account',
                                style: textTheme.bodySmall.copyWith(
                                  color: colorScheme.primary,
                                  fontSize: 20.0,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: colorScheme.background,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: width * 0.05,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            ProfilePicture(),
                            Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: colorScheme.background,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                splashRadius: 35,
                                onPressed: () {
                                  _bottomSheet(context);
                                },
                                icon: Icon(Icons.camera_alt_rounded),
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        if (task != null)
                          StreamBuilder<TaskSnapshot>(
                            stream: task.snapshotEvents,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox.shrink();
                              }
                              double progress =
                                  snapshot.data.bytesTransferred / snapshot.data.totalBytes;
                              if (progress < 1) {
                                return Column(
                                  children: [
                                    Text(
                                      'Uploading...',
                                      style: textTheme.displayLarge.copyWith(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${(progress * 100).toStringAsFixed(2)} %',
                                      style: textTheme.displayLarge.copyWith(fontSize: 16.0),
                                    ),
                                    Container(
                                      width: 150,
                                      child: LinearPercentIndicator(
                                        percent: progress,
                                        lineHeight: 10.0,
                                        progressColor: colorScheme.background,
                                        barRadius: Radius.circular(5.0),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return SizedBox.shrink();
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _formRows(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle style = textTheme.displayLarge.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: colorScheme.onPrimary,
              size: 100.0,
            ),
          );
        }
        final String name = '${snapshot.data['User_Details.firstName']} '
            '${snapshot.data['User_Details.lastName']}';
        final String phoneNumber = snapshot.data['User_Details.phoneNumber'] ?? '0110000000';
        int year;
        int month;
        int day;
        DateTime date;
        if (snapshot.data['User_Details.dateOfBirth'] != null) {
          final String birth = snapshot.data['User_Details.dateOfBirth'];
          year = DateTime.parse(birth).year;
          month = DateTime.parse(birth).month;
          day = DateTime.parse(birth).day;
        } else {
          year = DateTime.now().year;
          month = DateTime.now().month;
          day = DateTime.now().day;
        }
        if (_dateOfBirth == null) {
          date = DateTime(year, month, day);
        } else {
          date = _dateOfBirth;
        }
        final String dateString = DateFormat('dd-MMM-yyyy').format(date);
        final TextEditingController controller = TextEditingController(text: dateString);
        return Column(
          children: [
            _row(
              context,
              icon: Icons.person,
              textFormField: TextFormField(
                textInputAction: TextInputAction.next,
                initialValue: name,
                onSaved: (text) {
                  _name = text.trim();
                },
                validator: (text) {
                  return nameValidator(text, 'Name');
                },
                keyboardType: TextInputType.name,
                style: style,
                cursorColor: colorScheme.onPrimary,
                decoration: _decoration(context, 'Name'),
              ),
            ),
            _row(
              context,
              icon: Icons.phone,
              textFormField: TextFormField(
                textInputAction: TextInputAction.next,
                initialValue: phoneNumber,
                onSaved: (text) {
                  _phoneNumber = text.trim();
                },
                validator: (text) {
                  return phoneValidator(text);
                },
                keyboardType: TextInputType.phone,
                style: style,
                cursorColor: colorScheme.onPrimary,
                decoration: _decoration(context, 'Phone Number'),
              ),
            ),
            _row(
              context,
              icon: Icons.calendar_today_outlined,
              textFormField: TextFormField(
                controller: controller,
                onTap: () async {
                  _dateOfBirth = await datePicker(context, controller);
                },
                onSaved: (text) {
                  _dateOfBirth = DateFormat('dd-MMM-yyyy').parse(controller.text);
                },
                readOnly: true,
                style: style,
                cursorColor: colorScheme.onPrimary,
                decoration: _decoration(context, 'Date of Birth'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _row(BuildContext context, {IconData icon, TextFormField textFormField}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(
              icon,
              size: 35,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          Expanded(
            child: textFormField,
          ),
        ],
      ),
    );
  }

  Widget _passwordRows(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle style = textTheme.displayLarge.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );
    return Column(
      children: [
        _row(
          context,
          icon: Icons.key,
          textFormField: TextFormField(
            textInputAction: TextInputAction.next,
            obscureText: _previousInvisible,
            onSaved: (text) {
              _previousPassword = text.trim();
            },
            validator: (text) {
              return previousPasswordValidator(text, user);
            },
            onFieldSubmitted: (text) {
              FocusScope.of(context).nextFocus();
            },
            keyboardType: TextInputType.visiblePassword,
            style: style,
            cursorColor: colorScheme.onPrimary,
            decoration: _decoration(context, 'Old Password').copyWith(
              suffixIcon: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  _previousInvisible = !_previousInvisible;
                  setState(() {});
                },
                child: Icon(
                  _previousInvisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
        _row(
          context,
          icon: Icons.password,
          textFormField: TextFormField(
            textInputAction: TextInputAction.next,
            obscureText: _newInvisible,
            onSaved: (text) {
              _newPassword = text.trim();
            },
            onChanged: (text) {
              _newPassword = text.trim();
            },
            onFieldSubmitted: (text) {
              FocusScope.of(context).nextFocus();
            },
            validator: (text) {
              return createPasswordValidator(text);
            },
            keyboardType: TextInputType.visiblePassword,
            style: style,
            cursorColor: colorScheme.onPrimary,
            decoration: _decoration(context, 'New Password').copyWith(
              suffixIcon: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  _newInvisible = !_newInvisible;
                  setState(() {});
                },
                child: Icon(
                  _newInvisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
        _row(
          context,
          icon: Icons.check,
          textFormField: TextFormField(
            textInputAction: TextInputAction.done,
            obscureText: _confirmInvisible,
            onSaved: (text) {
              _confirmPassword = text.trim();
            },
            validator: (text) {
              return confirmPasswordValidator(text, _newPassword);
            },
            keyboardType: TextInputType.visiblePassword,
            style: style,
            cursorColor: colorScheme.onPrimary,
            decoration: _decoration(context, 'Confirm Password').copyWith(
              suffixIcon: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  _confirmInvisible = !_confirmInvisible;
                  setState(() {});
                },
                child: Icon(
                  _confirmInvisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Text _passwordButtonText(BuildContext context, String text) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodySmall.copyWith(color: colorScheme.primary, fontSize: 20.0),
    );
  }

  InputDecoration _decoration(BuildContext context, String title) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.onPrimary,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.error,
        ),
      ),
      errorStyle: textTheme.bodyLarge.copyWith(
        color: colorScheme.error,
        fontSize: 15,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1,
            offset: Offset(0.5, 0.5),
          ),
        ],
      ),
      contentPadding: EdgeInsets.only(
        bottom: 3,
        top: 0,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.tertiary,
          width: 0.5,
        ),
      ),
      labelText: title,
      labelStyle: textTheme.displaySmall.copyWith(
        fontSize: 23,
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
        shadows: [],
      ),
    );
  }

  bool _accountDeletePassword = true;
  bool _deletePasswordVisibility = false;
  AnimationController _accountController;
  String _accountConfirmPassword;

  Future<void> _deleteAccountDialog(BuildContext context) async {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_remove_alt_1_outlined,
                    size: 80,
                    color: colorScheme.onError,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Are You Sure About Deleting Your Account?',
                      style: textTheme.bodyLarge.copyWith(
                        fontSize: 20,
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'You will lose all information in your '
                      'account and will not be able to recover it.',
                      style: textTheme.displayLarge.copyWith(
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizeTransition(
                    axisAlignment: 1.0,
                    sizeFactor: Tween(begin: 0.0, end: 1.0).animate(_accountController),
                    child: _row(
                      context,
                      icon: Icons.check,
                      textFormField: TextFormField(
                        textInputAction: TextInputAction.done,
                        obscureText: _accountDeletePassword,
                        onChanged: (text) {
                          _accountConfirmPassword = text.trim();
                        },
                        keyboardType: TextInputType.visiblePassword,
                        style: textTheme.displayLarge.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        cursorColor: colorScheme.onPrimary,
                        decoration: _decoration(context, 'Confirm Password').copyWith(
                          suffixIcon: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              _accountDeletePassword = !_accountDeletePassword;
                              setState(() {});
                            },
                            child: Icon(
                              _accountDeletePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        deleteDialogActions(context, 'Yes'),
                        deleteDialogActions(context, 'No'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget deleteDialogActions(BuildContext context, String action) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 85,
      child: ElevatedButton(
        onPressed: () async {
          if (action == 'No') {
            Navigator.pop(context, false);
            return 0;
          }
          final bool hasConnection = oneTimeCheck(context);
          if (!hasConnection) {
            toast('You don\'t have Internet Connection.');
            return 0;
          }
          if (user.providerData[0].providerId != 'password') {
            await deleteAccount();
            return 0;
          } else {
            if(_deletePasswordVisibility){
              await deleteAccount();
              return 0;
            }
          }
          if (!_deletePasswordVisibility) {
            if(user.providerData[0].providerId == 'password'){
              setState(() {
                _deletePasswordVisibility = true;
              });
            }
          }
          if (_deletePasswordVisibility) {
            _accountController.forward();
          }
        },
        child: Text(
          action,
          style: textTheme.bodySmall.copyWith(
            fontSize: 20.0,
            color: colorScheme.primary,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          backgroundColor: colorScheme.background,
        ),
      ),
    );
  }

  Future<void> deleteAccount() async {
    AuthCredential credential = await authCredential(user, password: _accountConfirmPassword,);
    await user.reauthenticateWithCredential(credential).then((reAuth) async {
      setState(() {
        _userDeleted = true;
      });
      toast('Deleting...');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (_) {
          return LogOutSplashScreen();
        },
      ), (route) => false);
      await removeUserDate(user).then((fire) {
        toast('All your data has been deleted.');
      }).catchError((error) {
        toast('Something Went Wrong while deleting your data. Try again later.');
      });
      await user.delete().then((value) {
        toast('Your Account has been deleted.');
      }).catchError((error) {
        toast('Something Went Wrong while deleting your account. Try again later.');
      });
    }).catchError((onError) {
      toast('${onError.toString()}');
    });
  }

  Future<void> _bottomSheet(BuildContext context) async {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return await showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _bottomSheetItem(context, Icons.file_upload_outlined, 'Upload Photo'),
            _bottomSheetItem(context, Icons.delete_outline, 'Remove Photo'),
          ],
        );
      },
    );
  }

  Widget _bottomSheetItem(BuildContext context, IconData icon, String text) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: colorScheme.onPrimary.withOpacity(0.2), shape: BoxShape.circle),
        child: Icon(icon, color: colorScheme.onPrimary),
      ),
      title: Text(
        text,
        style: textTheme.displayLarge.copyWith(color: colorScheme.onPrimary),
      ),
      onTap: () {
        if (text == 'Upload Photo') {
          _uploadProfilePicture(context);
        } else {
          final DocumentReference userData =
              FirebaseFirestore.instance.collection('Users').doc(user.uid);
          userData.update({
            'User_Details.photoURL': 'No Image',
          });
          toast('Photo Removed.');
          Navigator.of(context).pop();
        }
      },
    );
  }

  Future<void> _uploadProfilePicture(BuildContext context) async {
    final _storage = FirebaseStorage.instance;
    await Permission.storage.request();
    var permissionStatus = await Permission.storage.status;
    if (!permissionStatus.isGranted) {
      return toast('Permission denied to select image.');
    }
    final CroppedFile image = await _getFromGallery(context).whenComplete(() {
      Navigator.of(context).pop();
    });
    if (image == null) {
      return toast('No image found to upload.');
    }
    var file = File(image.path);
    try {
      setState(() {
        task = _storage.ref().child('User_Data/${user.uid}/Profile_Picture').putFile(file);
      });
    } on FirebaseException catch (error) {
      toast(error.toString());
    }
    final snapshot = await task.whenComplete(() {});
    final String _imageURL = await snapshot.ref.getDownloadURL();
    final DocumentReference userData =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);
    userData.update({
      'User_Details.photoURL': _imageURL,
    });
  }

  Future<CroppedFile> _getFromGallery(BuildContext context) async {
    XFile pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    return await _cropImage(context, pickedFile.path);
  }

  Future<CroppedFile> _cropImage(BuildContext context, String filePath) async {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    CroppedFile croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      compressQuality: 70,
      maxHeight: 1080,
      maxWidth: 1080,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Select Photo',
          toolbarColor: colorScheme.background,
          toolbarWidgetColor: colorScheme.primary,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
      ],
    );
    if (croppedImage != null) {
      return croppedImage;
    }
    return null;
  }
}
