class userModel {
  String? id;
  String? password;
  String? role;
  dynamic balance;

  userModel({this.id, this.password, this.balance});

  userModel.fromJson(Map<String, dynamic> json) {
    id = json['UID'];
    password = json['password'];
    balance = json['balance'];
    role = json['role'];
  }
}
