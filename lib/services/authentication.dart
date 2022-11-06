import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;

  User? getLoggedInUser() {
    late User? loggedInUser;
    try {
      loggedInUser = auth.currentUser;
    } catch (e) {
      return null;
    }
    return loggedInUser;
  }
}

final authenticationProvider =
    Provider.autoDispose<Authentication?>((ref) => Authentication());

final loggedInUserUidProvider = Provider<String?>(((ref) {
  final loggedInUser = ref.read(authenticationProvider);
  final String? loggedInUserUid = loggedInUser?.getLoggedInUser()?.uid;
  return loggedInUserUid;
}));
