import 'package:json_annotation/json_annotation.dart';

part 'onboarding_status_response.g.dart';

@JsonSerializable()
class OnboardingStatusResponse {
  @JsonKey(name: "your_details_section", required: true, defaultValue: false)
  final bool? yourDetailsSection;

  @JsonKey(required: true, defaultValue: false)
  final bool? documentation;

  @JsonKey(name: 'email_verified', required: true, defaultValue: false)
  final bool? emailVerified;

  @JsonKey(name: 'account_verified', required: true, defaultValue: false)
  final bool? accountVerified;

  OnboardingStatusResponse(this.yourDetailsSection, this.documentation,
      this.emailVerified, this.accountVerified);

  factory OnboardingStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingStatusResponseToJson(this);
}
