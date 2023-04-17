class ProductModel {
  String? key;
  String? type;
  double? price;

  ProductModel({required this.key, required this.type, required this.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        key: json["product"], type: json["type"], price: json["price"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'product': key,
      'type': type,
      'price': price,
    };
  }
}
