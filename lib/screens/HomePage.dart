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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isEmailVerified = false;
  @override
  void initState() {
    super.initState();
    _checkEmailverification();
  }

  void _checkEmailverification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _showVerifyEmailDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please verify your email'),
            content: Text('we need to verify your account'),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    _signOut();
                    _sendverifyEmail();
                  },
                  child: Text('Send')),
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _signOut();
                  },
                  child: Text('dismiss')),
            ],
          );
        });
  }

  void _sendverifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thank you '),
            content: Text('Link has been sent '),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _sendverifyEmail();
                  },
                  child: Text('Ok')),
            ],
          );
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
