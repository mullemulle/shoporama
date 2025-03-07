import 'dart:developer' show log;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as image_package;

// part 'firestorageservice.g.dart';

class FirestorageRepository {
  final FirebaseStorage store; // FirebaseStorage.instance
  FirestorageRepository({required this.store});

  //
  // uploadImage
  //
  Future<Map<String, dynamic>> uploadImage(String pathAndFilename, Uint8List bytes, {String? withThumbnail, String? withIcon}) async {
    log('FirestorageRepository -> uploadImage');

    pathAndFilename = pathAndFilename.replaceAll(' ', '_');

    log('Decode image');
    image_package.Image? img = image_package.decodeImage(bytes);

    // Create a storage
    log('Ref to store');
    final storageRef = FirebaseStorage.instance.ref();

    // Actual image
    log('Resize image: $pathAndFilename');
    Uint8List actualImage = resizeImageToPNG(1024, img);
    final actualImageRef = storageRef.child(pathAndFilename);

    // Thumbnail image
    late Reference thumbnailImageRef;
    late Uint8List thumbnailImage;
    if (withThumbnail != null) {
      log('Resize thumbnail image: $withThumbnail');
      var image = image_package.decodeJpg(actualImage);
      thumbnailImage = resizeImageToPNG(250, image);
      thumbnailImageRef = storageRef.child(withThumbnail);
    }

    // Icon image
    late Reference iconImageRef;
    late Uint8List iconImage;
    if (withIcon != null) {
      log('Resize icon image: $withIcon');
      var image = image_package.decodeJpg(actualImage);
      iconImage = resizeImageToPNG(100, image);
      iconImageRef = storageRef.child(withIcon);
    }

    try {
      log('Upload image');
      // Upload raw data.
      await actualImageRef.putData(actualImage);

      log('Upload thumbnail');
      if (withThumbnail != null) {
        await thumbnailImageRef.putData(thumbnailImage);
      }

      log('Upload icon');
      if (withIcon != null) {
        await iconImageRef.putData(iconImage);
      }
    } catch (e) {
      log('FirestorageRepository -> uploadImage FAILED ${e.toString()}');
    }

    return {
      'width': img!.width,
      'height': img.height,
    };
  }

  Future<void> removeMany(String sitename, List<dynamic> products) async {
    log('FirestorageRepository -> removeMany');

    // Create a storage
    log('Ref to store');
    final storageRef = FirebaseStorage.instance.ref();

    final List<Future<dynamic>> deleteList = <Future<dynamic>>[];

    for (var product in products) {
      if (product.files != null) {
        for (var file in product.files!) {
          log('\tRemove: ${file.file}');
          deleteList.add(storageRef.child(file.file).delete());
          if (file.thumbnail != null && file.thumbnail!.isNotEmpty) {
            log('\tRemove: ${file.thumbnail}');
            deleteList.add(storageRef.child(file.thumbnail!).delete());
          }
          if (file.icon != null && file.icon!.isNotEmpty) {
            log('\tRemove: ${file.icon}');
            deleteList.add(storageRef.child(file.icon!).delete());
          }
        }
      }
    }

    await Future.wait<dynamic>(deleteList);

    log('DONE');
  }

  static Uint8List resizeImageToPNG(int fixedWidth, image_package.Image? img) {
    final int newHeight = calculateRatio(fixedWidth, img!);

    if (fixedWidth * 1.2 > img.width) {
      return Uint8List.fromList(image_package.encodeJpg(img, quality: 80));
    }

    log('Before resize: ${img.data!.length}');

    image_package.Image resized = image_package.copyResize(img, width: fixedWidth, height: newHeight);
    Uint8List resizedImg = Uint8List.fromList(image_package.encodePng(resized));

    log('After resize: ${resized.data!.length}');

    return resizedImg;
  }

  static int calculateRatio(int fixedWidth, image_package.Image img) {
    final int width = img.width;
    final int height = img.height;
    final double aspectRatio = width / height;
    return (fixedWidth / aspectRatio).round();
  }
}
