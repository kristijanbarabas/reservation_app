import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../services/constants.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Authentication
    final auth = FirebaseAuth.instance;
    // Function to signout the user
    void signoutUser() {
      try {
        auth.signOut();
      } catch (e) {
        Alert(
            context: context,
            type: AlertType.error,
            title: 'Error',
            desc: 'Signout failed!');
      }
    }

    return GestureDetector(
      onTap: () {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "SIGN OUT!",
          desc: "Are you sure?",
          buttons: [
            DialogButton(
              onPressed: () {
                signoutUser();
                Navigator.pushNamed(context, WelcomeScreen.id);
              },
              color: kButtonColor,
              child: const Text(
                "YES",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            DialogButton(
              onPressed: () => Navigator.pop(context),
              color: kButtonColor,
              child: const Text(
                "NO",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      },
      child: const Padding(
        padding: EdgeInsets.only(top: 15.0, right: 10.0),
        child: FaIcon(FontAwesomeIcons.rightFromBracket),
      ),
    );
  }
}