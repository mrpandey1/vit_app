import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/animations/animatedPageRoute.dart';
import 'package:vit_app/src/constants.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                image: NetworkImage(
                                    'https://cdn2.iconfinder.com/data/icons/men-avatars/33/man_19-512.png'),
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => print('hello'),
                      child: Padding(
                          padding: EdgeInsets.only(top: 90.0, right: 100.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 25.0,
                                child: new Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )),
                    )
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
                  child: Text('${currentUser.displayName}'),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 30),
                  child: Text('${currentUser.email}'),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 30),
                  child: Text('${currentUser.rollNumber}'),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  onPressed: () => Navigator.push(
                      context, BouncyPageRoute(widget: EditProfile())),
                  child: Text('Change profile'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
