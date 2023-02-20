class TeacherModel {
  late String id;
  late String email;
  late String role;
  late String name;
  TeacherModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role});

  TeacherModel.fromJson(Map<String, dynamic> json) {
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
