// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) => ChatResponse(
      (json['sent'] as List<dynamic>).map((e) => e as String?).toList(),
      (json['received'] as List<dynamic>).map((e) => e as String?).toList(),
    );

Map<String, dynamic> _$ChatResponseToJson(ChatResponse instance) =>
    <String, dynamic>{
      'sent': instance.sent,
      'received': instance.received,
    };
