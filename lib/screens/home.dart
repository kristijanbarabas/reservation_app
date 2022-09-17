import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/constants.dart';
import 'package:reservation_app/screens/main_menu_screen.dart';
import 'package:reservation_app/screens/profile_screen.dart';

import '../components/booking_calendar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  // creating our user
  late User loggedInUser;
  //firestore instance
  final _firestore = FirebaseFirestore.instance;
  // authentification
  final _auth = FirebaseAuth.instance;
  // PROFILE DATA
  late Map<String, dynamic> fireProfile = {};
  late String username = fireProfile['username'];
  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  getProfile() async {
    isLoading = true;
    final docRef = _firestore
        .collection('user')
        .doc(loggedInUser.uid)
        .collection('profile')
        .get();
    await docRef.then(
      (QuerySnapshot snapshot) {
        final data = snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          setState(() {
            fireProfile = documentSnapshot.data() as Map<String, dynamic>;
            isLoading = false;
          });
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  //State class
  int _pageIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  List<Widget> bottomNavigationBarItems = [
    const Icon(
      Icons.home,
      size: 30,
      color: Colors.white,
    ),
    const Icon(
      Icons.add,
      size: 30,
      color: Colors.white,
    ),
    const FaIcon(
      FontAwesomeIcons.person,
      size: 30,
      color: Colors.white,
    ),
  ];

  late List<Widget> screens = [
    MainMenu(userID: loggedInUser.uid),
    const CustomBookingCalendar(),
    ProfileScreen(
      email: loggedInUser.email!,
      username: username,
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SpinKitChasingDots(
            color: Colors.black,
            duration: Duration(seconds: 3),
          )
        : Scaffold(
            backgroundColor: kBackgroundColor,
            body: screens[_pageIndex],
            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              color: kButtonColor,
              height: 60,
              backgroundColor:
                  _pageIndex == 1 ? Colors.white : kBackgroundColor,
              items: bottomNavigationBarItems,
              onTap: (index) async {
                setState(() {
                  _pageIndex = index;
                });
              },
            ),
          );
  }
}
