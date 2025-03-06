import 'package:customer_app/PRODUCT/product_item_screen.dart';
import 'package:customer_app/_SERVICE/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCircle;

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
  const ProductPage({super.key, this.supplierId});

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
          final sortedCategoryIds = getUniqueSortedCategoryIds(categories, products);

          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    MenuIcon(icon: Icons.clear_all_outlined, onTap: () async {}),
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
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                      child: ListTile(leading: image == null ? null : Image.network(image), title: Text(product.name), subtitle: Text("ID: ${product.productId}"), shape: const Border(bottom: BorderSide(color: Colors.white, width: 1))),
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

  List<int> getUniqueSortedCategoryIds(List<ShopCategory> categories, List<Product> products) {
    final Set<int> uniqueCategoryIds = {};
    for (var product in products) {
      if (product.categories != null) {
        uniqueCategoryIds.addAll(product.categories!);
      }
    }
    return uniqueCategoryIds.toList()..sort();
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
        backgroundColor: const Color.fromARGB(255, 68, 101, 129), // Baggrundsfarve for tag
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
