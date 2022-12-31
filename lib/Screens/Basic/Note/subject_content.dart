import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Widgets/common_background.dart';

class NotePage extends StatelessWidget {
  final String subject;
  const NotePage(this.subject);

  Future<List<String>> numberOfImages() async {
    int images;
    String pathName = subject.split(' ').join('_');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    images = prefs.getInt(pathName);
    List<String> allImages = List.generate(images, (index) {
      String imageName = pathName + '_${index + 1}';
      return prefs.getString(imageName);
    });
    return allImages;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return CommonBackground(
      appBarTitle: Text(
        subject,
        style: textTheme.headlineLarge,
      ),
      body: Center(
        child: Container(
          width: size.width * 0.95,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: FutureBuilder<List<String>>(
                future: numberOfImages(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
                      ),
                      child: ListView(
                        children: List.generate(
                          snapshot.data.length,
                              (index) {
                            Uint8List _bytes = Base64Decoder().convert(snapshot.data[index]);
                            return Image.memory(_bytes);
                          },
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
