import 'package:json_annotation/json_annotation.dart';

import 'package:maison_mate/network/response/partner_response.dart';

part 'sign_in_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SignInResponse {
  SignInResponse(this.token, this.partner);

  String token;
  PartnerResponse partner;

  factory SignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);
}
