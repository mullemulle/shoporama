import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String? description;
  final String action;
  IconData? icon;
  MenuItem({required this.title, this.description, required this.action, this.icon});
}

class MenuTile extends StatelessWidget {
  final MenuItem button;
  final TextStyle? style;
  final Color? backgroundColor;
  final Function(MenuItem button) onTap;
  const MenuTile({required this.button, required this.onTap, this.style, this.backgroundColor, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(button),
      child: Stack(children: [
        Container(
          width: 150,
          height: 100,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 4, color: Colors.grey),
          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            width: 150,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                button.title,
                style: style,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            )),
        if (button.description != null)
          Positioned(
              bottom: 0,
              left: 0,
              width: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  button.description!,
                  style: style?.copyWith(fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ))
      ]),
    );
  }
}
