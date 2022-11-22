import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_app/custom_widgets/sign_in_button.dart';
import 'package:reservation_app/routing/go_router.dart';
import '../services/constants.dart';
import 'package:reservation_app/custom_widgets/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // User data
  late String? email = '';
  late String? password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              GoRouter.of(context).pop();
            },
            child: const Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
        title: Text(
          kLoginTitle,
          style: kGoogleFonts,
        ),
        centerTitle: true,
        backgroundColor: kButtonColor,
      ), */
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Hero(
                tag: kHeroTag,
                child: SizedBox(
                  height: 200,
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
                setState(() {
                  email = value;
                });
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
                  setState(() {
                    password = value;
                  });
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: kHintTextPassword)),
            const SizedBox(
              height: 24.0,
            ),
            // Sign in button
            SignInButton(
              email: email,
              password: password,
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
            const GoogleSignInButton(),
            const SizedBox(
              height: 14,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: kGoogleLoginStyle,
                  ),
                  GestureDetector(
                      onTap: () => context.goNamed(AppRoutes.register.name),
                      child: Text(
                        ('$kSignUp!'),
                        style: kGoogleFonts.copyWith(
                          color: kButtonColor,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
