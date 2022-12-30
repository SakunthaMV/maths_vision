import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maths_vision/Models/subjects_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import '../../Widgets/maths_vision_logo.dart';
import '../Basic/Main_List/content.dart';

class NavigationDrawer extends StatelessWidget {
  static const Divider _divider = Divider(
    height: 0,
    thickness: 1,
    color: Color.fromARGB(255, 112, 112, 112),
  );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: colorScheme.onSurface),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
        ),
        child: Drawer(
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              children: [
                Center(
                  child: roundedLogo(
                    context,
                    size: 100,
                    border: true,
                    borderColor: colorScheme.tertiaryContainer,
                    padding: const EdgeInsets.only(bottom: 10),
                  ),
                ),
                Center(
                  child: Text(
                    'MATHS VISION',
                    style: GoogleFonts.roboto(
                      fontSize: 30,
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.normal,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                  child: Text(
                    'A Platform to Create a Vision for Your Tomorrow.',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium.copyWith(
                      fontSize: 15,
                      color: Colors.black,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                _divider,
                _contentExpansion(context, 'Pure'),
                _contentExpansion(context, 'Applied'),
                _divider,
                _actionTiles(context, Icons.share, 'Share'),
                _actionTiles(context, Icons.star_border_purple500_sharp, 'Rate Us'),
                _actionTiles(context, Icons.mail_outline, 'Mail Us'),
                _actionTiles(context, Icons.policy_outlined, 'Privacy Policy'),
                _actionTiles(context, Icons.exit_to_app_sharp, 'Exit'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: _divider,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _mediaButton('Facebook'),
                    _mediaButton('Instagram'),
                    _mediaButton('Telegram'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ExpansionTile _contentExpansion(BuildContext context, String subject) {
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ExpansionTile(
      title: Text(
        subject == 'Pure' ? 'PURE MATHS' : 'APPLIED MATHS',
        style: textTheme.displayLarge.copyWith(
          letterSpacing: 0.7,
        ),
      ),
      children: List.generate(
        subject == 'Pure' ? pureSubjects.length : appliedSubjects.length,
        (index) {
          return Column(
            children: [
              lesson(context, index, subject, main: false),
              Divider(
                height: 1,
                thickness: 1,
                indent: width * 0.2,
                endIndent: width * 0.02,
              ),
            ],
          );
        },
      ),
    );
  }

  void _customLaunch(String link) async {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    } else {
      print('cannot launch $link');
    }
  }

  SizedBox _actionTiles(BuildContext context, IconData icon, String title) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 40,
      child: ListTile(
        leading: Icon(
          icon,
          color: colorScheme.onPrimary,
        ),
        horizontalTitleGap: 0,
        title: Text(
          title,
          style: textTheme.displayLarge.copyWith(
            letterSpacing: 0.7,
          ),
        ),
        onTap: () async {
          const String url = 'https://play.google.com/store/apps/'
              'details?id=org.mathsvision.mathsvision';
          if (title == 'Share') {
            await Share.share(url);
          } else if (title == 'Rate Us') {
            await launchUrl(Uri.parse(url));
          } else if (title == 'Mail Us') {
            _customLaunch('mailto:sakunthasugathadasa@gmail.com,thamindumanodya285@gmail.com?'
                'subject=Related%20to%20Maths%20Vision%20App&body= ');
          } else if (title == 'Privacy Policy') {
            _customLaunch('https://mathsvisionprivecy.blogspot.com/2021/07/'
                'maths-vision-privacy-policy.html');
          } else {
            SystemNavigator.pop();
          }
        },
      ),
    );
  }

  IconButton _mediaButton(String iconName){
    return IconButton(
      icon: Image.asset('assets/$iconName\_Icon.png'),
      onPressed: () async {
        if(iconName=='Facebook'){
          await launchUrl(Uri.parse('https://www.facebook.com/groups/mathsvision/'));
        } else if (iconName=='Telegram') {
          await launchUrl(Uri.parse('https://t.me/maths_vision'));
        } else {
          await launchUrl(Uri.parse('https://www.instagram.com/maths_vision/'));
        }
      },
    );
  }
}
