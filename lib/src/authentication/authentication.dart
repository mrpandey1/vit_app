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
    var user = _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  @override
  Future<String> signIn(String email, String password) async {
    var user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    return user.emailVerified ? user.uid : null;
  }

  @override
  Future<String> signUp(String email, String password) async {
    var user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    await userRef.doc(user.uid).set({
      'id': user.uid,
      'email': user.email,
      'admin': false,
      'timestamp': DateTime.now(),
      'DisplayName':
          '${user.email.split('@')[0].split('.')[0]} ${user.email.split('@')[0].split('.')[1]}'
    });

    return user.uid;
  }

  @override
  Future<bool> isEmailVerified() async {
    var user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future sendPasswordResetLink(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
