import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.title = "",
    this.value = 0.0,
    this.inStock = true,
    this.photoUrl = "",
  });

  String id;
  String title;
  double value;
  bool inStock;
  String photoUrl;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        value: double.parse(json["value"].toString()),
        inStock: json["inStock"],
        photoUrl: json["photoURL"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "value": value,
        "inStock": inStock,
        "photoURL": photoUrl,
      };
}
