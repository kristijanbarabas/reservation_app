import 'package:flutter/material.dart';
import 'package:reservation_app/custom_widgets/rounded_button.dart';
import 'package:reservation_app/services/constants.dart';
import 'package:reservation_app/screens/login_screen.dart';
import 'package:reservation_app/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
            // Logo
            Hero(
              tag: 'logo',
              child: Image.asset(kLogoPath),
            ),
            const SizedBox(
              height: 68.0,
            ),
            // Login button
            CustomRoundedButton(
                textStyle: kGoogleFonts,
                iconData: Icons.login,
                title: kLoginTitle,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
            // Register button
            CustomRoundedButton(
              textStyle: kGoogleFonts,
              iconData: Icons.app_registration_rounded,
              title: kRegisterTitle,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
