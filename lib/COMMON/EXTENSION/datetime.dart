// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';

enum InputTimeTypeEnum {
  time,
  date,
  datetime,
}

extension DateTimeExtension on DateTime {
  String toText() {
    return millisecondsSinceEpoch.toString();
  }

  String toReadable() {
    return DateFormat('yyyy-MM-dd – kk:mm').format(this);
  }
}

extension DateTimeNullExtension on DateTime? {
  String toText() {
    if (this == null) return '';

    return this!.millisecondsSinceEpoch.toString();
  }

  (String, String, String) toFriendly() {
    if (this == null) return ('', '', '');

    final current = this!.toLocal();
    DateTime now = DateTime.now().toLocal();
    DateTime tenMinutesBefore = current.add(const Duration(minutes: 5));
    DateTime oneHourBefore = current.add(const Duration(hours: 1));
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    final diff = now.difference(current);

    if (now.isBefore(tenMinutesBefore)) {
      return ('#time.just_now', '', '');
    } else if (now.isBefore(oneHourBefore)) {
      return ('#time.newly', diff.inMinutes.toString(), '#time.mins');
    } else if (now.isAfter(today)) {
      return ('#time.today', diff.inHours.toString(), '#time.hours');
    } else if (now.isAfter(yesterday) && current.isBefore(today)) {
      return ('#time.yesterday', DateFormat('kk:mm').format(current), '');
    }

    return ('', DateFormat('dd/MM/yyyy').format(current), '');
  }

  String toFriendlyString({InputTimeTypeEnum? type}) {
    if (this == null) return '';

    final current = this!.toLocal();
    DateTime now = DateTime.now().toLocal();
    DateTime tenMinutesBefore = current.add(const Duration(minutes: 5));
    DateTime oneHourBefore = current.add(const Duration(hours: 1));
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    final diff = now.difference(current);

    if (type != null && type == InputTimeTypeEnum.time) {
      final innerDiff = DateTime(2000, 1, 1).difference(current);
      if (innerDiff.inDays == 0) {
        return DateFormat('HH:mm').format(current);
      } else {
        return '${innerDiff.inDays}${'#time.days'.tr()}${DateFormat('HH:mm').format(current)}';
      }
    }

    if (now.isBefore(tenMinutesBefore)) {
      return '#time.just_now';
    } else if (now.isBefore(oneHourBefore)) {
      return '${'#time.newly'.tr()} ${diff.inMinutes} ${'#time.mins'.tr()}';
    } else if (now.isAfter(today)) {
      return '${'#time.today'.tr()} ${diff.inHours}${'#time.hours'.tr()}';
    } else if (now.isAfter(yesterday) && current.isBefore(today)) {
      return '${'#time.yesterday'.tr()} ${DateFormat('kk:mm').format(current)}';
    }

    return DateFormat('dd/MM/yyyy').format(current);
  }

  DateTime? roundMin() {
    if (this == null) return null;

    int minutes = 0;
    if (this!.minute <= 15) {
      minutes = 0;
    } else if (this!.minute > 15 && this!.minute <= 45) {
      minutes = 30;
    } else {
      minutes = 60;
    }

    return DateTime(this!.year, this!.month, this!.day, this!.hour, minutes);
  }
}
