import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservation_app/custom_widgets/reservation_details.dart';
import 'package:reservation_app/models/reservation_data.dart';
import 'package:reservation_app/models/reservations.dart';
import 'package:reservation_app/services/firestore_path.dart';
import 'package:reservation_app/services/firestore_service.dart';
import 'package:reservation_app/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String? uid;

  final _service = FirestoreService.instance;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot<Object?>> reservationStream = _firestore
      .collection('user')
      .doc('reservation')
      .collection('reservation')
      .where('userId', isEqualTo: _auth.currentUser?.uid)
      .snapshots();

  // User profile data stream
  Stream<UserProfile> profileStream({required String? profileId}) =>
      _service.documentStream(
        path: FirestorePath.userProfile(uid!),
        builder: (data, documentId) => UserProfile.fromMap(data, documentId),
      );

  // User reservation profile data stream
  Stream<List<ReservationDetails>> reservationsStream() => _service.queryStream(
        query: FirestorePath.reservationQuery(uid!),
        builder: (data) => data,
      );

  // Delete a reservation
  void deleteReservationOnSwipe({required String bookingEnd}) async {
    final docRef = _firestore
        .collection('user')
        .doc('reservation')
        .collection('reservation')
        .where('bookingEnd', isEqualTo: bookingEnd)
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
