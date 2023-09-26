import 'package:json_annotation/json_annotation.dart';

part 'onboarding_status_response.g.dart';

@JsonSerializable()
class OnboardingStatusResponse {
  @JsonKey(name: "your_details_section", required: true, defaultValue: false)
  final bool? yourDetailsSection;

  OnboardingStatusResponse(this.yourDetailsSection);

  factory OnboardingStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingStatusResponseToJson(this);
}
