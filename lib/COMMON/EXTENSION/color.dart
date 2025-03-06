import 'package:flutter/material.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  Color darkenColor([double percent = 10]) {
    // Beregn ny RGB-værdi baseret på den procentværdi, der er angivet
    double factor = percent / 100.0;
    int red = (this.red * (1 - factor)).round();
    int green = (this.green * (1 - factor)).round();
    int blue = (this.blue * (1 - factor)).round();

    // Kontroller, at værdierne forbliver inden for det acceptable interval
    red = red.clamp(0, 255);
    green = green.clamp(0, 255);
    blue = blue.clamp(0, 255);

    // Returner den nye farve
    return Color.fromRGBO(red, green, blue, 1);
  }

  Color lightenColor([double percent = 10]) {
    // Beregn ny RGB-værdi baseret på den procentværdi, der er angivet
    double factor = percent / 100.0;
    int red = (this.red + ((255 - this.red) * factor)).round();
    int green = (this.green + ((255 - this.green) * factor)).round();
    int blue = (this.blue + ((255 - this.blue) * factor)).round();

    // Kontroller, at værdierne forbliver inden for det acceptable interval
    red = red.clamp(0, 255);
    green = green.clamp(0, 255);
    blue = blue.clamp(0, 255);

    // Returner den nye farve
    return Color.fromRGBO(red, green, blue, 1);
  }
}

class HexColorHandler extends Color {
  HexColorHandler._(super.value);

  static int? _buildColorIntFromHex(String input) {
    final buffer = StringBuffer();
    if (input.length == 6 || input.length == 7) buffer.write('ff');
    buffer.write(input.replaceFirst('#', ''));

    final strColor = buffer.toString();
    if (strColor == "00000000") {
      return Colors.transparent.value;
    }

    return Color(int.parse(strColor, radix: 16)).value;
/*
    const int base = 16;

    String normalized = input.replaceFirst('#', '').toUpperCase();

    if (normalized.length < 3) {
      return null;
    }

    final String r = '${normalized[0]}${normalized[0]}';
    final String g = '${normalized[1]}${normalized[1]}';
    final String b = '${normalized[2]}${normalized[2]}';
    final String a = '${normalized[3]}${normalized[3]}';

    if (normalized.length == 3) {
      // Example: f00 => ff0000 => Red, 100 % Alpha
      return int.tryParse('FF$r$g$b', radix: base);
    }

    if (normalized.length == 4) {
      // Example: f00f => ff0000ff => Red, 100 % Alpha
      final String a = '${normalized[3]}${normalized[3]}';
      return int.tryParse('$r$g$b$a', radix: base);
    } else if (normalized.length == 6) {
      // Example: ff0000 => Rot, Red % Alpha
      normalized = 'FF$normalized';
    } else if (normalized.length == 8) {
      // Example: ff0000 => Rot, Red % Alpha
      normalized = '$a$normalized';
    }

    // Example: ffff0000 => Red, 100 % Alpha
    return int.tryParse(normalized, radix: base);*/
  }

  factory HexColorHandler(final String hexColorText) {
    int? hexColor = _buildColorIntFromHex(hexColorText);

    if (hexColor == null) {
      throw HexColorParseException();
    }

    /* if (hexColorText == "#00000000") {
      return HexColorHandler._(Colors.transparent.value);
    } //._(Colors.transparent);*/

    return HexColorHandler._(hexColor);
  }
}

class HexColorParseException implements Exception {}
