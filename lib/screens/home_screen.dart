import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/async_value_widget.dart';
import 'package:reservation_app/screens/loading_screen.dart';
import 'package:reservation_app/screens/sign_in_screen.dart';
import 'package:reservation_app/services/firestore_database.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final watchUser = ref.watch(authStateChangesProvider);
      return AsyncValueWidget<User?>(
        value: watchUser,
        data: (user) {
          if (user == null) {
            return const LoginScreen();
          } else {
            return const LoadingScreen();
          }
        },
      );
    });
  }
}
