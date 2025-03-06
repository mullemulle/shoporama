import 'dart:async';

import 'package:flutter/material.dart';

Future<T?> showListPopup<T>({required BuildContext context, required List<(String, T)> list, TextStyle? style, Color? backgroundColor, Color? borderColor}) {
  var completer = Completer<T?>();

  const space = 10.0; // MediaQuery.of(context).size.width * 0.04;

  showDialog(
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
    context: context,
    builder: (BuildContext innerContext) {
      var mediaQuery = MediaQuery.of(innerContext);

      return Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
          duration: const Duration(milliseconds: 300),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(left: space, right: space, bottom: space),
                padding: const EdgeInsets.only(left: space, right: space, top: space, bottom: 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                // height: mediaQuery.size.height - 600,
                constraints: BoxConstraints(maxHeight: mediaQuery.size.height - 40),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                          children: list
                              .map((e) => InkWell(
                                    onTap: () {
                                      Navigator.of(innerContext).pop();
                                      completer.complete(e.$2);
                                    },
                                    child: PopupSelectionItem(
                                      title: e.$1,
                                      style: style,
                                      backgroundColor: backgroundColor,
                                      borderColor: borderColor,
                                    ),
                                  ))
                              .toList()),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: space + 5,
                  right: space + 5,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(innerContext).pop();
                      completer.complete(null);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Icon(Icons.close, size: 33),
                    ),
                  )),
            ],
          ),
        ),
      );
    },
  );

  return completer.future;
}

class PopupSelectionItem extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final TextStyle? style;
  final Color? backgroundColor;
  final Color? borderColor;
  const PopupSelectionItem({
    super.key,
    this.icon,
    this.title,
    this.style,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: const BorderRadius.all(Radius.circular(5)), border: Border.all(color: borderColor ?? Colors.black)),
        child: Center(
          child: Text(
            title!,
            style: style,
          ),
        ),
      ),
    );
  }
}
