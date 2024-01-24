// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsuranceResponse _$InsuranceResponseFromJson(Map<String, dynamic> json) =>
    InsuranceResponse(
      json['two_million_insurance'] as bool?,
      json['one_million_insurance'] as bool?,
      json['expiry_date'] as int?,
      ImageResponse.fromJson(json['image'] as Map<String, dynamic>),
      json['status'] as String?,
      json['reason_for_rejection'] as String?,
    );

Map<String, dynamic> _$InsuranceResponseToJson(InsuranceResponse instance) =>
    <String, dynamic>{
      'two_million_insurance': instance.twoMillionInsurance,
      'one_million_insurance': instance.oneMillionInsurance,
      'expiry_date': instance.expiryDate,
      'image': instance.image,
      'status': instance.status,
      'reason_for_rejection': instance.reasonForRejection,
    };
