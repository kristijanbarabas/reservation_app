import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reservation_app/components/text_field_widget.dart';
import 'package:reservation_app/components/rounded_button.dart';
import 'package:reservation_app/constants.dart';
import 'package:reservation_app/screens/login_screen.dart';

final _firestore = FirebaseFirestore.instance;

late User loggedInUser;

class ReservationDetails extends StatefulWidget {
  static const String id = 'reservation_details';

  const ReservationDetails({Key? key}) : super(key: key);

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  // bool
  bool isLoading = true;
  // FORM DATA
  late String name = fireData['name'];
  late String lastName = fireData['lastname'];
  late Timestamp timestamp = fireData['timestamp'];
  late DateTime reservationDate = timestamp.toDate();
  late String reservationTime = fireData['time'];

  //firebase authentication
  final _auth = FirebaseAuth.instance;
  //text field editing controller
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  late Map<String, dynamic> fireData = {};

  getData() async {
    isLoading = true;
    final docRef = _firestore
        .collection('reservation')
        .where('sender', isEqualTo: loggedInUser.email)
        .get();
    await docRef.then(
      (QuerySnapshot snapshot) {
        final data = snapshot.docs.forEach((DocumentSnapshot doc) {
          setState(() {
            fireData = doc.data() as Map<String, dynamic>;
            isLoading = false;
          });
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  deleteData() async {
    final docRef = _firestore
        .collection('reservation')
        .where('sender', isEqualTo: loggedInUser.email)
        .get();
    await docRef
        .then((querySnapshot) => {querySnapshot.docs[0].reference.delete()});
  }

  updateData() async {
    final docRef = _firestore
        .collection('reservation')
        .where('sender', isEqualTo: loggedInUser.email)
        .get();
    await docRef.then((querySnapshot) => {
          querySnapshot.docs[0].reference.set({
            'name': name,
            'lastname': lastName,
            'timestamp': reservationDate,
            'time': reservationTime,
            'sender': loggedInUser.email
          })
        });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.

    _controller1.dispose();

    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
            child: Icon(Icons.arrow_back)),
        actions: [
          GestureDetector(
            onTap: () {
              _auth.signOut();
              Navigator.pushNamed(context, LoginScreen.id);
            },
            child: const Icon(Icons.clear),
          ),
        ],
        title: const Text('Reservation Details'),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const SpinKitChasingDots(
              color: Colors.black,
              duration: Duration(seconds: 3),
            )
          : Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFieldWidget(
                      text: 'Name: $name',
                      controller: _controller1,
                      newValue: (value) {
                        name = value!;
                      },
                    ),
                    TextFieldWidget(
                      text: 'Last name: $lastName',
                      controller: _controller2,
                      newValue: (value) {
                        lastName = value!;
                      },
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: reservationDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2023),
                            selectableDayPredicate: (DateTime day) =>
                                day.weekday == 6 || day.weekday == 7
                                    ? false
                                    : true,
                          );
                          setState(() {
                            reservationDate = newDate!;
                          });
                        },
                        child: Text(
                          'Date: ${reservationDate.day}/${reservationDate.month}/${reservationDate.year}',
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),

                    // RESERVATION TIME
                    DropdownButton(
                        value: reservationTime,
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: Colors.purple,
                        ),
                        elevation: 16,
                        style: const TextStyle(color: Colors.purple),
                        underline: Container(
                          color: Colors.transparent,
                        ),
                        items: dropdownButtonList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                                child: Text(
                              value,
                              style: const TextStyle(fontSize: 20.0),
                            )),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            reservationTime = newValue!;
                            print(reservationTime);
                          });
                        }),

// UPDATE BUTTON
                    RoundedButton(
                        googleFonts: kGoogleFonts,
                        color: Colors.purple,
                        title: 'Change Reservation',
                        onPressed: () {
                          updateData();
                          _controller1.clear();
                          _controller2.clear();
                        }),

                    // DELETE BUTTON
                    RoundedButton(
                        googleFonts: kGoogleFonts,
                        color: Colors.red,
                        title: 'Delete Reservation',
                        onPressed: () {
                          _controller1.clear();
                          _controller2.clear();
                          //deleteData();
                        })
                  ],
                ),
              ),
            ),
    );
  }
}
