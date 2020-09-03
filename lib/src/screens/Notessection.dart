import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/Shared/loading.dart';
import 'package:vit_app/src/screens/DepartmentNotes.dart';
import '../ShowNotes.dart';
import 'HomePage.dart';

List<DocumentSnapshot> _list;
String yearValue;

class NotesSection extends StatefulWidget {
  @override
  _NotesSectionState createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, isAppTitle: false, titleText: 'Notes'),
        body: currentUser.admin ? adminScreen() : studentScreen());
  }

  Widget adminScreen() {
    return Scaffold(
        body: FutureBuilder(
      future: departmentRef.get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return loadingScreen();
        }
        _list = snapshot.data.docs;
        List<Padding> _listTiles = [];
        _list.forEach(
          (DocumentSnapshot documentSnapshot) {
            _listTiles.add(
              Padding(
                padding: EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DepartmentNotes(dept: documentSnapshot.id)),
                    )
                  },
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: kPrimaryColor.withOpacity(0.6),
                              width: 0.7,
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff9921E8).withOpacity(0.9),
                                kPrimaryColor
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${documentSnapshot.id}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );

        return GridView.count(
          crossAxisCount: 2,
          children: _listTiles,
          physics: BouncingScrollPhysics(),
        );
      },
    ));
  }

  Widget studentScreen() {
    return Scaffold(
        body: FutureBuilder(
      future:
          subjectsRef.doc(currentUser.dept).collection(currentUser.year).get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return loadingScreen();
        }
        _list = snapshot.data.docs;
        List<Padding> _listTiles = [];
        _list.forEach(
          (DocumentSnapshot documentSnapshot) {
            _listTiles.add(
              Padding(
                padding: EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowNotes(
                                subject: '${documentSnapshot.id}',
                              )),
                    )
                  },
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: kPrimaryColor.withOpacity(0.6),
                              width: 0.7,
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff9921E8).withOpacity(0.9),
                                kPrimaryColor
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${documentSnapshot.id}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );

        return GridView.count(
          crossAxisCount: 2,
          children: _listTiles,
          physics: BouncingScrollPhysics(),
        );
      },
    ));
  }
}
