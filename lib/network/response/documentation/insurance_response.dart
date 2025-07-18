import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/image_response.dart';

part 'insurance_response.g.dart';

@JsonSerializable()
class InsuranceResponse {
  InsuranceResponse(this.twoMillionInsurance, this.oneMillionInsurance,
      this.expiryDate, this.image, this.status, this.reasonForRejection);

  @JsonKey(name: "two_million_insurance")
  final bool? twoMillionInsurance;

  @JsonKey(name: "one_million_insurance")
  final bool? oneMillionInsurance;

  @JsonKey(name: "expiry_date")
  final int? expiryDate;

  ImageResponse image;

  @JsonKey()
  final String? status;

  @JsonKey(
    name: "reason_for_rejection",
  )
  final String? reasonForRejection;

  factory InsuranceResponse.fromJson(Map<String, dynamic> json) =>
      _$InsuranceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InsuranceResponseToJson(this);
}
