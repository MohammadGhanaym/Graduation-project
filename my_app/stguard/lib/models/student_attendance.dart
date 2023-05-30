
class LessonAttendance {
  late String lessonName;
  late String teacherName;
  late String subject;
  late DateTime datetime;
  late Map<String, dynamic> attendance;
  String? id;
  LessonAttendance({
    required this.lessonName,
    required this.teacherName,
    required this.subject,
    required this.datetime,
    required this.attendance,
    this.id
  });

  LessonAttendance.fromMap(Map<String, dynamic> map, {String? attendanceId}) {
    id = attendanceId;
    lessonName = map['lesson'];
    teacherName = map['teacher'];
    subject = map['subject'];
    datetime = map['datetime'].toDate();
    attendance = Map<String, dynamic>.from(map['attendance']);
  }

  Map<String, dynamic> toMap() {
    return {
      'lesson': lessonName,
      'teacher': teacherName,
      'subject': subject,
      'datetime': datetime,
      'attendance': attendance,
    };
  }
}
