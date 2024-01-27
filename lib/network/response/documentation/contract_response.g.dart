// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractResponse _$ContractResponseFromJson(Map<String, dynamic> json) =>
    ContractResponse(
      json['signature'] as String? ?? '',
      ImageResponse.fromJson(json['image'] as Map<String, dynamic>),
      json['status'] as String? ?? '',
      json['reason_for_rejection'] as String? ?? '',
    );

Map<String, dynamic> _$ContractResponseToJson(ContractResponse instance) =>
    <String, dynamic>{
      'image': instance.document,
      'status': instance.status,
      'signature': instance.signature,
      'reason_for_rejection': instance.reasonForRejection,
    };
