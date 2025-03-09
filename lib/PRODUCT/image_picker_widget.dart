import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:native_image_cropper/native_image_cropper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ImagePickerWidget extends ConsumerStatefulWidget {
  final Size maxSizeOfImage;
  final String targetFileFormat;
  final bool allowCustomCrop;
  final Widget child;
  final Function(Uint8List) onImage;

  const ImagePickerWidget({required this.maxSizeOfImage, this.targetFileFormat = 'png', this.allowCustomCrop = false, required this.child, required this.onImage, super.key});

  @override
  ConsumerState<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends ConsumerState<ImagePickerWidget> {
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      await _processImage(File(pickedFile.path));
    } catch (e) {
      _showErrorSnackbar('error_image_pick');
    }
  }

  Future<void> _processImage(File file) async {
    setState(() => _isProcessing = true);
    try {
      Uint8List imageBytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) throw Exception('error_decode_failed');

      /*if (widget.allowCustomCrop) {
        final width = math.min(widget.maxSizeOfImage.width.toInt(), image.width);
        final height = math.min(widget.maxSizeOfImage.height.toInt(), image.height);
        imageBytes = await NativeImageCropper.cropRect(bytes: imageBytes, x: 0, y: 0, width: width, height: height, format: ImageFormat.png);
        image = img.decodeImage(imageBytes);
        if (image == null) throw Exception('error_decode_failed_after_crop');
      }*/

      image = _resizeImageIfNeeded(image);
      Uint8List finalImage = _convertImage(image);
      widget.onImage(finalImage);
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  img.Image _resizeImageIfNeeded(img.Image image) {
    final maxWidth = widget.maxSizeOfImage.width.toInt();
    final maxHeight = widget.maxSizeOfImage.height.toInt();

    if (image.width > maxWidth || image.height > maxHeight) {
      final scale = math.min(maxWidth / image.width, maxHeight / image.height);
      final newWidth = (image.width * scale).toInt();
      final newHeight = (image.height * scale).toInt();
      return img.copyResize(image, width: newWidth, height: newHeight);
    }
    return image;
  }

  Uint8List _convertImage(img.Image image) {
    switch (widget.targetFileFormat.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return Uint8List.fromList(img.encodeJpg(image));
      case 'tga':
        return Uint8List.fromList(img.encodeTga(image));
      case 'png':
      default:
        return Uint8List.fromList(img.encodePng(image));
    }
  }

  void _showErrorSnackbar(String errorKey) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorKey.tr())));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [GestureDetector(onTap: _pickImage, child: widget.child), if (_isProcessing) Positioned.fill(child: Container(color: Colors.black54, child: Center(child: SpinKitFadingCircle(color: Colors.white, size: 50.0))))]);
  }
}
