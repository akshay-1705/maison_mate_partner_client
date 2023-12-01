// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptItemResponse _$ReceiptItemResponseFromJson(Map<String, dynamic> json) =>
    ReceiptItemResponse(
      json['category'] as String,
      (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$ReceiptItemResponseToJson(
        ReceiptItemResponse instance) =>
    <String, dynamic>{
      'category': instance.category,
      'price': instance.price,
    };
