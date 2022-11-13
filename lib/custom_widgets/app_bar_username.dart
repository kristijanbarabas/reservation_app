import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/empty_placeholder_widget.dart';
import 'package:reservation_app/services/constants.dart';
import '../services/firestore_database.dart';

class AppBarUsernameWidget extends StatelessWidget {
  const AppBarUsernameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return Consumer(builder: (context, ref, child) {
      final userProfileAsyncValue =
          ref.watch(userProfileProvider(firebaseAuth.currentUser?.uid));
      return userProfileAsyncValue.when(
          data: (userProfile) {
            return userProfile.username == null
                ? const Text('Welcome!')
                : Text(
                    'Welcome ${userProfile.username}!',
                    style: kMainMenuFonts,
                  );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) {
            return const EmptyPlaceholderWidget();
          });
    });
  }
}
