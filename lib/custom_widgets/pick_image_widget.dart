import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:reservation_app/custom_widgets/loading_widget.dart';
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

  File? image;

  @override
  Widget build(BuildContext context) {
    final loggedInUserUid = ref.watch(loggedInUserUidProvider);
    final cloudFunctions = ref.watch(cloudStorageFunctions);
    // TODO compress image before upload

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
        await cloudFunctions
            .uploadFile(filePath: image.path, uid: loggedInUserUid!)
            .whenComplete(
              () => Alert(
                      context: context,
                      title: "Success",
                      desc: "Image uploaded!",
                      type: AlertType.success)
                  .show(),
            )
            .whenComplete(() => Navigator.pop(context));
        await cloudFunctions.uploadNewImageToFirebase(loggedInUserUid);
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
