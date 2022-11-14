import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/custom_widgets/async_value_widget.dart';
import 'package:reservation_app/custom_widgets/pick_image_widget.dart';
import 'package:reservation_app/models/user_profile.dart';
import 'package:reservation_app/services/constants.dart';
import '../services/firestore_database.dart';
import 'profile_picture_widget.dart';

class ProfileUserData extends StatelessWidget {
  const ProfileUserData({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Consumer(builder: (context, ref, child) {
      final userProfileAsyncValue =
          ref.watch(userProfileProvider(auth.currentUser?.uid));
      return AsyncValueWidget<UserProfile>(
        value: userProfileAsyncValue,
        data: (userProfile) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: kButtonColor,
                      radius: 100.0,
                      child: userProfile.userProfilePicture == null
                          ? const FaIcon(FontAwesomeIcons.faceGrin,
                              size: 100, color: Colors.white)
                          : ProfilePictureWidget(
                              profilePicture: userProfile.userProfilePicture!,
                              imageHeight: 200,
                              imageWidth: 200,
                            ),
                    ),
                    // Pick image from gallery or camera
                    const PickImageWidget(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    userProfile.username == null
                        ? 'Add a username number...'
                        : userProfile.username!,
                    style: kMainMenuFonts,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    userProfile.userPhoneNumber == null
                        ? 'Add a phone number...'
                        : userProfile.userPhoneNumber!,
                    style: kMainMenuFonts,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    auth.currentUser!.email!,
                    style: kMainMenuFonts,
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}
