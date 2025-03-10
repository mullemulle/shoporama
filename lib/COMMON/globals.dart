import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'default.dart';
import 'package.dart';

class GlobalValues {
  final Map<String, dynamic> map;
  final Map<String, dynamic> accountMap = {};
  int lastAccountMapHash = 0;
  final Map<String, dynamic> openMap = {};
  GlobalValues({required this.map});

  EdgeInsets screenPadding = const EdgeInsets.only(left: 20, right: 20);

  Map<String, dynamic> getMap(Map<String, String>? account) {
    final newHash = accountMap.hashCode + (account?.hashCode ?? 0);
    if (accountMap.isEmpty || newHash != lastAccountMapHash) {
      accountMap.clear();
      accountMap
        ..addAll(map)
        ..addAll(account ?? {});

      lastAccountMapHash = newHash;
    }

    return accountMap;
  }

  ColorConverter color(Map<String, String>? account) {
    return ColorConverter(getMap(account));
  }

  DecorationConverter decoration(Map<String, String>? account) {
    return DecorationConverter(getMap(account));
  }

  PaddingConverter padding(Map<String, String>? account) {
    return PaddingConverter(getMap(account));
  }

  TextStyleConverter textStyle(Map<String, String>? account) {
    return TextStyleConverter(getMap(account));
  }

  FontConverter font(Map<String, String>? account) {
    return FontConverter(getMap(account));
  }

  dynamic value(Map<String, String>? account) {
    return DynamicConverter(getMap(account));
  }

  Map<String, dynamic> rawPropertyStandard(Map<String, String>? account) {
    return getMap(account)['property']!['standard'];
  }

  Map<String, dynamic> raw() {
    return map;
  }

  MarkdownStyleSheet defaultMarkdownStyle({required GlobalValues defaults, Color? fixedColor}) {
    TextStyle markdowntitlefont = defaults.textStyle(null).get('markdowntitlefont');
    TextStyle markdownsubtitlefont = defaults.textStyle(null).get('markdownsubtitlefont');
    TextStyle markdowntextfont = defaults.textStyle(null).get('markdowntextfont');
    if (fixedColor != null) {
      markdowntitlefont = markdowntitlefont.copyWith(color: fixedColor);
      markdownsubtitlefont = markdownsubtitlefont.copyWith(color: fixedColor);
      markdowntextfont = markdowntextfont.copyWith(color: fixedColor);
    }

    return MarkdownStyleSheet(
      h1: markdowntitlefont,
      h2: markdownsubtitlefont,
      h3: markdowntextfont,
      h4: markdowntextfont,
      p: markdowntextfont,
      a: markdowntextfont.copyWith(color: markdowntextfont.color?.lightenColor(50)),
      listBullet: markdowntextfont,
    );
  }
}

class FontConverter {
  final Map<String, dynamic> map;
  FontConverter(this.map);

  FontModel get(String key) {
    return map['font'].containsKey(key) ? FontModel.fromJson(map['font'][key]) : FontModel(fontname: "Lato", color: Colors.amberAccent.toHex());
  }
}

class TextStyleConverter {
  final Map<String, dynamic> map;
  TextStyleConverter(this.map);

  TextStyle get(String key) {
    var thisMap = map['font'][key];
    if (thisMap is TextStyle) return thisMap;

    map['font'][key] = (thisMap != null ? FontModel.fromJson(thisMap) : FontModel(fontname: "Lato", color: Colors.pink.toHex())).asStyle(); //const Color.fromARGB(255, 63, 82, 120)
    return map['font'][key];
  }

  static TextStyle? convert(Map<String, dynamic>? thisMap) {
    return (thisMap != null && thisMap.isNotEmpty ? FontModel.fromJson(thisMap) : FontModel(fontname: "Lato", color: Colors.pink.toHex())).asStyle(); //const Color.fromARGB(255, 63, 82, 120)
  }
}

class ColorConverter {
  final Map<String, dynamic> map;
  ColorConverter(this.map);

  Color get(String key) {
    return map['color'].containsKey(key) ? HexColorHandler(map['color'][key]) : Colors.white;
  }
}

class DecorationConverter {
  final Map<String, dynamic> map;
  DecorationConverter(this.map);

  BoxDecoration? get(String key) {
    var thisMap = map['decoration'][key];
    if (thisMap == null) return null;
    if (thisMap is BoxDecoration) return thisMap;

    final color = HexColorHandler(thisMap['color']);
    final border = Border.all(color: color);
    final double borderRadius = double.parse('${thisMap['radius'] ?? 5}');

    final backgroundcolor = HexColorHandler(thisMap['backgroundcolor'] ?? "#00000000");

    map['decoration'][key] = BoxDecoration(border: border, borderRadius: BorderRadius.circular(borderRadius), color: backgroundcolor);

    return map['decoration'][key];
  }
}

class PaddingConverter {
  final Map<String, dynamic> map;
  PaddingConverter(this.map);

  EdgeInsets? get(String key) {
    var thisMap = map['padding'][key];
    if (thisMap == null) return null;
    if (thisMap is EdgeInsets) return thisMap;

    map['padding'][key] = EdgeInsets.only(left: double.parse('${thisMap['left'] ?? 0}'), right: double.parse('${thisMap['right'] ?? 0}'), top: double.parse('${thisMap['top'] ?? 0}'), bottom: double.parse('${thisMap['bottom'] ?? 0}'));

    return map['padding'][key];
  }
}

class DynamicConverter {
  final Map<String, dynamic> map;
  DynamicConverter(this.map);

  dynamic get(String key) {
    return map['value'].containsKey(key) ? map['value'][key] : null;
  }
}

final shadow = [
  const Shadow(blurRadius: 10.0, color: Colors.white, offset: Offset(0, 0)),
  const Shadow(blurRadius: 10.0, color: Colors.white, offset: Offset(-1, 0)),
  const Shadow(blurRadius: 10.0, color: Colors.white, offset: Offset(1, 0)),
  const Shadow(blurRadius: 10.0, color: Colors.white, offset: Offset(0, -1)),
  const Shadow(blurRadius: 10.0, color: Colors.white, offset: Offset(0, 1)),
];

const shadowTransparentColor = Color.fromARGB(150, 255, 255, 255);
final shadowTransparent = [
  const Shadow(blurRadius: 10.0, color: shadowTransparentColor, offset: Offset(0, 0)),
  const Shadow(blurRadius: 10.0, color: shadowTransparentColor, offset: Offset(-1, 0)),
  const Shadow(blurRadius: 10.0, color: shadowTransparentColor, offset: Offset(1, 0)),
  const Shadow(blurRadius: 10.0, color: shadowTransparentColor, offset: Offset(0, -1)),
  const Shadow(blurRadius: 10.0, color: shadowTransparentColor, offset: Offset(0, 1)),
];
