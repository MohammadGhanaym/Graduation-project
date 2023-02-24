class CanteenProductModel {
  late String name;
  late String image;
  late double price;
  List<dynamic>? allergies;
  CanteenProductModel(
      {
      required this.name,
      required this.image,
      required this.price});

  CanteenProductModel.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    price = map['price'].toDouble();
    image = map['image'];
    if (map.keys.contains('allergies')) {
      allergies = map['allergies'];
    }
  }
}
