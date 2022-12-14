import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservation_app/custom_widgets/reservation_details.dart';
import 'package:reservation_app/services/firestore_path.dart';
import 'package:reservation_app/services/firestore_service.dart';
import 'package:reservation_app/models/user_profile.dart';

import '../models/pricelist.dart';

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String? uid;

  final _service = FirestoreService.instance;
  final _auth = FirebaseAuth.instance;

  // User profile data stream
  Stream<UserProfile> profileStream({required String? profileId}) =>
      _service.documentStream(
        path: FirestorePath.userProfile(uid!),
        builder: (data, documentId) => UserProfile.fromMap(data, documentId),
      );

  // User reservation profile data stream
  Stream<List<ReservationDetails>> reservationsStream() =>
      _service.reservationListStream(
        query: FirestorePath.reservationQueryPath(uid!),
        builder: (data) => data,
      );

  // Delete a reservation from a list on swipe
  Future<void> deleteReservationOnSwipe({required String bookingEnd}) async {
    final docRef = FirestorePath.deleteReservationByQueryPath(bookingEnd).get();
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

  // Update profile
  Future<void> updateProfile(
      {required String? firstName,
      required String? lastName,
      required String? userPhoneNumber}) {
    final docRef = FirestorePath.updateUserProfilePath(_auth.currentUser!.uid);
    final data = {
      'firstName': firstName,
      'lastName': lastName,
      'userPhoneNumber': userPhoneNumber
    };
    return docRef.set(data, SetOptions(merge: true));
  }

  // Delete user profile and all data
  Future<void> deleteUser() {
    return _auth.currentUser!.delete();
  }

  Future<void> deleteUserProfile() {
    return FirestorePath.userProfileDocumentPath(_auth.currentUser!.uid)
        .delete();
  }

  Future<void> deleteUserReservations() async {
    final docRef =
        FirestorePath.deleteUserReservationsPath(_auth.currentUser!.uid).get();
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

  // TODO add a alert to notify the user that the data/account has been deleted
  deleteAllUserDataAndReservations() async {
    await deleteUser();
    await deleteUserProfile();
    await deleteUserReservations();
  }

  Future<List<Price>> getPricelist() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var ref = db.collection('pricelist');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((e) => e.data());
    var pricelist = data.map((e) => Price.fromJson(e));
    return pricelist.toList();
  }
}

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final databaseProvider = Provider.autoDispose<FirestoreDatabase?>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  if (auth.asData?.value?.uid != null) {
    return FirestoreDatabase(uid: auth.asData?.value?.uid);
  } else {
    return null;
  }
});

final userProfileProvider =
    StreamProvider.autoDispose.family<UserProfile, String?>((ref, profileId) {
  final database = ref.watch(databaseProvider);
  return database!.profileStream(profileId: profileId);
});

final userReservationProvider =
    StreamProvider.autoDispose<List<ReservationDetails>>((ref) {
  final database = ref.watch(databaseProvider);
  return database!.reservationsStream();
});

final pricelistProvider = FutureProvider.autoDispose<List<Price>>((ref) {
  final database = ref.watch(databaseProvider);
  return database!.getPricelist();
});
