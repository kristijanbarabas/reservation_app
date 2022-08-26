import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:reservation_app/components/rounded_button.dart';
import 'package:reservation_app/constants.dart';
import 'package:reservation_app/screens/login_screen.dart';
import 'package:reservation_app/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String welcomeScreenTitle = 'STUDIO ASTRID';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
                tag: 'logo',
                child: Container(child: Image.asset('images/logo.png'))),
            const SizedBox(
              height: 68.0,
            ),

            // LOGIN BUTTON
            RoundedButton(
                iconData: Icons.login,
                color: kButtonColor,
                title: kLoginTitle,
                googleFonts: kGoogleFonts,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
            // REGISTER BUTTON
            RoundedButton(
                iconData: Icons.app_registration_rounded,
                color: kButtonColor,
                title: kRegisterTitle,
                googleFonts: kGoogleFonts,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                })
          ],
        ),
      ),
    );
  }
}
