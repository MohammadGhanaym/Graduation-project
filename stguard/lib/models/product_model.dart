class ProductModel {
  late String trans_id;
  late String productName;
  late dynamic price;
  late dynamic quantity;
  ProductModel({
    required this.trans_id,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      trans_id = json['trans_id'];

      productName = json['product'];

      price = json['price'];

      quantity = json['quantity'];
    }
  }
}
