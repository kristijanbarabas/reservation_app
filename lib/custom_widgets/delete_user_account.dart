import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/services/firestore_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../services/constants.dart';

class DeleteUserAccountAndData extends ConsumerWidget {
  const DeleteUserAccountAndData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
    final auth = FirebaseAuth.instance;

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
                auth.signOut().whenComplete(() => Navigator.pop(context));
              },
              color: kButtonColor,
              child: const Text(
                "YES",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            DialogButton(
              onPressed: () {
                //TODO navigator pop
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
