// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) =>
    PaymentResponse(
      json['service_name'] as String?,
      json['unique_transaction_reference'] as String? ?? '',
      json['amount'] as String?,
      json['status'] as String?,
      json['transaction_date'] as String? ?? '',
    );

Map<String, dynamic> _$PaymentResponseToJson(PaymentResponse instance) =>
    <String, dynamic>{
      'service_name': instance.serviceName,
      'unique_transaction_reference': instance.uniqueTransactionReference,
      'amount': instance.amount,
      'status': instance.status,
      'transaction_date': instance.transactionDate,
    };
