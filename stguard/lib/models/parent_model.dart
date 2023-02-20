class ParentModel {
  late String id;
  late String email;
  late String role;
  late String name;
  late double balance;
  ParentModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.balance,
      required this.role});

  ParentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    balance = json['balance'].toDouble();
  }
  toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'balance': balance
      };
}
