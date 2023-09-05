// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/partner_response.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final String token;
  final PartnerResponse partner;

  AuthResponse({required this.token, required this.partner});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
