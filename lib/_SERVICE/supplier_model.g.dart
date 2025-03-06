// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Supplier _$SupplierFromJson(Map<String, dynamic> json) => Supplier(
  supplierId: json['supplier_id'] as String,
  isRemoved: json['is_removed'] as String,
  name: json['name'] as String,
  linkTo: json['link_to'] as String?,
  dropshippingMail: json['dropshipping_mail'] as String?,
);

Map<String, dynamic> _$SupplierToJson(Supplier instance) => <String, dynamic>{
  'supplier_id': instance.supplierId,
  'is_removed': instance.isRemoved,
  'name': instance.name,
  'link_to': instance.linkTo,
  'dropshipping_mail': instance.dropshippingMail,
};
