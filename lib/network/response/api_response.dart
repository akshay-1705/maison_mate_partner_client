import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/sign_in.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse<T> {
  bool success;
  String message;
  @_Converter()
  T data;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}

class _Converter<T> implements JsonConverter<T, Object> {
  const _Converter();

  @override
  T fromJson(Object json) {
    final map = json as Map<String, dynamic>;
    if (map.containsKey('partner') && map.containsKey('token')) {
      return SignIn.fromJson(map) as T;
    } else {
      return map as T;
    }
  }

  @override
  Object toJson(T object) {
    return T;
  }
}
