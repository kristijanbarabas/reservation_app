// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationData _$DataFromJson(Map<String, dynamic> json) => ReservationData(
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      placeAddress: json['placeAddress'] as String?,
      bookingStart: ReservationData.timeStampToDateTime(
          json['bookingStart'] as Timestamp),
      bookingEnd:
          ReservationData.timeStampToDateTime(json['bookingEnd'] as Timestamp),
      placeId: json['placeId'] as String?,
      userId: json['userId'] as String?,
      serviceName: json['serviceName'] as String?,
      serviceDuration: json['serviceDuration'] as int?,
      servicePrice: json['servicePrice'] as int?,
    );

Map<String, dynamic> _$DataToJson(ReservationData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'placeId': instance.placeId,
      'serviceName': instance.serviceName,
      'serviceDuration': instance.serviceDuration,
      'servicePrice': instance.servicePrice,
      'bookingStart':
          ReservationData.dateTimeToTimeStamp(instance.bookingStart),
      'bookingEnd': ReservationData.dateTimeToTimeStamp(instance.bookingEnd),
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'placeAddress': instance.placeAddress,
    };
