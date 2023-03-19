class ParentModel {
  late String id;
  late String email;
  late String role;
  late String name;
  late double balance;
  String? deviceToken;
  ParentModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.balance,
      required this.role,
      this.deviceToken});

  ParentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    balance = json['balance'].toDouble();
    if (json.containsKey('device_token')) {
      deviceToken = json['device_token'];
    }
  }
  toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'balance': balance,
        'device_token':deviceToken
      };
}
