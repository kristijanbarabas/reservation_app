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
  final colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];
  String welcomeScreenTitle = 'STUDIO ASTRID';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        welcomeScreenTitle,
                        textStyle: kWelcomeScreenTitle,
                        colors: colorizeColors,
                        speed: const Duration(milliseconds: 300),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            // LOGIN BUTTON
            RoundedButton(
                color: Colors.red,
                title: kLoginTitle,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
            // REGISTER BUTTON
            RoundedButton(
                color: Colors.purple,
                title: kRegisterTitle,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                })
          ],
        ),
      ),
    );
  }
}
