import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/Shared/loading.dart';
import 'package:vit_app/src/animations/animatedPageRoute.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/model/user.dart';
import 'package:vit_app/src/screens/AdminFeatures.dart';
import 'package:vit_app/src/screens/AdmintimeLine.dart';
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
final StorageReference storageRef = FirebaseStorage.instance.ref();

VITUser currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PageController pageController;
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    userRef
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      currentUser = VITUser.fromDocument(documentSnapshot);
      if (!currentUser.isRegistered) {
        Navigator.push(context, BouncyPageRoute(widget: StudentRegistration()));
      } else {
        setState(() {
          _loading = false;
        });
      }
    });
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
    return _loading
        ? Scaffold(
            body: loadingScreen(),
          )
        : Scaffold(
            appBar: header(context, isAppTitle: true, isLogout: true),
            floatingActionButton: currentUser.admin
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    backgroundColor: kPrimaryColor,
                    onPressed: () => {
                      Navigator.push(
                          context, BouncyPageRoute(widget: AdminFeatures()))
                    },
                  )
                : null,
            body: PageView(
              children: <Widget>[
//                currentUser.admin ? AdmintimeLine() : TimeLine(),
                TimeLine(),
                NotesSection(),
                ProfilePage()
              ],
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
                BottomNavigationBarItem(icon: Icon(Icons.notifications)),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
              ],
            ),
          );
  }
}
