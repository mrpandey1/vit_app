import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vit_app/src/model/user.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/widgets/NoticeItem.dart';
import 'package:vit_app/src/widgets/TimelineLoadingPlaceholder.dart';

class TimeLine extends StatefulWidget {
  VITUser currentUser;
  TimeLine({this.currentUser});
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildTimeline());
  }

  Widget buildTimeline() {
    List<DocumentSnapshot> _list;
    return StreamBuilder(
        stream: timelineRef
            .doc(widget.currentUser.dept +
                widget.currentUser.division +
                widget.currentUser.year)
            .collection('timelinePosts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (!snapshots.hasData) {
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return LoadingContainer();
                });
          }
          _list = snapshots.data.docs;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _list.length,
            itemBuilder: (context, index) {
              return buildNoticeItem(context, _list[index]);
            },
          );
        });
  }
}
