import 'package:json_annotation/json_annotation.dart';

part 'profile_details_response.g.dart';

@JsonSerializable()
class ProfileDetailsResponse {
  ProfileDetailsResponse(
      this.email, this.firstName, this.lastName, this.onboardingStatus);

  @JsonKey(defaultValue: '')
  final String? email;

  @JsonKey(name: "first_name", defaultValue: '')
  final String? firstName;

  @JsonKey(name: "last_name", defaultValue: '')
  final String? lastName;

  @JsonKey(name: "onboarding_status", defaultValue: '')
  final String? onboardingStatus;

  factory ProfileDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDetailsResponseToJson(this);
}
