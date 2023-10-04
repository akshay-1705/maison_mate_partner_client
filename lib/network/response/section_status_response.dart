import 'package:json_annotation/json_annotation.dart';

part 'section_status_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SectionStatusResponse {
  SectionStatusResponse(this.banking, this.insurance, this.employees,
      this.profilePicture, this.healthAndSafety);

  @JsonKey(name: "banking")
  final String? banking;

  @JsonKey(name: "insurance")
  final String? insurance;

  @JsonKey(name: "employees")
  final String? employees;

  @JsonKey(name: "profile_picture")
  final String? profilePicture;

  @JsonKey(name: "health_and_safety")
  final String? healthAndSafety;

  factory SectionStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$SectionStatusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SectionStatusResponseToJson(this);
}
