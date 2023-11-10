// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteResponse _$QuoteResponseFromJson(Map<String, dynamic> json) =>
    QuoteResponse(
      (json['price'] as num).toDouble(),
      json['category'] as String,
      json['is_price_per_hour'] as bool,
    );

Map<String, dynamic> _$QuoteResponseToJson(QuoteResponse instance) =>
    <String, dynamic>{
      'price': instance.price,
      'category': instance.category,
      'is_price_per_hour': instance.isPricePerHour,
    };
