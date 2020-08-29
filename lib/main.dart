import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      home: MyAppHome(auth: new MyAuth()),
    );
  }
}

class MyAppHome extends StatefulWidget {
  MyAppHome({this.auth});
  final AuthFunc auth;
  @override
  State<StatefulWidget> createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  User _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (_user != null) {
      if (!_user.emailVerified) {
        // ----------- IF EMAIL IS NOT VERIFIED -----------
        Future(() {
          pushToSignInSignUp();
        });
      }
      Future(() {
        // ----------- EVERYTHING IS GOOD -----------
        pushToHomePage();
      });
    } else {
      Future(() {
        // ----------- NOT LOGGED IN -----------
        pushToSignInSignUp();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpinKitFoldingCube(
        color: kPrimaryColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void pushToSignInSignUp() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SignInSignUpPage(auth: widget.auth)));
  }

  void pushToHomePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
