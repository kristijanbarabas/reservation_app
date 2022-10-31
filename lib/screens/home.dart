import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/custom_widgets/loading_widget.dart';
import 'package:reservation_app/services/constants.dart';
import 'package:reservation_app/screens/main_menu_screen.dart';
import 'package:reservation_app/screens/profile_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'booking_calendar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  //firestore instance
  final _firestore = FirebaseFirestore.instance;

  // PROFILE DATA
  late Map<String, dynamic> firebaseData = {};
  late Map<String, dynamic> fireProfile = {};
  late String? userProfilePicture = fireProfile['userProfilePicture'];
  late String? username;
  late String? userPhoneNumber = fireProfile['userPhoneNumber'];

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
            doc.reference.delete();
          }
        },
      );
    }
  }

  void getDataAndDeleteExpiredReservation() async {
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
              isLoading = false;
            },
          );
        }
      },
      onError: (e) =>
          Alert(context: context, title: "Error", desc: "Try again!").show(),
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
    MainMenu(),
    const CustomBookingCalendar(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    getDataAndDeleteExpiredReservation();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CustomLoadingWidget()
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
