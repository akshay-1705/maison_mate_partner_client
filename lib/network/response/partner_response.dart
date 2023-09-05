// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'partner_response.g.dart';

@JsonSerializable()
class PartnerResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  final String? email;

  PartnerResponse({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
  });

  factory PartnerResponse.fromJson(Map<String, dynamic> json) =>
      _$PartnerResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PartnerResponseToJson(this);
}
