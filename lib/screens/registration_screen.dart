import 'package:flutter/material.dart';
import 'package:reservation_app/screens/home.dart';
import 'package:reservation_app/screens/main_menu_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../components/rounded_button.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//firestore instance
final _firestore = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // email and password variables
  late String email;
  late String password;
  late String username;

  // firebase authentication
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, WelcomeScreen.id);
            },
            child: const Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
        title: Text(
          kRegisterTitle,
          style: kGoogleFonts,
        ),
        centerTitle: true,
        backgroundColor: kButtonColor,
      ),
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 100,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            const SizedBox(
              height: 78.0,
            ),
            // EMAIL INPUT
            TextField(
              style: kTextFieldInputStyle,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email...'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            // PASSWORD INPUT
            TextField(
                style: kTextFieldInputStyle,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password...')),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
                style: kTextFieldInputStyle,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  username = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your username...')),

            // REGISTER BUTTON
            RoundedButton(
              iconData: Icons.app_registration_rounded,
              googleFonts: kGoogleFonts,
              color: kButtonColor,
              title: kRegisterTitle,
              onPressed: () async {
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    // send the user to the reservation screen
                    _firestore
                        .collection('user')
                        .doc(newUser.user!.uid)
                        .collection('profile')
                        .add({
                      'username': username,
                    });
                    Navigator.pushNamed(context, HomeScreen.id);
                  }
                } catch (e) {
                  Alert(context: context, title: "Error", desc: "Try again!")
                      .show();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
