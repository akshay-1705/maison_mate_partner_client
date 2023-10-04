// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documentation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentationResponse _$DocumentationResponseFromJson(
        Map<String, dynamic> json) =>
    DocumentationResponse(
      SectionStatusResponse.fromJson(json['status'] as Map<String, dynamic>),
      json['is_limited'] as bool? ?? false,
    );

Map<String, dynamic> _$DocumentationResponseToJson(
        DocumentationResponse instance) =>
    <String, dynamic>{
      'is_limited': instance.isLimited,
      'status': instance.status.toJson(),
    };
