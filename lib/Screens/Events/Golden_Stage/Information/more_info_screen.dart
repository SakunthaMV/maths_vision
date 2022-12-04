import 'package:flutter/material.dart';

class MoreInfoScreen extends StatelessWidget {
  MoreInfoScreen({Key key}) : super(key: key);

  final List<String> moreInfo = [
    'ඔබ Golden Stage එක තුලට ප්‍රවිෂ්ට වීම සඳහා, අනෙක් Stages 100% අවසන් කල යුතුය.',
    'එම Stages අවසන් වන විට ඔබගේ නිරවද්‍යතාව (Accuracy) 75% ට වඩා වැඩිවිය යුතුය.',
    'ඔබ එක ලඟ දවස් 5ක් හෝ ඊට වැඩි ගනනක් ඇප් එක වෙත පැමිණිය යුතුය.',
    'ඔබ, මෙම App එක භාවිතා කරන්නන් 70% දෙනා අභිබවා යා යුතු වේ.',
    'මෙම සෑම අවශ්‍යතාවයක්ම සම්පූර්ණ කලබව CLAIM Button එක එබීම මගින් තහවුරු වේ.',
    'මෙම සියලු අවශ්‍යතා සැපිරූ පසු ඔබට Golden Stage එක Unlock කිරීමට හැකියාව ඇත.',
    'ඔබට මෙම අවශ්‍යතා එකක් හෝ සපුරාලිය නොහැකි නම් ඔබට සැපිරීමට නොහැකි වූ ප්‍රමාණයට අනුව, ඔබට Coin ගෙවා Golden Stage එක වෙත පිවිසිය හැක.',
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 79, 134),
      body: Center(
        child: Container(
          width: width * 0.95,
          height: double.infinity,
          margin: EdgeInsets.only(
            top: height * 0.05,
            bottom: width * 0.025,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  width: 25,
                  height: double.infinity,
                  margin: EdgeInsets.only(left: 25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 239, 197, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.only(top: height * 0.2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 239, 197, 1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'More Info',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Open Sans',
                        letterSpacing: 0.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 25,
                  height: 40,
                  margin: EdgeInsets.only(top: height * 0.2, left: 25),
                  color: Colors.white,
                ),
                Container(
                  width: width * 0.95 - 50,
                  height: height * 0.2,
                  margin: EdgeInsets.only(left: 50),
                  child: Image.asset('assets/More_Info_Icon.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50, top: height * 0.2 + 40),
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(10, 17, 10, 15),
                    itemCount: moreInfo.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: index == 0 ? 18 : 15,
                              height: index == 0 ? 18 : 15,
                              margin: EdgeInsets.only(right: 15, top: index == 0 ? 5 : 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                moreInfo[index],
                                style: TextStyle(
                                  fontSize: index == 0 ? 18 : 15,
                                  fontFamily: 'Iskola Potha',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
