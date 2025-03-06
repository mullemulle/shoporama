import 'package:flutter/material.dart';

class MenuIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Future<void> Function() onTap;
  const MenuIcon({super.key, required this.icon, required this.onTap, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 2.0)), padding: EdgeInsets.all(5), margin: EdgeInsets.all(5), child: Icon(icon, color: color)));
  }
}
