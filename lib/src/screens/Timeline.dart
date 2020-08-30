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
    dept = 'INFT';
    division = 'B';
    year = 'Third';
    DocumentSnapshot snapshot =
        await studentRef.doc(dept).collection(year).doc(currentUser.id).get();

    QuerySnapshot sn = await timeLineref
        .doc(dept + division + year)
        .collection('timelinePosts')
        .
        // ignore: deprecated_member_use
        getDocuments();

    DocumentSnapshot posts = await timeLineref
        .doc(dept + division + year)
        .collection('timelinePosts')
        .doc()
        .get();
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
