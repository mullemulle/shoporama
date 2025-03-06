import 'package:easy_localization/easy_localization.dart' show tr;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../START/design.dart';
import '../_SERVICE/product_model.dart' show Product;
import '../_SERVICE/shoporama.dart';
import 'menu_icon.dart';

class ProductEditImageScreen extends StatelessWidget {
  final Product product;
  ProductEditImageScreen({super.key, required this.product});

  final imageSelectProvider = StateProvider((ref) => 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          MenuIcon(
            icon: Icons.upload_file,
            onTap: () async {
              // Implement online/pause functionality
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer(
              builder: (context, ref, child) {
                final imageSelectState = ref.watch(imageSelectProvider);
                final primaryImage = product.images != null && product.images!.isNotEmpty ? product.images![imageSelectState] : null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.images == null || product.images!.isEmpty)
                      Container(
                        width: double.infinity,
                        height: 200,

                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                        child: Center(child: Text('Vælg billede', style: h2Style.copyWith(color: Colors.black))),
                      ),
                    if (product.images != null && product.images!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 200,
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(10)),

                        child: Column(
                          children: [
                            if (primaryImage != null)
                              CachedNetworkImage(
                                imageUrl: primaryImage.url,
                                height: 200,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => const Padding(padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10), child: Center(child: SpinKitCircle(color: Colors.amber, size: 50.0))),
                                errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 100),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (primaryImage != null)
                                  MenuIcon(
                                    icon: Icons.delete,
                                    onTap: () async {
                                      try {
                                        await deleteImage(product.productId!, primaryImage.imageId!);
                                      } catch (e) {
                                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('#error.try_agian'))));
                                      }
                                      if (context.mounted) Navigator.of(context).pop();
                                    },
                                    color: Colors.black,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (product.images!.length > 1)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children:
                              product.images!.asMap().entries.map((entry) {
                                final index = entry.key;
                                final image = entry.value;

                                return ListTile(
                                  onTap: () => ref.read(imageSelectProvider.notifier).state = index,
                                  leading: Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: image.url,

                                      fit: BoxFit.contain,
                                      placeholder: (context, url) => const Padding(padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10), child: Center(child: SpinKitCircle(color: Colors.amber, size: 50.0))),
                                      errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 100),
                                    ),
                                  ),
                                  title: image.description == null ? null : Text(image.description!),
                                );
                              }).toList(),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> delete({required productId}) async {
    await ShoporamaService().deleteProduct(productId: productId);
  }

  Future<void> deleteImage(int productId, String imageId) async {
    await ShoporamaService().deleteImage(productId: productId, imageId: imageId);
  }
}

// Hovedfunktion for at vise Confirm Dialog
Future<void> _showConfirmDialog(BuildContext context, String title, String contentText, Future<void> Function() asyncOperation) async {
  bool isConfirmed = false;

  // Provider for loading state
  final provider = StateProvider((ref) => false);

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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Action completed!")));
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    } catch (_) {
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Action faild!")));
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Action confirmed!")));
  }
}
