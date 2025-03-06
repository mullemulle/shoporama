import 'package:json_annotation/json_annotation.dart';

part 'supplier_model.g.dart';

@JsonSerializable()
class Supplier {
  @JsonKey(name: 'supplier_id')
  final String supplierId;
  @JsonKey(name: 'is_removed')
  final String isRemoved;
  final String name;
  @JsonKey(name: 'link_to')
  final String? linkTo;
  @JsonKey(name: 'dropshipping_mail')
  final String? dropshippingMail;

  Supplier({required this.supplierId, required this.isRemoved, required this.name, this.linkTo, this.dropshippingMail});

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierToJson(this);
}
