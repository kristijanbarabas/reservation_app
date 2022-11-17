import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/rounded_button.dart';
import 'package:reservation_app/services/authentication.dart';
import '../services/constants.dart';

class SignInButton extends ConsumerWidget {
  final String? email;
  final String? password;
  const SignInButton({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customSignInWithEmailAndPassword =
        ref.watch(authenticationFunctionsProvider);

    return CustomRoundedButton(
      iconData: Icons.login,
      textStyle: kGoogleFonts,
      title: kLoginTitle,
      onPressed: () => customSignInWithEmailAndPassword!
          .customSignInWithEmailAndPassword(
              email: email, password: password, context: context),
    );
  }
}
