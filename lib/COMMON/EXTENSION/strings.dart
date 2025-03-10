import 'dart:io';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'metafone.dart';

extension StringExtension on String {
  String toText() {
    return this;
  }

  String translate(BuildContext context) {
    return (this as String?).translate(context);
  }

  String splitTranslate(String prefix) {
    return split(',').map((e) => tr('$prefix.$e')).join(' ');
  }

  // MARKDOWN
  String toMarkdown() {
    String text = this;

    // Erstat HTML-entiteter
    text = text.replaceAll('&aring;', 'å').replaceAll('&oslash;', 'ø').replaceAll('&aelig;', 'æ').replaceAll('&AElig;', 'Æ').replaceAll('&Oslash;', 'Ø').replaceAll('&Aring;', 'Å').replaceAll('&amp;', '&');

    // Erstat HTML-tags med Markdown
    text = text.replaceAllMapped(RegExp(r'<strong>(.*?)<\/strong>', dotAll: true), (match) => '**${match[1]}**');
    text = text.replaceAllMapped(RegExp(r'<em>(.*?)<\/em>', dotAll: true), (match) => '*${match[1]}*');
    text = text.replaceAll(RegExp(r'<br\s*\/?>'), '\n');
    text = text.replaceAllMapped(RegExp(r'<p>(.*?)<\/p>', dotAll: true), (match) => '\n\n${match[1]}');

    // Fjern eventuelle resterende HTML-tags
    text = text.replaceAll(RegExp(r'<[^>]+>'), '');

    return text.trim();
  }
}

extension StringNullExtension on String? {
  String toCapitalize() {
    if (this == null) return '';

    final split = this!.split(' ');
    final list = <String>[];
    for (var str in split) {
      list.add("${str[0].toUpperCase()}${str.substring(1).toLowerCase()}");
    }

    return list.join(' '); //"${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}";
  }

  String toText() {
    if (this == null) return '';

    return this!;
  }

  String toOnlyAlpha() {
    if (this == null) return '';

    return this!.replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  String toNoSpecial() {
    if (this == null) return '';

    return this!.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  String toSWIOMEDomain() {
    if (this == null) return '';

    String domain = this!;
    domain = domain.replaceAll(RegExp(r'[. -]'), '-');
    return domain.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  String toDomain() {
    if (this == null) return '';
    String input = this!;
    // Erstat danske specialtegn
    String processed = input.replaceAll('æ', 'ae').replaceAll('ø', 'o').replaceAll('å', 'aa');

    // Fjern specialtegn undtagen mellemrum og alfanumeriske tegn
    processed = processed.replaceAll(RegExp(r'[ -]'), '');
    processed = processed.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '');

    // Split input til ord
    List<String> words = processed.split(' ');

    // Fjern tomme ord (kan opstå ved flere mellemrum)
    words.removeWhere((word) => word.isEmpty);

    // Brug sidste ord som top-level domain
    String tld = words.removeLast().toLowerCase();

    // Kombiner resterende ord til domænenavn
    String domainName = words.join('').toLowerCase();

    // Kombiner domænenavn og top-level domain
    return domainName.isEmpty || tld.isEmpty ? processed : '$domainName.$tld';
  }

  String removeDigits() {
    if (this == null) return '';

    return this!.replaceAll(RegExp(r"\D"), "");
  }

  (String, String) keyValue(String splitter) {
    if (this == null) return ('', '');

    final arr = this!.split(splitter);

    return arr.isEmpty ? ('', '') : (arr[0], arr[1]);
  }

  String withoutExtension() {
    if (this == null) return '';

    String result = this!.replaceAll('_tb.jpg', '').replaceAll('_icon.jpg', '').replaceAll('.jpg', '');
    result = this!.replaceAll('_tb.png', '').replaceAll('_icon.png', '').replaceAll('.png', '');
    return result;
  }

  String? getExtension() {
    final input = this;
    if (input == null) return null;

    try {
      return ".${input.split('.').last}";
    } catch (e) {
      return null;
    }
  }

  String? toMetaphone() {
    final input = this;
    if (input == null) return null;

    try {
      return Metaphone.encode(input).toLowerCase();
    } catch (e) {
      return null;
    }
  }

  String translate(BuildContext context) {
    if (this == null || this!.isEmpty) return '';

    if (this!.startsWith('#')) return tr(this!);

    return this!;
  }

  String? reverse() {
    final input = this;
    if (input == null) return null;

    String reversed = '';
    for (int i = input.length - 1; i >= 0; i--) {
      reversed += input[i];
    }
    return reversed;
  }

  String? alphanumericWithUnderscore() {
    final input = this;
    if (input == null) return null;

    return input.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '');
  }

  String? truncate(int maxLength) {
    final input = this;
    if (input == null) return null;

    return input.substring(0, math.min(maxLength, input.length));
  }

  String? lastName({String? separator}) {
    final input = this;
    if (input == null) return null;

    return input.split(separator ?? Platform.pathSeparator).last;
  }
}
