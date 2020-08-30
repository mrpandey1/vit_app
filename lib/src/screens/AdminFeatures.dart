import 'package:flutter/material.dart';
import 'package:vit_app/src/animations/animatedPageRoute.dart';
import 'package:vit_app/src/screens/AddNotes.dart';
import 'package:vit_app/src/screens/AddNotice.dart';
import 'package:vit_app/src/Shared/header.dart';

class AdminFeatures extends StatefulWidget {
  @override
  _AdminFeaturesState createState() => _AdminFeaturesState();
}

class _AdminFeaturesState extends State<AdminFeatures> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        isAppTitle: true,
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () =>
                {Navigator.push(context, BouncyPageRoute(widget: AddNotice()))},
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0),
              child: Stack(
                children: [
                  Container(
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0),
                      gradient: LinearGradient(
                        colors: [Colors.indigoAccent, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Image.asset(
                        'assets/images/notice.png',
                      ),
                    ),
                  ),
                  Positioned(
                    top: 45.0,
                    left: 130.0,
                    child: Container(
                      child: Text(
                        'Add Notice',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                {Navigator.push(context, BouncyPageRoute(widget: AddNotes()))},
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0),
              child: Stack(
                children: [
                  Container(
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5.0),
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.red],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(25.0),
                      child: Image.asset(
                        'assets/images/notes.png',
                      ),
                    ),
                  ),
                  Positioned(
                    top: 45.0,
                    left: 130.0,
                    child: Container(
                      child: Text(
                        'Add Notes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
