import 'package:json_annotation/json_annotation.dart';

part 'nearby_job_details_response.g.dart';

@JsonSerializable()
class NearbyJobDetailsResponse {
  NearbyJobDetailsResponse(this.id, this.serviceName, this.kind, this.latitude,
      this.longitude, this.address, this.details, this.userName);

  @JsonKey()
  final int? id;

  @JsonKey(name: 'service_name', defaultValue: '')
  final String? serviceName;

  @JsonKey(name: 'user_name', defaultValue: '')
  final String? userName;

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

  factory NearbyJobDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$NearbyJobDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NearbyJobDetailsResponseToJson(this);
}
