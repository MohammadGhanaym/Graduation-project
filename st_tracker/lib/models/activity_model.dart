class ActivityModel {
  late String st_id;
  late String trans_id;
  late String date;
  late String activity;

  ActivityModel({
    required this.st_id,
    required this.trans_id,
    required this.date,
    required this.activity,
  });

  ActivityModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      st_id = json['id'];
      trans_id = json['trans_id'];

      date = json['date'];

      activity = json['activity'];
    }
  }
}
