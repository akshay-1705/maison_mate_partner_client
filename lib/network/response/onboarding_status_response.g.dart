// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingStatusResponse _$OnboardingStatusResponseFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['email_verified', 'phone_number_verified', 'status'],
  );
  return OnboardingStatusResponse(
    json['email_verified'] as bool? ?? false,
    json['status'] as String?,
    json['phone_number_verified'] as bool? ?? false,
  );
}

Map<String, dynamic> _$OnboardingStatusResponseToJson(
        OnboardingStatusResponse instance) =>
    <String, dynamic>{
      'email_verified': instance.emailVerified,
      'phone_number_verified': instance.phoneNumberVerified,
      'status': instance.status,
    };
