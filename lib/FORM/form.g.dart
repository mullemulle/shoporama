// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Field _$FieldFromJson(Map<String, dynamic> json) => Field(
  type: $enumDecode(_$FieldTypeEnumMap, json['type']),
  title: json['title'] as String?,
  helptext: json['helptext'] as String?,
  value: json['value'],
  validate:
      (json['validate'] as List<dynamic>?)?.map((e) => e as String).toList(),
  selection: json['selection'] as List<dynamic>?,
  multiline: json['multiline'] as bool?,
  lookup: json['lookup'] as bool?,
);

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
  'type': _$FieldTypeEnumMap[instance.type]!,
  'title': instance.title,
  'helptext': instance.helptext,
  'value': instance.value,
  'validate': instance.validate,
  'selection': instance.selection,
  'multiline': instance.multiline,
  'lookup': instance.lookup,
};

const _$FieldTypeEnumMap = {
  FieldType.hidden: 'hidden',
  FieldType.number: 'number',
  FieldType.selection: 'selection',
  FieldType.string: 'string',
  FieldType.phone: 'phone',
  FieldType.date: 'date',
  FieldType.time: 'time',
  FieldType.datetime: 'datetime',
  FieldType.button: 'button',
  FieldType.toggle: 'toggle',
  FieldType.password: 'password',
  FieldType.mail: 'mail',
};

FormSchema _$FormSchemaFromJson(Map<String, dynamic> json) => FormSchema(
  fields: (json['fields'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, Field.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$FormSchemaToJson(FormSchema instance) =>
    <String, dynamic>{'fields': instance.fields};
