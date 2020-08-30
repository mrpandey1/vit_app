import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/Shared/loading.dart';
import 'package:vit_app/src/animations/animatedPageRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vit_app/src/model/user.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/screens/editprofile.dart';

class ProfilePage extends StatefulWidget {
  final userRef = FirebaseFirestore.instance.collection('users');
  VITUser currentUser;
  ProfilePage({this.currentUser});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email, name, rollNumber;
  bool admin;
  @override
  void initState() {
    super.initState();
    userRef
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      currentUser = VITUser.fromDocument(documentSnapshot);
    });
  }

  getName() {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userRef.doc(currentUser.id).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return loadingScreen();
        }
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
                      child: Text(currentUser.displayName),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 30),
                      child: Text(currentUser.email),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 30),
                      child: Text(currentUser.rollNumber),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      onPressed: () => Navigator.push(
                          context,
                          BouncyPageRoute(
                              widget: EditProfile(
                            currentUser: currentUser,
                          ))),
                      child: Text('Change profile'),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
