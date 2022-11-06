import 'package:flutter/material.dart';
import 'package:reservation_app/screens/home.dart';
import 'package:reservation_app/screens/welcome_screen.dart';

import '../custom_widgets/rounded_button.dart';
import '../services/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:reservation_app/custom_widgets/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Firebase auth
  final _auth = FirebaseAuth.instance;
  // email and password variables
  late String email;
  late String password;

  void navigatorPushToHomePage() {
    Navigator.pushNamed(context, HomeScreen.id);
  }

  void customSignInWithEmailAndPassword() async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      navigatorPushToHomePage();
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
          kLoginTitle,
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
              height: 54.0,
            ),
            // Email input
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
            // Password input
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
              height: 24.0,
            ),
            // Sign in button
            CustomRoundedButton(
              iconData: Icons.login,
              textStyle: kGoogleFonts,
              title: kLoginTitle,
              onPressed: customSignInWithEmailAndPassword,
            ),
            const SizedBox(
              height: 24.0,
            ),
            Center(
              child: Text(
                'Sign in with Google:',
                style: kGoogleLoginStyle,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // Google login button
            const CustomGoogleSignInButton(),
          ],
        ),
      ),
    );
  }
}
