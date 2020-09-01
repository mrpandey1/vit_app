import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/Shared/loading.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/widgets/NoticeItem.dart';

List<DocumentSnapshot> _list;

class DepartmentPosts extends StatefulWidget {
  String dept, division;
  DepartmentPosts({this.dept, this.division});
  @override
  _DepartmentPostsState createState() => _DepartmentPostsState();
}

class _DepartmentPostsState extends State<DepartmentPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, isAppTitle: false, titleText: widget.dept),
        body: buildTimeline());
  }

  Widget buildTimeline() {
    return StreamBuilder(
        stream:
            postRef.doc(widget.dept).collection(widget.division).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (!snapshots.hasData) {
            return loadingScreen();
          }
          _list = snapshots.data.docs;
          return ListView.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              return buildNoticeItem(context, _list[index]);
            },
          );
        });
  }
}
