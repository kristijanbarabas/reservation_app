import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
        for (var documentSnapshot in snapshot.docs) {
          setState(() {
            fireProfile = documentSnapshot.data() as Map<String, dynamic>;
            username = fireProfile['username'];
          });
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  late String imageUrl = '';

  getProfileImage() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('${loggedInUser.uid}/profilepicture.jpg');
      String url = await ref.getDownloadURL();
      setState(
        () {
          imageUrl = url;
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // PROFILE DATA
  late Map<String, dynamic> fireProfile = {};
  late String username = fireProfile['username'];
  late String? phoneNumber = fireProfile['userPhoneNumber'];
  late Map<String, dynamic> firebaseData = {};

  void deleteExpiredReservation(String bookingStart) async {
    DateTime expiredDate = DateTime.parse(bookingStart);
    if (expiredDate.isBefore(DateTime.now()) == true) {
      final docRef = _firestore
          .collection('user')
          .doc('reservation')
          .collection('reservation')
          .where('bookingStart', isEqualTo: bookingStart)
          .get();
      await docRef.then(
        (querySnapshot) {
          for (var doc in querySnapshot.docs) {
            final docRef = doc.reference.delete();
            print(docRef);
          }
        },
      );
    }
  }

  getDataAndDeleteExpiredReservation() async {
    final docRef = _firestore
        .collection('user')
        .doc('reservation')
        .collection('reservation')
        .get();
    await docRef.then(
      (QuerySnapshot snapshot) {
        for (var documentSnapshot in snapshot.docs) {
          setState(
            () {
              firebaseData = documentSnapshot.data() as Map<String, dynamic>;
              String bookingStart = firebaseData['bookingStart'];
              deleteExpiredReservation(bookingStart);
            },
          );
        }
        isLoading = false;
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  //State class
  int _pageIndex = 0;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

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
    MainMenu(
      userID: loggedInUser.uid,
      imageUrl: imageUrl,
    ),
    const CustomBookingCalendar(),
    ProfileScreen(
      imageUrl: imageUrl,
      email: loggedInUser.email!,
      username: username,
      phoneNumber: loggedInUser.phoneNumber ?? phoneNumber,
    ),
  ];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getProfile();
    getProfileImage();
    getDataAndDeleteExpiredReservation();
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
              key: bottomNavigationKey,
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
