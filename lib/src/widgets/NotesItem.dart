import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:vit_app/src/screens/HomePage.dart';

import '../constants.dart';

Widget buildNotesItem(BuildContext context, DocumentSnapshot documentSnapshot) {
  return Padding(
    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
    child: GestureDetector(
      onTap: () => {openPdf(context, documentSnapshot)},
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: kPrimaryColor.withOpacity(0.6),
              width: 0.7,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildNotesHeader(documentSnapshot, context),
            Divider(
              color: Colors.grey.withOpacity(0.5),
              height: 0.5,
            ),
            buildPostImage(),
            buildPostFooter(documentSnapshot),
          ],
        ),
      ),
    ),
  );
}

Widget buildNotesHeader(
    DocumentSnapshot documentSnapshot, BuildContext context) {
  return ListTile(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          documentSnapshot.data()['fileName'],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
      ],
    ),
    trailing: currentUser.admin
        ? IconButton(
            onPressed: () => {handleDeleteNotes(context, documentSnapshot)},
            icon: Icon(
              Icons.more_vert,
              color: kPrimaryColor,
            ),
          )
        : Container(height: 0, width: 0),
  );
}

Widget buildPostFooter(DocumentSnapshot documentSnapshot) {
  return ListTile(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Notes by ',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              documentSnapshot.data()['from'],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            )
          ],
        ),
        SizedBox(
          height: 4.0,
        ),
        Text(
          timeago.format(documentSnapshot.data()['timestamp'].toDate()),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
      ],
    ),
    trailing: IconButton(
      onPressed: () => {downloadPdf(documentSnapshot)},
      icon: Icon(
        Icons.file_download,
        color: kPrimaryColor,
      ),
    ),
  );
}

Widget buildPostImage() {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(5.0),
      child: Image.asset(
        'assets/images/pdf.png',
        height: 80.0,
      ),
    ),
  );
}

openPdf(BuildContext context, DocumentSnapshot documentSnapshot) async {
  PDFDocument doc =
      await PDFDocument.fromURL(documentSnapshot.data()['downloadUrl']);

  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => PDFViewer(
              document: doc,
            )),
  );
}

downloadPdf(DocumentSnapshot documentSnapshot) async {
  String url = documentSnapshot.data()['downloadUrl'];
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

deleteNotes(BuildContext context, DocumentSnapshot documentSnapshot) async {
  String dept = documentSnapshot.data()['dept'];
  String year = documentSnapshot.data()['year'];
  String subject = documentSnapshot.data()['subject'];
  String fileName = documentSnapshot.data()['fileName'];

  DocumentSnapshot doc = await notesRef
      .doc(dept)
      .collection('Notes')
      .doc(year)
      .collection(subject)
      .doc(documentSnapshot.id)
      .get();

  if (doc.exists) {
    await doc.reference.delete();
    await storageRef.child(dept).child(year).child(fileName).delete();
    Navigator.pop(context);
//    _scaffoldKey.currentState.showSnackBar(snackBar(context,
//        isErrorSnackbar: false,
//        successText: 'Email sent successfully'))
  } else {
    // Error
    Navigator.pop(context);
  }
}

handleDeleteNotes(
    BuildContext parentContext, DocumentSnapshot documentSnapshot) {
  return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(title: Text("Delete this note"), children: <Widget>[
          SimpleDialogOption(
            onPressed: () => {deleteNotes(context, documentSnapshot)},
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
          SimpleDialogOption(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          )
        ]);
      });
}
