import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/image_response.dart';

part 'banking_response.g.dart';

@JsonSerializable()
class BankingResponse {
  BankingResponse(this.bankName, this.accountNumber, this.sortCode, this.image);

  @JsonKey(name: "bank_name")
  final String? bankName;

  @JsonKey(name: "account_number")
  final int? accountNumber;

  @JsonKey(name: "sort_code")
  final int? sortCode;

  ImageResponse image;

  factory BankingResponse.fromJson(Map<String, dynamic> json) =>
      _$BankingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BankingResponseToJson(this);
}
