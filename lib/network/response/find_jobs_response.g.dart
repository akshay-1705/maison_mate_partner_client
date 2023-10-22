// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_jobs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindJobsResponse _$FindJobsResponseFromJson(Map<String, dynamic> json) =>
    FindJobsResponse(
      (json['nearby_jobs'] as List<dynamic>)
          .map((e) => JobResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FindJobsResponseToJson(FindJobsResponse instance) =>
    <String, dynamic>{
      'nearby_jobs': instance.nearbyJobs,
    };
