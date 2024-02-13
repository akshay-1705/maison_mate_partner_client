// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earnings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EarningsResponse _$EarningsResponseFromJson(Map<String, dynamic> json) =>
    EarningsResponse(
      (json['payments'] as List<dynamic>)
          .map((e) => PaymentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['total_earnings'] as num?)?.toDouble(),
      (json['total_commission'] as num?)?.toDouble(),
      (json['partner_share'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$EarningsResponseToJson(EarningsResponse instance) =>
    <String, dynamic>{
      'payments': instance.payments,
      'total_earnings': instance.totalEarnings,
      'total_commission': instance.totalCommission,
      'partner_share': instance.partnerShare,
    };
