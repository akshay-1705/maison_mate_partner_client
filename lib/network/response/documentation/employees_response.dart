import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/image_response.dart';

part 'employees_response.g.dart';

@JsonSerializable()
class EmployeesResponse {
  EmployeesResponse(
      this.employeesPresent,
      this.liabilityInsurance,
      this.insuranceExpiryDate,
      this.image,
      this.status,
      this.reasonForRejection);

  @JsonKey(name: "employees_present")
  final bool? employeesPresent;

  @JsonKey(name: "liability_insurance")
  final bool? liabilityInsurance;

  @JsonKey(name: "insurance_expiry_date")
  final int? insuranceExpiryDate;

  ImageResponse image;

  @JsonKey()
  final String? status;

  @JsonKey(
    name: "reason_for_rejection",
  )
  final String? reasonForRejection;

  factory EmployeesResponse.fromJson(Map<String, dynamic> json) =>
      _$EmployeesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeesResponseToJson(this);
}
