import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../form.dart';

class FieldString extends ConsumerWidget {
  final String fieldKey;
  final Field field;
  final String? defaultValue;
  final Function(String, dynamic) updateField;
  final Function(String, dynamic, dynamic) validateField;
  final Map<String, String> errors;
  final Future<dynamic> Function(String)? onLookup;
  final bool? enabled;
  final TextInputType? textInputType;

  FieldString({super.key, required this.fieldKey, required this.field, required this.defaultValue, required this.updateField, required this.validateField, required this.errors, this.onLookup, this.enabled = false, this.textInputType});
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: defaultValue);

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: textInputType,
            obscureText: textInputType != null && textInputType == TextInputType.visiblePassword,
            enabled: enabled,
            controller: controller..text = defaultValue ?? '',
            decoration: InputDecoration(labelText: field.title, border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
            maxLines: field.multiline == true ? null : 1,
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
        if (onLookup != null && field.lookup == true)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await onLookup!(fieldKey);
              if (result != null) {
                controller.text = result.toString();
                updateField(fieldKey, result.toString());
              }
            },
          ),
      ],
    );
  }
}
