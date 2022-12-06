import 'package:flutter/material.dart';
import 'package:reservation_app/custom_widgets/app_bar_username.dart';
import 'package:reservation_app/custom_widgets/reservation_list.dart';
import 'package:reservation_app/custom_widgets/sign_out_button.dart';
import 'package:reservation_app/services/constants.dart';
import '../custom_widgets/app_bar_profile_picture.dart';

class MainMenu extends StatelessWidget {
  static const String id = 'menu_screen';

  const MainMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kButtonColor,
        leading: const CircleAvatar(
            backgroundColor: kButtonColor,
            radius: 100.0,
            // Profile picture
            child: AppBarProfilePictureWidget()),
        // Username
        title: const AppBarUsernameWidget(),
        actions: const [
          // Signout button
          SignOutButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: (() => showAboutDialog(context: context)),
                  child: Text(
                    kReservationsTitle,
                    style: kMainMenuFonts.copyWith(fontSize: 30.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 3,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0)),
                  // User reservations list
                  child: const ReservationList()),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
