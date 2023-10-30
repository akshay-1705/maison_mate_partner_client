import 'package:json_annotation/json_annotation.dart';

part 'job_response.g.dart';

@JsonSerializable()
class JobResponse {
  JobResponse(
    this.id,
    this.serviceName,
    this.kind,
    this.distance,
  );

  @JsonKey()
  final int? id;

  @JsonKey(name: 'service_name', defaultValue: '')
  final String? serviceName;

  @JsonKey(defaultValue: '')
  final String? distance;

  @JsonKey()
  final String? kind;

  factory JobResponse.fromJson(Map<String, dynamic> json) =>
      _$JobResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JobResponseToJson(this);
}
