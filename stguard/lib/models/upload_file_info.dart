import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadFileInfo {
  final String fileName;
  String progress;
  firebase_storage.UploadTask uploadTask;
  UploadFileInfo({required this.fileName, required this.progress, required this.uploadTask});
}
