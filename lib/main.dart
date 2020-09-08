import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vit_app/src/authentication/authentication.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/model/user.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/screens/SignInSignUpPage.dart';

final userRef = FirebaseFirestore.instance.collection('users');
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
  VITUser user;
  User _user;
  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    super.initState();
    if (_user != null) {
      if (!_user.emailVerified) {
        // ----------- IF EMAIL IS NOT VERIFIED -----------
        Future(() {
          pushToSignInSignUp();
        });
      }
      Future(() async {
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
        duration: Duration(seconds: 2),
      ),
    );
  }

  void pushToSignInSignUp() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SignInSignUpPage(auth: widget.auth)));
  }

  void pushToHomePage() async {
    DocumentSnapshot snapshot = await userRef.doc(_user.uid).get();
    user = VITUser.fromDocument(snapshot);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  user: user,
                )));
  }
}
