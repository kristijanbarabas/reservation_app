import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservation_app/components/cloud_storage.dart';
import 'package:reservation_app/components/rounded_button.dart';
import 'package:reservation_app/components/text_field_widget.dart';
import 'package:reservation_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  late String username;
  late String? phoneNumber;
  final String email;

  ProfileScreen(
      {Key? key,
      required this.username,
      required this.email,
      required this.phoneNumber})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;

  final CloudStorage storage = CloudStorage();
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
    } catch (e) {
      print(e);
    }
  }

  late String imageUrl;

  getProfileImage() async {
    isLoading = true;
    final ref = FirebaseStorage.instance
        .ref()
        .child('${loggedInUser.uid}/profilepicture.jpg');
    String url = await ref.getDownloadURL();
    setState(() {
      imageUrl = url;
    });
    isLoading = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getProfileImage();
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
                              TextFieldWidget(
                                initialValue: widget.phoneNumber == null
                                    ? 'Add a phone number...'
                                    : widget.phoneNumber!,
                                newValue: (value) {
                                  widget.phoneNumber = value!;
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
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('user')
              .doc(loggedInUser.uid)
              .collection('profile')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: SpinKitChasingDots(
                  color: Colors.black,
                  duration: Duration(seconds: 3),
                ),
              );
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
                            radius: 70.0,
                            child: isLoading
                                ? const FaIcon(FontAwesomeIcons.faceGrin,
                                    size: 100, color: Colors.white)
                                : ClipOval(
                                    child: Image.network(imageUrl,
                                        height: 160,
                                        width: 160,
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
                        '${widget.email}',
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
