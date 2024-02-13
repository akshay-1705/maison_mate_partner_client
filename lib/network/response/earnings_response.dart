import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/payment_response.dart';

part 'earnings_response.g.dart';

@JsonSerializable()
class EarningsResponse {
  EarningsResponse(this.payments, this.totalEarnings, this.totalCommission,
      this.partnerShare);

  @JsonKey()
  final List<PaymentResponse> payments;

  @JsonKey(name: "total_earnings")
  final double? totalEarnings;

  @JsonKey(name: "total_commission")
  final double? totalCommission;

  @JsonKey(name: "partner_share")
  final double? partnerShare;

  factory EarningsResponse.fromJson(Map<String, dynamic> json) =>
      _$EarningsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EarningsResponseToJson(this);
}
