import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/services/alerts.dart';
import 'package:reservation_app/services/firestore_database.dart';
import '../services/authentication.dart';
import '../services/constants.dart';

class DeleteUserAccountAndData extends ConsumerWidget {
  const DeleteUserAccountAndData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
    final authentication = ref.watch(authenticationFunctionsProvider);
    final customAlerts = ref.watch(customAlertsProvider);

    deleteUserData() {
      database!.deleteAllUserDataAndReservations();
      authentication!.signOutUser(context: context);
    }

    return FloatingActionButton(
      onPressed: () {
        customAlerts!
            .deleteAlertDialog(context: context, function: deleteUserData);
      },
      backgroundColor: kButtonColor,
      child: const FaIcon(FontAwesomeIcons.userSlash),
    );
  }
}
