import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  RulesScreen({Key key}) : super(key: key);

  final List<String> rules = [
    'මෙම Stage එකෙහි සෑම ප්‍රශ්ණයක්ම කොටස් 3කින් සමන්විත වේ.',
    'ප්‍රශ්නයේ කොටස් තුනටම නිවැරදි පිලිතුර සැපයූ පසු ප්‍රශ්නය නිවැරදි ලෙස සලකනු ලබන අතර ප්‍රශ්නයට අදාල ප්‍රශ්නයට '
        'අදාල XP ප්‍රමාණය ලැබෙනුයේ කොටස් 3ම නිවැරදි නම් පමනි.',
    'ඔබ ප්‍රශ්නයක් විවෘත කල පසු නැවත එයින් ඉවත්වීමට නොහැක. එසේ ඉවත් වුවහොත් ඔබ එම ප්‍රශ්නයට වැරදි පිලිතුරක් '
        'සැපයූ ලෙස බාරගනු ලැබේ.',
    'ඔබ යම්කිසි ප්‍රශ්නයක පලමු කොටස පමණක් දැක ඉවත් වුවහොත් හෝ පලමු කොටසේ පිලිතුර වැරදුනහොත්, ඔබට එම '
        'ප්‍රශ්නයට නැවත පිලිතුරු දීමට අවස්තාව හිමිවන අතර ඒ සඳහා ඔබට Coin 50ක් ගෙවීමට සිදුවේ.',
    'ඔබ යම්කිසි ප්‍රශ්නයක පලමු කොටස හා දෙවන කොටස පමණක් දැක ඉවත් වුවහොත් හෝ දෙවන කොටසේ පිලිතුර '
        'වැරදුනහොත්, ඔබට එම ප්‍රශ්නයට නැවත පිලිතුරු දීමට අවස්තාව හිමිවන අතර ඒ සඳහා ඔබට Coin 100ක් ගෙවීමට '
        'සිදුවේ.',
    'ඔබ යම් කිසි ප්‍රශ්නයක් Coin ලබා දී Unlock කර ගත් විගසම ඔබව එම ප්‍රශ්නය වෙත නැවත පිවිසෙනු ඇත.',
    'ඔබ යම්කිසි ප්‍රශ්නයක තෙවන කොටසේදී ඉවත් වුවහොත් හෝ තෙවන කොටසේ පිලිතුර වැරදුනහොත්, ඔබට එම ප්‍රශ්නයට '
        'නැවත පිලිතුරු දීමට අවස්තාවක් නොමැත.',
    'ඔබ Golden Sheet එක තුල ප්‍රශ්න කරගෙන යාමේදී, ඔබට යම් යම් සංකේත ප්‍රශ්නය මුලින් දිස්වනු ඇත. ඒවායින් '
        'අදහස් වනුයේ\n \n(?) - ඔබ ප්‍රශ්නයට තවම පිවිසී නොමැති බව,\n(1) - ඔබ ප්‍රශ්නයේ පලමු කොටස '
        'පමනක් දැක ඇති බව,\n(2) - ඔබ ප්‍රශ්නයේ පලමු කොටස හා දෙවන කොටස පමනක් දැක ඇති බව,\n(වැරදි ලකුණ) '
        '- ඔබ ප්‍රශ්ණය වැරදි ලෙස අවසන් කල බව,\n(හරි ලකුණ) - ඔබ නිවැරදිව ප්‍රශ්නය අවසන් කල බව.',
    'Golden Stage එක තුල ඔබට ප්‍රශ්ණයක් කිරීමට ගතවන කාලය අප විසින් මනිනු ලැබේ. (එම කාලය ඔබ ප්‍රශ්නයට '
        'පිවිසුනු විගස ආරම්භ වේ.)',
    'ඔබ යම්කිසි ප්‍රශ්නයක් නිවැරදිව අවසන් කලහොත් ඔබට ගතවන කාලය Wall (My Diary) එකට Share කළ හැකිය. '
        'එමගින් ඔබගේ දක්ශතාවය අන් අය සමග බෙදාගත හැකිය.',
    'ඔබ නිවැරදිව හෝ වැරදිව ප්‍රශ්න අවසන් කිරීමට ගතවන කාලය, ඔබ නිවැරදිව අවසන් කල ප්‍රශ්න ගණනින් බෙදා ලැබෙන '
        'සාමාන්‍ය අගයට අනුව GoldenBoard එක Update වනු ඇත.',
    'ඔබට GoldenBoard එකට ඇතුලත්වීම සඳහා ඔබ අවම වශයෙන් එක ප්‍රශ්නයක් හෝ නිවැරදිව අවසන් කල යුතුය.',
    'වැරදුනු ප්‍රශ්නයක් Coin ගෙවා Unlock කළ පසු ඔබට එම ප්‍රශ්ණය වැරදීමට ගතවූ කාලය නොසලකාහැරේ. '
        '(ඔබ ප්‍රශ්ණය නැවත ආරම්භ කිරීමේදී කාලය බිංදුවේ සිට මනිනු ලැබේ.)',
    'ඔබට අදාල ත්‍යාගය ලබාගැනීම සඳහා ඔබ ප්‍රශ්ණ 10ම නිවැරදිව හෝ වැරදිව අවසන් කල යුතුය.',
    'ප්‍රශ්න 10ම කුමන හෝ අයුරකින් අවසන් කල පසු ඔබට FINISH Button එක එබීමෙන් ඔබ Golden Stage එක '
        'අවසන් කල බව තහවුරු කල හැකිය. (ඔබ ප්‍රශ්න 10ම අවසන් කරන තෙක් ඔබට FINISH Button එක එබිය '
        'නොහැක.)',
    'ඕබ FINISH Button එක ඔබන අවස්තාවේදී, ඔබ GoldenBoard එකෙහි සිටන ස්ථානය (Position) අනුව ඔබට '
        'ඔබගේ ත්‍යාගය හිමිවනු ඇත.',
    'ඔබ යම්කිසි ප්‍රශ්ණයක් නිවැරදිව කිරීමට ගනු ලබන කාලය, එම ප්‍ර්ශ්නය සඳහා මෙම Event එක තුල හොඳම කාලය '
        'නම්, එම කාලය Golden Sheet (My Diary) එහෙහි දිස්වනු ඇත.'
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
                      'Rules & Regulations',
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
                  child: Image.asset('assets/Rules_And_Regulation_Icon.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50, top: height*0.2 +40),
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(10, 17, 10, 15),
                    itemCount: rules.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              margin: EdgeInsets.only(right: 15, top: 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                                border: Border.all(color: Colors.black, width: 3)
                              ),
                            ),
                            Flexible(
                              child: Text(rules[index],
                                style: TextStyle(
                                  fontSize: 15,
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
