import 'dart:async' show Completer;
import 'dart:developer' show log;
import 'dart:typed_data' show Uint8List;
import 'dart:ui' show Size;

import 'package:customer_app/COMMON/package.dart';
import 'package:customer_app/STD_WIDGET/icon_in_circle.dart' show IconInCircle;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage, SettableMetadata;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image/image.dart' as image_package;
import 'package:image_picker/image_picker.dart';
import 'package:native_image_cropper/native_image_cropper.dart';
import 'package:shortid/shortid.dart';

import 'firestorageservice.dart';

class ImageLoadingStateInfo {
  final String originalFilename;
  String? storageFilename;
  String? downloadImage;
  String filetype;
  Uint8List? bytes;
  String stage;

  // Work fields
  image_package.Image? image;
  ImageLoadingStateInfo({required this.originalFilename, this.storageFilename, this.bytes, required this.filetype, this.stage = ''});
}

class UploadProcess {
  final String command;
  final dynamic data;
  UploadProcess({required this.command, this.data});
}

Future<ImageLoadingStateInfo> decodeImage(ImageLoadingStateInfo fileInfo, dynamic data) async {
  log('Decode image');
  if (fileInfo.originalFilename.contains('.jpg') || fileInfo.originalFilename.contains('.jpeg')) {
    fileInfo.image ??= image_package.decodeJpg(fileInfo.bytes!);
  } else if (fileInfo.filetype.contains('.tga')) {
    fileInfo.image ??= image_package.decodeTga(fileInfo.bytes!);
  } else if (fileInfo.originalFilename.contains('.png')) {
    fileInfo.image ??= image_package.decodePng(fileInfo.bytes!);
  }

  try {
    fileInfo.image!.convert(numChannels: 4);
  } catch (_) {}

  fileInfo.stage = 'decoded';

  await Future.delayed(const Duration(milliseconds: 5));

  return fileInfo;
}

Future<ImageLoadingStateInfo> resizeImage(ImageLoadingStateInfo fileInfo, dynamic data) async {
  final size = data as Size;

  /*
  if (fileInfo.filetype.contains('.jpg') || fileInfo.filetype.contains('.jpeg')) {
    fileInfo.image ??= image_package.decodeJpg(fileInfo.bytes!);
  } else if (fileInfo.filetype.contains('.tga')) {
    fileInfo.image ??= image_package.decodeTga(fileInfo.bytes!);
  } else if (fileInfo.filetype.contains('.png')) {
    fileInfo.image ??= image_package.decodePng(fileInfo.bytes!);
  }
*/
  log('Resize image');
  fileInfo.bytes = FirestorageRepository.resizeImageToPNG(size.width.toInt(), fileInfo.image);
  //fileInfo.bytes = fileInfo.bytes ?? FirestorageRepository.resizeImageToPNG(size.width.toInt(), fileInfo.image);

  fileInfo.stage = 'resized';

  await Future.delayed(const Duration(milliseconds: 5));

  return fileInfo;
}

Future<ImageLoadingStateInfo> uploadImage(ImageLoadingStateInfo fileInfo, dynamic data) async {
  String pathAndFilename = data;

  if (fileInfo.bytes == null) return fileInfo;
  try {
    if (pathAndFilename.contains('{shortid}')) {
      pathAndFilename = pathAndFilename.replaceAll('{shortid}', shortid.generate());
    }

    log('Upload image');
    // Upload raw data.
    final actualImageRef = FirebaseStorage.instance.ref().child(pathAndFilename);
    await actualImageRef.putData(fileInfo.bytes!);

    // Download url for web
    try {
      String downloadUrl = await actualImageRef.getDownloadURL();
      fileInfo.downloadImage = downloadUrl;
    } catch (_) {}

    // For app
    fileInfo.storageFilename = 'gs://${'${actualImageRef.bucket}/$pathAndFilename'.replaceAll('//', '/')}';

    // Make the file public
    await actualImageRef.updateMetadata(SettableMetadata(cacheControl: 'public,max-age=300', contentType: 'image/jpeg'));
  } catch (e) {
    log('FirestorageRepository -> uploadImage FAILED ${e.toString()}');
  }

  fileInfo.stage = 'uploaded';

  await Future.delayed(const Duration(milliseconds: 5));

  return fileInfo;
}

Future<ImageLoadingStateInfo> usercropImage(ImageLoadingStateInfo fileInfo, dynamic data) async {
  if (fileInfo.bytes == null) return fileInfo;
  try {
    log('POP UP');
    final context = data['context'] as BuildContext;
    final size = data['size'] as Size;
    final result = await showImageClip(context: context, size: size, file: fileInfo);
    if (result != null) {
      fileInfo.bytes = result;
      final decodedImage = image_package.decodeImage(result);
      fileInfo.image = decodedImage;
    }

    /*.then(
        (value) {
        log('POP AFTER');
      },
    );*/
    log('POP DONE');
  } catch (e) {
    log('FirestorageRepository -> uploadImage FAILED ${e.toString()}');
  }

  fileInfo.stage = 'uploaded';

  await Future.delayed(const Duration(milliseconds: 5));

  return fileInfo;
}

Future<Uint8List?> showImageClip({required BuildContext context, required ImageLoadingStateInfo file, required Size size, Color? backgroundColor, TextStyle? style}) async {
  var completer = Completer<Uint8List?>();

  final controller = CropController();
  /*
  const maskOptions = MaskOptions(
    backgroundColor: Colors.black38,
    borderColor: Colors.white,
    strokeWidth: 2,
    aspectRatio: 4 / 4,
    minSize: 1024,
  );
  */
  const maskOptions = MaskOptions(backgroundColor: Colors.black38, borderColor: Colors.white, strokeWidth: 2);

  bool clicked = false;

  await showDialog(
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
    context: context,
    builder: (BuildContext innerContext) {
      var mediaQuery = MediaQuery.of(innerContext);
      final size = mediaQuery.size;
      const space = 10.0;

      return Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
          duration: const Duration(milliseconds: 300),
          child: Center(
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxHeight: size.height - (size.width * 0.2) - 140),
                      margin: const EdgeInsets.only(left: space, right: space, bottom: space),
                      padding: const EdgeInsets.only(left: space, right: space, top: space, bottom: 40),
                      decoration: BoxDecoration(color: backgroundColor ?? Colors.white, borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: CropPreview(
                        controller: controller,
                        bytes: file.bytes!,
                        mode: CropMode.rect,
                        dragPointSize: 10,
                        hitSize: 20,
                        maskOptions: maskOptions,
                        dragPointBuilder: (size, position) {
                          return CropDragPoint(size: size, color: Colors.blue);
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: space + 5,
                  right: space + 5,
                  child: Container(
                    color: backgroundColor ?? Colors.white,
                    child: Row(
                      children: [
                        GFButton(
                          onPressed: () async {
                            if (clicked) return;

                            clicked = true;

                            try {
                              file.filetype = '.png';

                              final cropSize = controller.cropSize;
                              final bytes = await controller.crop();

                              completer.complete(bytes);

                              if (!context.mounted) return;
                              Navigator.pop(innerContext, true);
                            } catch (e) {
                              GFToast.showToast('#Try again', innerContext);
                            }
                          },
                          text: tr('#profile.upload.button'),
                          textStyle: style,
                          shape: GFButtonShape.pills,
                        ), //Text(tr('#save image'), style: style)),
                        ...[
                          IconInCircle(
                            color: style?.color ?? Colors.black,
                            backgroundColor: Colors.transparent,
                            icon: Icons.close,
                            onPressed: () {
                              completer.complete(null);
                              Navigator.pop(innerContext);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  return completer.future;
}

class FileUploadService {
  static Future<List<ImageLoadingStateInfo>> pickImage({bool allowMultiple = false}) async {
    try {
      log('Consumer watch = true');

      final ImagePicker picker = ImagePicker();

      // Pick an image.
      final XFile? result = await picker.pickImage(maxWidth: 1080, maxHeight: 1920, imageQuality: 90, source: ImageSource.gallery);

      if (result != null) {
        final bytes = await result.readAsBytes();
        return [ImageLoadingStateInfo(originalFilename: result.name, bytes: bytes, filetype: result.name.getExtension()!)];
        //return [result].toList().map((e) => ImageLoadingStateInfo(originalFilename: e.name, bytes: e.bytes)).toList();
      } else {
        return [];
      }
    } finally {}
  }

  static uploadFiles(ImageLoadingStateInfo singleFile, List<UploadProcess> uploadProcess, {void Function(String status)? onProcessStatus}) async {
    for (var i = 0; i < uploadProcess.length; i++) {
      final process = uploadProcess[i];

      log('----> $i == ${uploadProcess.length}');
      if (onProcessStatus != null) {
        onProcessStatus(process.command);
      }

      switch (process.command) {
        case 'decodeImage':
          await decodeImage(singleFile, process.data);
          break;
        case 'resizeImage':
          log('resizeImage ${singleFile.bytes!.length}');
          await resizeImage(singleFile, process.data);
          log('resizeImage ${singleFile.bytes!.length}');
          break;
        case 'uploadImage':
          log('uploadImage ${singleFile.bytes!.length}');
          await uploadImage(singleFile, process.data);
          log('uploadImage ${singleFile.bytes!.length}');
          break;
        case 'usercropImage':
          log('usercropImage ${singleFile.bytes!.length}');
          await usercropImage(singleFile, process.data);
          log('usercropImage ${singleFile.bytes!.length}');
          break;
      }
    }
  }
}

Future<List<ImageLoadingStateInfo>> pickImage(WidgetRef ref, {bool allowMultiple = false}) async {
  try {
    log('Consumer watch = true');

    final ImagePicker picker = ImagePicker();

    // Pick an image.
    final XFile? result = await picker.pickImage(maxWidth: 1080, maxHeight: 1920, imageQuality: 90, source: ImageSource.gallery);

    if (result != null) {
      final bytes = await result.readAsBytes();
      return [ImageLoadingStateInfo(originalFilename: result.name, bytes: bytes, filetype: result.name.getExtension()!)];
      //return [result].toList().map((e) => ImageLoadingStateInfo(originalFilename: e.name, bytes: e.bytes)).toList();
    } else {
      return [];
    }
  } finally {}
}
