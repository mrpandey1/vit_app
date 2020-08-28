import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/authentication/authentication.dart';
import 'package:vit_app/src/model/user.dart';
import 'package:vit_app/src/screens/StudentRegistration.dart';

final userRef = FirebaseFirestore.instance.collection('users');
VITUser currentUser;

class HomePage extends StatefulWidget {
  final AuthFunc auth;
  final VoidCallback onSignOut;
  final String userId, userEmail;

  HomePage({Key key, this.auth, this.onSignOut, this.userEmail, this.userId})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    userRef
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      currentUser = VITUser.fromDocument(documentSnapshot);
      if (!currentUser.isRegistered) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentRegistration()),
        );
      }
    });
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Home'),
        actions: <Widget>[
          FlatButton(
            child: Text('Sign out'),
            onPressed: _signOut,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text('Hello' + widget.userEmail),
          )
        ],
      ),
    );
  }
}
