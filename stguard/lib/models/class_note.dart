class ClassNote {
  late String title;
  String? content;
  late String subject;
  Map<String, dynamic>? files;
  late String to;
  late DateTime datetime;

  ClassNote(
      {required this.title,
      required this.subject,
      required this.to,
      required this.datetime,
      this.content,
      this.files});

  ClassNote.fromMap(Map<String, dynamic>? map) {
    if (map != null) {
      title = map['title'];
      content = map['content'];
      subject = map['subject'];
      files = map['files'];
      to = map['to'];
      datetime = map['datetime'].toDate();
    }
  }
}
