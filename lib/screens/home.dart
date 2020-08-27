import 'package:flutter/material.dart';
import 'package:vit_app/authentication/authentication.dart';
import 'package:vit_app/screens/HomePage.dart';
import 'package:vit_app/shared/loading.dart';

class MyAppHome extends StatefulWidget {
  MyAppHome({this.auth});
  AuthFunc auth;
  @override
  _MyAppHomeState createState() => _MyAppHomeState();
}

enum AuthStatus { NOT_LOGIN, NOT_DETERMINED, LOGIN }

class _MyAppHomeState extends State<MyAppHome> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = '', _userEmail = '';

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          _userEmail = user?.email;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGIN : AuthStatus.LOGIN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _showLoading();
        break;
      case AuthStatus.NOT_LOGIN:
        return SignInSignUpPage(auth: widget.auth, onSignIn: _onSignedIn);
        break;
      case AuthStatus.LOGIN:
        if (_userId.length > 0 && _userId != null) //session is still live
          return HomePage(
              userId: _userId,
              userEmail: _userEmail,
              auth: widget.auth,
              onSignOut: _onSignOut;
        else
          return _showLoading();
        break;
      default:
        return _showLoading();
        break;
    }
  }
void _onSignOut(){
  setState(() {
    authStatus=AuthStatus.NOT_LOGIN;
    _userEmail=_userId='';
  });
}
  void _onSignedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        _userEmail = user.uid.toString();
      });
      setState(() {
        authStatus = AuthStatus.LOGIN;
      });
    });
  }
}

Widget _showLoading() {
  return Scaffold(
    body: Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    ),
  );
}
