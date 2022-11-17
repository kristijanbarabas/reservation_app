import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePath {
  static String userProfile(String uid) => 'user/$uid/profile/$uid';
  static CollectionReference getAndDeleteExpiredReservationPath() {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('user')
        .doc('reservation')
        .collection('reservation');
  }

  // Stream
  static Query<Map<String, dynamic>> reservationQueryPath(String uid) {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('user')
        .doc('reservation')
        .collection('reservation')
        .where('userId', isEqualTo: uid);
  }

  // For registering a new user and deleting user profile
  static DocumentReference userProfileDocumentPath(String uid) {
    final firestore = FirebaseFirestore.instance;
    return firestore.collection('user').doc(uid).collection('profile').doc(uid);
  }

  static Query<Map<String, dynamic>> deleteReservationByQueryPath(
      String bookingEnd) {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('user')
        .doc('reservation')
        .collection('reservation')
        .where('bookingEnd', isEqualTo: bookingEnd);
  }

  static DocumentReference updateUserProfilePath(String uid) {
    final firestore = FirebaseFirestore.instance;
    return firestore.collection('user').doc(uid).collection('profile').doc(uid);
  }

  static DocumentReference googleSignInPath(String uid) {
    final firestore = FirebaseFirestore.instance;
    return firestore.collection('user').doc(uid).collection('profile').doc(uid);
  }

  static Query<Map<String, dynamic>> deleteExpiredReservationPath(
      String bookingStart) {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('user')
        .doc('reservation')
        .collection('reservation')
        .where('bookingEnd', isEqualTo: bookingStart);
  }

  static Query<Map<String, dynamic>> deleteUserReservationsPath(String uid) {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection("user")
        .doc('reservation')
        .collection('reservation')
        .where('userId', isEqualTo: uid);
  }
}
