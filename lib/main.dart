import 'package:flutter/material.dart';
import 'package:vit_app/screens/home.dart';

import 'authentication/authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My_APP',
      home: new MyAppHome(auth: new MyAuth()),
    );
  }
}
