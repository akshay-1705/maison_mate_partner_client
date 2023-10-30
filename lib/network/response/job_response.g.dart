// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobResponse _$JobResponseFromJson(Map<String, dynamic> json) => JobResponse(
      json['id'] as int?,
      json['service_name'] as String? ?? '',
      json['kind'] as String?,
      json['distance'] as String? ?? '',
    );

Map<String, dynamic> _$JobResponseToJson(JobResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_name': instance.serviceName,
      'distance': instance.distance,
      'kind': instance.kind,
    };
