class StudentModel {
  String? id;
  String? className;
  String? image;
  String? name;
  dynamic pocketMoney;
  List<dynamic>? allergies;
  late Map<String, dynamic> dailySpending;
  String? parent;
  StudentModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      id = json['uid'];
      name = json['name'];
      image = json['image'];
      parent = json['parent'];
      className = json['class_name'];

      if (json.containsKey('parent')) {
        parent = json['parent'];
      }

      if (json.containsKey('pocket money')) {
        pocketMoney = json['pocket money'].toInt();
      }
      
      if (json.containsKey('dailySpending')) {
        dailySpending = json['dailySpending'];
      } else {
        dailySpending = {'value': 0.0, 'updateTime': DateTime.now()};
      }
      if (json.containsKey('allergies')) {
        allergies = json['allergies'];
      }
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
