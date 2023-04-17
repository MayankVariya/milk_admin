class SelectedProductModel {
  final String product;
  final double morningQ;
  final double eveningQ;

  SelectedProductModel(
      {required this.product, required this.morningQ, required this.eveningQ});

  factory SelectedProductModel.fromJson(Map<String, dynamic> json) {
    return SelectedProductModel(
        product: json["product"],
        morningQ: json["morningQ"],
        eveningQ: json["eveningQ"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product,
      'morningQ': morningQ,
      'eveningQ': eveningQ,
    };
  }
}

List<SelectedProductModel> selectedProduct = [];
