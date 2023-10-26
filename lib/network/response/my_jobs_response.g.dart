// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_jobs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyJobsResponse _$MyJobsResponseFromJson(Map<String, dynamic> json) =>
    MyJobsResponse(
      (json['my_jobs'] as List<dynamic>)
          .map((e) => JobItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyJobsResponseToJson(MyJobsResponse instance) =>
    <String, dynamic>{
      'my_jobs': instance.myJobs,
    };
