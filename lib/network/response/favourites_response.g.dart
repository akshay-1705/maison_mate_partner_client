// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourites_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavouritesResponse _$FavouritesResponseFromJson(Map<String, dynamic> json) =>
    FavouritesResponse(
      (json['favourites'] as List<dynamic>)
          .map((e) => UserResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FavouritesResponseToJson(FavouritesResponse instance) =>
    <String, dynamic>{
      'favourites': instance.favourites,
    };
