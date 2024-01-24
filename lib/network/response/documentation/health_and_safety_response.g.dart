// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_and_safety_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthAndSafetyResponse _$HealthAndSafetyResponseFromJson(
        Map<String, dynamic> json) =>
    HealthAndSafetyResponse(
      json['accidents_in_five_years'] as bool?,
      json['accidents_in_five_years_details'] as String?,
      json['notice_in_five_years'] as bool?,
      json['notice_in_five_years_details'] as String?,
      json['injury_in_three_years'] as bool?,
      json['injury_in_three_years_details'] as String?,
      json['damage_by_company_employee'] as bool?,
      json['damage_by_company_employee_details'] as String?,
      json['ever_bankrupt'] as bool?,
      json['ever_bankrupt_details'] as String?,
      json['status'] as String?,
      json['reason_for_rejection'] as String?,
    );

Map<String, dynamic> _$HealthAndSafetyResponseToJson(
        HealthAndSafetyResponse instance) =>
    <String, dynamic>{
      'accidents_in_five_years': instance.accidentsInFiveYears,
      'accidents_in_five_years_details': instance.accidentsInFiveYearsDetails,
      'notice_in_five_years': instance.noticeInFiveYears,
      'notice_in_five_years_details': instance.noticeInFiveYearsDetails,
      'injury_in_three_years': instance.injuryInThreeYears,
      'injury_in_three_years_details': instance.injuryInThreeYearsDetails,
      'damage_by_company_employee': instance.damageByCompanyEmployee,
      'damage_by_company_employee_details':
          instance.damageByCompanyEmployeeDetails,
      'ever_bankrupt': instance.everBankrupt,
      'ever_bankrupt_details': instance.everBankruptDetails,
      'status': instance.status,
      'reason_for_rejection': instance.reasonForRejection,
    };
