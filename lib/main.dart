import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/authentication/authentication.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/screens/SignInSignUpPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'VIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'mont',
        primaryColor: kPrimaryColor,
      ),
      home: new MyAppHome(auth: new MyAuth()),
    );
  }
}

class MyAppHome extends StatefulWidget {
  MyAppHome({this.auth});
  final AuthFunc auth;
  @override
  State<StatefulWidget> createState() => _MyAppHomeState();
}

enum AuthStatus { NOT_LOGIN, NOT_DETERMINED, LOGIN }

class _MyAppHomeState extends State<MyAppHome> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = '', _userEmail = '';
  User _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (_user != null) {
        if (!_user.emailVerified) {
          authStatus = AuthStatus.NOT_LOGIN;
        }
        _userId = _user?.uid;
        _userEmail = _user?.email;
        authStatus = AuthStatus.LOGIN;
      } else {
        authStatus = AuthStatus.NOT_LOGIN;
      }
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
              onSignOut: _onSignOut);
        else
          return _showLoading();
        break;

      default:
        return _showLoading();
        break;
    }
  }

  void _onSignOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGIN;
      _userEmail = _userId = '';
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
      child: CircularProgressIndicator(
        backgroundColor: kPrimaryColor,
      ),
    ),
  );
}
