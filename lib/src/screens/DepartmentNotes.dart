import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/Shared/loading.dart';
import 'package:vit_app/src/ShowNotes.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/screens/HomePage.dart';

List<DocumentSnapshot> _list;
String yearValue;

class DepartmentNotes extends StatefulWidget {
  final String dept;
  DepartmentNotes({this.dept});
  @override
  _DepartmentNotesState createState() => _DepartmentNotesState();
}

class _DepartmentNotesState extends State<DepartmentNotes> {
  String divValue;
  List<String> years = ['First', 'Second', 'Third', 'Fourth'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,
          isAppTitle: false, titleText: 'Select year', removeBack: true),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: DropdownButtonFormField(
              hint: Text('Select Year'),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  yearValue = value;
                });
              },
              validator: (value) =>
                  value == null ? 'This field is required' : null,
              items: years.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    '$value',
                  ),
                );
              }).toList(),
            ),
          ),
          yearValue != null
              ? Expanded(
                  child: studentScreen(widget.dept, yearValue),
                )
              : Container(
                  height: 0,
                )
        ],
      ),
    );
  }

  Widget studentScreen(String dept, String year) {
    return Scaffold(
        body: FutureBuilder(
      future: subjectsRef.doc(dept).collection(yearValue).get(),
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
                              dept: dept,
                              year: year)),
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
