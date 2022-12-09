import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_app/custom_widgets/sign_in_button.dart';
import 'package:reservation_app/routing/go_router.dart';
import '../services/constants.dart';
import 'package:reservation_app/custom_widgets/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final obscureTextProviderSignIn = StateProvider<bool>((ref) => false);

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
              textAlign: TextAlign.start,
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
            Consumer(
              builder: ((context, ref, child) {
                final passwordVisibility = ref.watch(obscureTextProviderSignIn);
                return TextField(
                  style: kTextFieldInputStyle,
                  obscureText: passwordVisibility,
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  decoration: kTextFieldPasswordDecoration.copyWith(
                      hintText: kHintTextPassword,
                      suffixIcon: IconButton(
                          onPressed: () {
                            ref
                                .read(obscureTextProviderSignIn.state)
                                .update((state) => !state);
                          },
                          icon: passwordVisibility == true
                              ? const Icon(
                                  FontAwesomeIcons.eyeSlash,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  FontAwesomeIcons.eye,
                                  color: Colors.white,
                                ))),
                );
              }),
            ),
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
