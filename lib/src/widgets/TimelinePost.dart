import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:timeago/timeago.dart' as timeago;

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
            buildPostHeader(),
            Divider(
              color: Colors.grey.withOpacity(0.5),
              height: 0.5,
            ),
            mediaUrl.isNotEmpty
                ? buildPostImage()
                : Container(
                    height: 0,
                    width: 0,
                  ),
            buildNotice(),
          ],
        ),
      ),
    );
  }

  Widget buildPostHeader() {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Notice by ',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              Text(
                from,
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
            timeago.format(timestamp.toDate()),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
      trailing: currentUser.admin
          ? IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => handleDeletePost(context, ownerId, postId, to),
            )
          : null,
    );
  }

  Widget buildPostImage() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(
          imageUrl: mediaUrl,
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

  Widget buildNotice() {
    return Container(
      padding:
          EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
      child: Text(
        notice,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }
}
