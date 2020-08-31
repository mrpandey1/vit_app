import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimelinePost extends StatefulWidget {
  final String mediaUrl;
  final String from;
  final String notice;
  final String ownerId;
  final String postId;
  final Timestamp timestamp;

  TimelinePost(
      {this.mediaUrl,
      this.from,
      this.notice,
      this.ownerId,
      this.postId,
      this.timestamp});

  // Named Constructor
  factory TimelinePost.fromDocument(DocumentSnapshot documentSnapshot) {
    return TimelinePost(
      mediaUrl: documentSnapshot.data()['mediaUrl'],
      from: documentSnapshot.data()['from'],
      notice: documentSnapshot.data()['notice'],
      ownerId: documentSnapshot.data()['ownerId'],
      postId: documentSnapshot.data()['postId'],
      timestamp: documentSnapshot.data()['timestamp'],
    );
  }

  @override
  _TimelinePostState createState() => _TimelinePostState(
        mediaUrl: this.mediaUrl,
        from: this.from,
        notice: this.notice,
        ownerId: this.ownerId,
        postId: this.postId,
        timestamp: this.timestamp,
      );
}

class _TimelinePostState extends State<TimelinePost> {
  final String mediaUrl;
  final String from;
  final String notice;
  final String ownerId;
  final String postId;
  final Timestamp timestamp;

  _TimelinePostState(
      {this.mediaUrl,
      this.from,
      this.notice,
      this.ownerId,
      this.postId,
      this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(notice),
        ),
        Container(
          child: Text(from),
        )
      ],
    );
  }
}
