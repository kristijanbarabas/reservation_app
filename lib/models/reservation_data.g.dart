// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationData _$ReservationDataFromJson(Map<String, dynamic> json) =>
    ReservationData(
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      placeAddress: json['placeAddress'] as String?,
      bookingStart: json['bookingStart'] == null
          ? null
          : DateTime.parse(json['bookingStart'] as String),
      bookingEnd: json['bookingEnd'] == null
          ? null
          : DateTime.parse(json['bookingEnd'] as String),
      placeId: json['placeId'] as String?,
      userId: json['userId'] as String?,
      serviceName: json['serviceName'] as String?,
      serviceDuration: json['serviceDuration'] as int?,
      servicePrice: json['servicePrice'] as int?,
    );

Map<String, dynamic> _$ReservationDataToJson(ReservationData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'placeId': instance.placeId,
      'serviceName': instance.serviceName,
      'serviceDuration': instance.serviceDuration,
      'servicePrice': instance.servicePrice,
      'bookingStart': instance.bookingStart?.toIso8601String(),
      'bookingEnd': instance.bookingEnd?.toIso8601String(),
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'placeAddress': instance.placeAddress,
    };
