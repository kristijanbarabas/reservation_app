import 'package:flutter/material.dart';

import 'package:reservation_app/screens/main_menu_screen.dart';

import 'package:reservation_app/screens/welcome_screen.dart';
import '../components/rounded_button.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // email and password variables
  late String email;
  late String password;
  // firebase auth
  final _auth = FirebaseAuth.instance;

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
          kLoginTitle,
          style: kGoogleFonts,
        ),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
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
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password...')),
            const SizedBox(
              height: 24.0,
            ),
            // LOGIN BUTTON
            RoundedButton(
              iconData: Icons.login,
              googleFonts: kGoogleFonts,
              color: kButtonColor,
              title: kLoginTitle,
              onPressed: () async {
                try {
                  final existingUser = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (existingUser != null) {
                    Navigator.pushNamed(context, MainMenu.id);
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
