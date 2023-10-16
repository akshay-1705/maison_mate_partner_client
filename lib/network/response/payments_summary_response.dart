import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/payment_response.dart';

part 'payments_summary_response.g.dart';

@JsonSerializable()
class PaymentsSummaryResponse {
  PaymentsSummaryResponse(this.payments, this.total, this.pending);

  @JsonKey()
  final List<PaymentResponse> payments;

  @JsonKey(defaultValue: 0)
  final int total;

  @JsonKey(defaultValue: 0)
  final int pending;

  factory PaymentsSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentsSummaryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentsSummaryResponseToJson(this);
}
