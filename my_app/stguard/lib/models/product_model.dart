class ProductModel {
  late String transId;
  late String name;
  late dynamic price;
  late dynamic quantity;
  ProductModel({
    required this.transId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      transId = json['trans_id'];

      name = json['product'];

      price = json['price'];

      quantity = json['quantity'];
    }
  }
}
