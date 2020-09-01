import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../constants.dart';

Widget buildNotesItem(BuildContext context, DocumentSnapshot documentSnapshot) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: kPrimaryColor.withOpacity(0.6),
            width: 0.7,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildNotesHeader(documentSnapshot, context),
          Divider(
            color: Colors.grey.withOpacity(0.5),
            height: 0.5,
          ),
          buildPostImage(
              'https://is1-ssl.mzstatic.com/image/thumb/Purple124/v4/a4/1f/86/a41f8664-0752-d8fd-b0ca-14108bda3505/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/1200x630wa.png')
        ],
      ),
    ),
  );
}

Widget buildNotesHeader(
    DocumentSnapshot documentSnapshot, BuildContext context) {
  return ListTile(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Notes by ',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              documentSnapshot.data()['from'],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            )
          ],
        ),
        SizedBox(
          height: 4.0,
        ),
        Text(
          timeago.format(documentSnapshot.data()['timestamp'].toDate()),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
      ],
    ),
  );
}

Widget buildPostImage(String image) {
  return Padding(
    padding: EdgeInsets.all(5.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) {
          return Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          );
        },
        fit: BoxFit.cover,
      ),
    ),
  );
}
