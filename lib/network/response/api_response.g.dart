// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(Map<String, dynamic> json) =>
    ApiResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: _Converter<T>().fromJson(json['data'] as Object),
    );

Map<String, dynamic> _$ApiResponseToJson<T>(ApiResponse<T> instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': _Converter<T>().toJson(instance.data),
    };
