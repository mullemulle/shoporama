import 'dart:convert';
import 'dart:developer';
import 'package:customer_app/_SERVICE/product_model.dart' show Product, ProductResponse;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'category_model.dart' show ShopCategory;
import 'supplier_model.dart' show Supplier;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shoporama.g.dart';

class ShoporamaService {
  final String baseUrl = "https://www.shoporama.dk/REST/";
  final String authorization = "Shoporama d2ee182259a2d455093df39c34cc3cee";

  Map<String, String> get _headers => {
    "Host": "www.shoporama.dk",
    "Accept": "*/*",
    "Authorization": authorization,
    "User-Agent": "App agent",
    utf8.decode(utf8.encode("content-type")): utf8.decode(utf8.encode("application/json")), // Sikrer JSON-format
  };

  /* **************************************************** */
  // CATEGORY
  /* **************************************************** */
  Future<List<ShopCategory>> fetchCategories({DateTime? lastModified, int limit = 100, int offset = 0}) async {
    try {
      final Uri url = Uri.parse("${baseUrl}category?${lastModified != null ? "last_modified=${lastModified.toIso8601String()}&" : ""}limit=$limit&offset=$offset");

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        // Når svaret er OK (200), konverter JSON-responsen til en liste af Category objekter
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((jsonItem) => ShopCategory.fromJson(jsonItem)).toList();
      } else {
        throw Exception("Failed to load categories: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching categories: $e");
    }
  }

  /* **************************************************** */
  // PRODUCT
  /* **************************************************** */
  Future<void> postProductSimple({required Product product}) async {
    try {
      final Uri url = Uri.parse("${baseUrl}product");

      final bodyInJSON = utf8.encode(
        jsonEncode({
          'name': product.name, // , 'supplier_id': product.supplierId, 'price': product.price, 'is_online': product.isOnline, 'no_shopping': 0,
        }),
      );

      dioPost(url: "${baseUrl}product", headers: _headers, bodyInJSON: {'name': product.name});

      /*
      final response = await http.post(
        url,
        headers: _headers,
        body: bodyInJSON,
        encodi/ng: Utf8Codec(), // Korrekt JSON encoding
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception("Failed to create product: ${response.statusCode} - ${response.reasonPhrase}\nResponse body: ${response.body}");
      }*/
    } catch (e) {
      throw Exception("Error creating product: $e");
    }
  }

  Future<void> deleteProduct({required int productId}) async {
    try {
      final Uri url = Uri.parse("${baseUrl}product/$productId");

      final response = await http.delete(url, headers: _headers);

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to deleting products: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  Future<ProductResponse> fetchProducts({required int? supplierId, DateTime? lastModified, int limit = 100, int offset = 0}) async {
    try {
      final Uri url = Uri.parse("${baseUrl}product?${supplierId != null ? 'supplier_id=$supplierId&' : ''}${lastModified != null ? "last_modified=${lastModified.toIso8601String()}&" : ""}limit=$limit&offset=$offset");

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        return ProductResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception("Failed to load products: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  /* **************************************************** */
  // PRODUCT - IMAGE
  /* **************************************************** */
  Future<void> deleteImage({required int productId, required String imageId}) async {
    try {
      final Uri url = Uri.parse("${baseUrl}product/$productId");

      final List<Map<String, dynamic>> bodyInJSON = [
        {'image_id': imageId, 'remove': 1},
      ];

      final response = await http.put(url, headers: _headers, body: jsonEncode(bodyInJSON));

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to deleting product image: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error deleting product image: $e");
    }
  }

  /* **************************************************** */
  // ORDER
  /* **************************************************** */
  Future<Supplier?> fetchOrder({required String supplierId, DateTime? lastModified, int limit = 100, int offset = 0}) async {
    try {
      final Uri url = Uri.parse("${baseUrl}order?$supplierId");

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        try {
          return Supplier.fromJson(json.decode(response.body)[0]);
        } catch (_) {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  /* **************************************************** */
  // Supplier
  /* **************************************************** */
  Future<Supplier?> fetchSupplier({required int supplierId, DateTime? lastModified, int limit = 100, int offset = 0}) async {
    try {
      final Uri url = Uri.parse("${baseUrl}supplier?$supplierId");

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        try {
          return Supplier.fromJson(json.decode(response.body)[0]);
        } catch (_) {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }
}

Future<void> dioPost({required String url, required Map<String, String> headers, required Map<String, dynamic> bodyInJSON}) async {
  try {
    final dio = Dio();

    // Tilføj en interceptor for at logge anmodninger og svar
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    final response = await dio.post(
      url,
      options: Options(headers: headers),
      data: bodyInJSON, // Dio håndterer automatisk JSON-konvertering
    );

    log('Response Status Code: ${response.statusCode}');
    log('Response Data: ${jsonEncode(response.data)}'); // Udskriv responsdata

    // ... håndter responsen
  } on DioException catch (e) {
    if (e.response != null) {
      log('Dio error!');
      log('STATUS: ${e.response?.statusCode}');
      log('DATA: ${e.response?.data}');
      log('HEADERS: ${e.response?.headers}');
    } else {
      // Simple error handling
      log('Error sending request!');
      log(e.message.toString());
      log(e.requestOptions.toString());
    }
  } catch (e) {
    log('Unexpected error: $e');
  }
}

/* ****************************************************************** */
/* RIVERPOD */
/* ****************************************************************** */

@Riverpod(keepAlive: true)
ShoporamaService shoporamaService(ShoporamaServiceRef ref) => ShoporamaService();

@Riverpod(keepAlive: true)
Future<ProductResponse?> fetchProducts(FetchProductsRef ref, {required int? supplierId, int? offset, int? limit}) {
  return ref.watch(shoporamaServiceProvider).fetchProducts(supplierId: supplierId, offset: offset ?? 0, limit: limit ?? 5);
}

@Riverpod(keepAlive: true)
Future<Supplier?> fetchSupplier(FetchSupplierRef ref, {required int supplierId}) {
  return ref.watch(shoporamaServiceProvider).fetchSupplier(supplierId: supplierId);
}

@Riverpod(keepAlive: true)
Future<List<ShopCategory>?> fetchCategories(FetchCategoriesRef ref) {
  return ref.watch(shoporamaServiceProvider).fetchCategories(limit: 1000);
}
