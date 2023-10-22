// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobResponse _$JobResponseFromJson(Map<String, dynamic> json) => JobResponse(
      json['id'] as int?,
      json['service_name'] as String? ?? '',
      json['amount'] as String? ?? '',
      json['distance'] as String? ?? '',
      json['completion_date'] as String?,
    );

Map<String, dynamic> _$JobResponseToJson(JobResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_name': instance.serviceName,
      'amount': instance.amount,
      'distance': instance.distance,
      'completion_date': instance.completionDate,
    };
