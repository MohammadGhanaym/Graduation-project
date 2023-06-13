class NotificationModel {
  final int id;
  final String title;
  final DateTime date;
  final String body;

  NotificationModel({
    required this.id,
    required this.title,
    required this.date,
    required this.body,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      body: map['body'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'body': body,
    };
  }
}
