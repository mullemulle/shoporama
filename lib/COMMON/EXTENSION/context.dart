import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'dart:math' as math;

ScreenSettings? screenSettings;

extension ScreenSetting on BuildContext {
  ScreenSettings setting({Map<String, dynamic>? properties, bool force = false}) {
    final context = this;

    if (force) {
      var size = MediaQuery.of(context);
      return ScreenSettings(size, properties);
    }
    if (screenSettings != null) return screenSettings!;

    var size = MediaQuery.of(context);
    screenSettings = ScreenSettings(size, properties);
    return screenSettings!;
  }
}

class ScreenSettings {
  // Screen
  late double width;
  late double height;
  late double columnWidth;
  late double perfferedItemWidth;
  final double outerPadding = 10;
  late bool isWebMobile;
  late bool useMobileLayout;
  double marginBottom = 0;
  double paddingTop = 0;
  double paddingBottom = 0;
  double paddingLeft = 0;
  double paddingRight = 0;
  double marginSafeTop = 0;
  double viewInsetsBottom = 0;

  // SideSheet
  late double widthSideSheet;

  ScreenSettings(MediaQueryData media, Map<String, dynamic>? props) {
    width = media.size.width;
    height = media.size.height;

    if (props != null) {
      marginBottom = double.parse(props['margin_bottom'] ?? '0.0');
      paddingTop = double.parse(props['padding_top'] as String? ?? '0.0');
      paddingBottom = double.parse(props['padding_bottom'] as String? ?? '0.0');
      paddingLeft = double.parse(props['padding_left'] as String? ?? '0.0');
      paddingRight = double.parse(props['padding_right'] as String? ?? '0.0');
    }

    useMobileLayout = media.size.shortestSide < 1000;
    isWebMobile = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) || useMobileLayout;

    if (useMobileLayout) marginSafeTop = 40; //media.padding.top;

    final double cw = math.min(1300, width);
    columnWidth = (width / cw < 1.2 ? width : cw) - paddingLeft + paddingRight;

    final double piw = columnWidth * 0.8;
    perfferedItemWidth = columnWidth / piw < 1.2 ? columnWidth : piw;

    final double wss = math.max(500, width * 0.3);
    widthSideSheet = width / wss < 1.2 ? width : wss;

    viewInsetsBottom = media.viewInsets.bottom;
  }

  double splitColumnWidth(int split, {int spacing = 0}) {
    return (columnWidth - (spacing * split)) / split;
  }
}
