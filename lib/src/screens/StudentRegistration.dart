import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/screens/HomePage.dart';

class StudentRegistration extends StatefulWidget {
  @override
  _StudentRegistrationState createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  List admissionYear = [16, 17, 18, 19, 20];
  List departments = ['INFT'];
  List divisions = ['A', 'B'];

  var deptMap = <String, int>{
    'INFT': 101,
  };

  int admissionYearValue;
  String departmentValue;
  String divisionValue;
  String roll = '';

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController rollNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Form(
        key: _formKey,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('VIT App'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    children: [
                      getDropDown(
                          hintText: 'Select Admission Year',
                          type: 'admissionYear',
                          valueMap: admissionYear),
                      SizedBox(height: 20.0),
                      getDropDown(
                          hintText: 'Select Your Department',
                          type: 'department',
                          valueMap: departments),
                      SizedBox(height: 20.0),
                      getDropDown(
                          hintText: 'Select Your Division',
                          type: 'division',
                          valueMap: divisions),
                      SizedBox(height: 20.0),
                      Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          onChanged: setRollNumber,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          controller: rollNumberController,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Roll Number ex: 0078',
                            labelText: 'Roll number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value.length != 4 ? 'Invalid roll number' : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    child: Text(
                      'Your Roll Number',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: Text(
                      '${admissionYearValue != null ? admissionYearValue : ''} ${deptMap[departmentValue] != null ? deptMap[departmentValue] : ''} ${divisionValue != null ? divisionValue : ''} $roll',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Container(
                    height: 40.0,
                    width: 250.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(5.0),
                      elevation: 2.0,
                      color: kPrimaryColor,
                      child: InkWell(
                        onTap: () => {
                          if (_formKey.currentState.validate()) {registerUser()}
                        },
                        child: Center(
                          child: Text(
                            'Confirm ',
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setRollNumber(value) {
    setState(() {
      roll = value;
    });
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
              case 'admissionYear':
                {
                  admissionYearValue = value;
                  break;
                }

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

  Future<void> registerUser() async {
    SnackBar failureSnackBar = SnackBar(
      content: Text('Roll number is already registered!'),
      backgroundColor: Colors.red,
    );
    SnackBar successSnackBar = SnackBar(
      content: Text('Registration Completed Successfully'),
      backgroundColor: Colors.green,
    );

    QuerySnapshot querySnapshot =
        await userRef.where('rollNumber', isEqualTo: roll).get();

    int foo = querySnapshot.docs.length;

    if (foo > 0) {
      // ----------- IF ROLL NUMBER IS ALREADY IN USE ------------
      _scaffoldKey.currentState.showSnackBar(failureSnackBar);
    } else {
      await userRef.doc(currentUser.id).update({
        'isRegistered': true,
        'rollNumber':
            '$admissionYearValue${deptMap[departmentValue]}$divisionValue$roll',
      });
      _scaffoldKey.currentState.showSnackBar(successSnackBar);
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    }
  }

  Future<bool> _onBackPressed() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Student Registration Warning',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text('Please fill the details to register yourself'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
