import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:reservation_app/services/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'firestore_database.dart';

class CustomAlerts {
  successAlertDialot({required BuildContext context}) {
    Alert(
      context: context,
      image: Lottie.asset('assets/success.json'),
      title: "SUCCESS!",
      desc: "Your reservation has been added.",
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  errorAlertDialog({required BuildContext context}) {
    Alert(
      context: context,
      image: Lottie.asset('assets/wrong.json'),
      title: "Something went wrong!",
      desc: "Try again!",
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  warningAlertDialog(
      {required BuildContext context, required VoidCallback function}) {
    Alert(
      context: context,
      image: Lottie.asset('assets/warning.json', height: 100, width: 100),
      title: "SIGN OUT!",
      desc: "Are you sure?",
      buttons: [
        DialogButton(
          onPressed: function,
          color: kButtonColor,
          child: const Text(
            "YES",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          onPressed: () => Navigator.pop(context),
          color: kButtonColor,
          child: const Text(
            "NO",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  deleteAlertDialog(
      {required BuildContext context, required VoidCallback function}) {
    Alert(
      context: context,
      image: Lottie.asset('assets/delete.json', height: 100, width: 100),
      title: "DELETE ACCOUNT?",
      desc: "Are you sure you want to delete your account?",
      buttons: [
        DialogButton(
          onPressed: function,
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
  }

  paperplaneAlertDialog({required BuildContext context}) {
    Alert(
            onWillPopActive: true,
            context: context,
            image: Lottie.asset('assets/paperplane.json'),
            style: const AlertStyle(isButtonVisible: false))
        .show();
  }
}

final customAlertsProvider = Provider.autoDispose<CustomAlerts?>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  if (auth.asData?.value?.uid != null) {
    return CustomAlerts();
  } else {
    return null;
  }
});
