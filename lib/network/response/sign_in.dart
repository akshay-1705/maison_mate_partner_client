import 'package:json_annotation/json_annotation.dart';

import 'package:maison_mate/network/response/partner.dart';

part 'sign_in.g.dart';

@JsonSerializable(explicitToJson: true)
class SignIn {
  SignIn(this.token, this.partner);

  String token;
  Partner partner;

  factory SignIn.fromJson(Map<String, dynamic> json) => _$SignInFromJson(json);
  Map<String, dynamic> toJson() => _$SignInToJson(this);
}
