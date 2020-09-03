import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userRef = FirebaseFirestore.instance.collection('users');

abstract class AuthFunc {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<User> getCurrentUser();
  Future<void> signOut();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
  Future sendPasswordResetLink(String email);
}

class MyAuth implements AuthFunc {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<void> sendEmailVerification() {
    final user = _firebaseAuth.currentUser;
    return user.sendEmailVerification();
  }

  @override
  Future<String> signIn(String email, String password) async {
    try {
      var user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return user.emailVerified ? user.uid : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> signUp(String email, String password) async {
    try {
      var user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      await userRef.doc(user.uid).set({
        'id': user.uid,
        'email': user.email,
        'admin': false,
        'isRegistered': false,
        'timestamp': DateTime.now(),
        'displayName':
            '${user.email.split('@')[0].split('.')[0]} ${user.email.split('@')[0].split('.')[1]}',
        'rollNumber': '',
        'dept': '',
        'division': '',
        'year': ''
      });

      return user.uid;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    try {
      var user = _firebaseAuth.currentUser;
      return user.emailVerified;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signOut() {
    try {
      return _firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  @override
  Future sendPasswordResetLink(String email) {
    try {
      return _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return null;
    }
  }
}
