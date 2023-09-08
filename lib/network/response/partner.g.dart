// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Partner _$PartnerFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'first_name',
      'last_name',
      'email',
      'created_at',
      'updated_at'
    ],
  );
  return Partner(
    json['id'] as int,
    json['first_name'] as String,
    json['last_name'] as String,
    json['email'] as String?,
    json['created_at'] as String?,
    json['updated_at'] as String?,
  );
}

Map<String, dynamic> _$PartnerToJson(Partner instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
