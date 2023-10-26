// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobItemResponse _$JobItemResponseFromJson(Map<String, dynamic> json) =>
    JobItemResponse(
      json['id'] as int?,
      json['service_name'] as String? ?? '',
      json['payment_status'] as String?,
      json['job_status'] as String?,
      json['completion_date'] as String?,
    );

Map<String, dynamic> _$JobItemResponseToJson(JobItemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_name': instance.serviceName,
      'payment_status': instance.paymentStatus,
      'job_status': instance.jobStatus,
      'completion_date': instance.completionDate,
    };
