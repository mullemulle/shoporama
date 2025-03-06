import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';

class FieldToggle extends StatelessWidget {
  final String fieldKey;
  final dynamic field;
  final bool? defaultValue;
  final Function(String, dynamic) updateField;
  final Function(String, dynamic, dynamic) validateField;
  final Map<String, String> errors;

  const FieldToggle({super.key, required this.fieldKey, required this.field, required this.defaultValue, required this.updateField, required this.validateField, required this.errors});

  @override
  Widget build(BuildContext context) {
    final toggleProvider = StateProvider<bool?>((ref) => defaultValue);

    return SizedBox(
      width: double.infinity,
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(toggleProvider);

          return GFToggle(
            onChanged: (val) {
              ref.read(toggleProvider.notifier).state = val;
              updateField(fieldKey, val);
              final error = validateField(fieldKey, field, val);
              if (error != null) {
                errors[fieldKey] = error;
              } else {
                errors.remove(fieldKey);
              }
            },
            value: state ?? false,
          );
        },
      ),
    );
  }
}
