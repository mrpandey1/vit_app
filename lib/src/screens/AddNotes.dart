import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:path/path.dart' as path;
import 'package:vit_app/src/Shared/loading.dart';
import 'HomePage.dart';

import '../constants.dart';

class AddNotes extends StatefulWidget {
  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';

  List subjects = [];
  bool _loading = false;
  bool foo = false;

  List departments = ['All', 'INFT'];
  List divisions = [
    'All',
    'A',
    'B',
  ];
  List years = ['All', 'First', 'Second', 'Third', 'Fourth'];
  String departmentValue;
  String yearValue;
  String subjectValue;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _fromController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: header(
          context,
          isAppTitle: false,
          titleText: 'Add Notes',
          isCenterTitle: true,
          bold: true,
        ),
        body: ListView(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  color: _loading
                      ? Colors.black12.withOpacity(0.1)
                      : Colors.black12.withOpacity(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50.0,
                        width: 250.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(5.0),
                          elevation: 2.0,
                          color: kPrimaryColor,
                          child: InkWell(
                            onTap: () => {selectFile(context)},
                            child: Center(
                              child: Text(
                                'Select Document',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      fileName.isNotEmpty
                          ? Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'File Selected',
                                    style: TextStyle(),
                                  ),
                                  Text(
                                    ' $fileName',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      SizedBox(height: 50.0),
                      getDropDown(
                          hintText: 'Select Department',
                          type: 'department',
                          valueMap: departments),
                      SizedBox(height: 20.0),
                      getDropDown(
                          hintText: 'Select Year',
                          type: 'year',
                          valueMap: years),
                      SizedBox(height: 20.0),
                      getDropDown(
                          hintText: 'Select Subject',
                          type: 'subject',
                          valueMap: subjects),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 15.0, right: 15.0),
                        child: TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          controller: _fromController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'ex. David Assistant Professor',
                            labelText: 'From:',
                          ),
                          validator: (value) =>
                              value.isEmpty ? 'This Field is required' : null,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Container(
                        height: 50.0,
                        width: 250.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(5.0),
                          elevation: 2.0,
                          color: kPrimaryColor,
                          child: InkWell(
                            onTap: () => {
                              if (_formKey.currentState.validate())
                                {uploadFile()}
                            },
                            child: Center(
                              child: Text(
                                'Upload Notes',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
                _loading
                    ? Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: loadingScreen(),
                        ),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      ),
              ],
            ),
          ],
        ),
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
              switch (type) {
                case 'department':
                  {
                    departmentValue = value;
                    setState(() {
                      foo = true;
                    });
                    break;
                  }

                case 'year':
                  {
                    yearValue = value;
                    fetchSubjects(yearValue);
                    break;
                  }

                case 'subject':
                  {
                    subjectValue = value;
                    break;
                  }
              }
            });
          },
          validator: (value) => value == null ? 'This field is required' : null,
          items: type == 'department' || foo
              ? valueMap.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      '$value',
                    ),
                  );
                }).toList()
              : null,
        ));
  }

  Future selectFile(BuildContext parentContext) async {
    try {
      file = await FilePicker.getFile(
          type: FileType.custom, allowedExtensions: ['pdf']);

      setState(() {
        fileName = path.basename(file.path);
      });

      print(fileName);
    } on PlatformException catch (e) {
      showDialog(
          context: parentContext,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> fetchSubjects(String yearValue) async {
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

  Future<void> uploadFile() async {
    if (file == null) {
      SnackBar snackBar = SnackBar(
        content: Text('Please select the file!'),
        backgroundColor: Colors.red,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }

    setState(() {
      _loading = true;
    });

    StorageReference storageReference =
        storageRef.child(departmentValue).child(yearValue).child(fileName);

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

//    /notes/INFT/Notes/First/ADBMS/p7TEFLqfwdJI30HpbUz3

    await notesRef
        .doc(departmentValue)
        .collection('Notes')
        .doc(yearValue)
        .collection(subjectValue)
        .doc()
        .set({
      'downloadUrl': url,
      'from': _fromController.text,
      'subject': subjectValue,
      'fileName': fileName,
      'timestamp': DateTime.now(),
    });

    setState(() {
      _loading = false;
    });

    SnackBar snackBar = SnackBar(
      content: Text('File Uploaded Successfully'),
      backgroundColor: Colors.green,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
