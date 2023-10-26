import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/job_item_response.dart';

part 'my_jobs_response.g.dart';

@JsonSerializable()
class MyJobsResponse {
  MyJobsResponse(this.myJobs);

  @JsonKey(name: 'my_jobs')
  final List<JobItemResponse> myJobs;

  factory MyJobsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyJobsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyJobsResponseToJson(this);
}
