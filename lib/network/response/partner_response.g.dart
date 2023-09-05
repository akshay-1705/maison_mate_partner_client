// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerResponse _$PartnerResponseFromJson(Map<String, dynamic> json) =>
    PartnerResponse(
      id: json['id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$PartnerResponseToJson(PartnerResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
    };
