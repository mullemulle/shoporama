// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'font_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FontModel _$FontModelFromJson(Map<String, dynamic> json) =>
    FontModel(
        fontname: json['fontname'] as String,
        size: (json['size'] as num?)?.toDouble() ?? 18,
        color: json['color'] as String? ?? "#ffffffff",
        backgroundcolor: json['backgroundcolor'] as String? ?? "#000000ff",
        letterSpacing: (json['letterSpacing'] as num?)?.toInt() ?? 1,
        height: (json['height'] as num?)?.toDouble(),
      )
      ..alignment = json['alignment'] as String?
      ..sizeInText = json['sizeInText'] as String?;

Map<String, dynamic> _$FontModelToJson(FontModel instance) => <String, dynamic>{
  'color': instance.color,
  'backgroundcolor': instance.backgroundcolor,
  'size': instance.size,
  'fontname': instance.fontname,
  'letterSpacing': instance.letterSpacing,
  'height': instance.height,
  'alignment': instance.alignment,
  'sizeInText': instance.sizeInText,
};
