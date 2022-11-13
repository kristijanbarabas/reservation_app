import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/services/firestore_database.dart';

class Authentication {
  Authentication({required this.uid});
  final String? uid;
  FirebaseAuth auth = FirebaseAuth.instance;
}

final authenticationProvider = Provider.autoDispose<Authentication?>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  if (auth.asData?.value?.uid != null) {
    return Authentication(uid: auth.asData?.value?.uid);
  } else {
    return null;
  }
});

final loggedInUserUidProvider = Provider<String?>(((ref) {
  final loggedInUser = ref.read(authenticationProvider);
  late final String? loggedInUserUid = loggedInUser?.uid;
  return loggedInUserUid;
}));
