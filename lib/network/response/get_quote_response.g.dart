// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_quote_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetQuoteResponse _$GetQuoteResponseFromJson(Map<String, dynamic> json) =>
    GetQuoteResponse(
      (json['quote'] as List<dynamic>)
          .map((e) => QuoteResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetQuoteResponseToJson(GetQuoteResponse instance) =>
    <String, dynamic>{
      'quote': instance.quote,
    };
