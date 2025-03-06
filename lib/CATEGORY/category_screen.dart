import 'package:flutter/material.dart';

import '../_SERVICE/shoporama.dart';
import '../_SERVICE/category_model.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shoporama - CODEWIRE.NET')),
      body: Center(
        child: FutureBuilder<List<ShopCategory>>(
          future: ShoporamaService().fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No products available");
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final category = snapshot.data![index];

                  final image = category.images.isNotEmpty ?? false ? category.images.first.url.replaceAll('fit-1000x1000', 'fit-150x150') : null;

                  return GestureDetector(
                    onTap: () async {}, // onCreateGroup(context, position),,
                    child: ListTile(leading: image == null ? null : Image.network(image), title: Text(category.name), subtitle: Text("ID: ${category.categoryId}"), shape: Border(bottom: BorderSide(color: Colors.white, width: 1))),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
