import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePath {
  static String userProfile(String uid) => 'user/$uid/profile/$uid';

  // Stream
  static Query<Map<String, dynamic>> reservationQuery(String uid) {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('user')
        .doc('reservation')
        .collection('reservation')
        .where('userId', isEqualTo: uid);
  }
}
