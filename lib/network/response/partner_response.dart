import 'package:json_annotation/json_annotation.dart';

part 'partner_response.g.dart';

@JsonSerializable(explicitToJson: true)
class PartnerResponse {
  @JsonKey(name: "id", required: true)
  final int id;

  @JsonKey(name: "first_name", required: true)
  final String firstName;

  @JsonKey(name: "last_name", required: true)
  final String lastName;

  @JsonKey(name: "email", required: true)
  final String? email;

  @JsonKey(name: "created_at", required: true)
  final String? createdAt;

  @JsonKey(name: "updated_at", required: true)
  final String? updatedAt;

  PartnerResponse(
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.createdAt,
    this.updatedAt,
  );

  factory PartnerResponse.fromJson(Map<String, dynamic> json) =>
      _$PartnerResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PartnerResponseToJson(this);
}
