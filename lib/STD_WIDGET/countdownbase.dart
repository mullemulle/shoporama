import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState {
  final DateTime targetDate;
  final Duration timeDifference;

  TimerState({required this.targetDate, required this.timeDifference});
}

// Notifier der håndterer timeren og opdaterer tidsforskellen
class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;

  TimerNotifier(DateTime targetDate) : super(TimerState(targetDate: targetDate, timeDifference: const Duration())) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _getTimeDifference());
    _getTimeDifference();
  }

  void _getTimeDifference() {
    final now = DateTime.now();
    final timeDifference = now.isBefore(state.targetDate) ? state.targetDate.difference(now) : now.difference(state.targetDate);
    state = TimerState(targetDate: state.targetDate, timeDifference: timeDifference);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/*
class CountdownBase extends ConsumerWidget {
  final TextStyle? style;
  final String? subtitle;
  final TextStyle? subTitleStyle;
  final DateTime targetDate;

  CountdownBase({super.key, required this.targetDate, this.subtitle, this.style, this.subTitleStyle});

  // Definerer en provider for at håndtere timer og datoindstillinger
  final timerProvider = StateNotifierProvider.family<TimerNotifier, TimerState, DateTime>((ref, targetDate) {
    return TimerNotifier(targetDate);
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timerProvider(targetDate));
    String timeText = '';

    // Beregn år
    final int years = state.timeDifference.inDays ~/ 365;
    final int days = state.timeDifference.inDays % 365;

    // Tilføj år til tidsteksten, hvis forskellen er mere end et år
    if (years > 0) timeText += years == 1 ? '$years year ' : '$years years ';
    if (days > 0) timeText += days == 1 ? '$days days ' : '$days days ';

    timeText += '${state.timeDifference.inHours % 24}:${state.timeDifference.inMinutes % 60}:${state.timeDifference.inSeconds % 60}';

    return FittedBox(child: Text(timeText, style: style));
  }
}*/

class CountdownBase extends ConsumerWidget {
  final TextStyle? style;
  final Color backgroundColor;
  final DateTime targetDate;
  final Widget Function(DateTime dateTime)? countEndedChild;
  CountdownBase({super.key, required this.targetDate, required this.backgroundColor, required this.style, this.countEndedChild});

  // Definerer en provider for at håndtere timer og datoindstillinger
  final timerProvider = StateNotifierProvider.family<TimerNotifier, TimerState, DateTime>((ref, targetDate) {
    return TimerNotifier(targetDate);
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timerProvider(targetDate));
    String timeText = '';

    // Beregn år
    final int years = state.timeDifference.inDays ~/ 365;
    final int days = state.timeDifference.inDays % 365;

    // Tilføj år til tidsteksten, hvis forskellen er mere end et år
    if (years > 0) timeText += years == 1 ? '$years year ' : '$years years ';
    if (days > 0) timeText += days == 1 ? '$days days ' : '$days days ';

    timeText += '${state.timeDifference.inHours % 24}:${state.timeDifference.inMinutes % 60}:${state.timeDifference.inSeconds % 60}';

    if (countEndedChild != null && state.targetDate.isBefore(DateTime.now())) {
      return countEndedChild!(state.targetDate);
    }

    if (state.targetDate.isBefore(DateTime.now())) {
      return Container();
    }

    return Container(
      width: double.infinity,
      color: style!.backgroundColor!,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
      child: Text(
        timeText.replaceAll('#', ''),
        style: style,
        overflow: TextOverflow.fade,
      ),
    );

    //FittedBox(child: Text(timeText, style: style));
  }
}
