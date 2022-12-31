class ProductModel {
  late String trans_id;
  late String product_name;
  late dynamic price;

  ProductModel({
    required this.trans_id,
    required this.product_name,
    required this.price,
  });

  ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      trans_id = json['trans_id'];

      product_name = json['product'];

      price = json['price'];
    }
  }
}
