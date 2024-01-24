import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/image_response.dart';

part 'banking_response.g.dart';

@JsonSerializable()
class BankingResponse {
  BankingResponse(this.bankName, this.accountNumber, this.sortCode, this.image,
      this.status, this.reasonForRejection);

  @JsonKey(name: "bank_name", defaultValue: '')
  final String? bankName;

  @JsonKey(name: "account_number", defaultValue: null)
  final int? accountNumber;

  @JsonKey(name: "sort_code", defaultValue: null)
  final int? sortCode;

  @JsonKey()
  final String? status;

  @JsonKey(
    name: "reason_for_rejection",
  )
  final String? reasonForRejection;

  ImageResponse image;

  factory BankingResponse.fromJson(Map<String, dynamic> json) =>
      _$BankingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BankingResponseToJson(this);
}
