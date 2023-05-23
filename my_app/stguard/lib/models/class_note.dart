class NoteModel {
  final String title;
  final String? id;
  final String? content;
  final String subject;
  final String studentReceiver;
  final String? teacherName;
  final Map<String, dynamic>? files;
  final DateTime datetime;

  NoteModel({
    required this.title,
    this.content,
    this.id,
    required this.subject,
    required this.studentReceiver,
    this.teacherName,
    this.files,
    required this.datetime,
  });

  factory NoteModel.fromMap(Map<String, dynamic> json, {String? id}) {
    
    return NoteModel(
      title: json['title'],
      content: json['content'],
      subject: json['subject'],
      id:id,
      studentReceiver: json['to'],
      teacherName: json['from'],
      files: json['files'],
      datetime: json['datetime'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'subject': subject,
      'to': studentReceiver,
      'from': teacherName,
      'files': files,
      'datetime': datetime.toIso8601String(),
    };
  }
}
