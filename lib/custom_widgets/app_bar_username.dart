import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/async_value_widget.dart';
import 'package:reservation_app/models/user_profile.dart';
import 'package:reservation_app/services/authentication.dart';
import 'package:reservation_app/services/constants.dart';
import '../services/firestore_database.dart';

class AppBarUsernameWidget extends StatelessWidget {
  const AppBarUsernameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final loggedInUserUid = ref.watch(loggedInUserUidProvider);
      final userProfileAsyncValue =
          ref.watch(userProfileProvider(loggedInUserUid));
      return AsyncValueWidget<UserProfile>(
        value: userProfileAsyncValue,
        data: (userProfile) {
          return userProfile.firstName == null
              ? const Text('Welcome!')
              : Text(
                  'Welcome ${userProfile.firstName}!',
                  style: kGoogleFonts.copyWith(fontSize: 30),
                );
        },
      );
    });
  }
}
