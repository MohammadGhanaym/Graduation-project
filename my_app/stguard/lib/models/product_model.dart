class ProductModel {
  late String transId;
  late String productName;
  late dynamic price;
  late dynamic quantity;
  ProductModel({
    required this.transId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      transId = json['trans_id'];

      productName = json['product'];

      price = json['price'];

      quantity = json['quantity'];
    }
  }
}
