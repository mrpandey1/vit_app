import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

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
            buildPostImage(kPdfImage),
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

Widget buildPostImage(String image) {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(
          imageUrl: image,
          height: 100.0,
          placeholder: (context, url) {
            return Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            );
          },
          fit: BoxFit.fill,
        ),
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
