import 'package:customer_app/COMMON/package.dart';
import 'package:customer_app/PRODUCT/image_picker_widget.dart' show ImagePickerWidget;
import 'package:easy_localization/easy_localization.dart' show tr;
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart' show MarkdownBody;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../START/design.dart';
import '../_SERVICE/product_model.dart' show Product;
import '../_SERVICE/shoporama.dart';
import 'menu_icon.dart';

class ProductItemScreen extends StatelessWidget {
  final Product product;
  ProductItemScreen({super.key, required this.product});

  final snackBarStyle = defaults.textStyle(null).get('snackBarStyle');

  final imageSelectProvider = StateProvider((ref) => 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          MenuIcon(
            icon: Icons.delete,
            onTap: () async {
              _showConfirmDialog(
                context,
                tr('#product.delete'),
                tr('#product.delete_are_you_sure'),
                () => delete(context, productId: product.productId!.toInt(), style: snackBarStyle), // Din asynkrone handling
              );
            },
          ),
          MenuIcon(
            icon: product.isOnline == 1 ? Icons.pause : Icons.play_arrow,
            onTap: () async {
              _showConfirmDialog(
                context,
                product.isOnline == 1 ? tr('#product.set_offline') : tr('#product.set_online'),
                product.isOnline == 1 ? tr('#product.set_offline_text') : tr('#product.set_online_text'),
                () => delete(context, productId: product.productId!.toInt(), style: snackBarStyle), // Din asynkrone handling
              );
            },
          ),
          ImagePickerWidget(
            maxSizeOfImage: Size(1000, 1000),
            allowCustomCrop: false,
            child: Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2.0)), padding: EdgeInsets.all(5), margin: EdgeInsets.all(5), child: Icon(Icons.upload_file, color: Colors.white)),
            onImage: (imageBytes) {
              ShoporamaService().putImage(productId: product.productId!, image: imageBytes);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr("#image.image_uploaded"), style: snackBarStyle), backgroundColor: snackBarStyle.backgroundColor));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.images != null && product.images!.isNotEmpty)
                  Consumer(
                    builder: (context, ref, child) {
                      final imageSelectState = ref.watch(imageSelectProvider);

                      final primaryImage = product.images![imageSelectState];
                      return Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: primaryImage.url,
                                  height: 200,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Padding(padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10), child: Center(child: SpinKitCircle(color: Colors.amber, size: 50.0))),
                                  errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 100),
                                ),
                                if (product.images!.length > 1) ...[
                                  Divider(color: Colors.black),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      // Tilføjet SingleChildScrollView
                                      scrollDirection: Axis.horizontal, // Aktiverer vandret scroll
                                      child: Row(
                                        children:
                                            product.images!.asMap().entries.map((entry) {
                                              final index = entry.key;
                                              final image = entry.value;

                                              return GestureDetector(
                                                onTap: () => ref.read(imageSelectProvider.notifier).state = index,
                                                child: Padding(
                                                  // Tilføjet Padding for at give mellemrum mellem billederne
                                                  padding: const EdgeInsets.symmetric(horizontal: 4.0), // Juster padding efter behov
                                                  child: CachedNetworkImage(
                                                    imageUrl: image.url,
                                                    height: 50,
                                                    fit: BoxFit.contain,
                                                    placeholder: (context, url) => const Padding(padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10), child: Center(child: SpinKitCircle(color: Colors.amber, size: 50.0))),
                                                    errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 100),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: MenuIcon(
                              color: Colors.black,
                              icon: Icons.delete,
                              onTap: () async {
                                try {
                                  await deleteImage(context, productId: product.productId!, imageId: primaryImage.imageId!);
                                } catch (e) {
                                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('#error.try_agian'), style: snackBarStyle), backgroundColor: snackBarStyle.backgroundColor));
                                }
                                if (context.mounted) Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                SizedBox(height: 26),
                Text(product.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),

                Text("${tr("#product.price")} ${product.price != null ? "${product.price} ${tr("#product.money_type")}" : tr("#product.no_price")}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),

                Row(children: []),
                SizedBox(height: 26),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: 100),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(10)),
                  child: MarkdownBody(data: product.description?.toMarkdown() ?? tr("#product.no_description"), styleSheet: markdownStyle), // Text(product.description ?? tr("#product.no_description"), style: productText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> delete(BuildContext context, {required int productId, required TextStyle style}) async {
    try {
      await ShoporamaService().deleteProduct(productId: productId);
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('#error.try_agian'), style: style), backgroundColor: style.backgroundColor));
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> onlineStatus(BuildContext context, {required int productId, required bool isOnline, required TextStyle style}) async {
    try {
      await ShoporamaService().postOnlineStatus(productId: productId, isOnline: isOnline);
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('#error.try_agian'), style: style), backgroundColor: style.backgroundColor));
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> deleteImage(BuildContext context, {required int productId, required String imageId}) async {
    try {
      await ShoporamaService().deleteImage(productId: productId, imageId: imageId);
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('#error.try_agian'), style: snackBarStyle), backgroundColor: snackBarStyle.backgroundColor));
    }
    if (context.mounted) Navigator.of(context).pop();
  }
}

// Hovedfunktion for at vise Confirm Dialog
Future<void> _showConfirmDialog(BuildContext context, String title, String contentText, Future<void> Function() asyncOperation) async {
  bool isConfirmed = false;

  // Provider for loading state
  final provider = StateProvider((ref) => false);

  final snackBarStyle = defaults.textStyle(null).get('snackBarStyle');

  // Vis dialogen
  isConfirmed = await showDialog(
    context: context,
    barrierDismissible: false, // Forhindrer at lukke dialogen ved at trykke udenfor
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(provider);

          return AlertDialog(
            title: Text(title), // Dynamisk titel
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dynamisk tekst for handlingen
                Text(contentText),
                SizedBox(height: 20),
                // Spinner vises kun, når state er true (under operationen)
                if (state) Center(child: SpinKitCircle(color: Colors.blue, size: 50.0)),
              ],
            ),
            actions: [
              if (!state) // Knapperne vises kun, når operationen ikke er igang
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Luk uden at bekræfte
                  },
                  child: Text("Cancel"),
                ),
              if (!state) // Knapperne vises kun, når operationen ikke er igang
                TextButton(
                  onPressed: () async {
                    // Sæt state til true (operationen kører nu)
                    ref.read(provider.notifier).state = true;

                    // Kald den asynkrone operation
                    try {
                      await asyncOperation();

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr("#product.action_completed"), style: snackBarStyle), backgroundColor: snackBarStyle.backgroundColor));
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    } catch (_) {
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('#error.try_agian'), style: snackBarStyle), backgroundColor: snackBarStyle.backgroundColor));
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }

                    // Luk dialogen og vis en snackbar med status
                  },
                  child: Text("OK"),
                ),
            ],
          );
        },
      );
    },
  );

  // Når handlingen er bekræftet
  if (isConfirmed) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr("#product.action_completed"), style: snackBarStyle), backgroundColor: snackBarStyle.backgroundColor));
  }
}
