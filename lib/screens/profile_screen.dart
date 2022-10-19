import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import 'package:reservation_app/services/cloud_storage.dart';
import 'package:reservation_app/components/rounded_button.dart';
import 'package:reservation_app/components/text_field_widget.dart';
import 'package:reservation_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservation_app/services/user_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  late String? username;
  late String? phoneNumber;
  final String email;
  final String? profilePicture;

  ProfileScreen(
      {Key? key,
      required this.username,
      required this.email,
      required this.phoneNumber,
      required this.profilePicture})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CloudStorage storage = CloudStorage();
  final UserDatabase deleteService = UserDatabase();
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
    await docRef.set(
        {'username': widget.username, 'userPhoneNumber': widget.phoneNumber},
        SetOptions(merge: true));
  }

  File? image;

  Future pickImage(source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imagePermanent = File(image.path);
      setState(() {
        this.image = imagePermanent;
      });
      await storage.uploadFile(image.path, loggedInUser.uid).then(
            (value) => print('Done'),
          );
      final ref = FirebaseStorage.instance
          .ref()
          .child('${loggedInUser.uid}/profilepicture.jpg');
      String url = await ref.getDownloadURL();
      final docRef = _firestore
          .collection('user')
          .doc(loggedInUser.uid)
          .collection('profile')
          .doc(loggedInUser.uid);
      await docRef.set({'userProfilePicture': url}, SetOptions(merge: true));
    } catch (e) {
      print(e);
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
                  // TODO: EXTRACT INTO WIDGET
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
                              initialValue: widget.username == null
                                  ? 'Add a username...'
                                  : widget.username!,
                              newValue: (value) {
                                widget.username = value!;
                              },
                            ),
                            TextFieldWidget(
                              initialValue: widget.phoneNumber == null
                                  ? 'Add a phone number...'
                                  : widget.phoneNumber!,
                              newValue: (value) {
                                widget.phoneNumber = value!;
                              },
                            ),
                            CustomRoundedButton(
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
            child: const Icon(Icons.edit),
          ),
        ],
        title: Text(
          'Profile',
          style: kGoogleFonts,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('user')
              .doc(loggedInUser.uid)
              .collection('profile')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('');
            } else {
              final profile = snapshot.data!.docs;
              Map<String, dynamic> profileData = {};
              late String username = profileData['username'];
              late String phoneNumber = profileData['userPhoneNumber'];
              for (var snapshot in profile) {
                profileData = snapshot.data() as Map<String, dynamic>;
              }
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
                            child: widget.profilePicture == null
                                ? const FaIcon(FontAwesomeIcons.faceGrin,
                                    size: 100, color: Colors.white)
                                : ClipOval(
                                    child: Image.network(widget.profilePicture!,
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover),
                                  )),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              Alert(
                                context: context,
                                type: AlertType.warning,
                                title: "PICK AN IMAGE!",
                                buttons: [
                                  DialogButton(
                                    onPressed: () {
                                      pickImage(ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                    color: kButtonColor,
                                    child: const Text(
                                      "GALLERY",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  DialogButton(
                                    onPressed: () {
                                      pickImage(ImageSource.camera);
                                      Navigator.pop(context);
                                    },
                                    color: kButtonColor,
                                    child: const Text(
                                      "CAMERA",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                ],
                              ).show();
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: FaIcon(
                                FontAwesomeIcons.images,
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
                        username == null
                            ? 'Add a username number...'
                            : username,
                        style: kMainMenuFonts,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        phoneNumber == null
                            ? 'Add a phone number...'
                            : phoneNumber,
                        style: kMainMenuFonts,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.email,
                        style: kMainMenuFonts,
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
