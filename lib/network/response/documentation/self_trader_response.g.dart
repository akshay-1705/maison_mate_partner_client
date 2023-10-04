// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_trader_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfTraderResponse _$SelfTraderResponseFromJson(Map<String, dynamic> json) =>
    SelfTraderResponse(
      json['vat_number'] as String? ?? '',
      json['date_of_birth'] as int?,
      json['proof_of_id'] == null
          ? null
          : ImageResponse.fromJson(json['proof_of_id'] as Map<String, dynamic>),
      json['proof_of_address'] == null
          ? null
          : ImageResponse.fromJson(
              json['proof_of_address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SelfTraderResponseToJson(SelfTraderResponse instance) =>
    <String, dynamic>{
      'vat_number': instance.vatNumber,
      'date_of_birth': instance.dateOfBirth,
      'proof_of_id': instance.proofOfId,
      'proof_of_address': instance.proofOfAddress,
    };
