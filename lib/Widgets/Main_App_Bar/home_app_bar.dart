import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maths_vision/Widgets/Main_App_Bar/local_widgets.dart';
import 'package:maths_vision/Widgets/toast.dart';
import 'package:provider/provider.dart';

import '../../Screens/Special/Diary/diary_home_screen.dart';
import '../../Screens/Account/Details/account_details.dart';
import '../../Screens/Special/Leaderboard/leaderboard.dart';
import '../../Screens/Special/Store/store.dart';
import '../../Screens/Account/Log_In/log_in_screen.dart';
import '../../Screens/Splashes/went_home_splash_screen.dart';
import '../../Utilities/check_internet.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;
  final String page;

  const HomeAppBar({Key key, this.leading, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: leading ??
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) {
                    return WentHomeSplashScreen();
                  },
                ),
              );
            },
            splashRadius: 20,
            splashColor: Colors.grey.shade600,
            highlightColor: Colors.black.withOpacity(0.2),
            iconSize: 30,
            color: colorScheme.primary,
          ),
      actions: [
        Builder(builder: (context) {
          bool hasConnection = Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.connected;
          final User user = FirebaseAuth.instance.currentUser;
          if (user == null || !hasConnection) {
            return SizedBox.shrink();
          }
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }
              final int coins = snapshot.data['User_Details.coins'];
              final int level = snapshot.data['User_Details.level'];
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return Store();
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 25,
                        width: 95,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12.5),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: SizedBox(
                                child: Image.asset('assets/Coin.png'),
                                height: 20,
                                width: 20,
                              ),
                            ),
                            userValues(context,'$coins'),
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 15,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: userValues(context, 'lv $level'),
                    ),
                  ),
                ],
              );
            },
          );
        }),
        actionButton(context, Icons.article, DiaryHomeScreen(), 'Notice'),
        actionButton(context, Icons.emoji_events_rounded, LeaderBoard(), 'Leaderboard'),
        actionButton(context, Icons.person, AccountScreen(), 'Account')
      ],
    );
  }

  Widget actionButton(BuildContext context, IconData icon, Widget screen, String currentPage) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      splashRadius: 20,
      splashColor: Colors.grey.shade600,
      highlightColor: Colors.black.withOpacity(0.2),
      iconSize: 30,
      color: colorScheme.primary,
      icon: IconShadowWidget(
        Icon(
          icon,
          color: colorScheme.primary,
          size: 30,
        ),
        showShadow: page == null
            ? true
            : page == currentPage
                ? true
                : false,
        shadowColor: page == null
            ? Colors.black.withOpacity(0.3)
            : page == currentPage
                ? Colors.black
                : null,
      ),
      onPressed: () {
        final bool hasConnection = oneTimeCheck(context);
        final User user = FirebaseAuth.instance.currentUser;
        if (page == currentPage) {
          return null;
        }
        if (user == null) {
          _logInErrorPopUp(context);
          return;
        }
        if (!hasConnection) {
          if (leading == null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) {
                  return WentHomeSplashScreen();
                },
              ),
            );
            toast('Your connection has been disconnected.');
            return;
          }
          toast('You need an internet connection to continue.');
          return;
        }
        if (leading == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) {
                return screen;
              },
            ),
          );
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return screen;
            },
          ),
        );
      },
    );
  }

  Future<void> _logInErrorPopUp(BuildContext context) async {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.asset('assets/Log_In_Error_Icon.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'You must be logged in to access this feature.',
                    style: textTheme.bodyLarge.copyWith(
                      fontSize: 20,
                      color: colorScheme.onPrimary.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    loginDialogActions(context, screen: LogInScreen()),
                    loginDialogActions(context),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
