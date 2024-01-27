import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/image_response.dart';

part 'contract_response.g.dart';

@JsonSerializable()
class ContractResponse {
  ContractResponse(
      this.signature, this.document, this.status, this.reasonForRejection);

  @JsonKey(name: 'image')
  final ImageResponse document;

  @JsonKey(defaultValue: '')
  final String? status;

  @JsonKey(defaultValue: '')
  final String? signature;

  @JsonKey(name: "reason_for_rejection", defaultValue: '')
  final String? reasonForRejection;

  factory ContractResponse.fromJson(Map<String, dynamic> json) =>
      _$ContractResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ContractResponseToJson(this);
}
