// ignore: must_be_immutable
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class ConfirmButton extends ConsumerWidget {
  final IconData icon;
  final IconData confirmIcon;
  final String? tooltip;
  final double? iconSize;
  final Color? iconColor;
  final Function() onChange;
  ConfirmButton({required this.icon, required this.confirmIcon, required this.onChange, this.iconSize, this.tooltip, this.iconColor, super.key});

  Timer? timer;
  final confirmedProvider = StateProvider((ref) => 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirmed = ref.watch(confirmedProvider);

    if (confirmed == 1) {
      reset(ref);
      return InkWell(
          onTap: () {
            timer!.cancel();
            onChange();
          },
          child: Icon(
            Icons.radio_button_unchecked_sharp,
            size: iconSize ?? 32,
            color: Colors.green,
          ));
    } else {
      return InkWell(onTap: () => ref.read(confirmedProvider.notifier).state = 1, child: Icon(icon, size: iconSize ?? 32, color: iconColor ?? const Color.fromRGBO(200, 200, 200, 1)));
    }
  }

  void reset(WidgetRef ref) {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 2), () {
      ref.read(confirmedProvider.notifier).state = 0;
      timer = null;
    });
  }
}
