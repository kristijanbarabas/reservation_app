import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  Future deleteUser(String uid) {
    return userCollection.doc(uid).delete();
  }
}
