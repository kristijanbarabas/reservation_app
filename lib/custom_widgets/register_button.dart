import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_app/custom_widgets/rounded_button.dart';
import 'package:reservation_app/services/authentication.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:reservation_app/services/firestore_path.dart';
import '../routing/app_router.dart';
import '../services/constants.dart';

class RegisterButton extends ConsumerWidget {
  final String? email;
  final String? password;
  final String? username;
  const RegisterButton(
      {super.key,
      required this.email,
      required this.password,
      required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerNewUser = ref.watch(authenticationFunctionsProvider);

    return CustomRoundedButton(
      textStyle: kGoogleFonts,
      iconData: Icons.app_registration_rounded,
      title: kRegisterTitle,
      onPressed: () => registerNewUser!.registerNewUser(
          email: email,
          password: password,
          username: username,
          context: context),
    );
  }
}