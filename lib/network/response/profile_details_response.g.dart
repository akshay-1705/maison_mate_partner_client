// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDetailsResponse _$ProfileDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    ProfileDetailsResponse(
      json['email'] as String? ?? '',
      json['first_name'] as String? ?? '',
      json['last_name'] as String? ?? '',
      json['onboarding_status'] as String? ?? '',
    );

Map<String, dynamic> _$ProfileDetailsResponseToJson(
        ProfileDetailsResponse instance) =>
    <String, dynamic>{
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'onboarding_status': instance.onboardingStatus,
    };
