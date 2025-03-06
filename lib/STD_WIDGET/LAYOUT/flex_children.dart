import 'package:flutter/material.dart';

class FlexChildren extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  const FlexChildren({super.key, required this.children, required this.direction});

  @override
  Widget build(BuildContext context) {
    List<Widget> c = children;
    if (direction == Axis.vertical) {
      c = children.map(
        (e) {
          return e is Expanded ? e.child : e;
        },
      ).toList();
    }

    return SizedBox(
      width: double.infinity,
      child: direction == Axis.horizontal ? Row(mainAxisSize: MainAxisSize.min, children: c) : Column(mainAxisSize: MainAxisSize.min, children: c),
    );
  }
}
