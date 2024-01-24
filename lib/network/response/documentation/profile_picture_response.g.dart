// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_picture_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfilePictureResponse _$ProfilePictureResponseFromJson(
        Map<String, dynamic> json) =>
    ProfilePictureResponse(
      ImageResponse.fromJson(json['image'] as Map<String, dynamic>),
      json['status'] as String?,
      json['reason_for_rejection'] as String?,
    );

Map<String, dynamic> _$ProfilePictureResponseToJson(
        ProfilePictureResponse instance) =>
    <String, dynamic>{
      'image': instance.image.toJson(),
      'status': instance.status,
      'reason_for_rejection': instance.reasonForRejection,
    };
