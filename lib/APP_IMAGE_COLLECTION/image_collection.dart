import 'package:collection/collection.dart';
import 'package:customer_app/COMMON/package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../COMMON/globals.dart';
import '../START/default.dart' show defaults;
import '../STD_WIDGET/package.dart';

class ImageCollection extends ConsumerWidget {
  // Input properties
  final List<FilePathSetup> paths;
  final String? filter;
  final bool showColorOption;
  final bool showImageOption;
  final bool showSelectManyOption;
  final Color? selectedColor;
  final Color? selectedImage;
  final Function(Color file) onColorTap;
  final Function(FileSetup file) onImageTap;
  final Function(List<FileSetup>? files)? onManyImageTap;

  ImageCollection({
    super.key,
    required this.paths,
    this.filter,
    required this.onColorTap,
    required this.onImageTap,
    this.onManyImageTap,
    this.showSelectManyOption = false,
    this.showColorOption = false,
    this.showImageOption = true,
    this.selectedColor,
    this.selectedImage,
  });

  // Providers
  final foldersProvider = StateProvider<List<FileSetup>>((ref) => []);
  final imageProvider = StateProvider<FileSetup?>((ref) => null);
  final colorProvider = StateProvider<Color?>((ref) => null);
  final selectedProvider = StateProvider<List<FileSetup>?>((ref) => null);

  // Constants
  final fireuser = FirebaseAuth.instance.currentUser!;
  final spacing = 10.0;
  final navigationStyle = defaults.textStyle(null).get('property_navigationfont');
  final imageListDeco = defaults.decoration(null).get('select_image');

  // Caching
  final Map<String, Image> images = {};

  Future<List<FileSetup>> getFiles(List<FilePathSetup> paths, {String? filter}) async {
    final storage = FirebaseStorage.instance;
    final allReferences = <Reference>[];

    for (var path in paths) {
      if (path.path == '#colorwheel') continue;
      final ref = storage.ref(path.path);
      final files = await ref.list(ListOptions(maxResults: 100));

      final selectedFilter = path.filter ?? filter;
      if (selectedFilter == null) {
        allReferences.addAll(files.items);
      } else {
        allReferences.addAll(files.items.where((e) => e.name.contains(selectedFilter)));
      }
    }

    return Future.wait(
      allReferences.map((ref) async {
        final downloadUrl = await ref.getDownloadURL();
        return FileSetup(path: ref.fullPath, name: ref.name, download: downloadUrl);
      }),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folderProvider = StateProvider<String>((ref) => showColorOption ? "#colorwheel" : "#empty");
    final size = MediaQuery.of(context).size;
    final imageWidth = (size.width - (20 + (spacing * 2))) / 3;

    Future.delayed(Duration(milliseconds: 10)).then((_) async {
      ref.read(foldersProvider.notifier).state = await getFiles(paths, filter: filter);
    });

    return Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildTiles(ref, folderProvider), _buildBody(context, ref, folderProvider, imageWidth)]));
  }

  Widget _buildTiles(WidgetRef ref, StateProvider<String> folderProvider) {
    return Consumer(
      builder: (context, ref, child) {
        final folderList = ref.watch(foldersProvider);
        final categories = folderList.map((e) => e.path.replaceAll(e.name, '')).toSet().toList();

        if (showColorOption) categories.insert(0, '#colorwheel');
        if (categories.isEmpty) return Container();

        return TilesList(fireuser: fireuser, folders: categories, onTap: (folder) => ref.read(folderProvider.notifier).state = folder);
      },
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, StateProvider<String> folderProvider, double imageWidth) {
    return Consumer(
      builder: (context, ref, child) {
        final folderList = ref.watch(foldersProvider);
        final selectedState = ref.watch(selectedProvider);
        final folder = ref.watch(folderProvider);

        if (folder.isEmpty) return Container();

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildHeader(ref, folder, selectedState), if (folder == '#colorwheel') _buildColorPicker(ref) else _buildImageGrid(ref, folderList, folder, selectedState, imageWidth), SizedBox(height: 100)],
          ),
        );
      },
    );
  }

  Widget _buildHeader(WidgetRef ref, String folder, List<FileSetup>? selectedState) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(getCategory(folder.replaceAll(fireuser.uid, 'user')).toCapitalize(), style: navigationStyle.copyWith(backgroundColor: Colors.transparent)),
          if (showSelectManyOption && !folder.startsWith('#'))
            DoButton(title: tr('#imagecollection.button.select'), constraints: BoxConstraints(maxWidth: 150), onTap: () => ref.read(selectedProvider.notifier).state = selectedState == null ? [] : null),
        ],
      ),
    );
  }

  Widget _buildColorPicker(WidgetRef ref) {
    return ColorPicker(
      pickerColor: Colors.amber,
      portraitOnly: true,
      hexInputBar: true,
      onColorChanged: (color) {
        ref.read(colorProvider.notifier).state = color;
        onColorTap(color);
      },
    );
  }

  Widget _buildImageGrid(WidgetRef ref, List<FileSetup> folderList, String folder, List<FileSetup>? selectedState, double imageWidth) {
    return Wrap(
      runSpacing: spacing,
      spacing: spacing,
      children:
          folderList.where((e) => e.path.contains(folder)).map((file) {
            return GestureDetector(onTap: () => _handleImageTap(ref, file, selectedState), child: Stack(children: [_buildImageContainer(file, imageWidth), if (selectedState != null) _buildSelectionIcon(ref, file, selectedState)]));
          }).toList(),
    );
  }

  Widget _buildImageContainer(FileSetup file, double imageWidth) {
    return Container(
      width: imageWidth,
      height: imageWidth,
      decoration: imageListDeco,
      child: ClipRRect(
        borderRadius: imageListDeco?.borderRadius ?? BorderRadius.circular(8.0),
        child: Builder(
          builder: (context) {
            final name = Uri.parse(file.download!).path;
            if (images.containsKey(name)) {
              return images[name]!;
            } else {
              final image = Image.network(file.download!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container());
              images[name] = image;
              return image;
            }
          },
        ),
      ),
    );
  }

  Widget _buildSelectionIcon(WidgetRef ref, FileSetup file, List<FileSetup>? selectedState) {
    return Positioned(right: 5, bottom: 5, child: Icon(selectedState!.any((e) => e.download == file.download) ? Icons.circle_rounded : Icons.circle_outlined, size: 33, color: navigationStyle.color));
  }

  void _handleImageTap(WidgetRef ref, FileSetup file, List<FileSetup>? selectedState) {
    ref.read(imageProvider.notifier).state = file;

    if (onManyImageTap != null && selectedState != null) {
      if (selectedState.any((e) => e.download == file.download)) {
        ref.read(selectedProvider.notifier).state = [...selectedState]..remove(file);
      } else {
        ref.read(selectedProvider.notifier).state = showSelectManyOption ? [...selectedState, file] : [file];
      }
      onManyImageTap!(selectedState);
    }

    onImageTap(file);
  }

  String getCategory(String fullPath) {
    final parts = fullPath.split('/');
    return parts.length == 1 ? parts[0] : parts[parts.length - 2];
  }
}

class TilesList extends StatelessWidget {
  final User fireuser;
  final List<String> folders;
  final Function(String folder) onTap;

  TilesList({super.key, required this.folders, required this.fireuser, required this.onTap});

  final spacing = 10.0;
  final navigationStyle = defaults.textStyle(null).get('property_navigationfont');

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: spacing,
      spacing: spacing,
      alignment: WrapAlignment.start,
      children:
          folders.map((folder) {
            final name = getCategory(folder.replaceAll(fireuser.uid, 'user')).toCapitalize();
            return GestureDetector(
              onTap: () => onTap(folder),
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: navigationStyle.color!), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Icon(folder == '#colorwheel' ? Icons.color_lens : FontAwesomeIcons.images, size: 33, color: navigationStyle.color),
                    Text(name, style: navigationStyle.copyWith(backgroundColor: Colors.transparent), overflow: TextOverflow.ellipsis, maxLines: 1),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  String getCategory(String fullPath) {
    final parts = fullPath.split('/');
    return parts.length == 1 ? parts[0] : parts[parts.length - 2];
  }
}

class FileSetup {
  final String path;
  final String name;
  String? download;

  FileSetup({required this.path, required this.name, this.download});
}

class FilePathSetup {
  final String path;
  final String? filter;
  final int upload;

  FilePathSetup({required this.path, this.filter, this.upload = 0});
}
