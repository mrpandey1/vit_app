import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vit_app/src/shared/header.dart';
import 'package:path/path.dart' as path;

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: header(
          context,
          isAppTitle: false,
          titleText: 'Add Notes',
          isCenterTitle: true,
          bold: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20.0),
          alignment: Alignment.center,
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
                  hintText: 'Select Division',
                  type: 'division',
                  valueMap: divisions),
              SizedBox(height: 20.0),
              getDropDown(
                  hintText: 'Select Year', type: 'year', valueMap: years),
              SizedBox(height: 20.0),
              Container(
                height: 50.0,
                width: 250.0,
                child: Material(
                  borderRadius: BorderRadius.circular(5.0),
                  elevation: 2.0,
                  color: kPrimaryColor,
                  child: InkWell(
                    onTap: () => {
                      if (_formKey.currentState.validate()) {print('all good')}
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
            ],
          ),
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
}
