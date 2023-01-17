class userModel {
  String? id;
  String? email;
  String? role;

  userModel({this.id, this.email, this.role});

  userModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    role = json['role'];

  }
  toMap() => {
        'id': id,
        'email': email,
        'role': role,
      };
}
