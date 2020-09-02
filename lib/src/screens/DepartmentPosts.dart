import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/Shared/loading.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/widgets/NoticeItem.dart';

List<DocumentSnapshot> _list;

class DepartmentPosts extends StatefulWidget {
  String dept;
  DepartmentPosts({this.dept});
  @override
  _DepartmentPostsState createState() => _DepartmentPostsState();
}

class _DepartmentPostsState extends State<DepartmentPosts> {
  String yearValue, divValue;
  List<String> years = ['All', 'First', 'Second', 'Third', 'Fourth'];
  List<String> division = ['All', 'A', 'B'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: false, titleText: widget.dept),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: DropdownButtonFormField(
              hint: Text('Select year'),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  yearValue = value;
                });
              },
              validator: (value) =>
                  value == null ? 'This field is required' : null,
              items: years.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    '$value',
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: DropdownButtonFormField(
              hint: Text('Select year'),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  divValue = value;
                });
              },
              validator: (value) =>
                  value == null ? 'This field is required' : null,
              items: division.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    '$value',
                  ),
                );
              }).toList(),
            ),
          ),
          yearValue != null && divValue != null
              ? Expanded(
                  child: buildTimeline(yearValue, divValue),
                )
              : Container(
                  height: 0,
                )
        ],
      ),
    );
  }

  Widget buildTimeline(String yearValue, String divValue) {
    return StreamBuilder(
        stream: postRef
            .doc(widget.dept)
            .collection(yearValue + divValue)
            .snapshots(),
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
