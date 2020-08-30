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
  String departmentValue;
  String divisionValue = currentUser.rollNumber.substring(5, 6);
  String roll = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: currentUser.displayName),
      body: ListView(
        children: <Widget>[
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
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                image: NetworkImage(
                                    'https://cdn2.iconfinder.com/data/icons/men-avatars/33/man_19-512.png'),
                                fit: BoxFit.cover,
                              ),
                            )),
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
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: nameController,
            ),
          ),
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
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: DropdownButtonFormField(
              hint: Text(
                  '${deptMapRev[int.parse(currentUser.rollNumber.substring(2, 5))]}'),
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
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: FlatButton(
              onPressed: () => {},
              child: Text('Confirm'),
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }

  void setRollNumber(value) {
    setState(() {
      roll = value;
    });
  }
}
