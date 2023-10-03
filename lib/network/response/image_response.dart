import 'package:json_annotation/json_annotation.dart';

part 'image_response.g.dart';

@JsonSerializable()
class ImageResponse {
  ImageResponse(this.imageUrl, this.imageName);

  @JsonKey(name: "image_url")
  final String? imageUrl;

  @JsonKey(name: "image_name")
  final String? imageName;

  factory ImageResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ImageResponseToJson(this);
}
