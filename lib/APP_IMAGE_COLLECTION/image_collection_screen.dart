import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../START/default.dart' show defaults;
import 'image_collection.dart';

class ImageCollectionScreen extends ConsumerWidget {
  final List<FilePathSetup> paths;
  final String? filter;
  final bool showColorOption;
  final bool showSelectManyOption;
  ImageCollectionScreen({super.key, required this.paths, this.filter, this.showColorOption = false, this.showSelectManyOption = false});

  final saveProvider = StateProvider<bool>((ref) => false);

  final navigationStyle = defaults.textStyle(null).get('property_navigationfont');
  final backgroundColor = defaults.color(null).get('image_selection_background');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String>? selectedFiles;
    Color? selectedColor;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ImageCollection(
            showColorOption: showColorOption,
            showSelectManyOption: showSelectManyOption,
            onColorTap: (color) {
              ref.read(saveProvider.notifier).state = true;
              selectedFiles = null;
              selectedColor = color;
              //Navigator.of(context).pop('color://${color.toHex()}');
            },
            onImageTap: (file) {
              ref.read(saveProvider.notifier).state = true;
              selectedColor = null;
              selectedFiles = [file.download!];
            },
            onManyImageTap: (files) {
              ref.read(saveProvider.notifier).state = true;
              selectedColor = null;
              selectedFiles = files == null ? null : [...files.map((e) => e.download!)];
            },
            paths: paths,
            filter: filter,
          ),
        ),
      ),
      /*
      floatingActionButton: FloatingSaveButtons(
        heroTag: 'background',
        title: tr('#event.save'),
        titleStyle: navigationStyle,
        provider: saveProvider,
        onSave: (action) async {
          if (selectedColor != null) {
            Navigator.of(context).pop('color://${selectedColor!.toHex()}');
          } else if (selectedFiles != null) {
            Navigator.of(context).pop(selectedFiles!.length == 1 ? selectedFiles![0] : selectedFiles);
          } else {
            Navigator.of(context).pop(null);
          }

          return false;
        },
      ),*/
    );
  }
}
