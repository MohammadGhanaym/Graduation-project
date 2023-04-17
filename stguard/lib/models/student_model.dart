class StudentModel {
  late String id;
  String? className;
  String? image;
  String? name;
  dynamic calorieLimit;
  dynamic pocketMoney;
  List<dynamic>? allergies;
  late Map<String, dynamic> dailySpending;
  late Map<String, dynamic> dailyCalorie;
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
      } else {
        pocketMoney = 0.0;
      }

      if (json.containsKey('dailySpending')) {
        dailySpending = json['dailySpending'];
      } else {
        dailySpending = {'value': 0.0, 'updateTime': DateTime.now()};
      }
      if (json.containsKey('allergies')) {
        allergies = json['allergies'];
      }
      if (json.containsKey('calorie')) {
        calorieLimit = json['calorie'].toDouble();
      } else {
        calorieLimit = 0.0;
      }
      if (json.containsKey('dailyCalorie')) {
        dailyCalorie = json['dailyCalorie'];
      } else {
        dailyCalorie = {'value': 0.0, 'updateTime': DateTime.now()};
      }
    }
  }

  void resetDailySpending() {
    dailySpending = {'value': 0.0, 'updateTime': DateTime.now()};
  }
    void resetDailyCalorie() {
    dailyCalorie = {'value': 0.0, 'updateTime': DateTime.now()};
  }
}

class SchoolAttendanceModel {
  late String action;
  late DateTime date;

  SchoolAttendanceModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    date = json['updateTime'].toDate();
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
