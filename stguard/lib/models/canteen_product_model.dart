class CanteenProductModel {
  late String id;
  late String name;
  late String image;
  late double price;
  List<String>? allergies;
  CanteenProductModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});

  CanteenProductModel.fromMap(String product_id, Map<String, dynamic> map) {
    id = product_id;
    name = map['name'];
    price = map['price'].toDouble();
    image = map['image'];
    if (map.keys.contains('allergies')) {
      allergies = map['allergies'];
    }
  }
}
