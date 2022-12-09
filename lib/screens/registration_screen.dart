import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_app/custom_widgets/register_button.dart';
import '../services/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // New user data
  late String? email = '';
  late String? password = '';
  late String? firstName = '';
  late String? lastName = '';
  final obscureTextProviderRegister = StateProvider<bool>((ref) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              GoRouter.of(context).pop();
            },
            child: const Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
        title: Text(
          kSignUp,
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
                tag: kHeroTag,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(kLogoPath),
                ),
              ),
            ),
            const SizedBox(
              height: 54.0,
            ),
            // EMAIL INPUT
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
            // PASSWORD INPUT
            Consumer(
              builder: ((context, ref, child) {
                bool passwordVisibility =
                    ref.watch(obscureTextProviderRegister);
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
                                .read(obscureTextProviderRegister.state)
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
              height: 8.0,
            ),
            TextField(
                style: kTextFieldInputStyle,
                textAlign: TextAlign.start,
                onChanged: (value) {
                  setState(() {
                    firstName = value;
                  });
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your firstname...')),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
                style: kTextFieldInputStyle,
                textAlign: TextAlign.start,
                onChanged: (value) {
                  setState(() {
                    lastName = value;
                  });
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your lastname...')),
            const SizedBox(
              height: 24.0,
            ),
            // REGISTER BUTTON
            RegisterButton(
              email: email,
              password: password,
              firstName: firstName,
              lastName: lastName,
            ),
          ],
        ),
      ),
    );
  }
}
