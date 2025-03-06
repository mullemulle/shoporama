import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field2/intl_phone_field.dart';

class FieldPhone extends ConsumerWidget {
  final String fieldKey;
  final dynamic field;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) updateField;
  final Function(String, dynamic, dynamic) validateField;
  final Map<String, String> errors;

  const FieldPhone({super.key, 
    required this.fieldKey,
    required this.field,
    required this.formValues,
    required this.updateField,
    required this.validateField,
    required this.errors,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countryCode = WidgetsBinding.instance.platformDispatcher.locale.countryCode;
    final languageCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;

    return IntlPhoneField(
      initialValue: formValues[fieldKey] ?? field.value,
      initialCountryCode: countryCode,
      languageCode: languageCode,
      decoration: InputDecoration(
        labelText: fieldKey.tr(),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      ),
      onChanged: (value) {
        updateField(fieldKey, value.completeNumber);
        final error = validateField(fieldKey, field, value.completeNumber);
        if (error != null) {
          errors[fieldKey] = error;
        } else {
          errors.remove(fieldKey);
        }
      },
    );
  }
}
