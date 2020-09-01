import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vit_app/src/Shared/loading.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/widgets/NoticeItem.dart';

class TimeLine extends StatefulWidget {
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
    // return Scaffold(body: buildTimeline());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildTimeline(),
            buildAllTimeline('INFT', 'All', 'Third'),
          ],
        ),
      ),
    );
  }

  Widget buildTimeline() {
    List<DocumentSnapshot> _list;
    return StreamBuilder(
        stream: timelineRef
            .doc(currentUser.dept + currentUser.division + currentUser.year)
            .collection('timelinePosts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (!snapshots.hasData) {
            return loadingScreen();
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

  Widget buildAllTimeline(dept, division, year) {
    List<DocumentSnapshot> _list;
    return StreamBuilder(
        stream: timelineRef
            .doc(dept + division + year)
            .collection('timelinePosts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (!snapshots.hasData) {
            return loadingScreen();
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
