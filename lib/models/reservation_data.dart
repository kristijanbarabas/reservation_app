import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'reservation_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ReservationData {
  static DateTime timeStampToDateTime(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  static Timestamp dateTimeToTimeStamp(DateTime? dateTime) {
    return Timestamp.fromDate(dateTime ?? DateTime.now()); //To TimeStamp
  }

  /// The generated code assumes these values exist in JSON.
  final String? userId;
  final String? placeId;
  final String? serviceName;
  final int? serviceDuration;
  final int? servicePrice;

  //Because we are storing timestamp in Firestore, we need a converter for DateTime
  /* static DateTime timeStampToDateTime(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  static Timestamp dateTimeToTimeStamp(DateTime? dateTime) {
    return Timestamp.fromDate(dateTime ?? DateTime.now()); //To TimeStamp
  }*/
  /* @JsonKey(fromJson: timeStampToDateTime, toJson: dateTimeToTimeStamp) */
  final DateTime? bookingStart;
  /* @JsonKey(fromJson: timeStampToDateTime, toJson: dateTimeToTimeStamp) */
  final DateTime? bookingEnd;
  final String? email;
  final String? phoneNumber;
  final String? placeAddress;

  ReservationData(
      {this.email,
      this.phoneNumber,
      this.placeAddress,
      this.bookingStart,
      this.bookingEnd,
      this.placeId,
      this.userId,
      this.serviceName,
      this.serviceDuration,
      this.servicePrice});

  /// Connect the generated [_$DataFromJson] function to the `fromJson`
  /// factory.
  factory ReservationData.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  /// Connect the generated [_$DataToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
