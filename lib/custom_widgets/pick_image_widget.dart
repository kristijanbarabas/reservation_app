import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservation_app/custom_widgets/loading_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../services/cloud_firebase_storage.dart';
import '../services/constants.dart';

class PickImageWidget extends StatefulWidget {
  const PickImageWidget({super.key});

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  // authentification
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  final _firestore = FirebaseFirestore.instance;
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

  uploadNewImageToFirebase() async {
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
  }

  // TODO compress image before upload
  File? image;
  final CloudStorage storage = CloudStorage();
  Future pickImage(source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imagePermanent = File(image.path);
      setState(() {
        this.image = imagePermanent;
        debugPrint('image set as permanent');
      });
      showDialog(
          context: context,
          builder: (context) {
            return const CustomLoadingWidget();
          });
      await storage
          .uploadFile(image.path, loggedInUser.uid)
          .then(
            (value) => Alert(
                    context: context,
                    title: "Success",
                    desc: "Image uploaded!",
                    type: AlertType.success)
                .show(),
          )
          .whenComplete(() => Navigator.pop(context));
      await uploadNewImageToFirebase();
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
                onPressed: () async {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                color: kButtonColor,
                child: const Text(
                  "GALLERY",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              DialogButton(
                onPressed: () async {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                color: kButtonColor,
                child: const Text(
                  "CAMERA",
                  style: TextStyle(color: Colors.white, fontSize: 20),
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
    );
  }
}
