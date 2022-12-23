import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/custom_widgets/loading_widget.dart';
import 'package:reservation_app/screens/about.dart';
import 'package:reservation_app/services/constants.dart';
import 'package:reservation_app/screens/main_menu_screen.dart';
import 'package:reservation_app/screens/profile_screen.dart';
import 'package:reservation_app/services/firestore_path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'booking_calendar.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const LoadingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLoading = true;

  // TODO add path and refactor code
  void deleteExpiredReservation(String bookingStart) async {
    DateTime expiredDate = DateTime.parse(bookingStart);
    if (expiredDate.isBefore(DateTime.now()) == true) {
      final docRef =
          FirestorePath.deleteExpiredReservationPath(bookingStart).get();
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
    final docRef = FirestorePath.userReservationsPath().get();
    await docRef.then(
      (QuerySnapshot snapshot) {
        for (var documentSnapshot in snapshot.docs) {
          setState(
            () {
              late Map<String, dynamic> firebaseData =
                  documentSnapshot.data() as Map<String, dynamic>;
              late String bookingStart = firebaseData['bookingStart'];
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
      FontAwesomeIcons.calendarPlus,
      size: 30,
      color: Colors.white,
    ),
    const Icon(
      FontAwesomeIcons.locationCrosshairs,
      size: 30,
      color: Colors.white,
    ),
    const Icon(
      FontAwesomeIcons.person,
      size: 30,
      color: Colors.white,
    ),
  ];

  late List<Widget> screens = [
    const MainMenu(),
    const CustomBookingCalendar(),
    const About(),
    const ProfileScreen(),
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
