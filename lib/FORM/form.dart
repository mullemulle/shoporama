import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shortid/shortid.dart';
import 'package:easy_localization/easy_localization.dart';
import '_WIDGET/fields.dart';

part 'form.g.dart';

enum FieldType { hidden, number, selection, string, phone, date, time, datetime, button, toggle, password, mail }

@JsonSerializable()
class Field {
  final FieldType type;
  final String? title;
  final String? helptext;
  final dynamic value;
  final List<String>? validate; // List of validation rules
  final List<dynamic>? selection;
  final bool? multiline;
  final bool? lookup;

  Field({required this.type, this.title, this.helptext, this.value, this.validate, this.selection, this.multiline, this.lookup});

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);
  Map<String, dynamic> toJson() => _$FieldToJson(this);
}

@JsonSerializable()
class FormSchema {
  final Map<String, Field> fields;

  FormSchema({required this.fields});

  factory FormSchema.fromJson(Map<String, dynamic> json) => _$FormSchemaFromJson(json);

  get keys => null;
  Map<String, dynamic> toJson() => _$FormSchemaToJson(this);
}

class DynamicForm extends ConsumerWidget {
  final FormSchema formSchema;
  final Map<String, dynamic>? defaultValues;
  final Function(Map<String, dynamic>) onChanged;
  final Function(String, dynamic) onFieldChanged;
  final dynamic Function(String fieldKey)? onLookup;
  final Function(Map<String, dynamic> values, Map<String, dynamic> defaultValues)? onButtonTap;

  DynamicForm({super.key, required this.formSchema, this.defaultValues, required this.onChanged, required this.onFieldChanged, this.onLookup, this.onButtonTap});

  final errorProvider = StateProvider<Map<String, String>>((ref) => {});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formValues = defaultValues ?? {};

    void updateField(String key, dynamic value) {
      formValues[key] = value;
      onChanged(formValues);
      onFieldChanged(key, value);
    }

    String? validateField(String key, Field field, dynamic value) {
      if (field.validate != null) {
        for (var rule in field.validate!) {
          if (rule == 'afternow' && value != null) {
            final inputDate = DateTime.tryParse(value);
            if (inputDate != null && inputDate.isAfter(DateTime.now().add(Duration(minutes: 10)))) {
              return tr('date_be_after');
            }
          } else if (rule == 'afternow' && value != null) {
            final inputDate = DateTime.tryParse(value);
            if (inputDate != null && inputDate.isBefore(DateTime.now())) {
              return tr('date_be_before');
            }
          } else if (rule == 'number' && value != null && !RegExp(r'^\d+$').hasMatch(value)) {
            return tr('number');
          } else if (rule == 'mandatory' && (value == null)) {
            return tr('mandatory');
          } else if (rule.startsWith('minLength:')) {
            final minLength = int.parse(rule.split(':')[1]);
            if (value != null && value.length < minLength) {
              return '${tr('minimun_length')} $minLength';
            }
          }
        }
      }

      return null;
    }

    void validateAllFields() {
      final ref = ProviderScope.containerOf(context);

      final oldErrors = ref.read(errorProvider.notifier).state;

      final Map<String, String> errors = {};
      formSchema.fields.forEach((key, field) {
        try {
          final error = validateField(key, field, formValues[key]);
          if (error != null) {
            errors[key] = error;
          }
        } catch (_) {}
      });
      onChanged(formValues);

      if (oldErrors.keys != errors.keys) ref.read(errorProvider.notifier).state = errors;

      if (errors.isEmpty && onButtonTap != null) onButtonTap!(formValues, {});
    }

    List<Widget> buildFields() {
      return formSchema.fields.entries.map((entry) {
        final fieldKey = entry.key;
        final field = entry.value;

        if ((field.validate ?? []).contains('hidden')) return Container();

        if (field.type == FieldType.button) {
          return Fields(
            fieldType: field.type,
            fieldKey: fieldKey,
            field: field,
            formValues: formValues,
            updateField: updateField,
            validateField: (key, __, ___) {
              validateAllFields();
              onFieldChanged(fieldKey, formValues);
            },
            errors: {},
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            decoration: field.type == FieldType.toggle ? null : BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12.0), color: Colors.grey.shade50),
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (field.title != null && field.type != FieldType.string) Text(field.title!.tr(), style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
                Consumer(
                  builder: (context, ref, child) {
                    final errors = ref.watch(errorProvider);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Fields(
                          fieldType: field.type,
                          fieldKey: fieldKey,
                          field: field,
                          formValues: formValues,
                          updateField: updateField,
                          validateField: (key, field, value) => validateField(key, field, value),
                          errors: errors,
                          onLookup: (value) async => await onLookup!(value),
                        ),
                        if (field.helptext != null) Text(field.helptext!.tr(), style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
                        if (errors.containsKey(fieldKey)) Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(errors[fieldKey]!, style: const TextStyle(color: Colors.red, fontSize: 12.0))),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }).toList();
    }

    return Form(child: Column(children: [...buildFields()]));
  }
}

// Example usage of DynamicForm
final formSchema = FormSchema.fromJson({
  "fields": {
    "id": {"type": "hidden", "value": shortid.generate()},
    "date": {
      "type": "datetime",
      "helptext": "Påfyldningsdato",
      "value": null,
      "validate": ["mandatory"],
    },
    "numberOfBags": {
      "type": "number",
      "value": "0",
      "validate": ["mandatory", "number"],
    },
    "siloState": {
      "type": "selection",
      "value": tr('#statistic.edit.siloStateSelection.none'),
      "selection": [tr('#statistic.edit.siloStateSelection.none'), tr('#statistic.edit.siloStateSelection.full'), tr('#statistic.edit.siloStateSelection.empty')],
      "validate": ["mandatory"],
    },
    "description": {
      "type": "string",
      "helptext": "Evt. tekst",
      "value": null,
      "validate": ["mandatory", "minLength:4"],
    },
    "submit": {
      "type": "button",
      "helptext": "Send ind",
      "value": null,
      "validate": ["mandatory"],
    },
  },
});
