import 'package:flutter/material.dart';

class IconInCircle extends StatelessWidget {
  final Color? color;
  final Color? backgroundColor;
  final IconData icon;
  final double iconSize;
  final Color? doubleBorderColor;
  final bool doubleBorder;
  final EdgeInsetsGeometry? margin;
  final Function()? onPressed;
  const IconInCircle({super.key, this.backgroundColor, this.color, required this.icon, this.onPressed, this.doubleBorder = false, this.doubleBorderColor, this.margin, this.iconSize = 30});

  @override
  Widget build(BuildContext context) {
    final child = CircleAvatar(
      backgroundColor: backgroundColor ?? Colors.blue,
      radius: 25,
      child: Icon(icon, size: iconSize, color: color ?? Colors.white),
    );
    final buttom = onPressed != null
        ? InkWell(
            onTap: () => onPressed!(),
            child: child,
          )
        : child;

    if (doubleBorder) {
      return Container(
          margin: margin,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: backgroundColor ?? Colors.white,
            border: Border.all(color: doubleBorderColor ?? Colors.transparent),
            borderRadius: const BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          child: buttom);
    } else {
      return buttom;
    }
  }
}

class IconInHalfCircle extends StatelessWidget {
  final Color? color;
  final Color? backgroundColor;
  final IconData icon;
  final Color? doubleBorderColor;
  final bool doubleBorder;
  final EdgeInsetsGeometry? margin;
  final Function() onPressed;
  final double? extraWidth;
  const IconInHalfCircle({super.key, this.backgroundColor, this.color, required this.icon, required this.onPressed, this.doubleBorder = false, this.doubleBorderColor, this.margin, this.extraWidth});

  @override
  Widget build(BuildContext context) {
    final buttom = InkWell(
      onTap: () => onPressed(),
      child: CircleAvatar(
        backgroundColor: backgroundColor ?? Colors.blue,
        radius: 25,
        child: Icon(icon, size: 30, color: color ?? Colors.white),
      ),
    );

    if (doubleBorder) {
      return Container(
          margin: margin,
          padding: EdgeInsets.only(right: extraWidth ?? 0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: backgroundColor ?? Colors.white,
            border: Border(
              left: BorderSide(color: doubleBorderColor ?? Colors.transparent),
              top: BorderSide(color: doubleBorderColor ?? Colors.transparent),
              bottom: BorderSide(color: doubleBorderColor ?? Colors.transparent),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
          ),
          child: buttom);
    } else {
      return buttom;
    }
  }
}

class IconTextInCircle extends StatelessWidget {
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final IconData icon;
  final String? title;
  final TextStyle? style;
  final Function() onPressed;
  const IconTextInCircle({super.key, this.backgroundColor, this.color, required this.icon, required this.onPressed, this.title, this.style, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: backgroundColor ?? Colors.white,
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20,
              child: Icon(icon, size: 30, color: color ?? Colors.white),
            ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 10, top: 2, bottom: 2),
                child: Text(title!, style: style),
              ),
          ],
        ),
      ),
    );
  }
}
