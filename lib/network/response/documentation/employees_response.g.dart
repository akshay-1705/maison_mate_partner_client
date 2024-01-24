// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employees_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeesResponse _$EmployeesResponseFromJson(Map<String, dynamic> json) =>
    EmployeesResponse(
      json['employees_present'] as bool?,
      json['liability_insurance'] as bool?,
      json['insurance_expiry_date'] as int?,
      ImageResponse.fromJson(json['image'] as Map<String, dynamic>),
      json['status'] as String?,
      json['reason_for_rejection'] as String?,
    );

Map<String, dynamic> _$EmployeesResponseToJson(EmployeesResponse instance) =>
    <String, dynamic>{
      'employees_present': instance.employeesPresent,
      'liability_insurance': instance.liabilityInsurance,
      'insurance_expiry_date': instance.insuranceExpiryDate,
      'image': instance.image,
      'status': instance.status,
      'reason_for_rejection': instance.reasonForRejection,
    };
