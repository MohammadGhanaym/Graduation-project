class TeacherModel {
  late String id;
  late String email;
  late String role;
  late String name;
  List<dynamic>? subjects;
  TeacherModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      this.subjects});


  TeacherModel.fromJson(Map<String, dynamic> json, List<dynamic> subj) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    subjects = subj;
  }
  toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
      };
}
