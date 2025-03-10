import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../START/default.dart';
import '../../STD_WIDGET/package.dart';

class FieldButton extends ConsumerWidget {
  final String fieldKey;
  final String label;
  final Function(String, dynamic, dynamic) onButtonTap;

  FieldButton({super.key, required this.fieldKey, required this.label, required this.onButtonTap});

  final navigationStyle = defaults.textStyle(null).get('property_navigationfont');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DoButton(onTap: () => onButtonTap(fieldKey, null, null), title: label.tr(), style: navigationStyle, constraints: BoxConstraints(minHeight: 50));
  }
}
