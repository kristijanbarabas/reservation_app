import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomAlerts {
  BuildContext context;
  CustomAlerts(this.context);
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
}
