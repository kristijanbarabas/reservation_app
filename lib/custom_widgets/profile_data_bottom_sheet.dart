import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/async_value_widget.dart';
import 'package:reservation_app/custom_widgets/rounded_button.dart';
import 'package:reservation_app/custom_widgets/text_form_field_widget.dart';
import 'package:reservation_app/models/user_profile.dart';
import 'package:reservation_app/services/authentication.dart';
import '../services/constants.dart';
import '../services/firestore_database.dart';

class ProfileDataBottomSheet extends StatelessWidget {
  const ProfileDataBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      final database = ref.watch(databaseProvider);
      final loggedInUserUid = ref.watch(loggedInUserUidProvider);
      final userProfileAsyncValue =
          ref.watch(userProfileProvider(loggedInUserUid));
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
                  mainAxisSize: MainAxisSize.min,
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
                      initialValue: userProfile.firstName == null
                          ? 'Add a firstname...'
                          : userProfile.firstName!,
                      newValue: (value) {
                        userProfile.firstName = value!;
                      },
                    ),
                    CustomTextFormFieldWidget(
                      initialValue: userProfile.lastName == null
                          ? 'Add a lastname...'
                          : userProfile.lastName!,
                      newValue: (value) {
                        userProfile.lastName = value!;
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
                          database!.updateProfile(
                              firstName: userProfile.firstName,
                              lastName: userProfile.lastName,
                              userPhoneNumber: userProfile.userPhoneNumber);
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
