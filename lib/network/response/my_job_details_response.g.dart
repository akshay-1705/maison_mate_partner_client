// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_job_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyJobDetailsResponse _$MyJobDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    MyJobDetailsResponse(
      json['id'] as int?,
      json['service_name'] as String? ?? '',
      json['kind'] as String? ?? '',
      (json['latitude'] as num?)?.toDouble(),
      (json['longitude'] as num?)?.toDouble(),
      json['address'] as String? ?? '',
      json['details'] as String? ?? '',
      json['user_name'] as String? ?? '',
      json['user_id'] as int?,
      json['job_id'] as int?,
      json['status'] as String?,
      json['accepted_at'] as int?,
      json['quote_final'] as bool? ?? false,
      json['status_to_search'] as int?,
      json['user_phone_number'] as String?,
      json['user_rating'] as int?,
    );

Map<String, dynamic> _$MyJobDetailsResponseToJson(
        MyJobDetailsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_name': instance.serviceName,
      'user_name': instance.userName,
      'user_id': instance.userId,
      'job_id': instance.jobId,
      'kind': instance.kind,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'details': instance.details,
      'status': instance.status,
      'status_to_search': instance.statusToSearch,
      'accepted_at': instance.acceptedAt,
      'quote_final': instance.quoteFinal,
      'user_phone_number': instance.userPhoneNumber,
      'user_rating': instance.userRating,
    };
