import 'package:json_annotation/json_annotation.dart';

part 'payment_response.g.dart';

@JsonSerializable(explicitToJson: true)
class PaymentResponse {
  @JsonKey(name: "job_assignment_id", required: true)
  final int jobAssignmentId;

  @JsonKey(name: "job_completed_at", required: true)
  final String jobCompletedAt;

  @JsonKey(name: "service_name", required: true)
  final String serviceName;

  @JsonKey(name: "total_amount", required: true)
  final double? totalAmount;

  @JsonKey(name: "commission", required: true)
  final int? commission;

  @JsonKey(name: "payment_status", required: true)
  final String? paymentStatus;

  PaymentResponse(
    this.jobAssignmentId,
    this.jobCompletedAt,
    this.serviceName,
    this.totalAmount,
    this.commission,
    this.paymentStatus,
  );

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);
}
