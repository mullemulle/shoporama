extension IntExtension on int? {
  String toHM({String delimiter = ':'}) {
    if (this == null) return '00${delimiter}00';

    final int hour = this! ~/ 60;
    final int minutes = this! % 60;
    return '${hour.toString().padLeft(2, "0")}$delimiter${minutes.toString().padLeft(2, "0")}';
  }
}
