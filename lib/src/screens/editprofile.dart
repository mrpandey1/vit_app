import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/screens/HomePage.dart';

import '../constants.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController rollNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: currentUser.displayName);
    rollNumberController =
        TextEditingController(text: currentUser.rollNumber.substring(6));
  }

  List admissionYear = [16, 17, 18, 19, 20];
  List departments = ['INFT'];
  List divisions = ['A', 'B'];

  var deptMap = <String, int>{
    'INFT': 101,
  };
  var deptMapRev = <int, String>{
    101: 'INFT',
  };

  int admissionYearValue = int.parse(currentUser.rollNumber.substring(0, 2));
  String divisionValue = currentUser.rollNumber.substring(5, 6);
  String roll = currentUser.rollNumber.substring(6);
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    String departmentValue =
        deptMapRev[int.parse(currentUser.rollNumber.substring(2, 5))];
    return Scaffold(
      appBar: header(context, titleText: currentUser.displayName),
      body: Form(
        key: _formKey,
        child: Scaffold(
          key: _scaffoldKey,
          body: ListView(
            children: <Widget>[
              //Image section
              Container(
                height: 200.0,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Stack(fit: StackFit.loose, children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              width: 140.0,
                              height: 140.0,
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://cdn2.iconfinder.com/data/icons/men-avatars/33/man_19-512.png',
                                placeholder: (context, url) => Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => print('hello'),
                          child: Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 25.0,
                                    child: new Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )),
                        )
                      ]),
                    )
                  ],
                ),
              ),
              //Name section
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: nameController,
                ),
              ),
              //Year of admission
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: DropdownButtonFormField(
                  hint: Text('Select Admission Year'),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      admissionYearValue = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'This field is required' : null,
                  value: admissionYearValue,
                  items: admissionYear.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        '$value',
                      ),
                    );
                  }).toList(),
                ),
              ),
              //Department
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: DropdownButtonFormField(
                  // hint: Text(
                  //     '${deptMapRev[int.parse(currentUser.rollNumber.substring(2, 5))]}'),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      departmentValue = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'This field is required' : null,
                  value: departmentValue,
                  items: departments.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        '$value',
                      ),
                    );
                  }).toList(),
                ),
              ),
              //Division
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: DropdownButtonFormField(
                  hint: Text('Select Your Division'),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      divisionValue = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'This field is required' : null,
                  value: divisionValue,
                  items: divisions.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        '$value',
                      ),
                    );
                  }).toList(),
                ),
              ),
              //rollno
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  onChanged: setRollNumber,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  controller: rollNumberController,
                  validator: (value) =>
                      value.length != 4 ? 'Invalid roll number' : null,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //confirm button
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: FlatButton(
                  onPressed: () => {
                    if (_formKey.currentState.validate()) {updateUserProfile()}
                  },
                  child: Text('Confirm'),
                  color: Colors.green,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Container(
                  child: Text(
                    'Your Roll Number',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    '${admissionYearValue != null ? admissionYearValue : ''} ${deptMap[departmentValue] != null ? deptMap[departmentValue] : ''} ${divisionValue != null ? divisionValue : ''} $roll',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUserProfile() async {
    SnackBar successSnackBar = SnackBar(
      content: Text('Updated Successfully'),
      backgroundColor: Colors.green,
    );
    SnackBar failureSnackBar = SnackBar(
      content: Text('Something went wrong please try again '),
      backgroundColor: Colors.green,
    );
    await userRef
        .doc(currentUser.id)
        .update({
          'rollNumber':
              '$admissionYearValue${deptMap['INFT']}$divisionValue$roll',
        })
        .then(
            (value) => _scaffoldKey.currentState.showSnackBar(successSnackBar))
        .catchError(
            (e) => {_scaffoldKey.currentState.showSnackBar(failureSnackBar)});
    Timer(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  void setRollNumber(value) {
    setState(() {
      roll = value;
    });
  }
}
