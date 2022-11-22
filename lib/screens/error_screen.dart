import 'package:flutter/material.dart';
import 'package:reservation_app/services/constants.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Error',
          style: kMainMenuFonts,
        ),
      ),
    );
  }
}
