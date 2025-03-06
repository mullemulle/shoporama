import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_annotation/json_annotation.dart';

import '../EXTENSION/color.dart';

part 'font_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FontModel {
  String color;
  String backgroundcolor;
  double size;
  String fontname;
  int letterSpacing;
  double? height;
  String? alignment;
  String? sizeInText;
  FontModel({required this.fontname, this.size = 18, this.color = "#ffffffff", this.backgroundcolor = "#000000ff", this.letterSpacing = 1, this.height});

  factory FontModel.fromJson(Map<String, dynamic> json) => _$FontModelFromJson(json);

  Map<String, dynamic> toJson() => _$FontModelToJson(this);

  Color asColor() {
    return color.isEmpty ? Colors.black : HexColorHandler(color);
  }

  Color asBackgroundcolor() {
    return color.isEmpty ? Colors.black : HexColorHandler(backgroundcolor);
  }

  TextStyle asStyle() {
    return GoogleFonts.getFont(fontname, fontSize: size, fontWeight: FontWeight.bold, backgroundColor: HexColorHandler(backgroundcolor), color: asColor(), letterSpacing: 1, height: height);
  }

  FontModel copyWith({String? color, String? backgroundcolor, double? size, String? fontname, int? letterSpacing, double? height, String? alignment, String? sizeInText}) {
    return FontModel(
        fontname: fontname ?? this.fontname,
        color: color ?? this.color,
        backgroundcolor: backgroundcolor ?? this.backgroundcolor,
        size: size ?? this.size,
        letterSpacing: letterSpacing ?? this.letterSpacing,
        height: height ?? this.height,
      )
      ..alignment = alignment ?? this.alignment
      ..sizeInText = sizeInText ?? this.sizeInText;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory FontModel.fromProperty(String? propertyString) {
    return propertyString == null ? FontModel(fontname: 'Lato') : FontModel.fromJson(jsonDecode(propertyString));
  }

  static List<IconData>? alignmentTextToIcon(String? alignment) {
    final map = {
      'topLeft': [FontAwesomeIcons.alignLeft, Icons.vertical_align_top],
      'topCenter': [FontAwesomeIcons.alignCenter, Icons.vertical_align_top],
      'topRight': [FontAwesomeIcons.alignRight, Icons.vertical_align_top],
      'centerLeft': [FontAwesomeIcons.alignLeft, Icons.vertical_align_center],
      'center': [FontAwesomeIcons.alignCenter, Icons.vertical_align_center],
      'centerRight': [FontAwesomeIcons.alignRight, Icons.vertical_align_center],
      'bottomLeft': [FontAwesomeIcons.alignLeft, Icons.vertical_align_bottom],
      'bottomCenter': [FontAwesomeIcons.alignCenter, Icons.vertical_align_bottom],
      'bottomRight': [FontAwesomeIcons.alignRight, Icons.vertical_align_bottom],
      'default': [FontAwesomeIcons.alignJustify, Icons.vertical_align_center],
    };

    try {
      return map[alignment ?? 'default']!;
    } catch (e) {
      return map['default']!;
    }
  }
}
