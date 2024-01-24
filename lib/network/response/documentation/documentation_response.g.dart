// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documentation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentationResponse _$DocumentationResponseFromJson(
        Map<String, dynamic> json) =>
    DocumentationResponse(
      SectionStatusResponse.fromJson(
          json['section_wise_status'] as Map<String, dynamic>),
      json['onboarding_status'] as String?,
      json['is_limited'] as bool? ?? false,
      json['hide_insurance'] as bool? ?? false,
      json['agree_to_tnc'] as bool? ?? false,
      json['can_work_in_uk'] as bool? ?? false,
      json['not_have_criminal_offence'] as bool? ?? false,
    );

Map<String, dynamic> _$DocumentationResponseToJson(
        DocumentationResponse instance) =>
    <String, dynamic>{
      'is_limited': instance.isLimited,
      'hide_insurance': instance.hideInsurance,
      'section_wise_status': instance.sectionWiseStatus.toJson(),
      'onboarding_status': instance.onboardingStatus,
      'agree_to_tnc': instance.agreeToTnc,
      'can_work_in_uk': instance.canWorkInUk,
      'not_have_criminal_offence': instance.notHaveCriminalOffence,
    };
