import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/screens/HomePage.dart';
import 'package:vit_app/src/shared/header.dart';
import 'package:vit_app/src/shared/loading.dart';
import 'package:vit_app/src/widgets/NotesItem.dart';

List<DocumentSnapshot> _list;

class ShowNotes extends StatefulWidget {
  final String subject;

  const ShowNotes({@required this.subject});

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
      body: FutureBuilder(
        future: notesRef
            .doc(currentUser.dept)
            .collection('Notes')
            .doc(currentUser.year)
            .collection(widget.subject)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (!snapshots.hasData) {
            return loadingScreen();
          }
          _list = snapshots.data.docs;
          return _list.length == 0
              ? Center(
                  child: Text('No Notes For Now!'),
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
