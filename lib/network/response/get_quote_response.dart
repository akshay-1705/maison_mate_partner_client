import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/quote_response.dart';

part 'get_quote_response.g.dart';

@JsonSerializable()
class GetQuoteResponse {
  GetQuoteResponse(this.quote);

  @JsonKey()
  final List<QuoteResponse> quote;

  factory GetQuoteResponse.fromJson(Map<String, dynamic> json) =>
      _$GetQuoteResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetQuoteResponseToJson(this);
}
