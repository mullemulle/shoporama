import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

enum PickerType { date, time, dateTime }

class FieldDateTime extends StatelessWidget {
  final String fieldKey;
  final dynamic field;
  final DateTime? defaultValue;
  final Function(String key, DateTime datetime) updateField;
  final Function(String key, dynamic, DateTime datetime) validateField;
  final Map<String, String> errors;
  final PickerType pickerType;

  const FieldDateTime({
    super.key,
    required this.fieldKey,
    required this.field,
    required this.defaultValue,
    required this.updateField,
    required this.validateField,
    required this.errors,
    required this.pickerType,
  });

  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).toString();
    String formattedInitialValue = '';

    final dateTimeProvider = StateProvider<DateTime?>((ref) => defaultValue);
    final ref = ProviderScope.containerOf(context);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              DateTime? selectedDateTime;
              switch (pickerType) {
                case PickerType.date:
                  selectedDateTime = await DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    locale: LocaleType.da,
                  );
                  break;
                case PickerType.time:
                  selectedDateTime = await DatePicker.showTimePicker(
                    context,
                    showTitleActions: true,
                    locale: LocaleType.da,
                  );
                  break;
                case PickerType.dateTime:
                  selectedDateTime = await DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    locale: LocaleType.da,
                  );
                  break;
              }

              if (selectedDateTime != null) {
                ref.read(dateTimeProvider.notifier).state = selectedDateTime;
                updateField(fieldKey, selectedDateTime);
                final error = validateField(fieldKey, field, selectedDateTime);
                if (error != null) {
                  errors[fieldKey] = error;
                } else {
                  errors.remove(fieldKey);
                }
              }
            },
            child: AbsorbPointer(
              child: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(dateTimeProvider);

                  DateTime initialDateTime = state ?? DateTime.now();
                  formattedInitialValue = switch (pickerType) {
                    PickerType.date => DateFormat.yMd(locale).format(initialDateTime),
                    PickerType.time => DateFormat.Hm(locale).format(initialDateTime),
                    PickerType.dateTime => DateFormat.yMd(locale).add_Hm().format(initialDateTime),
                  };

                  return Text(formattedInitialValue, style: TextStyle(color: state == null ? Colors.grey : Colors.black));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
