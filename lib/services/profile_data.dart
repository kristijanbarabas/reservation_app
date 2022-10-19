import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final profileDatabase = Provider<ProfileData>((ref) => ProfileData());

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User loggedInUser;

class ProfileData {
  Future<String> getUserData() {
    return Future.delayed(const Duration(seconds: 3), () {
      return "Kiki";
    });
  }

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

  Future<String> test() async {
    return await Future.delayed(const Duration(seconds: 3), () {
      Map<String, String> fireProfile = {
        'username': "Kiki",
      };
      return fireProfile['username']!;
    });
  }

  Future<String> getProfile() async {
    late Map<String, dynamic> fireProfile = {};
    late String username;
    final docRef = _firestore
        .collection('user')
        .doc(loggedInUser.uid)
        .collection('profile')
        .get();
    await docRef.then(
      (QuerySnapshot snapshot) {
        snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          fireProfile = documentSnapshot.data() as Map<String, dynamic>;
          username = fireProfile['username'];
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return username;
  }
}
