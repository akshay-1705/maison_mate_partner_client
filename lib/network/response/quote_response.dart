import 'package:json_annotation/json_annotation.dart';

part 'quote_response.g.dart';

@JsonSerializable()
class QuoteResponse {
  QuoteResponse(this.price, this.category, this.isPricePerHour);

  @JsonKey()
  final double price;

  @JsonKey()
  final String category;

  @JsonKey(name: 'is_price_per_hour')
  final bool isPricePerHour;

  factory QuoteResponse.fromJson(Map<String, dynamic> json) =>
      _$QuoteResponseFromJson(json);
  Map<String, dynamic> toJson() => _$QuoteResponseToJson(this);
}
