import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/model/notices.dart';
import 'package:vit_app/src/model/user.dart';
import 'package:vit_app/src/screens/HomePage.dart';

class TimeLine extends StatefulWidget {
  final userRef = FirebaseFirestore.instance.collection('users');
  VITUser currentUser;
  TimeLine({this.currentUser});

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  final timeLineref = FirebaseFirestore.instance.collection('timeline');
  final studentRef = FirebaseFirestore.instance.collection('students');
  List<Notices> list = List();
  String dept, year, division;
  String from, mediaUrl, notice, ownerId, postId;
  @override
  void initState() {
    super.initState();
    getPost();
  }

  getPost() async {
    DocumentSnapshot snapshot = await userRef.doc(currentUser.id).get();
    snapshot.data().forEach((key, value) {
      if (key == 'year') {
        year = value;
      } else if (key == 'division') {
        division = value;
      } else if (key == 'dept') {
        dept = value;
      }
    });
    QuerySnapshot sn = await timeLineref
        .doc(dept + division + year)
        .collection('timelinePosts')
        .get();
    sn.docs.forEach((value) {
      value.data().forEach((key, value) {
        switch (key) {
          case 'ownerId':
            ownerId = value;
            break;
          case 'mediaUrl':
            mediaUrl = value;
            break;
          case 'notice':
            notice = value;
            break;
          case 'from':
            from = value;
            break;
          case 'postId':
            postId = value;
            break;
        }
      });
      Notices notices = new Notices(
        ownerId: ownerId,
        from: from,
        postId: postId,
        mediaUrl: mediaUrl,
        notice: notice,
      );
      list.add(notices);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget UI(String ownerId, String notice, String postId, String from) {
      return GestureDetector(
        onTap: () => {},
        child: Card(
          child: Column(
            children: [
              Text(ownerId),
              Text(mediaUrl),
              Text(from),
              Text(notice),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        child: list.length == 0
            ? Text('No new Notice')
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return UI(list[index].ownerId, list[index].notice,
                      list[index].postId, list[index].from);
                }),
      ),
    );
  }
}
