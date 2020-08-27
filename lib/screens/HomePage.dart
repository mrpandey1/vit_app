import 'package:flutter/material.dart';
import 'package:vit_app/authentication/authentication.dart';

class HomePage extends StatefulWidget {
  AuthFunc auth;
  VoidCallback onSignOut;
  String userId, userEmail;

  HomePage({Key key, this.auth, this.onSignOut, this.userEmail, this.userId})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
