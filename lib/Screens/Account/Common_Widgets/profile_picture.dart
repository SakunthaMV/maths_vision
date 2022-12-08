import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 10,
          ),
        ],
        border: Border.all(
          color: colorScheme.primary,
          width: 5.0,
        ),
      ),
      child: ClipOval(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                color: Colors.black.withOpacity(0.7),
                strokeWidth: 7,
              );
            }
            Icon errorIcon = Icon(
              Icons.account_circle_rounded,
              size: 130,
              color: colorScheme.onTertiaryContainer.withOpacity(0.7),
            );
            if(snapshot.data['User_Details.photoURL']=='No Image'){
              return errorIcon;
            }
            return CachedNetworkImage(
              imageUrl: snapshot.data['User_Details.photoURL'],
              progressIndicatorBuilder: (context, url, progress) {
                return CircularProgressIndicator(
                  color: Colors.black.withOpacity(0.7),
                  strokeWidth: 7,
                );
              },
              errorWidget: (context, url, error) {
                return errorIcon;
              },
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
