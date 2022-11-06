import 'package:flutter/material.dart';
import 'package:reservation_app/screens/home.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../custom_widgets/rounded_button.dart';
import '../services/constants.dart';
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
  // New user data
  late String email;
  late String password;
  late String username;

  void registerNewUser() async {
    final auth = FirebaseAuth.instance;
    try {
      final newUser = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        _firestore
            .collection('user')
            .doc(newUser.user!.uid)
            .collection('profile')
            .doc(newUser.user!.uid)
            .set(
          {
            'username': username,
            'userPhoneNumber': 'Add phone number...',
          },
        ).whenComplete(() => Navigator.pushNamed(context, HomeScreen.id));
      }
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
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
                child: SizedBox(
                  height: 100,
                  child: Image.asset(kLogoPath),
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
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: kHintTextEmail),
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
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: kHintTextPassword)),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
                style: kTextFieldInputStyle,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  username = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: kHintTextUsername)),
            // REGISTER BUTTON
            CustomRoundedButton(
              textStyle: kGoogleFonts,
              iconData: Icons.app_registration_rounded,
              title: kRegisterTitle,
              onPressed: registerNewUser,
            ),
          ],
        ),
      ),
    );
  }
}
