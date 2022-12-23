import 'package:flutter/material.dart';
import 'package:reservation_app/custom_widgets/profile_user_data.dart';
import 'package:reservation_app/services/constants.dart';
import '../custom_widgets/delete_user_account.dart';
import '../custom_widgets/profile_data_bottom_sheet.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile_screen';

  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        floatingActionButton: const DeleteUserAccountAndData(),
        appBar: AppBar(
          backgroundColor: kButtonColor,
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: const ProfileDataBottomSheet(),
                    );
                  },
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.edit),
              ),
            ),
          ],
          title: Text(
            'Profile',
            style: kGoogleFonts.copyWith(fontSize: 30),
          ),
        ),
        body: const ProfileUserData());
  }
}
