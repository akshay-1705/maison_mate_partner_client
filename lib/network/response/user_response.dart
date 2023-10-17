import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
  UserResponse(this.id, this.name, this.openJobs);

  @JsonKey()
  final int? id;

  @JsonKey(defaultValue: '')
  final String? name;

  @JsonKey(name: 'open_jobs')
  final int? openJobs;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
