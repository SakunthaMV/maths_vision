import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'account_screen.dart';
import 'event_errors_and_loading.dart';

class AccountEditScreen extends StatefulWidget {
  const AccountEditScreen({Key key}) : super(key: key);

  @override
  _AccountEditScreenState createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final editFormKey = GlobalKey<FormState>();
  DocumentSnapshot _userData;
  User user;
  UploadTask task;
  StreamSubscription _userSubscription;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _nameTapped = false;
  bool _phoneTapped = false;
  bool _dateOfBirthTapped = false;
  String _name;
  String _phoneNumber;
  String _dateOfBirth;
  int _year;
  int _month;
  int _day;
  List _birth;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    Stream userStream =
    FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots();
    _userSubscription = userStream.listen((event) {
      setState(() {
        _userData = event;
      });
      if(_userData!= null) {
        setState(() {
          _nameController.text = '${_userData['User_Details.firstName']} ${_userData['User_Details.lastName']}';
          _phoneController.text = _userData['User_Details.phoneNumber'] != null ? '${_userData['User_Details.phoneNumber']}' : '0110000000';
        });
        if(_userData['User_Details.dateOfBirth']!= null){
          setState(() {
            _birth = (_userData['User_Details.dateOfBirth']).split('-');
            _year = int.parse(_birth[0]);
            _month = int.parse(_birth[1]);
            _day = int.parse(_birth[2]);
          });
        } else {
          setState(() {
            _birth = [];
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 183, 183, 183),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _userData != null
          ? Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                SizedBox(
                  height: height,
                  width: width,
                  child: CustomPaint(
                    painter: BackContainer(),
                    child: Container(),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    width: width * 0.8,
                    margin: EdgeInsets.only(top: 30),
                    height: 450,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 120,
                        ),
                        Form(
                          key: editFormKey,
                          child: Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child: Icon(
                                        Icons.person,
                                        size: 35,
                                        color: Color.fromARGB(255, 0, 136, 145),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.6,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _nameController,
                                        onTap: () {
                                          setState(() {
                                            _nameTapped = true;
                                          });
                                        },
                                        onFieldSubmitted: (text) {
                                          setState(() {
                                            _nameTapped = false;
                                          });
                                        },
                                        onSaved: (text) {
                                          setState(() {
                                            _name = text.trim();
                                          });
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
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        cursorColor: Color.fromARGB(255, 45, 45, 45),
                                        decoration: InputDecoration(
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
                                            color:Colors.red.shade600,
                                            fontSize: 15,
                                            fontFamily: 'Philosopher',
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.5),
                                                blurRadius: 4,
                                                offset: Offset(1.5, 1.5),
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
                                          labelText: 'Name',
                                          labelStyle: TextStyle(
                                            fontSize: 23,
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                          ),
                                          suffixIcon: !_nameTapped
                                              ? Icon(
                                                  Icons.edit,
                                                  color: Colors.black.withOpacity(0.3),
                                                )
                                              : Container(
                                                  width: 10,
                                                  height: 10,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child: Icon(
                                        Icons.phone,
                                        size: 35,
                                        color: Color.fromARGB(255, 0, 136, 145),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.6,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: _phoneController,
                                        onTap: () {
                                          setState(() {
                                            _phoneTapped = true;
                                          });
                                        },
                                        onFieldSubmitted: (text) {
                                          setState(() {
                                            _phoneTapped = false;
                                          });
                                        },
                                        onSaved: (text) {
                                          setState(() {
                                            _phoneNumber = text.trim();
                                          });
                                        },
                                        keyboardType: TextInputType.phone,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        cursorColor: Color.fromARGB(255, 45, 45, 45),
                                        decoration: InputDecoration(
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
                                            color: Color.fromARGB(255, 234, 234, 234),
                                            fontSize: 15,
                                            fontFamily: 'Philosopher',
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(1),
                                                blurRadius: 4,
                                                offset: Offset(1.5, 1.5),
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
                                          labelText: 'Phone Number',
                                          labelStyle: TextStyle(
                                            fontSize: 23,
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                          ),
                                          suffixIcon: !_phoneTapped
                                              ? Icon(
                                                  Icons.edit,
                                                  color: Colors.black.withOpacity(0.3),
                                                )
                                              : Container(
                                                  width: 10,
                                                  height: 10,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child: Icon(
                                        Icons.calendar_today_outlined,
                                        size: 35,
                                        color: Color.fromARGB(255, 0, 136, 145),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.6,
                                      child: DateTimePicker(
                                        type: DateTimePickerType.date,
                                        dateMask: 'dd-MMM-yyyy',
                                        initialValue: _userData['User_Details.dateOfBirth'] != null
                                            ? DateTime(_year, _month, _day).toString()
                                            : DateTime.now().toString(),
                                        firstDate: DateTime(1960),
                                        lastDate: DateTime.now(),
                                        calendarTitle: 'Date of Birth',
                                        confirmText: 'Done',
                                        onChanged: (dob) {
                                          setState(() {
                                            _dateOfBirth = dob;
                                          });
                                        },
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        cursorColor: Color.fromARGB(255, 45, 45, 45),
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.only(
                                            bottom: 3,
                                            top: 0,
                                          ),
                                          labelText: 'Date of Birth',
                                          labelStyle: TextStyle(
                                            fontSize: 23,
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(255, 112, 112, 112),
                                              width: 0.5,
                                            ),
                                          ),
                                          suffixIcon: !_dateOfBirthTapped
                                              ? Icon(
                                                  Icons.edit,
                                                  color: Colors.black.withOpacity(0.3),
                                                )
                                              : Container(
                                                  width: 10,
                                                  height: 10,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20, bottom: 20),
                          child: SizedBox(
                            width: 100,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                DocumentReference userData = FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(user.uid);
                                List nameList = [];
                                final isValid = editFormKey.currentState.validate();
                                if (isValid) {
                                  editFormKey.currentState.save();
                                  nameList = _name.split(' ');
                                  userData.update({
                                    'User_Details.firstName': nameList[0],
                                    'User_Details.lastName': nameList.length>1? nameList[1]:'',
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
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                ClipOval(
                                  child: SizedBox(
                                    width: 130,
                                    height: 130,
                                    child: _userData['User_Details.photoURL'] != null
                                        ? CachedNetworkImage(
                                            imageUrl: _userData['User_Details.photoURL'],
                                            placeholder: (_, url) {
                                              return CircularProgressIndicator();
                                            },
                                            errorWidget: (context, url, error) {
                                              return Icon(Icons.error);
                                            },
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.account_circle_rounded,
                                            size: 130,
                                            color: Color.fromARGB(255, 202, 202, 202),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                              onPressed: () {
                                uploadProfilePicture();
                              },
                              icon: Icon(Icons.camera_alt_rounded),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      task != null
                          ? StreamBuilder<TaskSnapshot>(
                              stream: task.snapshotEvents,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final progress = snapshot.data.bytesTransferred /
                                      snapshot.data.totalBytes;
                                  return progress < 1
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: LinearPercentIndicator(
                                                percent: progress,
                                                lineHeight: 10.0,
                                                progressColor: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container();
                                } else {
                                  return Container();
                                }
                              },
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            )
          : EventLoading(),
    );
  }

  Future<void> uploadProfilePicture() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    DocumentReference userData = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    XFile image;
    String _imageURL;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      image = await _picker.pickImage(source: ImageSource.gallery);
      // image = await _picker.getImage(source: ImageSource.gallery);
      if (image != null) {
        var file = File(image.path);
        try {
          setState(() {
            task = _storage.ref().child('User_Data/${user.uid}/Profile_Picture').putFile(file);
          });
        } on FirebaseException catch (error) {
          Fluttertoast.showToast(
            msg: error.toString(),
            fontSize: 16,
          );
        }
        final snapshot = await task.whenComplete(() {});
        _imageURL = await snapshot.ref.getDownloadURL();
        userData.update({
          'User_Details.photoURL': _imageURL,
        });
      } else {
        Fluttertoast.showToast(
          msg: 'No image found to upload.',
          fontSize: 16,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Permission denied to select image.',
        fontSize: 16,
      );
    }
  }
}
