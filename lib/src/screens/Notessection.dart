import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/widgets/NotesItem.dart';
import 'package:vit_app/src/widgets/TimelineLoadingPlaceholder.dart';

class NotesSection extends StatefulWidget {
  @override
  _NotesSectionState createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  List subjects = [];
  String departmentValue;
  String subjectValue;
  bool _loading = false;
  Future<void> fetchSubjects(String yearValue) async {
    departmentValue = currentUser.dept;
    yearValue = currentUser.year;
    setState(() {
      _loading = true;
    });
    QuerySnapshot querySnapshot =
        await subjectsRef.doc(departmentValue).collection(yearValue).get();

    subjects.clear();

    querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
      setState(() {
        subjects.add(documentSnapshot.id);
      });
    });

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSubjects(currentUser.year);
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> _list;
    return Scaffold(
      body: Column(
        children: [
          getDropDown(
              hintText: 'Select Subject', type: 'subject', valueMap: subjects),
          subjectValue != null
              ? Expanded(
                  child: StreamBuilder(
                      stream: notesRef
                          .doc(currentUser.dept)
                          .collection('Notes')
                          .doc(currentUser.year)
                          .collection(subjectValue)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                        if (!snapshots.hasData) {
                          return ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return LoadingContainer();
                              });
                        }
                        _list = snapshots.data.docs;
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return buildNotesItem(context, _list[index]);
                          },
                        );
                      }),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
    );
  }

  Container getDropDown(
      {@required hintText, @required type, @required List<dynamic> valueMap}) {
    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: DropdownButtonFormField(
            hint: Text('$hintText'),
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                subjectValue = value;
              });
            },
            validator: (value) =>
                value == null ? 'This field is required' : null,
            items: valueMap.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  '$value',
                ),
              );
            }).toList()));
  }
}
