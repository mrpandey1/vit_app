import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/Shared/loading.dart';
import 'package:vit_app/src/widgets/NotesItem.dart';

List<DocumentSnapshot> _list;

class ShowNotes extends StatefulWidget {
  final String subject;
  final String dept;
  final String year;
  const ShowNotes({@required this.subject, this.dept, this.year});

  @override
  _ShowNotesState createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        isAppTitle: false,
        isCenterTitle: true,
        titleText: '${widget.subject}',
        bold: true,
      ),
      body: StreamBuilder(
        stream: notesRef
            .doc(widget.dept)
            .collection('Notes')
            .doc(widget.year)
            .collection(widget.subject)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (!snapshots.hasData) {
            return loadingScreen();
          }
          _list = snapshots.data.docs;
          return _list.length == 0
              ? Center(
                  child: Text('No notes available'),
                )
              : ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildNotesItem(context, _list[index]);
                  },
                );
        },
      ),
    );
  }
}
