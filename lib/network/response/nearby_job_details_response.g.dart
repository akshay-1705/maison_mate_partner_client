// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_job_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyJobDetailsResponse _$NearbyJobDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    NearbyJobDetailsResponse(
      json['id'] as int?,
      json['service_name'] as String? ?? '',
      json['kind'] as String? ?? '',
      (json['latitude'] as num?)?.toDouble(),
      (json['longitude'] as num?)?.toDouble(),
      json['address'] as String? ?? '',
      json['details'] as String? ?? '',
      json['user_name'] as String? ?? '',
    );

Map<String, dynamic> _$NearbyJobDetailsResponseToJson(
        NearbyJobDetailsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_name': instance.serviceName,
      'user_name': instance.userName,
      'kind': instance.kind,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'details': instance.details,
    };
