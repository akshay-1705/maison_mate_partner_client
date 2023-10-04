import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/image_response.dart';

part 'self_trader_response.g.dart';

@JsonSerializable()
class SelfTraderResponse {
  SelfTraderResponse(
      this.vatNumber, this.dateOfBirth, this.proofOfId, this.proofOfAddress);

  @JsonKey(name: "vat_number", defaultValue: '')
  final String? vatNumber;

  @JsonKey(name: "date_of_birth")
  final int? dateOfBirth;

  @JsonKey(name: "proof_of_id")
  final ImageResponse? proofOfId;

  @JsonKey(name: "proof_of_address")
  final ImageResponse? proofOfAddress;

  factory SelfTraderResponse.fromJson(Map<String, dynamic> json) =>
      _$SelfTraderResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SelfTraderResponseToJson(this);
}
