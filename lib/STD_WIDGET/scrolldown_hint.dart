import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScrolldownHint extends ConsumerWidget {
  final Widget child;
  ScrolldownHint({super.key, required this.child});

  final scrollHintProvider = StateProvider((ref) => true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onStartScroll(ScrollMetrics metrics) {
      ref.read(scrollHintProvider.notifier).state = false;
    }

    return NotificationListener<ScrollNotification>(
      child: Stack(alignment: Alignment.bottomCenter, children: [
        child,
        Consumer(
          builder: (context, ref, child) {
            if (ref.watch(scrollHintProvider)) {
              return const ScrollDownHint();
            } else {
              return Container();
            }
          },
        )
      ]),
      onNotification: (ScrollNotification scrollNotification) {
        if (scrollNotification is ScrollStartNotification) {
          onStartScroll(scrollNotification.metrics);
        }

        return true;
      },
    );
  }
}

class ScrollDownHint extends StatefulWidget {
  const ScrollDownHint({super.key});

  @override
  ScrollDownHintState createState() => ScrollDownHintState();
}

class ScrollDownHintState extends State<ScrollDownHint> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Icon(
          FontAwesomeIcons.upDown,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
