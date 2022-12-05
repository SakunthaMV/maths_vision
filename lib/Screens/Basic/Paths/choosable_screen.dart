import 'dart:async';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maths_vision/Screens/Basic/Papers/Categorized_List/papers_screen.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Widgets/common_background.dart';
import '../Note/subject_content.dart';

class ChooseScreen extends StatelessWidget {
  final String subjectE;
  final String subjectS;

  const ChooseScreen(this.subjectE, this.subjectS);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return CommonBackground(
      body: Center(
        child: Column(
          children: [
            Text(
              subjectS,
              style: textTheme.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subjectE,
              style: textTheme.headlineLarge.copyWith(
                fontSize: 25,
                color: Color.fromARGB(255, 125, 249, 255),
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.grey.shade900,
                    blurRadius: 5,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.075,
                  vertical: 18.0,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  const List levels = [
                    ['සටහන', 'NOTE'],
                    ['පසුගිය ප්‍රශ්න', 'QUESTIONS'],
                    ['පිළිතුරු', 'MARKING SCHEMES']
                  ];
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (index == 0) {
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        bool deviceConnected = await InternetConnectionChecker().hasConnection;
                        final String pathName = subjectE.split(' ').join('_');
                        String imageBase64;
                        final int imageCount = prefs.getInt(pathName) ?? 0;
                        int downloadedCount = 0;
                        int storageImageCount = 0;
                        if (imageCount != 0) {
                          for (int i = 0; i < imageCount; i++) {
                            imageBase64 = prefs.getString('$pathName\_${i + 1}');
                            if (imageBase64 != null) {
                              downloadedCount++;
                            }
                          }
                        }
                        if (deviceConnected) {
                          final Reference ref =
                              FirebaseStorage.instance.ref().child('/Notes/$pathName');
                          ref.listAll().then((pages) {
                            storageImageCount = pages.items.length;
                          });
                        }
                        if (downloadedCount > 0 &&
                            imageCount > 0 &&
                            downloadedCount == imageCount &&
                            (storageImageCount == 0 || storageImageCount == downloadedCount)) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return NotePage(subjectE);
                              },
                            ),
                          );
                        } else {
                          if (deviceConnected) {
                            progressDialogBox(context);
                          } else {
                            Fluttertoast.showToast(
                              msg: 'You need an internet connection to view '
                                  '$subjectE Note for the first time.',
                            );
                          }
                        }
                      } else if (index == 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return PapersScreen(
                                'Past_Papers',
                                subjectS,
                                subjectE,
                              );
                            },
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return PapersScreen(
                                'Marking_Schemes',
                                subjectS,
                                subjectE,
                              );
                            },
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        padding: EdgeInsets.only(left: 25),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 246, 246, 246),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              spreadRadius: 0,
                              color: Colors.black.withOpacity(0.4),
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  levels[index][0],
                                  style: textTheme.headlineMedium.copyWith(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSecondary,
                                    height: 1,
                                    letterSpacing: 1,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1,
                                        color: Colors.black.withOpacity(0.5),
                                        offset: Offset(0.5, 1),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  levels[index][1],
                                  style: textTheme.displayLarge.copyWith(
                                    color: colorScheme.tertiary,
                                    letterSpacing: 1.5,
                                    height: 1.5,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1,
                                        color: Colors.black.withOpacity(0.5),
                                        offset: Offset(0.5, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: SizedBox(
                                height: 90,
                                child: Image.asset('assets/Choosable_Pic.jpg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> saveImage(List<int> imageBytes, String imageName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(imageBytes);
    return prefs.setString(imageName, base64Image);
  }

  Future<void> progressDialogBox(BuildContext context) async {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String pathName = subjectE.split(' ').join('_');
    Reference ref = FirebaseStorage.instance.ref().child('/Notes/$pathName');
    int imageCounter = 0;
    int totalImages = 0;
    ref.listAll().then((pages) {
      prefs.setInt(pathName, pages.items.length);
      totalImages = pages.items.length;
      pages.items.forEach((element) async {
        String link = await element.getDownloadURL();
        http.Response response = await http.get(
          Uri.parse(link),
        );
        saveImage(response.bodyBytes, element.name);
        imageCounter++;
        if (totalImages == imageCounter) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) {
                return NotePage(subjectE);
              },
            ),
          );
        }
      });
    });
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          title: Center(
            child: Text(
              'Please Wait ...',
              style: textTheme.displayMedium.copyWith(
                height: 1.5,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.black26,
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.asset('assets/Brain_Loading_Icon.png'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'The data related to the $subjectE note is being processed.',
                style: textTheme.displayLarge.copyWith(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
