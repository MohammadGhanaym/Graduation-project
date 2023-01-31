class userModel {
  late String id;
  late String email;
  late String role;
  late String name;
  userModel({required this.id,required this.name, required this.email,required this.role});

  userModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
  }
  toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
      };
}
