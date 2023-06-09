class CanteenProductModel {
  late String name;
  late String image;
  late String category;
  late double price;
  late double calories;
  List<dynamic>? allergies;
  CanteenProductModel(
      {required this.name, required this.image, required this.price});

  CanteenProductModel.fromMap(Map<String, dynamic> map, String cat) {
    name = map['name'];
    price = map['price'].toDouble();
    image = map['image'];
    category = cat;
    if (map.keys.contains('calories')) {
      calories = map['calories'].toDouble();
    }
    if (map.keys.contains('allergies')) {
      allergies = map['allergies'];
    }
  }
}

class TransactionModel {
  final Buyer buyer;
  final DateTime date;
  final dynamic totalPrice;
  final List<Product> products;

  TransactionModel({
    required this.buyer,
    required this.totalPrice,
    required this.date,
    required this.products,
  });

  TransactionModel.fromMap(Map<String, dynamic> map)
      : buyer = Buyer.fromMap(map['buyer']),
        totalPrice = map['total_price'],
        date = map['date'].toDate(),
        products = List<Product>.from(
          map['products'].map((productMap) => Product.fromMap(productMap)),
        );
}

class Product {
  final String name;
  final dynamic price;
  final int quantity;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
  });

  Product.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        price = map['price'].toDouble(),
        quantity = map['quantity'];
}

class Buyer {
  final String name;
  final String id;

  Buyer({
    required this.name,
    required this.id,
  });

  Buyer.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        id = map['id'];
}
