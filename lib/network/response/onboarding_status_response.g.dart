// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingStatusResponse _$OnboardingStatusResponseFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['your_details_section'],
  );
  return OnboardingStatusResponse(
    json['your_details_section'] as bool? ?? false,
  );
}

Map<String, dynamic> _$OnboardingStatusResponseToJson(
        OnboardingStatusResponse instance) =>
    <String, dynamic>{
      'your_details_section': instance.yourDetailsSection,
    };
