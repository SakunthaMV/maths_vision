import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String userId;
  const ProfilePicture(this.userId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 10,
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 5.0,
        ),
      ),
      child: ClipOval(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                color: Colors.black.withOpacity(0.7),
                strokeWidth: 7,
              );
            }
            return CachedNetworkImage(
              imageUrl: snapshot.data['User_Details.photoURL'],
              placeholder: (_, url) {
                return CircularProgressIndicator(
                  color: Colors.black.withOpacity(0.7),
                  strokeWidth: 7,
                );
              },
              errorWidget: (context, url, error) {
                return Icon(
                  Icons.account_circle_rounded,
                  size: 130,
                  color: Color.fromARGB(255, 202, 202, 202),
                );
              },
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
