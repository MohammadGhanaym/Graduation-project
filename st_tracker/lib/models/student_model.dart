class studentModel {
  String? id;
  bool? attendanceStatus;
  String? grade;
  String? image;
  Map<String, dynamic>? location;
  String? name;
  dynamic pocket_money;
  List<dynamic>? restricted_food;

  studentModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      id = json['uid'];
      name = json['name'];
      image = json['image'];
      grade = json['grade'];
      pocket_money = json['pocket money'];
      location = json['location'];
      restricted_food = json['restricted food'];
      attendanceStatus = json['attendance status'];
    }
  }
}
