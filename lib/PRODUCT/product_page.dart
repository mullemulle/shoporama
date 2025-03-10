import 'package:customer_app/PRODUCT/product_item_screen.dart';
import 'package:customer_app/START/design.dart';
import 'package:customer_app/_SERVICE/category_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCircle;

import '../COMMON/package.dart';
import '../START/default.dart' show defaults;
import '../_SERVICE/shoporama.dart';
import '../_SERVICE/product_model.dart';
import 'menu_icon.dart';
import 'product_edit_screen.dart';

const int limit = 10;

final combinedDataProvider = FutureProvider.autoDispose.family<(ProductResponse?, List<ShopCategory>?), (int?, int)>((ref, params) async {
  final supplierId = params.$1;
  final offset = params.$2;

  final productsFuture = ref.watch(fetchProductsProvider(supplierId: supplierId, limit: limit, offset: offset).future);
  final categoriesFuture = ref.watch(fetchCategoriesProvider.future);

  final results = await Future.wait([productsFuture, categoriesFuture]);

  return (results[0] as ProductResponse?, results[1] as List<ShopCategory>?);
});

class ProductNotifier extends StateNotifier<AsyncValue<(ProductResponse?, List<ShopCategory>?)>> {
  final int? supplierId;
  final Ref ref;
  int offset = 0;
  List<Product> allProducts = [];

  ProductNotifier(this.ref, this.supplierId) : super(const AsyncValue.loading()) {
    fetchData();
  }

  Future<void> fetchData({bool reset = false}) async {
    try {
      if (reset) {
        offset = 0;
        allProducts.clear();
      }
      state = const AsyncValue.loading();
      final combinedData = await ref.read(combinedDataProvider((supplierId, offset)).future);

      if (combinedData.$1 != null) {
        allProducts.addAll(combinedData.$1!.products);
      }
      state = AsyncValue.data((ProductResponse(products: allProducts, paging: combinedData.$1!.paging), combinedData.$2));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    if (state is AsyncLoading) return;
    offset += 5;
    await fetchData();
  }
}

final dataProvider = StateNotifierProvider.family<ProductNotifier, AsyncValue<(ProductResponse?, List<ShopCategory>?)>, int?>((ref, supplierId) => ProductNotifier(ref, supplierId));

class ProductPage extends ConsumerWidget {
  final int? supplierId;
  ProductPage({super.key, this.supplierId});

  final sheetTitleStyle = h1Style;
  final productTileTitleStyle = defaults.textStyle(null).get('productTileTitle');
  final productTileTextStyle = defaults.textStyle(null).get('productTileText');
  final productTilePriceStyle = defaults.textStyle(null).get('productTilePrice');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productResponse = ref.watch(dataProvider(supplierId));

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(dataProvider(supplierId).notifier).fetchData(reset: true);
      },
      child: productResponse.when(
        data: (response) {
          if (response.$1?.products.isEmpty ?? true) {
            return const Center(child: Text("No products available"));
          }

          final products = response.$1!.products;
          final paging = response.$1!.paging;
          final categories = response.$2!;

          final Map<String, ShopCategory> categoryMap = {for (var category in categories) category.categoryId: category};
          final sortedCategoryIds = _getUniqueSortedCategoryIds(categories, products);

          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    MenuIcon(
                      icon: Icons.apps, // clear_all_outlined
                      onTap: () async {
                        _showBottomSheet(context, titleStyle: sheetTitleStyle.copyWith(color: Colors.black), style: productTileTitleStyle.copyWith(color: Colors.white, backgroundColor: Colors.transparent));
                      },
                    ),
                    Spacer(),
                    MenuIcon(icon: Icons.add, onTap: () async => await Navigator.push(context, CupertinoPageRoute(builder: (context) => ProductEditScreen(supplierId: 11002)))),
                  ],
                ),
                CategoryTagsWidget(sortedCategoryIds: sortedCategoryIds, categories: categories, onTap: (category) {}),
                ...products.map<Widget>((product) {
                  final image = product.images?.isNotEmpty ?? false ? product.images?.first.url.replaceAll('fit-1000x1000', 'fit-150x150') : null;

                  return GestureDetector(
                    onTap: () async => await Navigator.push(context, CupertinoPageRoute(builder: (context) => ProductItemScreen(product: product))),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          ListTile(
                            tileColor: Colors.transparent,
                            leading:
                                image == null
                                    ? null
                                    : Stack(
                                      children: [
                                        Padding(padding: EdgeInsets.only(right: 13), child: SizedBox(width: 60, height: 60, child: Image.network(image))),
                                        if (product.images != null && product.images!.length > 1) Positioned(bottom: 2, right: 0, child: Column(children: [Icon(Icons.image_outlined, size: 15, color: Colors.black)])),
                                      ],
                                    ),
                            trailing: product.isOnline == 1 ? null : Icon(Icons.power_off_outlined),
                            title: Text(product.name, style: productTileTitleStyle),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text("${tr("#product.id")} ${product.productId}", style: productTileTextStyle), Text("${tr("#product.price")} ${product.price} ${tr("#product.money_type")}", style: productTilePriceStyle)],
                            ),
                          ),
                          //Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [Expanded(flex: 1, child: Text(tr("#product.price") + " ${product.price}")), Expanded(flex: 1, child: Text("ID: ${product.productId}"))])),
                        ],
                      ),
                    ),
                  );
                }),
                if (paging.offset + paging.count < paging.total)
                  IconButton(
                    onPressed: () {
                      ref.read(dataProvider(supplierId).notifier).loadMore();
                    },
                    icon: Icon(Icons.more, size: 33),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: SpinKitCircle(color: Colors.amber, size: 50.0)),
        error: (e, stack) => Center(child: Text("Error: $e")),
      ),
    );
  }

  List<int> _getUniqueSortedCategoryIds(List<ShopCategory> categories, List<Product> products) {
    final Set<int> uniqueCategoryIds = {};
    for (var product in products) {
      if (product.categories != null) {
        uniqueCategoryIds.addAll(product.categories!);
      }
    }
    return uniqueCategoryIds.toList()..sort();
  }

  void _showBottomSheet(BuildContext context, {required TextStyle titleStyle, required TextStyle style}) {
    final double maxHeight = MediaQuery.of(context).size.height * (2 / 3); // Dynamisk 2/3 af skærmen

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Tillader scrolling
      backgroundColor: Colors.white,
      barrierColor: Colors.black54, // Klik udenfor lukker modal
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: maxHeight), // Sætter max højde til 2/3 af skærmen
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(tr('#product.sheet.list.title'), style: titleStyle)),
                ListTypeTile(title: tr('#product.sheet.list.is_online'), text: tr('#product.sheet.list.is_online_text'), style: style, onTap: () async => onStyleTap(GetProductList.isOnline)),
                ListTypeTile(title: tr('#product.sheet.list.is_not_online'), text: tr('#product.sheet.list.is_not_online_text'), style: style, onTap: () async => onStyleTap(GetProductList.isNotOnline)),
                ListTypeTile(title: tr('#product.sheet.list.in_stock'), text: tr('#product.sheet.list.in_stock_text'), style: style, onTap: () async => onStyleTap(GetProductList.inStock)),
                ListTypeTile(title: tr('#product.sheet.list.not_in_stock'), text: tr('#product.sheet.list.not_in_stock_text'), style: style, onTap: () async => onStyleTap(GetProductList.notInStock)),
                ListTypeTile(title: tr('#product.sheet.list.by_category'), text: tr('#product.sheet.list.by_category_text'), style: style, onTap: () async => onStyleTap(GetProductList.byCategory)),
                ListTypeTile(title: tr('#product.sheet.list.by_brand'), text: tr('#product.sheet.list.by_brand_text'), style: style, onTap: () async => onStyleTap(GetProductList.byBrand)),
                ListTypeTile(title: tr('#product.sheet.list.by_supplier'), text: tr('#product.sheet.list.by_supplier_text'), style: style, onTap: () async => onStyleTap(GetProductList.bySupplier)),
              ],
            ),
          ),
        );
      },
    );
  }

  void onStyleTap(GetProductList listType) {}
}

enum GetProductList { isOnline, isNotOnline, inStock, notInStock, byCategory, byBrand, bySupplier }

class ListTypeTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String? text;
  final TextStyle style;
  ListTypeTile({super.key, required this.title, required this.style, this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
    final subStyle = style.copyWith(fontSize: style.fontSize! - 4);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(color: const Color.fromRGBO(128, 152, 164, 1), borderRadius: BorderRadius.circular(12)),
      child: ListTile(title: Text(title, style: style), subtitle: text == null ? null : Text(text!, style: subStyle), onTap: onTap ?? () => Navigator.pop(context)),
    );
  }
}

class CategoryTagsWidget extends StatelessWidget {
  final List<int> sortedCategoryIds;
  final List<ShopCategory> categories;
  final Function(ShopCategory category) onTap;
  const CategoryTagsWidget({super.key, required this.sortedCategoryIds, required this.categories, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Opret et map fra categoryId til ShopCategory
    final Map<int, ShopCategory> categoryMap = {for (var category in categories) int.parse(category.categoryId): category};

    // Filtrér kun de kategorier, som findes i sortedCategoryIds
    final selectedCategories = sortedCategoryIds.where((categoryId) => categoryMap.containsKey(categoryId)).toList();
    selectedCategories.sort();

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8.0, // Plads mellem tags
        runSpacing: 4.0, // Plads mellem rækker af tags
        children: [
          ...selectedCategories.map((category) {
            return Tag(onTap: (category) => onTap(category), category: categoryMap[category]!);
          }),
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final ShopCategory category;
  final Function(ShopCategory category) onTap;
  const Tag({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(category),
      child: Chip(
        label: Text(category.name),
        padding: EdgeInsets.all(0), // .symmetric(horizontal: 12.0, vertical: 6.0),
        backgroundColor: Color.fromRGBO(128, 152, 164, 1), // Baggrundsfarve for tag
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Afrundede hjørner
        ),
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 12, // Tekstfarve på tag
        ),
      ),
    );
  }
}
