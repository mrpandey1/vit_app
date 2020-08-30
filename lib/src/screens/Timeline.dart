import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  String dept, year, division;
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
        .getDocuments();
    sn.docs.forEach((element) {
      print(element.data());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('${currentUser.displayName}'),
      ),
    );
  }
}
