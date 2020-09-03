import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/Shared/loading.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/model/user.dart';
import 'package:vit_app/src/screens/DepartmentPosts.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/widgets/NoticeItem.dart';
import 'package:vit_app/src/widgets/TimelineLoadingPlaceholder.dart';

List<DocumentSnapshot> _list;

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
    return Scaffold(
        appBar: header(context,
            isAppTitle: false, titleText: 'Notices', isLogout: false),
        body: currentUser.admin ? adminTimeline() : buildTimeline());
  }

  Widget adminTimeline() {
    return Scaffold(
      body: FutureBuilder(
        future: departmentRef.get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingScreen();
          }
          _list = snapshot.data.docs;
          List<Padding> _listTiles = [];
          _list.forEach(
            (DocumentSnapshot documentSnapshot) {
              _listTiles.add(
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepartmentPosts(
                            dept: documentSnapshot.id,
                          ),
                        ),
                      ),
                    },
                    child: Container(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: kPrimaryColor.withOpacity(0.6),
                                width: 0.7,
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff9921E8).withOpacity(0.9),
                                  kPrimaryColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '${documentSnapshot.id}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );

          return GridView.count(
            crossAxisCount: 2,
            children: _listTiles,
            physics: BouncingScrollPhysics(),
          );
        },
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
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return LoadingContainer();
                });
          }
          _list = snapshots.data.docs;
          return _list.length == 0
              ? Center(
                  child: Text('No Notice For Now!'),
                )
              : ListView.builder(
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
