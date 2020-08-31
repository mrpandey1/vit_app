import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/Shared/loading.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/widgets/TimelinePost.dart';

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
    return Scaffold(body: buildTimeline());
  }

  Widget buildTimeline() {
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
        List<TimelinePost> timelinePosts = [];
        snapshots.data.docs.forEach((DocumentSnapshot documentSnapshot) {
          timelinePosts.add(TimelinePost.fromDocument(documentSnapshot));
        });

        return timelinePosts.isEmpty
            ? Text('No Notice For Now!')
            : ListView(
                children: timelinePosts,
              );
      },
    );
  }
}
