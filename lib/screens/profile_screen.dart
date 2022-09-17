import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:reservation_app/components/rounded_button.dart';
import 'package:reservation_app/components/text_field_widget.dart';
import 'package:reservation_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;

late User loggedInUser;

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  late String username;
  final String email;

  ProfileScreen({Key? key, required this.username, required this.email})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
// authentification
  final _auth = FirebaseAuth.instance;
  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  updateProfile() async {
    final docRef = _firestore
        .collection('user')
        .doc(loggedInUser.uid)
        .collection('profile')
        .doc(loggedInUser.uid);
    await docRef.set({'username': widget.username}, SetOptions(merge: true));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
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
                              TextFieldWidget(
                                initialValue: widget.username,
                                newValue: (value) {
                                  widget.username = value!;
                                },
                              ),
                              RoundedButton(
                                  color: kButtonColor,
                                  title: kSubmit,
                                  onPressed: () {
                                    updateProfile();
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
              },
              child: const Icon(Icons.edit))
        ],
        backgroundColor: kBackgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: kGoogleFonts,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  backgroundColor: kButtonColor,
                  radius: 70.0,
                  child: FaIcon(FontAwesomeIcons.faceGrin,
                      size: 100, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.edit,
                        color: kBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                '${widget.username}',
                style: kMainMenuFonts,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                '${widget.email}',
                style: kMainMenuFonts,
              ),
            )
          ],
        ),
      ),
    );
  }
}
