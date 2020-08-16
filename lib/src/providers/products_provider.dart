import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:formvalidation/src/models/product_model.dart';
import 'package:image_picker/image_picker.dart';
import "package:mime_type/mime_type.dart";
import "package:http_parser/http_parser.dart";

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

  Future<int> deleteProduct(String id) async {
    final url = "$_url/productos/$id.json";
    final response = await http.delete(url);

    print(response.body);
    return 1;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final url = '$_url/productos/${product.id}.json';
    final response = await http.put(url, body: productModelToJson(product));

    final decodedData = json.decode(response.body);
    print(decodedData);

    return true;
  }

  Future<String> uploadImage(PickedFile image) async {
    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/dgieo5oyq/image/upload?upload_preset=tsv7oqsw");
    final mimeType = mime(image.path).split('/');
    final imageRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );
    imageRequest.files.add(file);

    final streamResponse = await imageRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print("algo salio mal");
      print(response.body);
      return null;
    }

    final responseData = json.decode(response.body);
    return responseData["secure_url"];
  }
}
