// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentsSummaryResponse _$PaymentsSummaryResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentsSummaryResponse(
      (json['payments'] as List<dynamic>)
          .map((e) => PaymentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['total'] as int? ?? 0,
      json['pending'] as int? ?? 0,
    );

Map<String, dynamic> _$PaymentsSummaryResponseToJson(
        PaymentsSummaryResponse instance) =>
    <String, dynamic>{
      'payments': instance.payments,
      'total': instance.total,
      'pending': instance.pending,
    };
