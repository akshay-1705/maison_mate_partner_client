import 'package:json_annotation/json_annotation.dart';

part 'payment_response.g.dart';

@JsonSerializable()
class PaymentResponse {
  PaymentResponse(this.serviceName, this.uniqueTransactionReference,
      this.amount, this.status, this.transactionDate);

  @JsonKey(name: 'service_name')
  final String? serviceName;

  @JsonKey(name: 'unique_transaction_reference', defaultValue: '')
  final String? uniqueTransactionReference;

  @JsonKey()
  final String? amount;

  @JsonKey()
  final String? status;

  @JsonKey(name: 'transaction_date', defaultValue: '')
  final String? transactionDate;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);
}
