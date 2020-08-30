import 'package:cloud_firestore/cloud_firestore.dart';

class VITUser {
  final String id;
  final String displayName;
  final String email;
  final bool admin;
  final bool isRegistered;
  final String rollNumber;
  final String dept;
  final String year;
  final String division;

  VITUser(
      {this.id,
      this.displayName,
      this.email,
      this.admin,
      this.isRegistered,
      this.rollNumber,
      this.dept,
      this.division,
      this.year});

  // Named Constructor
  factory VITUser.fromDocument(DocumentSnapshot doc) {
    return VITUser(
      id: doc.data()['id'],
      displayName: doc.data()['displayName'],
      email: doc.data()['email'],
      admin: doc.data()['admin'],
      isRegistered: doc.data()['isRegistered'],
      rollNumber: doc.data()['rollNumber'],
      dept: doc.data()['dept'],
      division: doc.data()['division'],
      year: doc.data()['year'],
    );
  }
}
