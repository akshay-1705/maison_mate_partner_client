// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'your_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YourDetailsResponse _$YourDetailsResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'first_name',
      'last_name',
      'email',
      'postcodes_covered',
      'postcodes_available',
      'phone_number',
      'company_trading_name',
      'company_registered_name',
      'is_limited',
      'address_details',
      'postcode',
      'city',
      'country',
      'services_offered',
      'services_available',
      'status',
      'reason_for_rejection'
    ],
  );
  return YourDetailsResponse(
    json['first_name'] as String? ?? '',
    json['last_name'] as String? ?? '',
    json['email'] as String? ?? '',
    (json['postcodes_covered'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    (json['postcodes_available'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    json['phone_number'] as String? ?? '',
    json['company_trading_name'] as String? ?? '',
    json['company_registered_name'] as String? ?? '',
    json['is_limited'] as bool? ?? false,
    json['address_details'] as String? ?? '',
    json['postcode'] as String? ?? '',
    json['city'] as String? ?? '',
    json['country'] as String? ?? '',
    (json['services_offered'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    (json['services_available'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    json['status'] as String?,
    json['reason_for_rejection'] as String?,
  );
}

Map<String, dynamic> _$YourDetailsResponseToJson(
        YourDetailsResponse instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'postcodes_covered': instance.postcodesCovered,
      'postcodes_available': instance.postcodesAvailable,
      'phone_number': instance.phoneNumber,
      'company_trading_name': instance.companyTradingName,
      'company_registered_name': instance.companyRegisteredName,
      'is_limited': instance.isLimited,
      'address_details': instance.addressDetails,
      'postcode': instance.postcode,
      'city': instance.city,
      'country': instance.country,
      'services_offered': instance.servicesOffered,
      'services_available': instance.servicesAvailable,
      'status': instance.status,
      'reason_for_rejection': instance.reasonForRejection,
    };
