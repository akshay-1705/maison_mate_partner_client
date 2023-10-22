import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/job_response.dart';

part 'find_jobs_response.g.dart';

@JsonSerializable()
class FindJobsResponse {
  FindJobsResponse(this.nearbyJobs);

  @JsonKey(name: 'nearby_jobs')
  final List<JobResponse> nearbyJobs;

  factory FindJobsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindJobsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FindJobsResponseToJson(this);
}
