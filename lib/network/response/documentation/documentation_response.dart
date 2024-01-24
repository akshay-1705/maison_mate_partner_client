import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/documentation/section_status_response.dart';

part 'documentation_response.g.dart';

@JsonSerializable(explicitToJson: true)
class DocumentationResponse {
  @JsonKey(name: "is_limited", defaultValue: false)
  final bool isLimited;

  @JsonKey(name: "hide_insurance", defaultValue: false)
  final bool hideInsurance;

  @JsonKey(name: "section_wise_status")
  SectionStatusResponse sectionWiseStatus;

  @JsonKey(name: "onboarding_status")
  final String? onboardingStatus;

  @JsonKey(name: "agree_to_tnc", defaultValue: false)
  final bool agreeToTnc;

  @JsonKey(name: "can_work_in_uk", defaultValue: false)
  final bool canWorkInUk;

  @JsonKey(name: "not_have_criminal_offence", defaultValue: false)
  final bool notHaveCriminalOffence;

  DocumentationResponse(
      this.sectionWiseStatus,
      this.onboardingStatus,
      this.isLimited,
      this.hideInsurance,
      this.agreeToTnc,
      this.canWorkInUk,
      this.notHaveCriminalOffence);
  factory DocumentationResponse.fromJson(Map<String, dynamic> json) =>
      _$DocumentationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentationResponseToJson(this);
}
