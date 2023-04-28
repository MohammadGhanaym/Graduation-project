class StudentAttendanceModel {
  String stID;
  String studentName;
  String lessonName;
  int isPresent;

  StudentAttendanceModel(
      {required this.stID,
      required this.studentName,
      required this.lessonName,
      required this.isPresent});

  factory StudentAttendanceModel.fromMap(Map<String, dynamic> map) {
    return StudentAttendanceModel(
        stID: map['student_id'],
        studentName: map['student_name'],
        lessonName: map['lesson'],
        isPresent: map['is_present']);
  }
}

class Attendance {
  String lesson;
  String grade;
  String stID;
  String stName;
  int isPresent;

  Attendance(
      {required this.lesson,
      required this.grade,
      required this.stID,
      required this.stName,
      required this.isPresent});

  Map<String, dynamic> toMap() {
    return {
      'lesson': lesson,
      'grade': grade,
      'student_stID': stID,
      'student_name': stName,
      'is_present': isPresent,
    };
  }
}

class LessonModel {
  final String name;
  final String grade;
  final DateTime datetime;

  LessonModel(
      {required this.name, required this.grade, required this.datetime});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'grade': grade,
      'datetime': datetime.toIso8601String(),
    };
  }

  static LessonModel fromMap(Map<String, dynamic> map) {
    return LessonModel(
      name: map['name'],
      grade: map['grade'],
      datetime: DateTime.parse(map['datetime']),
    );
  }
}
