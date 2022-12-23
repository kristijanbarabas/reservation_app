import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:reservation_app/services/alerts.dart';
import 'package:reservation_app/services/authentication.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../services/cloud_firebase_storage.dart';
import '../services/constants.dart';

class PickImageWidget extends ConsumerStatefulWidget {
  const PickImageWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickImageWidgetState();
}

class _PickImageWidgetState extends ConsumerState<PickImageWidget> {
  //TODO refactor this shit

  File? imageFromFile;

  @override
  Widget build(BuildContext context) {
    final loggedInUserUid = ref.watch(loggedInUserUidProvider);
    final cloudFunctions = ref.watch(cloudStorageFunctions);
    final customAlerts = ref.watch(customAlertsProvider);

    Future pickImage(source) async {
      try {
        final image = await ImagePicker().pickImage(
            source: source,
            /* Lower image quality makes the image upload faster*/
            imageQuality: 85);
        if (image == null) return;
        final imagePermanent = File(image.path);
        setState(() {
          imageFromFile = imagePermanent;
          debugPrint('image set as permanent');
        });
        customAlerts!.paperplaneAlertDialog(context: context);
        await cloudFunctions
            .uploadFile(filePath: image.path, uid: loggedInUserUid!)
            .whenComplete(
                () => cloudFunctions.uploadNewImageToFirebase(loggedInUserUid))
            .whenComplete(
                () => customAlerts.successAlertDialot(context: context))
            .whenComplete(() => Navigator.pop(context));
      } catch (e) {
        Alert(context: context, title: "Error", desc: "Try again!").show();
      }
    }

    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          Alert(
            context: context,
            image: Lottie.asset('assets/santa.json', height: 150, width: 150),
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
