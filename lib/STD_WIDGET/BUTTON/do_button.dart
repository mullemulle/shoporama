import 'package:customer_app/COMMON/package.dart';
import 'package:flutter/material.dart';


class DoButton extends StatelessWidget {
  final String title;
  final dynamic tailing;
  final TextStyle? style;
  final Function()? onTap;
  final bool enabled;
  final BoxConstraints? constraints;
  DoButton({super.key, required this.title, this.onTap, this.style, this.constraints, this.enabled = true, this.tailing});

  final decoButton = defaults.decoration(null).get('button')!;
  final paddingButton = defaults.padding(null).get('button')!;
  final marginButton = defaults.padding(null).get('buttonMargin')!;

  @override
  Widget build(BuildContext context) {
    final styleButton = style ?? defaults.textStyle(null).get('button');
    final backgroundColor = enabled ? styleButton.backgroundColor! : styleButton.backgroundColor?.lightenColor(50);

    return GestureDetector(
      onTap: () => onTap == null ? null : onTap!(),
      child: Container(
        decoration: decoButton.copyWith(color: backgroundColor),
        constraints: constraints,
        padding: paddingButton,
        margin: marginButton,
        child: Align(
          alignment: Alignment.center,
          child:
              tailing == null
                  ? Text(title, style: styleButton.copyWith(backgroundColor: backgroundColor), maxLines: 1)
                  : Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: styleButton.copyWith(backgroundColor: backgroundColor), maxLines: 1),
                      switch (tailing.runtimeType) {
                            IconData => Icon(tailing, size: 22, color: styleButton.color),
                            _ => tailing,
                          }
                          as Widget,
                    ],
                  ),
        ),
      ),
    );
  }
}
