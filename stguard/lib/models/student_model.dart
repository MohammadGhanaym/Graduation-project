class StudentModel {
  String? id;
  String? className;
  String? image;
  String? name;
  dynamic pocketMoney;
  String? parent;
  StudentModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      id = json['uid'];
      name = json['name'];
      image = json['image'];
      parent = json['parent'];
      className = json['class_name'];
    }
  }
}

class SchoolAttendanceModel {
  late bool arrived;
  late DateTime arriveDate;
  late bool left;
  late DateTime leaveDate;
  SchoolAttendanceModel.fromJson(Map<String, dynamic> json) {
    arrived = json['arrive_state'];
    arriveDate = json['arrive_date'].toDate();
    left = json['leave_state'];
    leaveDate = json['leave_date'].toDate();
  }
}

class StudentLocationModel {
  late double lat;
  late double long;
  late String date;
  late String time;
  StudentLocationModel.fromJson(Map<String, dynamic> json) {
    lat = json['latitude'];
    long = json['longitude'];
    date = json['date'];
    time = json['time'];
  }
}
