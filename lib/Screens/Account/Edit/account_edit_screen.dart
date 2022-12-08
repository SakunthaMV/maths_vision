import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maths_vision/Widgets/toast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Common_Widgets/profile_picture.dart';

class AccountEditScreen extends StatefulWidget {
  const AccountEditScreen({Key key}) : super(key: key);

  @override
  _AccountEditScreenState createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final editFormKey = GlobalKey<FormState>();
  User user;
  UploadTask task;

  String _name;
  String _phoneNumber;
  String _dateOfBirth;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
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
          padding: const EdgeInsets.only(top: 50),
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: width * 0.85,
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  height: 450,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: colorScheme.primary,
                    border: Border.all(color: colorScheme.onPrimary, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Form(
                        key: editFormKey,
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: _formRows(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            final DocumentReference userData =
                                FirebaseFirestore.instance.collection('Users').doc(user.uid);
                            final isValid = editFormKey.currentState.validate();
                            if (isValid) {
                              editFormKey.currentState.save();
                              userData.update({
                                'User_Details.firstName': _name.split(' ').first,
                                'User_Details.lastName': _name.split(' ').last,
                                'User_Details.phoneNumber': _phoneNumber,
                                'User_Details.dateOfBirth': _dateOfBirth,
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
                      )
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
                            onPressed: () async {
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
          ),
        ),
      ),
    );
  }

  Widget _formRows() {
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
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _formRowIcon(context, Icons.person),
                Expanded(
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    initialValue: name,
                    onSaved: (text) {
                      _name = text.trim();
                    },
                    validator: (text) {
                      if (text.isEmpty) {
                        return 'Enter Your Name';
                      } else if (text.length < 4) {
                        return 'Enter a Valid Name';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.name,
                    style: style,
                    cursorColor: colorScheme.onPrimary,
                    decoration: _decoration(context, 'Name'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _formRowIcon(context, Icons.phone),
                Expanded(
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    initialValue: phoneNumber,
                    onSaved: (text) {
                      _phoneNumber = text.trim();
                    },
                    validator: (text) {
                      final String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                      RegExp regExp = RegExp(pattern);
                      if (text.length == 0) {
                        return 'Please enter mobile number';
                      } else if (!regExp.hasMatch(text)) {
                        return 'Enter valid mobile number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    style: style,
                    cursorColor: colorScheme.onPrimary,
                    decoration: _decoration(context, 'Phone Number'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _formRowIcon(context, Icons.calendar_today_outlined),
                Expanded(
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    dateMask: 'dd-MMM-yyyy',
                    initialValue: DateTime(year, month, day).toString(),
                    firstDate: DateTime(1960),
                    lastDate: DateTime.now(),
                    calendarTitle: 'Date of Birth',
                    confirmText: 'Done',
                    onChanged: (dob) {
                      _dateOfBirth = dob;
                    },
                    style: style,
                    cursorColor: colorScheme.onPrimary,
                    decoration: _decoration(context, 'Date of Birth'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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

  Widget _formRowIcon(BuildContext context, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Icon(
        icon,
        size: 35,
        color: Theme.of(context).colorScheme.background,
      ),
    );
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
