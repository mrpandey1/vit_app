import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/screens/HomePage.dart';

class TimelinePost extends StatefulWidget {
  final String mediaUrl;
  final String from;
  final String notice;
  final String ownerId;
  final String postId;
  final Timestamp timestamp;
  final String to;
  TimelinePost(
      {this.mediaUrl,
      this.from,
      this.notice,
      this.ownerId,
      this.postId,
      this.timestamp,
      this.to});

  // Named Constructor
  factory TimelinePost.fromDocument(DocumentSnapshot documentSnapshot) {
    return TimelinePost(
        mediaUrl: documentSnapshot.data()['mediaUrl'],
        from: documentSnapshot.data()['from'],
        notice: documentSnapshot.data()['notice'],
        ownerId: documentSnapshot.data()['ownerId'],
        postId: documentSnapshot.data()['postId'],
        timestamp: documentSnapshot.data()['timestamp'],
        to: documentSnapshot.data()['to']);
  }

  @override
  _TimelinePostState createState() => _TimelinePostState(
        mediaUrl: this.mediaUrl,
        from: this.from,
        notice: this.notice,
        ownerId: this.ownerId,
        postId: this.postId,
        timestamp: this.timestamp,
        to: this.to,
      );
}

class _TimelinePostState extends State<TimelinePost> {
  final String mediaUrl;
  final String from;
  final String notice;
  final String ownerId;
  final String postId;
  final Timestamp timestamp;
  final String to;

  _TimelinePostState(
      {this.mediaUrl,
      this.from,
      this.notice,
      this.ownerId,
      this.postId,
      this.timestamp,
      this.to});

  deletePost(String ownerId, String postId, String to) async {
    postRef
        .doc(ownerId)
        .collection(to.substring(0, 4))
        .doc(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    timelineRef
        .doc(to)
        .collection('timelinePosts')
        .doc(postId)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
    if (mediaUrl != '') {
      storageRef.child('posts').child('post_$postId.jpg').delete();
    }
    Navigator.pop(context);
  }

  handleDeletePost(
      BuildContext parentContext, String ownerId, String postId, String to) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
              title: Text("Remove this post"),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () => deletePost(ownerId, postId, to),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                SimpleDialogOption(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notice by ' + from),
                subtitle: Text(notice),
                trailing: currentUser.admin
                    ? IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            handleDeletePost(context, ownerId, postId, to),
                      )
                    : null,
              )
            ],
          ),
        )
      ],
    );
  }
}
