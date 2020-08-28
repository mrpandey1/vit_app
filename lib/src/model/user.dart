import 'package:cloud_firestore/cloud_firestore.dart';

class VITUser {
  final String id;
  final String displayName;
  final String email;
  final bool admin;
  final bool isRegistered;
  final String rollNumber;

  VITUser({
    this.id,
    this.displayName,
    this.email,
    this.admin,
    this.isRegistered,
    this.rollNumber,
  });

  // Named Constructor
  factory VITUser.fromDocument(DocumentSnapshot doc) {
    return VITUser(
      id: doc.data()['id'],
      displayName: doc.data()['displayName'],
      email: doc.data()['email'],
      admin: doc.data()['admin'],
      isRegistered: doc.data()['isRegistered'],
      rollNumber: doc.data()['rollNumber'],
    );
  }
}
