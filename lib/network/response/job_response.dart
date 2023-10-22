import 'package:json_annotation/json_annotation.dart';

part 'job_response.g.dart';

@JsonSerializable()
class JobResponse {
  JobResponse(this.id, this.serviceName, this.amount, this.distance,
      this.completionDate);

  @JsonKey()
  final int? id;

  @JsonKey(name: 'service_name', defaultValue: '')
  final String? serviceName;

  @JsonKey(defaultValue: '')
  final String? amount;

  @JsonKey(defaultValue: '')
  final String? distance;

  @JsonKey(name: 'completion_date')
  final int? completionDate;

  factory JobResponse.fromJson(Map<String, dynamic> json) =>
      _$JobResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JobResponseToJson(this);
}
