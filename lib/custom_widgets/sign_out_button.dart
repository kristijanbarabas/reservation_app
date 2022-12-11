import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/services/alerts.dart';
import 'package:reservation_app/services/authentication.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((context, ref, child) {
        final authenticationFunctions =
            ref.watch(authenticationFunctionsProvider);
        final customAlerts = ref.watch(customAlertsProvider);
        return GestureDetector(
          onTap: () {
            customAlerts!.warningAlertDialog(
                context: context,
                function: () =>
                    authenticationFunctions!.signOutUser(context: context));
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 15.0, right: 10.0),
            child: FaIcon(FontAwesomeIcons.rightFromBracket),
          ),
        );
      }),
    );
  }
}
