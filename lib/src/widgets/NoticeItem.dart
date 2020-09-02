import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../constants.dart';


Widget buildNoticeItem(
    BuildContext context, DocumentSnapshot documentSnapshot) {
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
          buildPostHeader(documentSnapshot, context),
          Divider(
            color: Colors.grey.withOpacity(0.5),
            height: 0.5,
          ),
          documentSnapshot.data()['mediaUrl'].isNotEmpty
              ? buildPostImage(documentSnapshot)
              : Container(
                  height: 0,
                  width: 0,
                ),
          buildNotice(documentSnapshot),
        ],
      ),
    ),
  );
}

Widget buildPostHeader(
    DocumentSnapshot documentSnapshot, BuildContext context) {
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
    trailing: currentUser.admin
        ? IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => handleDeletePost(
                context,
                documentSnapshot.data()['ownerId'],
                documentSnapshot.data()['postId'],
                documentSnapshot.data()['toDepartment'],
                documentSnapshot.data()['toDivision'],
                documentSnapshot.data()['toYear'],
                documentSnapshot),
          )
        : null,
  );
}

deletePost(BuildContext context, String ownerId, String postId, String toDept,
    String toDivi, String toYear, DocumentSnapshot documentSnapshot) async {
  List lDepartments = ['INFT'];
  List lDivisions = [
    'A',
    'B',
  ];
  List lYears = ['First', 'Second', 'Third', 'Fourth'];
  postRef.doc(toDept).collection(toYear + toDivi).doc(postId).get().then((doc) {
    if (doc.exists) {
      doc.reference.delete();
    }
  });
  if (toDept == 'All' && toDivi == 'All' && toYear == 'All') {
    lDepartments.forEach((dept) {
      lDivisions.forEach((div) {
        lYears.forEach((year) async {
          await timelineRef
              .doc(dept + div + year)
              .collection('timelinePosts')
              .doc(postId)
              .get()
              .then((value) {
            if (value.exists) {
              value.reference.delete();
            }
          });
        });
      });
    });
  } else if (toDept == 'All' && toDivi == 'All' && toYear != 'All') {
    lDepartments.forEach((dept) {
      lDivisions.forEach((div) async {
        await timelineRef
            .doc(dept + div + toYear)
            .collection('timelinePosts')
            .doc(postId)
            .get()
            .then((value) {
          if (value.exists) {
            value.reference.delete();
          }
        });
      });
    });
  } else if (toDept == 'All' && toDivi != 'All' && toYear == 'All') {
    lDepartments.forEach((dept) {
      lYears.forEach((years) async {
        await timelineRef
            .doc(dept + toDivi + lYears)
            .collection('timelinePosts')
            .doc(postId)
            .get()
            .then((value) {
          if (value.exists) {
            value.reference.delete();
          }
        });
      });
    });
  } else if (toDept != 'All' && toDivi != 'All' && toYear == 'All') {
    lYears.forEach((years) async {
      await timelineRef
          .doc(toDept + toDivi + years)
          .collection('timelinePosts')
          .doc(postId)
          .get()
          .then((value) {
        if (value.exists) {
          value.reference.delete();
        }
      });
    });
  } else if (toDept != 'All' && toDivi == 'All' && toYear != 'All') {
    lDivisions.forEach((divi) async {
      await timelineRef
          .doc(toDept + divi + toYear)
          .collection('timelinePosts')
          .doc(postId)
          .get()
          .then((value) {
        if (value.exists) {
          value.reference.delete();
        }
      });
    });
  } else if (toDept != 'All' && toDivi == 'All' && toYear == 'All') {
    lDivisions.forEach((divi) {
      lYears.forEach((years) async {
        await timelineRef
            .doc(toDept + divi + years)
            .collection('timelinePosts')
            .doc(postId)
            .get()
            .then((value) {
          if (value.exists) {
            value.reference.delete();
          }
        });
      });
    });
  } else if (toDept == 'All' && toDivi != 'All' && toYear != 'All') {
    lDepartments.forEach((dept) async {
      await timelineRef
          .doc(dept + toDivi + toYear)
          .collection('timelinePosts')
          .doc(postId)
          .get()
          .then((value) {
        if (value.exists) {
          value.reference.delete();
        }
      });
    });
  } else {
    await timelineRef
        .doc(toDept + toDivi + toYear)
        .collection('timelinePosts')
        .doc(postId)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
  }

  if (documentSnapshot.data()['mediaUrl'] != '') {
    storageRef.child('posts').child('post_$postId.jpg').delete();
  }
  Navigator.pop(context);
}

handleDeletePost(
    BuildContext parentContext,
    String ownerId,
    String postId,
    String toDept,
    String toDivi,
    String toYear,
    DocumentSnapshot documentSnapshot) {
  return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(title: Text("Remove this post"), children: <Widget>[
          SimpleDialogOption(
            onPressed: () => deletePost(context, ownerId, postId, toDept,
                toDivi, toYear, documentSnapshot),
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

Widget buildPostImage(DocumentSnapshot documentSnapshot) {
  return Padding(
    padding: EdgeInsets.all(5.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: CachedNetworkImage(
        imageUrl: documentSnapshot.data()['mediaUrl'],
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

Widget buildNotice(DocumentSnapshot documentSnapshot) {
  return Container(
    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
    child: Text(
      documentSnapshot.data()['notice'],
      style: TextStyle(
        fontSize: 16.0,
      ),
    ),
  );
}
