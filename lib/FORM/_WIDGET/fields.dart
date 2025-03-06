import 'package:easy_localization/easy_localization.dart' show tr;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../form.dart';
import 'field_button.dart';
import 'field_number.dart';
import 'field_selection.dart';
import 'field_datetime.dart';
import 'field_string.dart';
import 'field_phone.dart';
import 'field_toggle.dart';

class Fields extends ConsumerWidget {
  final FieldType fieldType;
  final String fieldKey;
  final Field field;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) updateField;
  final Function(String, dynamic, dynamic) validateField;
  final Future<dynamic> Function(String)? onLookup;
  final Map<String, String> errors;

  const Fields({super.key, required this.fieldType, required this.fieldKey, required this.field, required this.formValues, required this.updateField, required this.validateField, this.onLookup, required this.errors});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (fieldType) {
      case FieldType.number:
        return FieldNumber(fieldKey: fieldKey, field: field, defaultValue: formValues[fieldKey], updateField: updateField, validateField: validateField, errors: errors);
      case FieldType.selection:
        return FieldSelection(fieldKey: fieldKey, field: field, defaultValue: formValues[fieldKey], updateField: updateField, validateField: validateField, errors: errors);
      case FieldType.datetime:
        return FieldDateTime(
          pickerType: PickerType.dateTime,
          fieldKey: fieldKey,
          field: field,
          defaultValue: formValues[fieldKey] is DateTime ? formValues[fieldKey] : DateTime.parse(formValues[fieldKey] ?? DateTime.now().toString()),
          updateField: updateField,
          validateField: validateField,
          errors: errors,
        );
      case FieldType.date:
        return FieldDateTime(pickerType: PickerType.date, fieldKey: fieldKey, field: field, defaultValue: formValues[fieldKey], updateField: updateField, validateField: validateField, errors: errors);
      case FieldType.time:
        return FieldDateTime(pickerType: PickerType.time, fieldKey: fieldKey, field: field, defaultValue: formValues[fieldKey], updateField: updateField, validateField: validateField, errors: errors);
      case FieldType.password:
      case FieldType.mail:
      case FieldType.string:
        return FieldString(
          enabled: !((field.lookup ?? false) && (field.validate ?? []).contains('lookupOnly')),
          textInputType: switch (fieldType) {
            FieldType.password => TextInputType.visiblePassword,
            _ => TextInputType.text,
          },
          fieldKey: fieldKey,
          field: field,
          defaultValue: formValues[fieldKey],
          updateField: updateField,
          validateField: validateField,
          errors: errors,
          onLookup: (value) async => await onLookup!(value),
        );
      case FieldType.phone:
        return FieldPhone(fieldKey: fieldKey, field: field, formValues: formValues, updateField: updateField, validateField: validateField, errors: errors);
      case FieldType.button:
        return FieldButton(fieldKey: fieldKey, label: field.title ?? tr('Send'), onButtonTap: validateField);
      case FieldType.toggle:
        return FieldToggle(fieldKey: fieldKey, field: field, defaultValue: formValues[fieldKey], updateField: updateField, validateField: validateField, errors: errors);
      default:
        return Container();
    }
  }
}
