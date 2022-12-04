import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import '../Basic/Main_List/content.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {

  _launchURL() async {
    const url =
        "https://play.google.com/store/apps/details?id=" + "org.mathsvision.mathsvision";
    await launchUrl(Uri.parse(url));
  }

  _facebookURL() async {
    const url = "https://www.facebook.com/groups/mathsvision/";
    await launchUrl(Uri.parse(url));
  }

  _instagramURL() async {
    // username = maths_vision
    // password = ma.ha.0101
    // email = magichackers0101@gmail.com
    const url = "https://www.instagram.com/maths_vision/";
    await launchUrl(Uri.parse(url));
  }

  _telegramURL() async {
    const url = "https://t.me/maths_vision";
    await launchUrl(Uri.parse(url));
  }

  void customLaunch(String link) async {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    } else {
      print('cannot launch $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Color.fromARGB(255, 183, 183, 183)),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
        ),
        child: Drawer(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              SafeArea(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: -5,
                          offset: Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: Color.fromARGB(255, 0, 88, 122),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/HomeButton.jpg',
                        width: 100,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Maths Vision',
                    style: TextStyle(
                      fontFamily: 'Baiti',
                      fontSize: 30,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          color: Colors.grey.shade900,
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: 15,
                ),
                child: Text(
                  'A Platform to Create a Vision for Your Tomorrow.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Gothic',
                    fontSize: 15,
                    color: Colors.black,
                    letterSpacing: 0.3,
                    wordSpacing: 1,
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
                color: Color.fromARGB(255, 112, 112, 112),
              ),
              ExpansionTile(
                title: Text(
                  'PURE MATHS',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Open Sans',
                    letterSpacing: 0.7,
                  ),
                ),
                children: [ContentNavigation('Pure')],
              ),
              ExpansionTile(
                title: Text(
                  'APPLIED MATHS',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Open Sans',
                    letterSpacing: 0.7,
                  ),
                ),
                children: [ContentNavigation('Pure')],
              ),
              Divider(
                height: 0,
                thickness: 1,
                color: Color.fromARGB(255, 112, 112, 112),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  horizontalTitleGap: 0,
                  title: Text(
                    'Share',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                      letterSpacing: 0.7,
                    ),
                  ),
                  onTap: () {
                    Share.share(
                        'https://play.google.com/store/apps/details?id=org.mathsvision.mathsvision');
                  },
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: Icon(
                    Icons.star_border_purple500_sharp,
                    color: Colors.black,
                  ),
                  horizontalTitleGap: 0,
                  title: Text(
                    'Rate Us',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                      letterSpacing: 0.7,
                    ),
                  ),
                  onTap: _launchURL,
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: Icon(
                    Icons.mail_outline,
                    color: Colors.black,
                  ),
                  horizontalTitleGap: 0,
                  title: Text(
                    'Mail Us',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                      letterSpacing: 0.7,
                    ),
                  ),
                  onTap: () {
                    customLaunch(
                        'mailto:sakunthasugathadasa@gmail.com,thamindumanodya285@gmail.com?subject=Related%20to%20Maths%20Vision%20App&body= ');
                  },
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: Icon(
                    Icons.policy_outlined,
                    color: Colors.black,
                  ),
                  horizontalTitleGap: 0,
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                      letterSpacing: 0.7,
                    ),
                  ),
                  onTap: () {
                    customLaunch(
                        'https://mathsvisionprivecy.blogspot.com/2021/07/maths-vision-privacy-policy.html');
                  },
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: Icon(
                    Icons.exit_to_app_sharp,
                    color: Colors.black,
                  ),
                  horizontalTitleGap: 0,
                  title: Text(
                    'Exit',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                      letterSpacing: 0.7,
                    ),
                  ),
                  onTap: () {
                    SystemNavigator.pop();
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Image.asset('assets/Facebook_Icon.png'),
                    onPressed: _facebookURL,
                  ),
                  IconButton(
                    icon: Image.asset('assets/Instagram_Icon.png'),
                    onPressed: _instagramURL,
                  ),
                  IconButton(
                    icon: Image.asset('assets/Telegram_Icon.png'),
                    onPressed: _telegramURL,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
