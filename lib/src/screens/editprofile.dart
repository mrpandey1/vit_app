import 'package:flutter/material.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/screens/HomePage.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: currentUser.displayName),
    );
  }
}
