import 'package:json_annotation/json_annotation.dart';

part 'health_and_safety_response.g.dart';

@JsonSerializable()
class HealthAndSafetyResponse {
  HealthAndSafetyResponse(
      this.accidentsInFiveYears,
      this.accidentsInFiveYearsDetails,
      this.noticeInFiveYears,
      this.noticeInFiveYearsDetails,
      this.injuryInThreeYears,
      this.injuryInThreeYearsDetails,
      this.damageByCompanyEmployee,
      this.damageByCompanyEmployeeDetails,
      this.everBankrupt,
      this.everBankruptDetails,
      this.status,
      this.reasonForRejection);

  @JsonKey(name: "accidents_in_five_years")
  final bool? accidentsInFiveYears;

  @JsonKey(name: "accidents_in_five_years_details")
  final String? accidentsInFiveYearsDetails;

  @JsonKey(name: "notice_in_five_years")
  final bool? noticeInFiveYears;

  @JsonKey(name: "notice_in_five_years_details")
  final String? noticeInFiveYearsDetails;

  @JsonKey(name: "injury_in_three_years")
  final bool? injuryInThreeYears;

  @JsonKey(name: "injury_in_three_years_details")
  final String? injuryInThreeYearsDetails;

  @JsonKey(name: "damage_by_company_employee")
  final bool? damageByCompanyEmployee;

  @JsonKey(name: "damage_by_company_employee_details")
  final String? damageByCompanyEmployeeDetails;

  @JsonKey(name: "ever_bankrupt")
  final bool? everBankrupt;

  @JsonKey(name: "ever_bankrupt_details")
  final String? everBankruptDetails;

  @JsonKey()
  final String? status;

  @JsonKey(
    name: "reason_for_rejection",
  )
  final String? reasonForRejection;

  factory HealthAndSafetyResponse.fromJson(Map<String, dynamic> json) =>
      _$HealthAndSafetyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HealthAndSafetyResponseToJson(this);
}
