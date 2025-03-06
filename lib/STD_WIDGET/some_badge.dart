import 'package:flutter/material.dart';

class SOMOBadge extends StatelessWidget {
  final String app;
  final IconData icon;
  final Color iconColor;
  final String? defaultValue;
  final bool showEditIcon;
  final double? size;
  final Function(String app, String? defaultValue) onTap;
  const SOMOBadge({super.key, required this.icon, required this.iconColor, required this.app, required this.onTap, this.defaultValue, this.showEditIcon = true, this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onTap(app, defaultValue);
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: showEditIcon ? const EdgeInsets.only(right: 5, bottom: 5) : const EdgeInsets.only(top: 3, left: 3, right: 2, bottom: 2),
            child: Icon(icon, size: size ?? 40, color: iconColor),
          ),
          if (showEditIcon)
            const CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 10,
              child: Icon(Icons.edit, size: 10, color: Colors.white),
            )
        ],
      ),
    );
  }
}
