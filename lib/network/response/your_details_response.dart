import 'package:json_annotation/json_annotation.dart';

part 'your_details_response.g.dart';

@JsonSerializable(explicitToJson: true)
class YourDetailsResponse {
  @JsonKey(name: "first_name", required: true, defaultValue: "")
  final String firstName;

  @JsonKey(name: "last_name", required: true, defaultValue: "")
  final String lastName;

  @JsonKey(name: "email", required: true, defaultValue: "")
  final String? email;

  @JsonKey(name: "postcodes_covered", required: true, defaultValue: [])
  final List<String>? postcodesCovered;

  @JsonKey(name: "postcodes_available", required: true, defaultValue: [])
  final List<String>? postcodesAvailable;

  @JsonKey(name: "phone_number", required: true, defaultValue: "")
  final String? phoneNumber;

  @JsonKey(name: "company_trading_name", required: true, defaultValue: "")
  final String? companyTradingName;

  @JsonKey(name: "company_registered_name", required: true, defaultValue: "")
  final String? companyRegisteredName;

  @JsonKey(name: "is_limited", required: true, defaultValue: false)
  final bool? isLimited;

  @JsonKey(name: "address_details", required: true, defaultValue: "")
  final String? addressDetails;

  @JsonKey(name: "postcode", required: true, defaultValue: "")
  final String? postcode;

  @JsonKey(name: "city", required: true, defaultValue: "")
  final String? city;

  @JsonKey(name: "country", required: true, defaultValue: "")
  final String? country;

  @JsonKey(name: "services_offered", required: true, defaultValue: [])
  final List<String>? servicesOffered;

  @JsonKey(name: "services_available", required: true, defaultValue: [])
  final List<String>? servicesAvailable;

  YourDetailsResponse(
    this.firstName,
    this.lastName,
    this.email,
    this.postcodesCovered,
    this.postcodesAvailable,
    this.phoneNumber,
    this.companyTradingName,
    this.companyRegisteredName,
    this.isLimited,
    this.addressDetails,
    this.postcode,
    this.city,
    this.country,
    this.servicesOffered,
    this.servicesAvailable,
  );

  factory YourDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$YourDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$YourDetailsResponseToJson(this);
}
