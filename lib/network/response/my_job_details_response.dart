import 'package:json_annotation/json_annotation.dart';

part 'my_job_details_response.g.dart';

@JsonSerializable()
class MyJobDetailsResponse {
  MyJobDetailsResponse(
      this.id,
      this.serviceName,
      this.kind,
      this.latitude,
      this.longitude,
      this.address,
      this.details,
      this.userName,
      this.userId,
      this.status,
      this.acceptedAt);

  @JsonKey()
  final int? id;

  @JsonKey(name: 'service_name', defaultValue: '')
  final String? serviceName;

  @JsonKey(name: 'user_name', defaultValue: '')
  final String? userName;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(defaultValue: '')
  final String? kind;

  @JsonKey()
  final double? latitude;

  @JsonKey()
  final double? longitude;

  @JsonKey(defaultValue: '')
  final String? address;

  @JsonKey(defaultValue: '')
  final String? details;

  @JsonKey()
  final String? status;

  @JsonKey(name: 'accepted_at')
  final int? acceptedAt;

  factory MyJobDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyJobDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyJobDetailsResponseToJson(this);
}
