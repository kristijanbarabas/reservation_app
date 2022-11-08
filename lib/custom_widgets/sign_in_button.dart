import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/custom_widgets/rounded_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../screens/home.dart';
import '../services/constants.dart';

class SignInButton extends StatefulWidget {
  final String? email;
  final String? password;
  const SignInButton({super.key, required this.email, required this.password});

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  @override
  Widget build(BuildContext context) {
    void customSignInWithEmailAndPassword() async {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      try {
        await firebaseAuth
            .signInWithEmailAndPassword(
                email: widget.email!, password: widget.password!)
            .whenComplete(() => Navigator.pushNamed(context, HomeScreen.id));
      } catch (e) {
        Alert(context: context, title: "Error", desc: "Try again!").show();
      }
    }

    return CustomRoundedButton(
      iconData: Icons.login,
      textStyle: kGoogleFonts,
      title: kLoginTitle,
      onPressed: customSignInWithEmailAndPassword,
    );
  }
}
