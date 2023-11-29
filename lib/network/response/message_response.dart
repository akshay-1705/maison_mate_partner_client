import 'package:json_annotation/json_annotation.dart';

part 'message_response.g.dart';

@JsonSerializable()
class MessageResponse {
  MessageResponse(this.text, this.isSender);

  @JsonKey()
  final String text;

  @JsonKey(name: 'is_sender')
  final bool isSender;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MessageResponseToJson(this);
}
