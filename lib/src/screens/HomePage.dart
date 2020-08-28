import 'package:flutter/material.dart';
import 'package:vit_app/src/authentication/authentication.dart';

class HomePage extends StatefulWidget {
  final AuthFunc auth;
  final VoidCallback onSignOut;
  final String userId, userEmail;

  HomePage({Key key, this.userId, this.userEmail, this.auth, this.onSignOut})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
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
          ),
        ],
      ),
    );
  }
}
