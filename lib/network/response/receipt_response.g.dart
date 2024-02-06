// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptResponse _$ReceiptResponseFromJson(Map<String, dynamic> json) =>
    ReceiptResponse(
      (json['receipt'] as List<dynamic>)
          .map((e) => ReceiptItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['discount'] as bool? ?? false,
    );

Map<String, dynamic> _$ReceiptResponseToJson(ReceiptResponse instance) =>
    <String, dynamic>{
      'receipt': instance.receipt,
      'discount': instance.discount,
    };
