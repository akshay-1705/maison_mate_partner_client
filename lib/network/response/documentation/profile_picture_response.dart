import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/image_response.dart';

part 'profile_picture_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfilePictureResponse {
  ProfilePictureResponse(this.image, this.status, this.reasonForRejection);

  @JsonKey()
  final ImageResponse image;

  @JsonKey()
  final String? status;

  @JsonKey(
    name: "reason_for_rejection",
  )
  final String? reasonForRejection;

  factory ProfilePictureResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfilePictureResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProfilePictureResponseToJson(this);
}
