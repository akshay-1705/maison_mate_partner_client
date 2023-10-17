import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/user_response.dart';

part 'favourites_response.g.dart';

@JsonSerializable()
class FavouritesResponse {
  FavouritesResponse(this.favourites);

  @JsonKey()
  final List<UserResponse> favourites;

  factory FavouritesResponse.fromJson(Map<String, dynamic> json) =>
      _$FavouritesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FavouritesResponseToJson(this);
}
