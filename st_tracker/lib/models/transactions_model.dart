class ProductModel {
  late String st_id;
  late String trans_id;
  late String date;
  late String product_name;
  late dynamic price;

  ProductModel({
    required this.st_id,
    required this.trans_id,
    required this.date,
    required this.product_name,
    required this.price,
  });

  ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      st_id = json['st_id'];
      trans_id = json['trans_id'];

      date = json['date'];

      product_name = json['product'];

      price = json['price'];
    }
  }
}
