import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/Shared/snackbar.dart';
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
  List departments = ['All', 'INFT', 'EXTC'];
  List divisions = [
    'All',
    'A',
    'B',
  ];
  List years = ['All', 'First', 'Second', 'Third', 'Fourth'];

  List lDepartments = ['INFT'];
  List lDivisions = [
    'A',
    'B',
  ];
  List lYears = ['First', 'Second', 'Third', 'Fourth'];

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

    try {
      String mediaUrl = '';
      if (widget.file != null) {
        mediaUrl = await uploadImage(widget.file);
      }

      Map<String, dynamic> data = {
        'postId': postId,
        'ownerId': currentUser.id,
        'from': widget.fromText,
        'mediaUrl': mediaUrl,
        'notice': widget.noticeText,
        'timestamp': DateTime.now(),
        'toDepartment': departmentValue,
        'toDivision': divisionValue,
        'toYear': yearValue
      };

      if (departmentValue == 'All' &&
          divisionValue == 'All' &&
          yearValue == 'All') {
        lDepartments.forEach((dept) {
          lDivisions.forEach((div) {
            lYears.forEach((year) async {
              await timelineRef
                  .doc(dept + div + year)
                  .collection('timelinePosts')
                  .doc(postId)
                  .set(data);
            });
          });
        });
      } else if (departmentValue == 'All' &&
          divisionValue != 'All' &&
          yearValue != 'All') {
        lDepartments.forEach((dept) async {
          await timelineRef
              .doc(dept + divisionValue + yearValue)
              .collection('timelinePosts')
              .doc(postId)
              .set(data);
        });
      } else if (departmentValue == 'All' &&
          divisionValue == 'All' &&
          yearValue != 'all') {
        lDepartments.forEach((dept) {
          lDivisions.forEach((div) async {
            await timelineRef
                .doc(dept + div + yearValue)
                .collection('timelinePosts')
                .doc(postId)
                .set(data);
          });
        });
      } else if (departmentValue != 'All' &&
          divisionValue == 'All' &&
          yearValue != 'All') {
        lDivisions.forEach((div) async {
          await timelineRef
              .doc(departmentValue + div + yearValue)
              .collection('timelinePosts')
              .doc(postId)
              .set(data);
        });
      } else if (departmentValue != 'All' &&
          divisionValue == 'All' &&
          yearValue == 'All') {
        lDivisions.forEach((div) {
          lYears.forEach((year) async {
            await timelineRef
                .doc(departmentValue + div + year)
                .collection('timelinePosts')
                .doc(postId)
                .set(data);
          });
        });
      } else if (departmentValue != 'All' &&
          divisionValue != 'All' &&
          yearValue == 'All') {
        lYears.forEach((year) async {
          await timelineRef
              .doc(departmentValue + divisionValue + year)
              .collection('timelinePosts')
              .doc(postId)
              .set(data);
        });
      } else if (departmentValue == 'All' &&
          divisionValue != 'All' &&
          yearValue == 'All') {
        lDepartments.forEach((dept) {
          lYears.forEach((year) async {
            await timelineRef
                .doc(dept + divisionValue + year)
                .collection('timelinePosts')
                .doc(postId)
                .set(data);
          });
        });
      } else {
        await timelineRef
            .doc(departmentValue + divisionValue + yearValue)
            .collection('timelinePosts')
            .doc(postId)
            .set(data);
      }

      await postRef
          .doc(departmentValue)
          .collection(yearValue + divisionValue)
          .doc(postId)
          .set(data);

      _scaffoldKey.currentState.showSnackBar(snackBar(context,
          isErrorSnackbar: false, successText: 'Notice sent Successfully'));
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(snackBar(context,
          isErrorSnackbar: true, errorText: 'Something went wrong'));
    }

    setState(() {
      _loading = false;
    });
  }
}
