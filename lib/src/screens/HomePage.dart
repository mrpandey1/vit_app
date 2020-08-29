import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vit_app/main.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/Shared/loading.dart';
import 'package:vit_app/src/animations/animatedPageRoute.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/model/user.dart';
import 'package:vit_app/src/screens/AdminFeatures.dart';
import 'package:vit_app/src/screens/StudentRegistration.dart';

final userRef = FirebaseFirestore.instance.collection('users');
VITUser currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
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
        Navigator.push(context, BouncyPageRoute(widget: StudentRegistration()));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => StudentRegistration()),
        // );
      } else {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, BouncyPageRoute(widget: MyApp()));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Scaffold(
            body: loadingScreen(),
          )
        : Scaffold(
            appBar: header(context, isAppTitle: true, isLogout: true),
            floatingActionButton: currentUser.admin
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    backgroundColor: kPrimaryColor,
                    onPressed: () => {
                      Navigator.push(
                          context, BouncyPageRoute(widget: AdminFeatures()))
                    },
                  )
                : null,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text('Hello ${currentUser.admin}'),
                ),
              ],
            ),
          );
  }
}
