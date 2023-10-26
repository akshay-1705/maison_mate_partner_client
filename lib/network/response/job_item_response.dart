import 'package:json_annotation/json_annotation.dart';

part 'job_item_response.g.dart';

@JsonSerializable()
class JobItemResponse {
  JobItemResponse(this.id, this.serviceName, this.paymentStatus, this.jobStatus,
      this.completionDate);

  @JsonKey()
  final int? id;

  @JsonKey(name: 'service_name', defaultValue: '')
  final String? serviceName;

  @JsonKey(name: 'payment_status')
  final String? paymentStatus;

  @JsonKey(name: 'job_status')
  final String? jobStatus;

  @JsonKey(name: 'completion_date')
  final String? completionDate;

  factory JobItemResponse.fromJson(Map<String, dynamic> json) =>
      _$JobItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JobItemResponseToJson(this);
}
