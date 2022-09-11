import 'package:flutter/material.dart';
import 'package:reservation_app/constants.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  final String username;
  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Username: ${widget.username}',
              style: kGoogleFonts,
            )
          ],
        ),
      ),
    );
  }
}
