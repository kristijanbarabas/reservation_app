import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/custom_widgets/pick_image_widget.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import 'package:reservation_app/custom_widgets/rounded_button.dart';
import 'package:reservation_app/custom_widgets/text_form_field_widget.dart';
import 'package:reservation_app/services/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservation_app/services/firestore_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../custom_widgets/profile_picture_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestore = FirebaseFirestore.instance;
  late User loggedInUser;
// authentification
  final _auth = FirebaseAuth.instance;
  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  deleteUser() {
    loggedInUser.delete();
  }

  deleteUserProfile() {
    _firestore
        .collection("user")
        .doc(loggedInUser.uid)
        .collection('profile')
        .doc(loggedInUser.uid)
        .delete();
  }

  deleteUserReservations() async {
    final docRef = _firestore
        .collection("user")
        .doc('reservation')
        .collection('reservation')
        .where('userId', isEqualTo: loggedInUser.uid)
        .get();
    await docRef.then(
      (querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            doc.reference.delete();
          },
        );
      },
    );
  }

  updateProfile(String? username, String? userPhoneNumber) async {
    final docRef = _firestore
        .collection('user')
        .doc(loggedInUser.uid)
        .collection('profile')
        .doc(loggedInUser.uid);
    await docRef.set({'username': username, 'userPhoneNumber': userPhoneNumber},
        SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //DELETE USER ACCOUNT
            Alert(
              context: context,
              type: AlertType.error,
              title: "DELETE ACCOUNT?",
              desc: "Are you sure you want to delete your account?",
              buttons: [
                DialogButton(
                  onPressed: () {
                    deleteUserProfile();
                    deleteUserReservations();
                    deleteUser();
                    Navigator.pushNamed(context, WelcomeScreen.id);
                  },
                  color: kButtonColor,
                  child: const Text(
                    "YES",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                DialogButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: kButtonColor,
                  child: const Text(
                    "NO",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ).show();
          },
          backgroundColor: kButtonColor,
          child: const FaIcon(FontAwesomeIcons.userSlash),
        ),
        appBar: AppBar(
          backgroundColor: kButtonColor,
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Consumer(builder: ((context, ref, child) {
                      final userProfileAsyncValue = ref
                          .watch(userProfileProvider(_auth.currentUser?.uid));
                      return userProfileAsyncValue.when(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
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
                                        initialValue:
                                            userProfile.username == null
                                                ? 'Add a username...'
                                                : userProfile.username!,
                                        newValue: (value) {
                                          userProfile.username = value!;
                                        },
                                      ),
                                      CustomTextFormFieldWidget(
                                        initialValue:
                                            userProfile.userPhoneNumber == null
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
                          error: (error, stackTrace) => Text(error.toString()),
                          loading: () => const CircularProgressIndicator());
                    }));
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
            style: kMainMenuFonts,
          ),
        ),
        body: Consumer(builder: (context, ref, child) {
          final userProfileAsyncValue =
              ref.watch(userProfileProvider(_auth.currentUser?.uid));
          return userProfileAsyncValue.when(
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
                                    profilePicture:
                                        userProfile.userProfilePicture!,
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
                          loggedInUser.email!,
                          style: kMainMenuFonts,
                        ),
                      )
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const CircularProgressIndicator());
        }));
  }
}
