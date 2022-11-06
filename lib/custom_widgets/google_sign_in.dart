import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reservation_app/services/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../screens/home.dart';
import 'loading_widget.dart';

class CustomGoogleSignInButton extends StatefulWidget {
  const CustomGoogleSignInButton({super.key});

  @override
  State<CustomGoogleSignInButton> createState() =>
      _CustomGoogleSignInButtonState();
}

class _CustomGoogleSignInButtonState extends State<CustomGoogleSignInButton>
    with SingleTickerProviderStateMixin {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void customSignInWithGoogle() async {
    try {
      showDialog(
        context: context,
        builder: (context) => const CustomLoadingWidget(),
      );
      await signInWithGoogle();
      if (_auth.currentUser?.uid != null) {
        final docRef = _firestore
            .collection('user')
            .doc(_auth.currentUser?.uid)
            .collection('profile')
            .doc(_auth.currentUser?.uid);
        await docRef.get().then(
          (DocumentSnapshot document) {
            if (document.exists) {
              // DO NOTHING
            } else {
              docRef.set(
                {
                  'username': _auth.currentUser?.displayName,
                  'phoneNumber': _auth.currentUser?.phoneNumber,
                  'userProfilePicture': _auth.currentUser?.photoURL,
                },
              );
            }
            Navigator.pop(context);
            Navigator.pushNamed(context, HomeScreen.id);
          },
        );
      }
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
  }

  late double _scale;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Center(
      child: GestureDetector(
        onTap: customSignInWithGoogle,
        onTapDown: _tapDown,
        onTapUp: _tapUp,
        child: Transform.scale(
          scale: _scale,
          child: _animatedButton(),
        ),
      ),
    );
  }

  Widget _animatedButton() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              blurRadius: 5,
              color: Color.fromARGB(255, 36, 36, 36),
              spreadRadius: 0.1)
        ],
      ),
      child: const CircleAvatar(
        radius: 35,
        backgroundColor: kButtonColor,
        child: FaIcon(
          FontAwesomeIcons.google,
          color: Colors.white,
        ),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
