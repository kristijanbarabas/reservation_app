import 'package:json_annotation/json_annotation.dart';
part 'pricelist.g.dart';

@JsonSerializable()
class Price {
  final List<Pricelist> pricelist;

  const Price({
    this.pricelist = const [],
  });

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
  Map<String, dynamic> toJson() => _$PriceToJson(this);
}

@JsonSerializable()
class Pricelist {
  final String? price;
  final String? service;

  const Pricelist({
    this.price,
    this.service,
  });

  factory Pricelist.fromJson(Map<String, dynamic> json) =>
      _$PricelistFromJson(json);
  Map<String, dynamic> toJson() => _$PricelistToJson(this);
}
