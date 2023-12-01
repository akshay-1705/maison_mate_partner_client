import 'package:json_annotation/json_annotation.dart';

part 'receipt_item_response.g.dart';

@JsonSerializable()
class ReceiptItemResponse {
  ReceiptItemResponse(this.category, this.price);

  @JsonKey()
  final String category;

  @JsonKey()
  final double price;

  factory ReceiptItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptItemResponseToJson(this);
}
