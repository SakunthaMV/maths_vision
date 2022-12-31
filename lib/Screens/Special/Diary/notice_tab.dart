import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class NoticeTab extends StatelessWidget {
  const NoticeTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: width * 0.05,
        ),
        Expanded(
          child: Container(
            width: width * 0.9,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 110, 187, 192),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                Container(
                  width: width * 0.9,
                  height: 70,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 181, 226, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        spreadRadius: -4,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'This allows you to share your thoughts with'
                      ' us until you respond to our comments',
                      style: TextStyle(
                        fontFamily: 'Microsoft Yi Baiti',
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 0.7,
                        height: 0.9,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.04,
                      right: width * 0.04,
                    ),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Events')
                            .doc('Notices')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return LoadingBouncingLine.circle(
                              size: 100,
                            );
                          }
                          Map notices = snapshot.data.data();
                          if (notices.length == 0) {
                            return Center(
                              child: Text(
                                'There is no notice to Show.',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Philosopher',
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                              left: width * 0.01,
                              right: width * 0.01,
                              top: 10,
                              bottom: 10,
                            ),
                            itemCount: notices.length,
                            itemBuilder: (context, index) {
                              return Notice(index, notices['Notice_${index + 1}']);
                            },
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: width * 0.05,
        ),
      ],
    );
  }
}

class Notice extends StatefulWidget {
  final int index;
  final Map noticeData;

  const Notice(this.index, this.noticeData, {Key key}) : super(key: key);

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> with SingleTickerProviderStateMixin {
  DataModel item;
  AnimationController _controller;
  User user;

  @override
  void initState() {
    item = DataModel('${widget.index}');
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _noticeBack(),
        _noticeFront(),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _noticeBack() {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.8,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 181, 226, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 17,
              right: 58,
              top: 14,
              bottom: 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                widget.noticeData['Notice'].length,
                (i) {
                  return Text(
                    '${widget.noticeData['Notice'][i]}',
                    style: TextStyle(
                      fontFamily: 'Iskola Potha',
                      fontSize: 17,
                      letterSpacing: 0.7,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
          ),
          SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: Column(
              children: [
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(user.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            Map userData = snapshot.data.data();
                            return Row(
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    ClipOval(
                                      child: SizedBox(
                                        width: 27,
                                        height: 27,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: userData['User_Details']['photoURL'],
                                          placeholder: (_, url) {
                                            return CircularProgressIndicator();
                                          },
                                          errorWidget: (context, url, error) {
                                            return Icon(
                                              Icons.account_circle_rounded,
                                              size: 27,
                                              color: Color.fromARGB(255, 202, 202, 202),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 3,
                                      bottom: 3,
                                    ),
                                    child: TextField(
                                      controller: item.textEditingController,
                                      minLines: 1,
                                      maxLines: 8,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Open Sans',
                                        color: Colors.black,
                                        wordSpacing: 1.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          item.commentTapped = true;
                                        });
                                      },
                                      onChanged: (text) {
                                        setState(() {
                                          item.comment = text.trim();
                                        });
                                      },
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Add a comment...',
                                        hintStyle: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Open Sans',
                                          color: Colors.black.withOpacity(0.4),
                                          fontWeight: FontWeight.normal,
                                          wordSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (item.commentTapped)
                                  InkWell(
                                    onTap: item.comment != ''
                                        ? () {
                                            DocumentReference _commentData = FirebaseFirestore
                                                .instance
                                                .collection('Events')
                                                .doc('Notices');
                                            _commentData.update({
                                              'Notice_${widget.index + 1}.Comments':
                                                  FieldValue.arrayUnion([
                                                {
                                                  'Comment': item.comment,
                                                  'UserID': userData['User_Details']['userId'],
                                                }
                                              ]),
                                            });
                                            item.textEditingController.text = '';
                                            FocusScope.of(context).unfocus();
                                            setState(() {
                                              item.commentTapped = false;
                                            });
                                          }
                                        : null,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Icon(
                                        Icons.send,
                                        size: 15,
                                      ),
                                    ),
                                  )
                              ],
                            );
                          }),
                      Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (context) {
                    if (widget.noticeData['Comments'] == null) {
                      return SizedBox.shrink();
                    }
                    return ListBody(
                      children: List.generate(
                        widget.noticeData['Comments'].length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(widget.noticeData['Comments']
                                          [widget.noticeData['Comments'].length - index - 1]
                                      ['UserID'])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return LoadingBouncingLine.circle(
                                    size: 30,
                                  );
                                }
                                return Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 10),
                                      child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          ClipOval(
                                            child: SizedBox(
                                              width: 27,
                                              height: 27,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    snapshot.data['User_Details.photoURL'],
                                                placeholder: (_, url) {
                                                  return CircularProgressIndicator();
                                                },
                                                errorWidget: (context, url, error) {
                                                  return Icon(
                                                    Icons.account_circle_rounded,
                                                    size: 27,
                                                    color: Color.fromARGB(255, 202, 202, 202),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${snapshot.data['User_Details.firstName']} '
                                            '${snapshot.data['User_Details.lastName']}',
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                              color: Color.fromARGB(255, 0, 88, 122),
                                              height: 1,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: Text(
                                              '${widget.noticeData['Comments'][widget.noticeData['Comments'].length - index - 1]['Comment']}',
                                              style: TextStyle(
                                                fontFamily: 'Abhaya Libre',
                                                fontSize: 13,
                                                color: Colors.black,
                                                height: 0.9,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _noticeFront() {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.8,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: width * 0.8,
                height: 25,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 107, 195, 242),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Text(
                  'MATHS VISION',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Roboto Regular',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.4,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.4),
                        offset: Offset(0.5, 1),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 17,
                        right: 10,
                        top: 14,
                        bottom: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          widget.noticeData['Notice'].length,
                          (i) {
                            return Text(
                              '${widget.noticeData['Notice'][i]}',
                              style: TextStyle(
                                fontFamily: 'Iskola Potha',
                                fontSize: 17,
                                letterSpacing: 0.7,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        item.expanded = !item.expanded;
                        item.commentTapped = false;
                      });
                      if (item.expanded) {
                        _controller.forward();
                      } else {
                        _controller.reverse();
                      }
                      FocusScope.of(context).unfocus();
                      item.textEditingController.clear();
                    },
                    icon: RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    padding: EdgeInsets.all(0),
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 10,
            top: 9,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              child: ClipOval(
                child: Image.asset('assets/HomeButton.jpg'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DataModel extends State<StatefulWidget> {
  String title;
  bool expanded;
  TextEditingController textEditingController;
  bool commentTapped;
  String comment;

  DataModel(this.title) {
    expanded = false;
    textEditingController = TextEditingController();
    commentTapped = false;
    comment = '';
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
