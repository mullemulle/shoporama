import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../form.dart';

class FieldNumber extends ConsumerWidget {
  final String fieldKey;
  final Field field;
  final double? defaultValue;
  final Function(String, dynamic) updateField;
  final Function(String, dynamic, dynamic) validateField;
  final Map<String, String> errors;

  const FieldNumber({super.key, required this.fieldKey, required this.field, required this.defaultValue, required this.updateField, required this.validateField, required this.errors});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: (defaultValue ?? 0).toString(),
            decoration: InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final result = double.tryParse(value);
              if (result == null) return;
              updateField(fieldKey, result);
              final error = validateField(fieldKey, field, result);
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
