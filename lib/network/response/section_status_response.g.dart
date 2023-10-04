// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionStatusResponse _$SectionStatusResponseFromJson(
        Map<String, dynamic> json) =>
    SectionStatusResponse(
      json['banking'] as String?,
      json['insurance'] as String?,
      json['employees'] as String?,
      json['profile_picture'] as String?,
      json['health_and_safety'] as String?,
      json['owner_identification'] as String?,
    );

Map<String, dynamic> _$SectionStatusResponseToJson(
        SectionStatusResponse instance) =>
    <String, dynamic>{
      'banking': instance.banking,
      'insurance': instance.insurance,
      'employees': instance.employees,
      'profile_picture': instance.profilePicture,
      'health_and_safety': instance.healthAndSafety,
      'owner_identification': instance.ownerIdentification,
    };
