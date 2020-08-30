import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';
import 'package:vit_app/src/Shared/header.dart';

import '../constants.dart';
import 'HomePage.dart';

class SelectSendNoticeOptions extends StatefulWidget {
  final String noticeText;
  final String fromText;
  final File file;

  const SelectSendNoticeOptions(
      {Key key, this.noticeText, this.fromText, this.file})
      : super(key: key);

  @override
  _SelectSendNoticeOptionsState createState() =>
      _SelectSendNoticeOptionsState();
}

class _SelectSendNoticeOptionsState extends State<SelectSendNoticeOptions> {
  List departments = ['All', 'INFT'];
  List divisions = [
    'All',
    'A',
    'B',
  ];
  List years = ['All', 'First', 'Second', 'Third', 'Fourth'];

  String departmentValue;
  String divisionValue;
  String yearValue;

  bool _loading = false;
  String postId = Uuid().v4();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: header(
            context,
            isAppTitle: false,
            titleText: 'Select Options',
            isCenterTitle: true,
            bold: true,
          ),
          body: Container(
              height: MediaQuery.of(context).size.height,
              color: _loading
                  ? Colors.black12.withOpacity(0.1)
                  : Colors.black12.withOpacity(0),
              child: Stack(
                children: [
                  showBody(),
                  showCircularProgress(),
                ],
              )),
        ));
  }

  Widget showBody() {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            getDropDown(
                hintText: 'Select Department',
                type: 'department',
                valueMap: departments),
            SizedBox(height: 20.0),
            getDropDown(
                hintText: 'Select Division',
                type: 'division',
                valueMap: divisions),
            SizedBox(height: 20.0),
            getDropDown(hintText: 'Select Year', type: 'year', valueMap: years),
            SizedBox(height: 50.0),
            Container(
              height: 50.0,
              width: 250.0,
              child: Material(
                borderRadius: BorderRadius.circular(5.0),
                elevation: 2.0,
                color: kPrimaryColor,
                child: InkWell(
                  onTap: () => {
                    if (_formKey.currentState.validate()) {sendNotice()}
                  },
                  child: Center(
                    child: Text(
                      'Send Notice',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget showCircularProgress() {
    if (_loading) {
      return Container(
        child: Center(
          child: SpinKitFoldingCube(
            color: kPrimaryColor,
            duration: Duration(seconds: 2),
          ),
        ),
      );
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  // ------------- DROPDOWN LIST WIDGET ---------------
  Container getDropDown(
      {@required hintText, @required type, @required List<dynamic> valueMap}) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: DropdownButtonFormField(
        hint: Text('$hintText'),
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            switch (type) {
              case 'department':
                {
                  departmentValue = value;
                  break;
                }

              case 'division':
                {
                  divisionValue = value;
                  break;
                }

              case 'year':
                {
                  yearValue = value;
                }
            }
          });
        },
        validator: (value) => value == null ? 'This field is required' : null,
        items: valueMap.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(
              '$value',
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child('posts').child('post_$postId.jpg').putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> sendNotice() async {
    setState(() {
      _loading = true;
    });

    SnackBar failureSnackBar = SnackBar(
      content: Text('Notice Sent Failure!'),
      backgroundColor: Colors.red,
    );
    SnackBar successSnackBar = SnackBar(
      content: Text('Notice Sent Successfully'),
      backgroundColor: Colors.green,
    );

    String mediaUrl = '';

    if (widget.file != null) {
      mediaUrl = await uploadImage(widget.file);
    }

    // ------------ ADD CONDITION FOR "ALL" ----------------
    // add here

    // QuerySnapshot querySnapshot = await studentRef
    //     .doc(departmentValue)
    //     .collection(yearValue)
    //     .where('division', isEqualTo: divisionValue)
    //     .get();

    await timelineRef
        .doc(departmentValue + divisionValue + yearValue)
        .collection('timelinePosts')
        .doc(postId)
        .set({
      'postId': postId,
      'ownerId': currentUser.id,
      'from': widget.fromText,
      'mediaUrl': mediaUrl,
      'notice': widget.noticeText,
      'timestamp': DateTime.now(),
    });
    setState(() {
      _loading = false;
    });
    _scaffoldKey.currentState.showSnackBar(successSnackBar);
  }
}
