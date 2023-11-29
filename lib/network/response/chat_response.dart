import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/message_response.dart';

part 'chat_response.g.dart';

@JsonSerializable()
class ChatResponse {
  ChatResponse(this.messages);

  @JsonKey()
  final List<MessageResponse> messages;

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ChatResponseToJson(this);
}
