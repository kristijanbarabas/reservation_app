import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reservation_app/services/firestore_database.dart';
import 'package:reservation_app/services/firestore_path.dart';
import '../routing/go_router.dart';
import 'package:reservation_app/services/alerts.dart';

class Authentication {
  Authentication({this.uid});
  final String? uid;
  FirebaseAuth auth = FirebaseAuth.instance;
  final CustomAlerts _alerts = CustomAlerts();

  // Sign in with email
  Future<void> customSignInWithEmailAndPassword({
    required String? email,
    required String? password,
    required BuildContext context,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email!, password: password!);
    } catch (e) {
      _alerts.errorAlertDialog(context: context);
    }
  }

  // Google sign in function
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

  // Full google sign in function that displays a loading animation while checking if the user has already signed in before
  void customSignInWithGoogle({required BuildContext context}) async {
    final data = {
      'firstName': auth.currentUser?.displayName,
      'phoneNumber': auth.currentUser?.phoneNumber,
      'userProfilePicture': auth.currentUser?.photoURL,
    };
    try {
      await signInWithGoogle();
      if (auth.currentUser?.uid != null) {
        final docRef = FirestorePath.googleSignInPath(auth.currentUser!.uid);
        await docRef.get().then(
          (DocumentSnapshot document) {
            if (document.exists) {
              // Do nothing
            } else {
              docRef.set(data);
            }
          },
        );
      }
    } catch (e) {
      _alerts.errorAlertDialog(context: context);
    }
  }

  // Register a new user
  void registerNewUser(
      {required String? email,
      required String? password,
      required String? firstName,
      required String? lastName,
      required BuildContext context}) async {
    final auth = FirebaseAuth.instance;
    final data = {
      'userPhoneNumber': 'Add phone number...',
      'firstName': firstName,
      'lastName': lastName,
    };
    try {
      final UserCredential newUser = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      if (newUser != null) {
        FirestorePath.userProfileDocumentPath(newUser.user!.uid)
            .set(data)
            .whenComplete(() => context.pushNamed(AppRoutes.home.name));
      }
    } catch (e) {
      _alerts.errorAlertDialog(context: context);
    }
  }

  // Signout the user
  signOutUser({required BuildContext context}) {
    auth.signOut().whenComplete(() => Navigator.pop(context));
  }
}

final authenticationFunctionsProvider =
    Provider<Authentication?>((ref) => Authentication());

final authenticationProvider = Provider.autoDispose<Authentication?>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  if (auth.asData?.value?.uid != null) {
    return Authentication(uid: auth.asData?.value?.uid);
  } else {
    return null;
  }
});

final loggedInUserUidProvider = Provider.autoDispose<String?>(((ref) {
  final loggedInUser = ref.watch(authenticationProvider);
  late final String? loggedInUserUid = loggedInUser?.uid;
  return loggedInUserUid;
}));
