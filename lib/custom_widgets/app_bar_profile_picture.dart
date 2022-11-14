import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/custom_widgets/async_value_widget.dart';
import 'package:reservation_app/custom_widgets/profile_picture_widget.dart';
import 'package:reservation_app/models/user_profile.dart';
import 'package:reservation_app/services/firestore_database.dart';

class AppBarProfilePictureWidget extends StatelessWidget {
  const AppBarProfilePictureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    late Widget profilePictureWidget;
    return Consumer(
      builder: (context, ref, child) {
        final userProfileAsyncValue =
            ref.watch(userProfileProvider(firebaseAuth.currentUser?.uid));
        return AsyncValueWidget<UserProfile>(
          value: userProfileAsyncValue,
          data: (userProfile) {
            userProfile.userProfilePicture == null
                ? profilePictureWidget = const FaIcon(FontAwesomeIcons.faceGrin,
                    size: 40, color: Colors.white)
                : profilePictureWidget = ProfilePictureWidget(
                    profilePicture: userProfile.userProfilePicture!,
                    imageHeight: 50,
                    imageWidth: 50,
                  );
            return profilePictureWidget;
          },
        );
      },
    );
  }
}
