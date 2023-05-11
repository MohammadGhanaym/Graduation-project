import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DownloadFileInfo {
  double progress;
  firebase_storage.DownloadTask downloadTask;
  DownloadFileInfo({required this.progress, required this.downloadTask});
}