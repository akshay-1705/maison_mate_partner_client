// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignIn _$SignInFromJson(Map<String, dynamic> json) => SignIn(
      json['token'] as String,
      Partner.fromJson(json['partner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignInToJson(SignIn instance) => <String, dynamic>{
      'token': instance.token,
      'partner': instance.partner.toJson(),
    };
