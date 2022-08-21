import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    final docRef = _firestore
        .collection('reservation')
        .where('sender', isEqualTo: loggedInUser.email)
        .get();
    await docRef.then(
      (QuerySnapshot snapshot) {
        final data = snapshot.docs.forEach((DocumentSnapshot doc) {
          setState(() {
            fireData = doc.data() as Map<String, dynamic>;
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
            'timestamp': timestamp,
            'time': reservationTime,
            'sender': loggedInUser.email
          })
        });
  }

  void _printLatestValue1() {
    print('Second text field: ${_controller1.text}');
  }

  void _printLatestValue2() {
    print('Second text field: ${_controller2.text}');
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getData();
    _controller1.addListener(() {
      _printLatestValue1();
    });
    _controller2.addListener(() {
      _printLatestValue2();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _controller1.dispose();
    // This also removes the _printLatestValue listener.
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              _auth.signOut();
              Navigator.pushNamed(context, LoginScreen.id);
            },
            child: const Icon(Icons.clear),
          ),
        ],
        title: Text('Reservation Details'),
      ),
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFieldWidget(
                text: 'Last name: $name',
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
                      /* selectableDayPredicate: (DateTime day) =>
                        day.weekday == 6 || day.weekday == 7 ? false : true, */
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
              /* Text(
                'Reservation Date: ${reservationDate.day}.${reservationDate.month}.${reservationDate.year}',
                style: kReservationDetails,
              ), */
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
              /* Text(
                'Reservation Time: $reservationTime',
                style: kReservationDetails,
              ), */
// UPDATE BUTTON
              RoundedButton(
                  color: Colors.purple,
                  title: 'Change Reservation',
                  onPressed: () {
                    updateData();
                  }),

              // DELETE BUTTON
              RoundedButton(
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
