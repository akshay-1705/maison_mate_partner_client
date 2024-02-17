import 'package:json_annotation/json_annotation.dart';

part 'onboarding_status_response.g.dart';

@JsonSerializable()
class OnboardingStatusResponse {
  @JsonKey(name: 'email_verified', required: true, defaultValue: false)
  final bool? emailVerified;

  @JsonKey(name: 'phone_number_verified', required: true, defaultValue: false)
  final bool? phoneNumberVerified;

  @JsonKey(required: true)
  final String? status;

  OnboardingStatusResponse(
      this.emailVerified, this.status, this.phoneNumberVerified);

  factory OnboardingStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OnboardingStatusResponseToJson(this);
}
