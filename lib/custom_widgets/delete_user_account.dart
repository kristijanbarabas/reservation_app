import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_app/services/firestore_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../routing/app_router.dart';
import '../services/constants.dart';

class DeleteUserAccountAndData extends ConsumerWidget {
  const DeleteUserAccountAndData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);

    return FloatingActionButton(
      onPressed: () {
        //Delete user account
        Alert(
          context: context,
          type: AlertType.error,
          title: "DELETE ACCOUNT?",
          desc: "Are you sure you want to delete your account?",
          buttons: [
            DialogButton(
              onPressed: () {
                database!.deleteAllUserDataAndReservations();
                context.pushNamed(AppRoutes.welcome.name);
              },
              color: kButtonColor,
              child: const Text(
                "YES",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: kButtonColor,
              child: const Text(
                "NO",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      },
      backgroundColor: kButtonColor,
      child: const FaIcon(FontAwesomeIcons.userSlash),
    );
  }
}
