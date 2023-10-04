import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/section_status_response.dart';

part 'documentation_response.g.dart';

@JsonSerializable(explicitToJson: true)
class DocumentationResponse {
  @JsonKey(name: "is_limited", defaultValue: false)
  final bool isLimited;

  SectionStatusResponse status;

  DocumentationResponse(this.status, this.isLimited);
  factory DocumentationResponse.fromJson(Map<String, dynamic> json) =>
      _$DocumentationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentationResponseToJson(this);
}
