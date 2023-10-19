import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/image_response.dart';

part 'profile_details_response.g.dart';

@JsonSerializable()
class ProfileDetailsResponse {
  ProfileDetailsResponse(
      this.email, this.firstName, this.lastName, this.profilePicture);

  @JsonKey(defaultValue: '')
  final String? email;

  @JsonKey(name: "first_name", defaultValue: '')
  final String? firstName;

  @JsonKey(name: "last_name", defaultValue: '')
  final String? lastName;

  @JsonKey(name: "profile_picture")
  ImageResponse profilePicture;

  factory ProfileDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDetailsResponseToJson(this);
}
