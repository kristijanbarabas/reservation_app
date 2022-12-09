import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/rounded_button.dart';
import 'package:reservation_app/services/authentication.dart';
import '../services/constants.dart';

class RegisterButton extends ConsumerWidget {
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  const RegisterButton({
    super.key,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerNewUser = ref.watch(authenticationFunctionsProvider);

    return CustomRoundedButton(
      textStyle: kGoogleFonts,
      iconData: Icons.app_registration_rounded,
      title: kSignUp,
      onPressed: () => registerNewUser!.registerNewUser(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          context: context),
    );
  }
}
