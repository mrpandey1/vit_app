import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/main.dart';
import 'package:vit_app/src/animations/animatedPageRoute.dart';

import 'package:vit_app/src/constants.dart';

void _signOut(context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, BouncyPageRoute(widget: MyApp()));
  } catch (e) {
    print(e);
  }
}

header(context,
    {bool isAppTitle = false,
    String titleText,
    removeback = false,
    isLogout = false}) {
  return AppBar(
      title: Text(
        isAppTitle ? 'VIT' : titleText,
        style: TextStyle(fontSize: isAppTitle ? 30 : 22, color: Colors.white),
      ),
      automaticallyImplyLeading: removeback ? false : true,
      backgroundColor: kPrimaryColor,
      actions: isLogout
          ? <Widget>[
              FlatButton(
                child: Text(
                  'Sign out',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _signOut(context),
              )
            ]
          : null);
}
