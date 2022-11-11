import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Support_Classes/Account/profile_picture.dart';

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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 183, 183, 183),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 50),
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
                    color: Colors.white,
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
                            DocumentReference userData =
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
                              Fluttertoast.showToast(
                                msg: 'Your data has been saved.',
                                fontSize: 16,
                              );
                            }
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontFamily: 'AgencyFB',
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Color.fromARGB(255, 0, 136, 145),
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
                        ProfilePicture(user.uid),
                        Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 136, 145),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            splashRadius: 35,
                            onPressed: uploadProfilePicture,
                            icon: Icon(Icons.camera_alt_rounded),
                            color: Colors.white,
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
                          final progress =
                              snapshot.data.bytesTransferred / snapshot.data.totalBytes;
                          if (progress < 1) {
                            return Column(
                              children: [
                                Text(
                                  'Uploading...',
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    shadows: [],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${progress.toStringAsFixed(2)} %',
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    shadows: [],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  child: LinearPercentIndicator(
                                    percent: progress,
                                    lineHeight: 10.0,
                                    progressColor: Colors.grey.shade500,
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
    final TextStyle style = TextStyle(
      fontSize: 18,
      fontFamily: 'Open Sans',
      fontWeight: FontWeight.bold,
      color: Colors.black,
      letterSpacing: 0.0,
      wordSpacing: 1.0,
      shadows: [],
    );
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.black,
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
                _formRowIcon(Icons.person),
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
                    cursorColor: Colors.black,
                    decoration: _decoration('Name'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _formRowIcon(Icons.phone),
                Expanded(
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    initialValue: phoneNumber,
                    onSaved: (text) {
                      _phoneNumber = text.trim();
                    },
                    keyboardType: TextInputType.phone,
                    style: style,
                    cursorColor: Colors.black,
                    decoration: _decoration('Phone Number'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _formRowIcon(Icons.calendar_today_outlined),
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
                    cursorColor: Colors.black,
                    decoration: _decoration('Date of Birth'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  InputDecoration _decoration(String title) {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 255, 51, 51),
        ),
      ),
      errorStyle: TextStyle(
        color: Colors.red.shade600,
        fontSize: 15,
        fontFamily: 'Philosopher',
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
      contentPadding: EdgeInsets.only(
        bottom: 3,
        top: 0,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 112, 112, 112),
          width: 0.5,
        ),
      ),
      labelText: title,
      labelStyle: TextStyle(
        fontSize: 23,
        color: Colors.black,
        fontFamily: 'Roboto',
        letterSpacing: 0.0,
        wordSpacing: 1.0,
        shadows: [],
      ),
    );
  }

  Widget _formRowIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Icon(
        icon,
        size: 35,
        color: Color.fromARGB(255, 0, 136, 145),
      ),
    );
  }

  Future<void> uploadProfilePicture() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    await Permission.storage.request();
    var permissionStatus = await Permission.storage.status;
    if (!permissionStatus.isGranted) {
      return Fluttertoast.showToast(
        msg: 'Permission denied to select image.',
      );
    }
    final XFile image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return Fluttertoast.showToast(
        msg: 'No image found to upload.',
      );
    }
    var file = File(image.path);
    try {
      setState(() {
        task = _storage.ref().child('User_Data/${user.uid}/Profile_Picture').putFile(file);
      });
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(
        msg: error.toString(),
      );
    }
    final snapshot = await task.whenComplete(() {});
    final String _imageURL = await snapshot.ref.getDownloadURL();
    final DocumentReference userData =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);
    userData.update({
      'User_Details.photoURL': _imageURL,
    });
  }
}
