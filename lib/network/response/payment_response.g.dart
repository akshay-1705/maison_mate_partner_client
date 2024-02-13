// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'job_assignment_id',
      'job_completed_at',
      'service_name',
      'total_amount',
      'commission',
      'payment_status'
    ],
  );
  return PaymentResponse(
    json['job_assignment_id'] as int,
    json['job_completed_at'] as String,
    json['service_name'] as String,
    (json['total_amount'] as num?)?.toDouble(),
    json['commission'] as int?,
    json['payment_status'] as String?,
  );
}

Map<String, dynamic> _$PaymentResponseToJson(PaymentResponse instance) =>
    <String, dynamic>{
      'job_assignment_id': instance.jobAssignmentId,
      'job_completed_at': instance.jobCompletedAt,
      'service_name': instance.serviceName,
      'total_amount': instance.totalAmount,
      'commission': instance.commission,
      'payment_status': instance.paymentStatus,
    };
