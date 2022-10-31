import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservation_app/services/firestore_path.dart';
import 'package:reservation_app/services/firestore_service.dart';
import 'package:reservation_app/models/user_profile.dart';

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String? uid;

  final _service = FirestoreService.instance;

  Stream<UserProfile> profileStream({required String? profileId}) =>
      _service.documentStream(
        path: FirestorePath.userProfile(uid!),
        builder: (data, documentId) => UserProfile.fromMap(data, documentId),
      );
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