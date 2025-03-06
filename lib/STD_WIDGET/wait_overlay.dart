import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../COMMON/package.dart';

class WaitOverlay {
  static Future<T?> waitWith<T>({required BuildContext context, required Future<T> future}) async {
    final analyseStyle = defaults.textStyle(null).get("popup_analyse");

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          const Opacity(
            opacity: 0.7,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
          Center(child: AnalyseWave(text: tr('#analyse'), style: analyseStyle))
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    T? result;
    try {
      result = await future;
    } catch (e) {
      rethrow;
    } finally {
      overlayEntry.remove();
    }

    return result;
  }

  static Future<T> wait<T>(BuildContext context, Future<T> Function() futureTask, {Widget? indicator}) async {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          const Opacity(
            opacity: 0.7,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
          Center(child: SpinKitCircle(color: Colors.amber, size: 50.0))
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    T result;
    try {
      result = await futureTask();
    } catch (e) {
      rethrow;
    } finally {
      overlayEntry.remove();
    }

    return result;
  }

  // TODO static WaitOverlayWidget visual<T>({required Future<T> Function() futureTask, Widget? indicator, required Function(T result) onFinished}) {  }
}

class AnalyseWave extends StatelessWidget {
  final TextStyle? style;
  final String text;
  const AnalyseWave({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return AnimatedContainer(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: 100,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        decoration: BoxDecoration(
          color: style!.backgroundColor!,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitWave(color: style!.color!, size: 20.0),
            const SizedBox(width: 10),
            Text(
              text,
              style: style,
            )
          ],
        ),
      ),
    );
  }
}
