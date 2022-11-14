library firestore_service;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation_app/custom_widgets/reservation_details.dart';
import 'package:reservation_app/models/reservations.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  Stream<T> queryStream<T>({
    required Query<Map<String, dynamic>> query,
    required T Function(List<ReservationDetails> data) builder,
  }) {
    late Map<String, dynamic> fireData;
    final Query<Map<String, dynamic>> reference = query;
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();
    return snapshots.map((event) {
      final allReservations = event.docs;
      List<ReservationDetails> reservationList = [];
      for (var reservation in allReservations) {
        fireData = reservation.data();
        final reservations = Reservations.fromMap(fireData);
        final String? bookingStart = reservations.bookingStart;
        final DateTime parsedReservationStart = DateTime.parse(bookingStart!);
        final String? bookingEnd = reservations.bookingEnd;
        final DateTime parsedReservationEnd = DateTime.parse(bookingEnd!);
        final String reservationDate =
            '${parsedReservationEnd.day}.${parsedReservationEnd.month}.${parsedReservationEnd.year}';
        final reservationWidget = ReservationDetails(
          date: parsedReservationEnd,
          bookingEnd: bookingEnd,
          reservationTime:
              '${parsedReservationStart.hour}:00 - ${parsedReservationEnd.hour}:00',
          reservationDate: reservationDate,
        );
        reservationList.add(reservationWidget);
        reservationList.sort((a, b) => a.date.compareTo(b.date));
      }
      return builder(reservationList);
    });
  }
}
