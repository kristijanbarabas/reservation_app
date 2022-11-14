import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/async_value_widget.dart';
import 'package:reservation_app/custom_widgets/rounded_button.dart';
import 'package:reservation_app/custom_widgets/text_form_field_widget.dart';
import 'package:reservation_app/models/user_profile.dart';

import '../services/constants.dart';
import '../services/firestore_database.dart';

class ProfileDataBottomSheet extends StatelessWidget {
  const ProfileDataBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    updateProfile(String? username, String? userPhoneNumber) async {
      final docRef = firestore
          .collection('user')
          .doc(auth.currentUser!.uid)
          .collection('profile')
          .doc(auth.currentUser!.uid);
      await docRef.set(
          {'username': username, 'userPhoneNumber': userPhoneNumber},
          SetOptions(merge: true));
    }

    return Consumer(builder: ((context, ref, child) {
      final userProfileAsyncValue =
          ref.watch(userProfileProvider(auth.currentUser?.uid));
      return AsyncValueWidget<UserProfile>(
        value: userProfileAsyncValue,
        data: (userProfile) {
          return Container(
            color: kModalSheetRadiusColor,
            child: Container(
              decoration: const BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              kEditProfile,
                              style: kMainMenuFonts,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 20,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.clear,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                    CustomTextFormFieldWidget(
                      initialValue: userProfile.username == null
                          ? 'Add a username...'
                          : userProfile.username!,
                      newValue: (value) {
                        userProfile.username = value!;
                      },
                    ),
                    CustomTextFormFieldWidget(
                      initialValue: userProfile.userPhoneNumber == null
                          ? 'Add a phone number...'
                          : userProfile.userPhoneNumber!,
                      newValue: (value) {
                        userProfile.userPhoneNumber = value!;
                      },
                    ),
                    CustomRoundedButton(
                        title: kSubmit,
                        onPressed: () {
                          updateProfile(userProfile.username,
                              userProfile.userPhoneNumber);
                          Navigator.pop(context);
                        },
                        textStyle: kMainMenuFonts,
                        iconData: Icons.done)
                  ],
                ),
              ),
            ),
          );
        },
      );
    }));
  }
}
