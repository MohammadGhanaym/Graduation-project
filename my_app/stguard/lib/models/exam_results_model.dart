class ExamResults {
  final String examType;
  final double maximumAchievableGrade;
  final String subject;
  final String teacher;
  final DateTime datetime;
  final Map<String, dynamic> grades;
  final id;
  ExamResults({
    required this.examType,
    required this.maximumAchievableGrade,
    required this.subject,
    required this.teacher,
    required this.grades,    required this.datetime,

    this.id
  });

  factory ExamResults.fromMap(Map<String, dynamic> map, {String? res_id}) {
    return ExamResults(
      examType: map['exam_type'],
      maximumAchievableGrade: map['maximum_achievable_grade'],
      subject: map['subject'],
      teacher: map['teacher'],
      id: res_id,      datetime: map['datetime'].toDate(),

      grades: map['grades'],
    );
  }
}
