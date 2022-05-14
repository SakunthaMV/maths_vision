import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDisplayScreen extends StatefulWidget {
  final int stage;

  const VideoDisplayScreen(this.stage, {Key key}) : super(key: key);

  @override
  _VideoDisplayScreenState createState() => _VideoDisplayScreenState();
}

class _VideoDisplayScreenState extends State<VideoDisplayScreen>
    with TickerProviderStateMixin {
  List videos = [
    'https://youtu.be/eDlZnG0jI9c',
    'https://youtu.be/7afWio9eXoA',
    'https://youtu.be/D4U_wTt8nX0',
    'https://youtu.be/nJQSlPAx4NY',
    'https://youtu.be/zEFSUOKgWX8',
    'https://youtu.be/TL11znKxZk4',
    'https://youtu.be/wwaIusa8ZIo',
    'https://youtu.be/WGFBDMO4UwI',
    'https://youtu.be/5azoctxIhf0',
    'https://youtu.be/gJAmnQdxJT8',
  ];

  List<String> descriptions = [
    'ඇත්ත වශයෙන්ම මේ Video එකේ කතා කරන්නෙ, ඇයි අපි මේ විදිහෙ Event එකක් කරන්නෙ,'
        ' ඇයි අපි මුල්ම Event එක විදිහට ත්‍රිකෝණමිතිය තෝර ගත්තෙ සහ ප්‍රධාන වශයෙන් පළවෙනි'
        ' Stage එකේ අපේ මාතෘකාව වන ත්‍රිකෝනණමිතික අනුපාත අතර සම්බන්ධතා ගැන.',
    'ඉතින් අපි දෙවෙනි Video එකේදි කතා කරන්නෙ පයිතගරස් සර්වසාම්‍ය ගැන. මොකද්ද මේ පයිතගරස් '
        'සර්වසාම්‍ය කියන්නෙ, කොහොමද අපිට ඒක ප්‍රශ්න වලට යොදා ගන්න පුළුවන්, කියල පැහදිළි '
        'වෙන විදිහට ප්‍රශ්න කිහිපයක් අපි මේ Video එකේදි අපි කතා කරනවා.',
    'තුන්වැනි Video එකේදි අපේ මාතෘකාව වෙන්නේ අගය වගුව සහ වෘත්ත පාද. ඉතින් මේ අගය වගුවේ '
        'අපිට මූලිකව දැනගෙන ඉන්න අගයන් මොනවද, කොහොමද අපි වෘත්ත පාද භාවිතා කරල නිවැරදිව '
        'කෝණයක් සුළුකරගන්නෙ, කියන දේවල් අපි උදාහරන සහිතව මේ Video එකේදි කතා කරනවා.',
    'හතරවැනි Video එක විඩිහට අපි කතා කරන්නෙ ආකලන සූත්‍ර සහ ගුණන සූත්‍ර එනම් ඔබ දන්නා'
        'A,B හා C,D සූත්‍ර. මෙහිදී අපි අදාළ සූත්‍ර සහ එමගින් ගැටළු විසඳීමේදී ඒවා භාවිතා කරන ආකාරය '
        'ගැන උදාහරණ මගින් කතා කරනවා',
    'පස්වන Video එක විදිහට අපි දෙගුණ කෝණ සූත්‍ර මාතෘකාව කරගන්නවා. ඉතින් දෙගුණ කෝණ සූත්‍ර වලට '
        'ලිවිය හැකි සියලුම සමීකරණ සහ ගණන් සැදීමේදී ඒවා භවිතා කරන ආකාරය ගැන අපි මේකෙදි අපි කතා කරනවා.',
    'හයවෙනි Video එකේදි අපේ මාතෘකාව වෙන්නෙ තෙගුණ කෝණ සූත්‍ර. ඉතින් sin, cos සහ tan වලට අදාළ'
        'සූත්‍ර ගැන අපි මෙහිදී කතා කරනවා. තවද සරල ගැටළුවකින් මෙහි යෙදීමක් විස්තර කරනවා.',
    'හත්වෙනි Video එක විදිහට අපි කතාකරන්නේ සාධාරණ විසඳුම් ගැන.මෙහිදී ත්‍රිකෝණමිතික අනුපාතයක ඇති ඕනෑම '
        'කෝණයක් සඳහා සාධාරණව ලිවිය හැකි ප්‍රකාශනය ගැන කතාකරනවා.මීට අමතරව ගැටළු එන විදිහ උදාහරණ ගැටළු '
        'මගින් අපි මේකෙදි කතා කරනවා.',
    'අටවෙනි video එකේ අපේ මාතෘකාව වෙන්නේ ප්‍රතිලෝම ශ්‍රිත .මෙහිදී අපි ත්‍රිකෝණමිතික අනුපාතවලට අදාළව කෝණය '
        'පවතින පරාස සහ මෙයින් ගැටළු විසඳන ආකාරය ගැන උදාහරණ මගින් කතා කරනවා.',
    'නවවැනි මාතෘකාව විදිහට අපි තෝරගත්තේ ත්‍රිකෝණමිතික ප්‍රස්තාර.මෙහිදී ප්‍රස්තාරයක් නිවැරදිව ඇඳීමේදී අනුගමනය '
        'කළයුතු ක්‍රියා පිළිවෙල සහ ඕනෑම ත්‍රිකෝණමිතික ප්‍රස්තාරයක් ඇඳීමට පහසු ක්‍රමයක් ගැන අපි කතාකරනවා',
    'දහවෙනි video එකේ අපේ අවසන් මාතෘකාව වන සම්මත අංකනයෙන් අංකනය කරන ලද ත්‍රිකෝණයක් සඳහා සාධාරණ සමීකරණ '
        'කියන මාතෘකාව අපි තෝරගෙන තියෙනවා.ඉතින් මේ සම්බන්ධව එන ගැටළු විසඳන ආකරය අපි උදාහරණ මගින් '
        'මෙහිදී කතාකරනවා'

  ];

  AnimationController _scaleAnimationController;
  Animation<double> _scaleAnimation;
  AnimationController _rotationAnimationController;
  Animation _rotationAnimation;
  Animation _opacityAnimation;
  YoutubePlayerController controller;
  TextEditingController _textEditingController = TextEditingController();
  bool _liked;
  bool _isCollapsed = false;
  bool _commentTapped = false;
  String _comment;
  User user;
  DocumentSnapshot _videoInfo;
  DocumentSnapshot _userData;
  DocumentSnapshot _commentsInfo;
  StreamSubscription _userSubscription;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    Stream userStream =
        FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots();
    _userSubscription = userStream.listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        _userData = event;
      });
    });
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videos[widget.stage-1]),
      flags: YoutubePlayerFlags(
        enableCaption: false,
        autoPlay: false,
      ),
    );
    DocumentReference videoData = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Trigonometry_Event')
        .doc('Stages');
    videoData.snapshots().listen((doc) {
      if (!mounted) {
        return;
      }
      setState(() {
        _videoInfo = doc;
        _liked = _videoInfo['Stage_${widget.stage}.Info.Video.liked'];
      });
    });
    DocumentReference commentData = FirebaseFirestore.instance
        .collection('Events')
        .doc('Trigonometry')
        .collection('Stages')
        .doc('Stage_${widget.stage}');
    commentData.snapshots().listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        _commentsInfo = event;
      });
    });
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.fastOutSlowIn,
    );
    _rotationAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _rotationAnimation = Tween(begin: 0.0, end: 0.5).animate(_rotationAnimationController);
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(_rotationAnimationController);
  }

  @override
  void dispose() {
    controller.dispose();
    _rotationAnimationController.dispose();
    _scaleAnimationController.dispose();
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 0, 136, 145),
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: SizedBox(),
            flexibleSpace: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 12, right: 7),
                    child: Text(
                      'After',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Copperplate Gothic',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '19',
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Matura Script',
                      color: Color.fromARGB(255, 0, 136, 145),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                TextEditingController().clear();
                setState(() {
                  _commentTapped = false;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  player,
                  _userData != null && _commentsInfo != null && _videoInfo != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Text(
                                'Trigonometry Stage ${widget.stage < 10 ? '0' : ''}${widget.stage} Lesson',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 22,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Color.fromARGB(255, 0, 95, 101),
                              thickness: 1,
                              height: 1,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    bottom: 7,
                                  ),
                                  child: _videoInfo != null
                                      ? Column(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                DocumentReference videoData = FirebaseFirestore
                                                    .instance
                                                    .collection('Users')
                                                    .doc(user.uid)
                                                    .collection('Trigonometry_Event')
                                                    .doc('Stages');
                                                videoData.update({
                                                  'Stage_${widget.stage}.Info.Video.liked':
                                                      !_liked,
                                                });
                                                DocumentReference likeData = FirebaseFirestore
                                                    .instance
                                                    .collection('Events')
                                                    .doc('Trigonometry')
                                                    .collection('Stages')
                                                    .doc('Stage_${widget.stage}');
                                                likeData.update({
                                                  'Video.LikeCount': _liked
                                                      ? FieldValue.increment(-1)
                                                      : FieldValue.increment(1),
                                                });
                                              },
                                              splashRadius: 1,
                                              icon: Icon(
                                                _liked
                                                    ? Icons.thumb_up_alt
                                                    : Icons.thumb_up_alt_outlined,
                                                size: 35,
                                                color: Colors.black.withOpacity(0.5),
                                              ),
                                            ),
                                            Text(
                                              '${_commentsInfo['Video.LikeCount']}',
                                              style: TextStyle(
                                                fontFamily: 'Roboto Regular',
                                                fontSize: 17,
                                                color: Colors.white,
                                                letterSpacing: 2,
                                                height: 0.8,
                                              ),
                                            )
                                          ],
                                        )
                                      : LoadingBouncingLine.circle(
                                          backgroundColor: Colors.black,
                                          size: 50,
                                        ),
                                ),
                                Container(
                                  width: 1,
                                  height: 45,
                                  color: Colors.white,
                                ),
                                Expanded(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        _isCollapsed = !_isCollapsed;
                                      });
                                      if (_isCollapsed) {
                                        _scaleAnimationController.forward();
                                        _rotationAnimationController.animateTo(1);
                                      } else {
                                        _scaleAnimationController.reverse();
                                        _rotationAnimationController.animateTo(0.0);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'DESCRIPTION',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontFamily: 'Open Sans',
                                              color: Colors.white,
                                              letterSpacing: 2,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 2,
                                                  color: Colors.black.withOpacity(0.7),
                                                  offset: Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RotationTransition(
                                            turns: _rotationAnimation,
                                            child: IconShadowWidget(
                                              Icon(
                                                Icons.expand_more_rounded,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                              shadowColor: Colors.black.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AnimatedBuilder(
                              animation: _opacityAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _opacityAnimation.value,
                                  child: Divider(
                                    color: Color.fromARGB(255, 0, 95, 101),
                                    thickness: 1,
                                    height: 1,
                                  ),
                                );
                              },
                            ),
                            SizeTransition(
                              axisAlignment: 1.0,
                              sizeFactor: _scaleAnimation,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                child: Text(
                                  descriptions[widget.stage-1],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Iskola Potha',
                                    color: Colors.white
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Divider(
                              color: Color.fromARGB(255, 0, 95, 101),
                              thickness: 1,
                              height: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 7,
                                left: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Comments',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 16,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 1,
                                          color: Colors.black.withOpacity(0.4),
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Opacity(
                                    opacity: 0.6,
                                    child: Text(
                                      '${_commentsInfo['Video.CommentCount']}',
                                      style: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontSize: 16,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 1,
                                            color: Colors.black.withOpacity(0.4),
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: [
                                          Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          ClipOval(
                                            child: _userData != null
                                                ? SizedBox(
                                                    width: 32,
                                                    height: 32,
                                                    child:
                                                        _userData['User_Details.photoURL'] !=
                                                                null
                                                            ? CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: _userData[
                                                                    'User_Details.photoURL'],
                                                                placeholder: (_, url) {
                                                                  return CircularProgressIndicator();
                                                                },
                                                                errorWidget:
                                                                    (context, url, error) {
                                                                  return Icon(Icons.error);
                                                                },
                                                              )
                                                            : Icon(
                                                                Icons.account_circle_rounded,
                                                                size: 32,
                                                                color: Color.fromARGB(
                                                                    255, 202, 202, 202),
                                                              ),
                                                  )
                                                : CircularProgressIndicator(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            top: 5,
                                            bottom: 5,
                                          ),
                                          child: TextField(
                                            controller: _textEditingController,
                                            minLines: 1,
                                            maxLines: 8,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Open Sans',
                                              color: Colors.black,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _commentTapped = true;
                                              });
                                            },
                                            onChanged: (text) {
                                              setState(() {
                                                _comment = text.trim();
                                              });
                                            },
                                            decoration: InputDecoration.collapsed(
                                              hintText: 'Add a comment...',
                                              hintStyle: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Open Sans',
                                                color: Colors.black.withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      _commentTapped
                                          ? Padding(
                                              padding: const EdgeInsets.only(left: 5),
                                              child: InkWell(
                                                onTap: _comment != ''
                                                    ? () {
                                                        DocumentReference commentAdd =
                                                            FirebaseFirestore.instance
                                                                .collection('Events')
                                                                .doc('Trigonometry')
                                                                .collection('Stages')
                                                                .doc('Stage_${widget.stage}');
                                                        commentAdd.update({
                                                          'Video.Comments':
                                                              FieldValue.arrayUnion([
                                                            {
                                                              'Comment': _comment,
                                                              'UserID': _userData[
                                                                  'User_Details.userId'],
                                                            }
                                                          ]),
                                                        });
                                                        _textEditingController.text = '';
                                                        FocusScope.of(context).unfocus();
                                                        setState(() {
                                                          _commentTapped = false;
                                                        });
                                                        DocumentReference commentCountData =
                                                            FirebaseFirestore.instance
                                                                .collection('Events')
                                                                .doc('Trigonometry')
                                                                .collection('Stages')
                                                                .doc('Stage_${widget.stage}');
                                                        commentCountData.update({
                                                          'Video.CommentCount':
                                                              FieldValue.increment(1),
                                                        });
                                                      }
                                                    : null,
                                                borderRadius: BorderRadius.circular(20),
                                                radius: 30,
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  child: Icon(
                                                    Icons.send,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ListBody(
                                  children: _commentsInfo['Video.Comments'] != null
                                      ? List.generate(
                                          _commentsInfo['Video.Comments'].length,
                                          (index) {
                                            return Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      left: 20,
                                                      right: 20),
                                                  child: Stack(
                                                    alignment: AlignmentDirectional.center,
                                                    children: [
                                                      Container(
                                                        width: 35,
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                      ClipOval(
                                                        child: SizedBox(
                                                          width: 32,
                                                          height: 32,
                                                          child: StreamBuilder<
                                                                  DocumentSnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection('Users')
                                                                  .doc(_commentsInfo[
                                                                          'Video.Comments'][
                                                                      _commentsInfo[
                                                                                  'Video.Comments']
                                                                              .length -
                                                                          index -
                                                                          1]['UserID'])
                                                                  .snapshots(),
                                                              builder: (context, snapshot) {
                                                                if (snapshot.hasData) {
                                                                  return CachedNetworkImage(
                                                                    fit: BoxFit.cover,
                                                                    imageUrl: snapshot.data[
                                                                        'User_Details.photoURL'],
                                                                    placeholder: (_, url) {
                                                                      return CircularProgressIndicator();
                                                                    },
                                                                    errorWidget:
                                                                        (context, url, error) {
                                                                      return Icon(Icons.error);
                                                                    },
                                                                  );
                                                                } else {
                                                                  return Icon(
                                                                    Icons
                                                                        .account_circle_rounded,
                                                                    size: 32,
                                                                    color: Color.fromARGB(
                                                                        255, 202, 202, 202),
                                                                  );
                                                                }
                                                              }),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 5, right: 20),
                                                    child: StreamBuilder<DocumentSnapshot>(
                                                      stream: FirebaseFirestore.instance
                                                          .collection('Users')
                                                          .doc(_commentsInfo['Video.Comments'][
                                                              _commentsInfo['Video.Comments']
                                                                      .length -
                                                                  index -
                                                                  1]['UserID'])
                                                          .snapshots(),
                                                      builder: (context, snapshot) {
                                                        if(snapshot.hasData){
                                                          return Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                '${snapshot.data['User_Details.firstName']} ${snapshot.data['User_Details.lastName']}',
                                                                style: TextStyle(
                                                                  fontFamily: 'Open Sans',
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                  letterSpacing: 0.5,
                                                                  color: Colors.black
                                                                      .withOpacity(0.5),
                                                                  height: 1,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                '${_commentsInfo['Video.Comments'][_commentsInfo['Video.Comments'].length - index - 1]['Comment']}',
                                                                style: TextStyle(
                                                                  fontFamily: 'Open Sans',
                                                                  fontSize: 17,
                                                                  color: Colors.white,
                                                                  height: 1,
                                                                ),
                                                                overflow: TextOverflow.fade,
                                                              ),
                                                              SizedBox(
                                                                height: 6,
                                                              ),
                                                              Divider(
                                                                thickness: 0.7,
                                                                color: Colors.black
                                                                    .withOpacity(0.4),
                                                                height: 6,
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return LoadingBouncingLine.circle(
                                                            size: 40,
                                                            backgroundColor: Colors.black,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      : [],
                                )
                              ],
                            ),
                          ],
                        )
                      : Container(
                          child: LoadingBouncingLine.circle(
                            backgroundColor: Colors.black,
                            size: 100,
                          ),
                          width: width,
                          height: height - 320,
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
