import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/chat_response.dart';
import 'package:maison_mate/network/response/documentation/banking_response.dart';
import 'package:maison_mate/network/response/documentation/contract_response.dart';
import 'package:maison_mate/network/response/documentation/employees_response.dart';
import 'package:maison_mate/network/response/documentation/health_and_safety_response.dart';
import 'package:maison_mate/network/response/documentation/documentation_response.dart';
import 'package:maison_mate/network/response/documentation/profile_picture_response.dart';
import 'package:maison_mate/network/response/documentation/self_trader_response.dart';
import 'package:maison_mate/network/response/earnings_response.dart';
import 'package:maison_mate/network/response/favourites_response.dart';
import 'package:maison_mate/network/response/find_jobs_response.dart';
import 'package:maison_mate/network/response/get_quote_response.dart';
import 'package:maison_mate/network/response/image_response.dart';
import 'package:maison_mate/network/response/documentation/insurance_response.dart';
import 'package:maison_mate/network/response/my_job_details_response.dart';
import 'package:maison_mate/network/response/my_jobs_response.dart';
import 'package:maison_mate/network/response/nearby_job_details_response.dart';
import 'package:maison_mate/network/response/onboarding_status_response.dart';
import 'package:maison_mate/network/response/profile_details_response.dart';
import 'package:maison_mate/network/response/receipt_response.dart';
import 'package:maison_mate/network/response/sign_in_response.dart';
import 'package:maison_mate/network/response/your_details_response.dart';

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
      return SignInResponse.fromJson(map) as T;
    } else if (map.containsKey('sent') && map.containsKey('received')) {
      return ChatResponse.fromJson(map) as T;
    } else if (map.containsKey('quote')) {
      return GetQuoteResponse.fromJson(map) as T;
    } else if (map.containsKey('service_name') &&
        map.containsKey('latitude') &&
        map.containsKey('longitude') &&
        map.containsKey('accepted_at')) {
      return MyJobDetailsResponse.fromJson(map) as T;
    } else if (map.containsKey('service_name') &&
        map.containsKey('latitude') &&
        map.containsKey('longitude') &&
        map.containsKey('kind')) {
      return NearbyJobDetailsResponse.fromJson(map) as T;
    } else if (map.containsKey('services_available') &&
        map.containsKey('postcodes_available')) {
      return YourDetailsResponse.fromJson(map) as T;
    } else if (map.containsKey('email_verified') && map.containsKey('status')) {
      return OnboardingStatusResponse.fromJson(map) as T;
    } else if (map.containsKey('account_number') &&
        map.containsKey('sort_code')) {
      return BankingResponse.fromJson(map) as T;
    } else if (map.containsKey('two_million_insurance') &&
        map.containsKey('one_million_insurance')) {
      return InsuranceResponse.fromJson(map) as T;
    } else if (map.containsKey('employees_present') &&
        map.containsKey('liability_insurance')) {
      return EmployeesResponse.fromJson(map) as T;
    } else if (map.containsKey('accidents_in_five_years') &&
        map.containsKey('notice_in_five_years')) {
      return HealthAndSafetyResponse.fromJson(map) as T;
    } else if (map.containsKey('image') && map.containsKey('signature')) {
      return ContractResponse.fromJson(map) as T;
    } else if (map.containsKey('image') && map.containsKey('status')) {
      return ProfilePictureResponse.fromJson(map) as T;
    } else if (map.containsKey('image_url') && map.containsKey('image_name')) {
      return ImageResponse.fromJson(map) as T;
    } else if (map.containsKey('section_wise_status') &&
        map.containsKey('hide_insurance')) {
      return DocumentationResponse.fromJson(map) as T;
    } else if (map.containsKey('proof_of_id') &&
        map.containsKey('proof_of_address')) {
      return SelfTraderResponse.fromJson(map) as T;
    } else if (map.containsKey('favourites')) {
      return FavouritesResponse.fromJson(map) as T;
    } else if (map.containsKey('first_name') &&
        map.containsKey('last_name') &&
        map.containsKey('email')) {
      return ProfileDetailsResponse.fromJson(map) as T;
    } else if (map.containsKey('nearby_jobs')) {
      return FindJobsResponse.fromJson(map) as T;
    } else if (map.containsKey('my_jobs')) {
      return MyJobsResponse.fromJson(map) as T;
    } else if (map.containsKey('messages')) {
      return ChatResponse.fromJson(map) as T;
    } else if (map.containsKey('receipt')) {
      return ReceiptResponse.fromJson(map) as T;
    } else if (map.containsKey('payments') &&
        map.containsKey('total_earnings')) {
      return EarningsResponse.fromJson(map) as T;
    } else {
      return map as T;
    }
  }

  @override
  Object toJson(T object) {
    return T;
  }
}
