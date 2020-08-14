import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:formvalidation/src/models/product_model.dart';

class ProductProvider {
  final String _url = "https://flutter-app-b330c.firebaseio.com";

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/productos.json';
    final response = await http.post(url, body: productModelToJson(product));

    final decodedData = json.decode(response.body);
    print(decodedData);

    return true;
  }

  Future<List<ProductModel>> getAllProducts() async {
    final url = '$_url/productos.json';
    final response = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(response.body);
    final products = new List<ProductModel>();

    if (decodedData == null) return [];

    decodedData.forEach((id, product) {
      final temp = ProductModel.fromJson(product);
      temp.id = id;
      products.add(temp);
    });

    print(products);

    return products;
  }
}
