import 'package:json_annotation/json_annotation.dart';

part 'partner.g.dart';

@JsonSerializable(explicitToJson: true)
class Partner {
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

  Partner(
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.createdAt,
    this.updatedAt,
  );

  factory Partner.fromJson(Map<String, dynamic> json) =>
      _$PartnerFromJson(json);
  Map<String, dynamic> toJson() => _$PartnerToJson(this);
}
