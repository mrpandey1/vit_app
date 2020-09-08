import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/model/user.dart';
import 'package:vit_app/src/screens/Notessection.dart';
import 'package:vit_app/src/screens/Profile.dart';
import 'package:vit_app/src/screens/StudentRegistration.dart';
import 'package:vit_app/src/screens/Timeline.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final studentRef = FirebaseFirestore.instance.collection('students');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final postRef = FirebaseFirestore.instance.collection('posts');
final subjectsRef = FirebaseFirestore.instance.collection('subjects');
final notesRef = FirebaseFirestore.instance.collection('notes');
final departmentRef = FirebaseFirestore.instance.collection('departments');
final StorageReference storageRef = FirebaseStorage.instance.ref();

VITUser currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PageController pageController;
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userRef.doc(FirebaseAuth.instance.currentUser.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: SpinKitFoldingCube(
                color: kPrimaryColor,
                duration: Duration(seconds: 2),
              ),
            ),
          );
        }
        currentUser = VITUser.fromDocument(snapshot.data);
        return currentUser.isRegistered
            ? Scaffold(
                body: PageView(
                  children: <Widget>[TimeLine(), NotesSection(), ProfilePage()],
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  physics: NeverScrollableScrollPhysics(),
                ),
                bottomNavigationBar: CupertinoTabBar(
                  currentIndex: pageIndex,
                  onTap: onTap,
                  activeColor: kPrimaryColor,
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
                    BottomNavigationBarItem(icon: Icon(Icons.library_books)),
                    BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
                  ],
                ),
              )
            : Scaffold(
                body: StudentRegistration(),
              );
      },
    );
  }
}
