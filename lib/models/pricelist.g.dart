// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricelist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Price _$PriceFromJson(Map<String, dynamic> json) => Price(
      pricelist: (json['pricelist'] as List<dynamic>?)
              ?.map((e) => Pricelist.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'pricelist': instance.pricelist,
    };

Pricelist _$PricelistFromJson(Map<String, dynamic> json) => Pricelist(
      price: json['price'] as String?,
      service: json['service'] as String?,
    );

Map<String, dynamic> _$PricelistToJson(Pricelist instance) => <String, dynamic>{
      'price': instance.price,
      'service': instance.service,
    };
