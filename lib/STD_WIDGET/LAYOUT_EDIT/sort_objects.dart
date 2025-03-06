import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../package.dart';

class SortDynamicToStrings extends ConsumerWidget {
  final Map<String, dynamic> lists;
  final TextStyle? style;
  final Color? buttonBorderColor;
  final Color? buttonBackgroundColor;
  final Color? backgroundColor;
  final Function(Map<String, dynamic> map) onChanges;
  final Function(String key) onDelete;

  SortDynamicToStrings({
    required this.onChanges,
    required this.lists,
    super.key,
    this.style,
    this.buttonBorderColor,
    this.backgroundColor,
    this.buttonBackgroundColor,
    required this.onDelete,
  });

  final paragraphSortProvider = StateProvider<Map<String, dynamic>>((ref) => {});

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Material(
            color: Colors.transparent,
            elevation: elevation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(paragraphSortProvider);
    if (list.isEmpty) list = lists;
    if (list.isEmpty) {
      return NothingFound(overrideText: tr('#error.nothing_found'));
    }

    final keys = list.keys.toList();
    keys.sort((a, b) => (list[a].sort ?? 0).compareTo(list[b].sort ?? 0));

    final items = keys.map((e) => list[e].toString()).toList();

    return ReorderableListView(
      proxyDecorator: proxyDecorator,
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }

        final key = keys.removeAt(oldIndex);
        keys.insert(newIndex, key);

        final newList = {for (var k in keys) k: list[k]};
        for (var i = 0; i < keys.length; i++) {
          newList[keys[i]].sort = i * 10;
        }
        onChanges(newList);
        ref.read(paragraphSortProvider.notifier).state = newList;
      },
      children: [
        for (int index = 0; index < keys.length; index++)
          ReorderableDragStartListener(
            key: Key('$index'),
            index: index,
            child: Dismissible(
              key: ValueKey(keys[index]),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                bool confirm = false;
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(tr('Confirm deletion')),
                      content: Text(tr('Do you want to delete this item?')),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            confirm = false;
                          },
                          child: Text(tr('Cancel')),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            confirm = true;
                          },
                          child: Text(tr('Delete')),
                        ),
                      ],
                    );
                  },
                );
                return confirm;
              },
              onDismissed: (direction) {
                final newList = {...list}..remove(keys[index]);
                onDelete(keys[index]);
                onChanges(newList);
                ref.read(paragraphSortProvider.notifier).state = newList;
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: buttonBackgroundColor ?? Colors.white,
                  border: Border.all(
                    width: 1,
                    color: buttonBorderColor ?? Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        items[index],
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: style?.copyWith(color: Colors.white),
                      ),
                    ),
                    const Icon(Icons.drag_indicator_rounded, size: 22),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
