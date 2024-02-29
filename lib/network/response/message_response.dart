import 'package:json_annotation/json_annotation.dart';

part 'message_response.g.dart';

@JsonSerializable()
class MessageResponse {
  MessageResponse(this.text, this.isSender, this.imageUrl);

  @JsonKey()
  final String text;

  @JsonKey(name: 'is_sender')
  final bool isSender;

  @JsonKey(name: "image_url")
  final String? imageUrl;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MessageResponseToJson(this);
}
