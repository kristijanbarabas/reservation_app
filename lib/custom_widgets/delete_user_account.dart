import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../screens/welcome_screen.dart';
import '../services/constants.dart';

class DeleteUserAccountAndData extends StatelessWidget {
  const DeleteUserAccountAndData({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    deleteUser() {
      auth.currentUser?.delete();
    }

    deleteUserProfile() {
      firestore
          .collection("user")
          .doc(auth.currentUser?.uid)
          .collection('profile')
          .doc(auth.currentUser?.uid)
          .delete();
    }

    deleteUserReservations() async {
      final docRef = firestore
          .collection("user")
          .doc('reservation')
          .collection('reservation')
          .where('userId', isEqualTo: auth.currentUser?.uid)
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

    return FloatingActionButton(
      onPressed: () {
        //Delete user account
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
    );
  }
}
