import 'package:json_annotation/json_annotation.dart';
import 'package:maison_mate/network/response/receipt_item_response.dart';

part 'receipt_response.g.dart';

@JsonSerializable()
class ReceiptResponse {
  ReceiptResponse(this.receipt, this.discount, this.paymentStatus);

  @JsonKey()
  final List<ReceiptItemResponse> receipt;

  @JsonKey(defaultValue: false)
  final bool discount;

  @JsonKey(name: "payment_status", required: true)
  final String? paymentStatus;

  factory ReceiptResponse.fromJson(Map<String, dynamic> json) =>
      _$ReceiptResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptResponseToJson(this);
}
