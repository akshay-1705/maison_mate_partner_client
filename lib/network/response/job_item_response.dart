import 'package:json_annotation/json_annotation.dart';

part 'job_item_response.g.dart';

@JsonSerializable()
class JobItemResponse {
  JobItemResponse(this.id, this.serviceName, this.kind, this.address,
      this.statusToShow, this.statusToSearch);

  @JsonKey()
  final int? id;

  @JsonKey(name: 'service_name', defaultValue: '')
  final String? serviceName;

  @JsonKey(name: 'status_to_show')
  final String? statusToShow;

  @JsonKey(name: 'status_to_search')
  final int? statusToSearch;

  @JsonKey()
  final String? kind;

  @JsonKey()
  final String? address;

  factory JobItemResponse.fromJson(Map<String, dynamic> json) =>
      _$JobItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JobItemResponseToJson(this);
}
