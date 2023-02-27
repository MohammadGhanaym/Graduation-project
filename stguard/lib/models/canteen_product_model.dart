class CanteenProductModel {
  late String name;
  late String image;
  late String category;
  late double price;
  List<dynamic>? allergies;
  CanteenProductModel(
      {required this.name, required this.image, required this.price});

  CanteenProductModel.fromMap(Map<String, dynamic> map, String cat) {
    name = map['name'];
    price = map['price'].toDouble();
    image = map['image'];
    category = cat;
    if (map.keys.contains('allergies')) {
      allergies = map['allergies'];
    }
  }
}
