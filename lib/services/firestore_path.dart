class FirestorePath {
  static String userProfile(String uid) => 'user/$uid/profile/$uid';
  static String userReservation(String uid) =>
      'user/reservation/reservation/$uid';
}
