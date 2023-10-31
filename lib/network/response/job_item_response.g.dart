// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobItemResponse _$JobItemResponseFromJson(Map<String, dynamic> json) =>
    JobItemResponse(
      json['id'] as int?,
      json['service_name'] as String? ?? '',
      json['kind'] as String?,
      json['address'] as String?,
      json['status_to_show'] as String?,
      json['status_to_search'] as int?,
    );

Map<String, dynamic> _$JobItemResponseToJson(JobItemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_name': instance.serviceName,
      'status_to_show': instance.statusToShow,
      'status_to_search': instance.statusToSearch,
      'kind': instance.kind,
      'address': instance.address,
    };
