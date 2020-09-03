import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/animations/animatedPageRoute.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/model/user.dart';
import 'package:vit_app/src/screens/DepartmentPosts.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/widgets/TimelinePost.dart';

import 'AddNotes.dart';
import 'AddNotice.dart';

class ProfilePage extends StatefulWidget {
  final userRef = FirebaseFirestore.instance.collection('users');
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = '', name = '', rollNumber = '';
  bool admin;
  List<TimelinePost> timelinePosts = [];
  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,
          isAppTitle: false, titleText: 'Profile', isLogout: true),
      body: currentUser.admin
          ? buildAdminProfileScreen(context)
          : buildProfileScreen(context),
    );
  }

  getProfile() async {
    DocumentSnapshot snapshot = await userRef.doc(currentUser.id).get();
    snapshot.data().forEach((key, value) {
      if (key == 'displayName') {
        setState(() {
          name = value;
        });
      } else if (key == 'rollNumber') {
        setState(() {
          rollNumber = value;
        });
      } else if (key == 'email') {
        setState(() {
          email = value;
        });
      }
    });
  }

  Widget buildAdminProfileScreen(context) {
    return Column(
      children: [
        Container(
          height: 200.0,
          child: new Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 120.0,
                          height: 120.0,
                          child:
                              Image.asset('assets/images/default-profile.png'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'Admin ',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          child: Icon(
                            Icons.stars,
                            color: Colors.green,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(color: kPrimaryColor),
        Expanded(
          child: ListView(
            children: [
              GestureDetector(
                onTap: () => {
                  Navigator.push(context, BouncyPageRoute(widget: AddNotice()))
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0),
                  child: Stack(
                    children: [
                      Container(
                        height: 120.0,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: LinearGradient(
                            colors: [Colors.indigoAccent, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Image.asset(
                            'assets/images/notice.png',
                          ),
                        ),
                      ),
                      Positioned(
                        top: 45.0,
                        left: 130.0,
                        child: Container(
                          child: Text(
                            'Add Notice',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(context, BouncyPageRoute(widget: AddNotes()))
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0),
                  child: Stack(
                    children: [
                      Container(
                        height: 120.0,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: LinearGradient(
                            colors: [Colors.pink, Colors.red],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(25.0),
                          child: Image.asset(
                            'assets/images/notes.png',
                          ),
                        ),
                      ),
                      Positioned(
                        top: 45.0,
                        left: 130.0,
                        child: Container(
                          child: Text(
                            'Add Notes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildProfileScreen(context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          //profile pic start
          Container(
            height: 200.0,
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: new Stack(fit: StackFit.loose, children: <Widget>[
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: 140.0,
                          height: 140.0,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://cdn2.iconfinder.com/data/icons/men-avatars/33/man_19-512.png',
                            placeholder: (context, url) => Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ],
                    ),
                  ]),
                )
              ],
            ),
          ),
          //profile pic ending
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 30),
                  child: Text(name),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 30),
                  child: Text(email ?? ''),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 30),
                  child: Text(rollNumber ?? ''),
                ),
                SizedBox(
                  height: 20,
                ),
                // FlatButton(
                //   onPressed: () => Navigator.push(
                //       context,
                //       BouncyPageRoute(
                //           widget: EditProfile(
                //         currentUser: currentUser,
                //       ))),
                //   child: Text('Change profile'),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
