// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankingResponse _$BankingResponseFromJson(Map<String, dynamic> json) =>
    BankingResponse(
      json['bank_name'] as String? ?? '',
      json['account_number'] as int?,
      json['sort_code'] as int?,
      ImageResponse.fromJson(json['image'] as Map<String, dynamic>),
      json['status'] as String?,
      json['reason_for_rejection'] as String?,
    );

Map<String, dynamic> _$BankingResponseToJson(BankingResponse instance) =>
    <String, dynamic>{
      'bank_name': instance.bankName,
      'account_number': instance.accountNumber,
      'sort_code': instance.sortCode,
      'status': instance.status,
      'reason_for_rejection': instance.reasonForRejection,
      'image': instance.image,
    };
