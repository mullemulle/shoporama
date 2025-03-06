import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FieldSelection extends ConsumerWidget {
  final String fieldKey;
  final dynamic field;
  final String? defaultValue;
  final Function(String, dynamic) updateField;
  final Function(String, dynamic, dynamic) validateField;
  final Map<String, String> errors;

  const FieldSelection({
    super.key,
    required this.fieldKey,
    required this.field,
    required this.defaultValue,
    required this.updateField,
    required this.validateField,
    required this.errors,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<dynamic>(
            value: defaultValue ?? field.value,
            decoration: InputDecoration(
              labelText: fieldKey.tr(),
              border: InputBorder.none,
            ),
            items: (field.selection as List<dynamic>?)?.map((option) {
              return DropdownMenuItem<dynamic>(
                value: option,
                child: Text(option.toString().tr()),
              );
            }).toList(),
            onChanged: (value) {
              updateField(fieldKey, value);
              final error = validateField(fieldKey, field, value);
              if (error != null) {
                errors[fieldKey] = error;
              } else {
                errors.remove(fieldKey);
              }
            },
          ),
        ),
      ],
    );
  }
}
