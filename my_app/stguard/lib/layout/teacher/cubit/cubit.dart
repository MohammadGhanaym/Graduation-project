import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/models/class_note.dart';
import 'package:stguard/models/country_model.dart';
import 'package:stguard/models/exam_results_model.dart';
import 'package:stguard/models/school_model.dart';
import 'package:stguard/models/student_attendance.dart';
import 'package:stguard/models/student_model.dart';
import 'package:stguard/models/teacher_model.dart';
import 'package:stguard/models/upload_file_info.dart';

import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/components/constants.dart';
import 'package:stguard/shared/network/local/cache_helper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:stguard/shared/network/remote/notification_helper.dart';

class TeacherCubit extends Cubit<TeacherStates> {
  TeacherCubit() : super(TeacherInitState());
  static TeacherCubit get(context) => BlocProvider.of(context);

  TeacherModel? teacher;
  Future<void> getTeacherInfo() async {
    emit(GetUserInfoLoading());
    if (userID != null) {
      await db.collection('Teachers').doc(userID).get().then((value) {
        if (value.data() != null) {
          print(value.data()!);
          teacher = TeacherModel.fromJson(value.data()!, subjects);
          emit(GetUserInfoSuccess());
          print(teacher!.subjects!);
        } else {
          emit(GetUserInfoError());
        }
      }).catchError((error) {
        print(error.toString());
        emit(GetUserInfoError());
      });
    }
  }

  List<dynamic> classes = [];

  Future<void> getClasses() async {
    classes = [];
    emit(GetClassesLoadingState());

    if (teacherPath != null) {
      await teacherPath!.get().then((value) {
        print(value.data());
        if (value.data() != null) {
          classes = value['classes names'];
          emit(GetClassesSuccessState());
        }
      }).catchError((error) {
        print(error.toString());
        emit(GetClassesErrorState());
      });
    }
  }

  String? selectedClassName;
  void selectClass(String? value) async {
    selectedClassName = value;
    emit(SelectClassSuccess());
    await getStudentsNames();
  }

  List<StudentModel> students = [];

  Future<void> getStudentsNames() async {
    students = [];
    emit(GetStudentNamesLoading());
    attendance = {};
    if (teacherPath != null) {
      await teacherPath!
          .collection('Students')
          .where('class_name', isEqualTo: selectedClassName)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.forEach((element) {
            students.add(StudentModel.fromJson(element.data()));
          });

          emit(GetStudentNamesSuccess());

          print(students);
        } else {
          emit(GetStudentNamesError('Something Went Wrong!'));
        }
      }).catchError((error) {
        print(error.toString());
        emit(GetStudentNamesError('Something Went Wrong!'));
      });
    }
  }

  String? lessonName;
  void setLessonName(lesson) {
    lessonName = lesson;
    emit(SetLessonNameState());
  }

  Map<String, int> attendance = {};
  void addtoAttendance(String stID, var stName, int isPresent) {
    attendance[stID] = isPresent;
    print(attendance[stID]);
    emit(AddStudenttoAttendanceState());
  }

  bool saveToThisLocation = false;
  void saveSelectedFolder(value) {
    saveToThisLocation = value;
    emit(SaveToThisLocationSuccess());
  }

  Future<dynamic> getSelectedFolder() {
    dynamic selectedFolder = CacheHelper.getData(key: 'selected_folder');

    return Future.value(selectedFolder);
  }

  FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>>? teacherPath;
  List<dynamic> subjects = [];
  String? teacherName;
  bool teacherPathLoading = true;
  Future<void> getTeacherPath() async {
    teacherPathLoading = true;
    emit(GetTeacherPathLoadingState());
    await db
        .collection('Teachers')
        .doc(userID)
        .collection('Community')
        .get()
        .then((accountInfo) async {
      if (accountInfo.docs.isNotEmpty) {
        teacherPath = db
            .collection('Countries')
            .doc(accountInfo.docs[0]['country'])
            .collection('Schools')
            .doc(accountInfo.docs[0]['school']);

        emit(GetTeacherPathSuccessState());
        await getClasses();
        teacherPathLoading = false;
        await teacherPath!
            .collection('SchoolStaff')
            .doc(accountInfo.docs[0]['uid'])
            .get()
            .then((value) async {
          print('get subjects');
          if (value.exists) {
            print(value.data());
            subjects = value['subjects'];
            if (value.data()!.containsKey('name')) {
              teacherName = value['name'];
              print(teacherName);
            }
            if (subjects.isNotEmpty) {
              selectedSubject = subjects[0];
            }
          }
        }).catchError((error) {
          print(error.toString());
        });
      } else {
        emit(NeedtoJoinCommunityState());
        teacherPathLoading = false;
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetTeacherPathErrorState());
      teacherPathLoading = false;
    });
    await getTeacherInfo();
  }

  void resetId() {
    db.runTransaction((transaction) async {
      db
          .collection('Teachers')
          .doc(userID)
          .collection('Community')
          .get()
          .then((value) {
        value.docs[0].reference.delete().then((value) async {
          teacherPath = null;
          subjects = [];
          emit(ResetIDSuccessState());
          await getTeacherPath();
        });
      });
    }).catchError((error) {
      print(error.toString());
      emit(ResetIDErrorState());
    });
  }

  void addTeacher(String id) {
    emit(AddTeacherLoadingState());
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.runTransaction((transaction) async {
      db
          .collection('Countries')
          .doc(pickedCountry!.id)
          .collection('Schools')
          .doc(pickedSchool!.id)
          .collection('SchoolStaff')
          .where('id', isEqualTo: id)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty && value.docs[0]['role'] == 'teacher') {
          db
              .collection('Teachers')
              .doc(userID)
              .collection('Community')
              .doc(id)
              .set({
            'uid': value.docs[0].id,
            'country': pickedCountry!.id,
            'school': pickedSchool!.id
          }).then((value) {
            emit(AddTeacherSucessState());
            getTeacherPath();
          });
        }
      });
    }).catchError((error) {
      print(error.toString());
      emit(AddTeacherErrorState(error.toString()));
    });
  }

  List<Country> countries = [];
  void getCountries() {
    countries = [];
    emit(GetCountriesLoadingState());
    db.collection('Countries').get().then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((country) {
          countries.add(Country(name: country['name'], id: country.id));
        });

        emit(GetCountriesSucessState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetCountriesErrorState(error.toString()));
    });
  }

  Country? pickedCountry;

  void pickCountry(int index) {
    pickedCountry = countries[index];
    emit(PickCountryState());
  }

  List<School> schools = [];
  void getSchools() {
    schools = [];
    emit(GetSchoolsLoadingState());

    db
        .collection('Countries')
        .doc(pickedCountry!.id)
        .collection('Schools')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((school) {
          schools.add(School(
              id: school.id, name: school['name'], logo: school['logo']));
        });
        emit(GetSchoolsSucessState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetSchoolsErrorState(error.toString()));
    });
  }

  School? pickedSchool;
  void pickSchool(School school) {
    pickedSchool = school;
    emit(PickSchoolState());
  }

  Future<void> uploadClassAttendance() async {
    try {
      emit(AddNewAttendanceLoadingState());
      if (attendance.isNotEmpty) {
        await teacherPath!
            .collection('classes')
            .doc(selectedClassName)
            .collection('attendance')
            .doc()
            .set({
          'lesson': lessonName,
          'teacher': teacherName,
          'subject': selectedSubject,
          'datetime': DateTime.now(),
          'attendance': attendance
        }).then((value) async {
          emit(AddNewAttendanceSuccessState());
          gradeFilePath = null;
          await NotificationHelper.sendNotification(
              title: 'Class Attendance Update',
              body:
                  "New attendance recorded for $lessonName, $selectedSubject.",
              receiverToken: '/topics/$selectedClassName');
        }).catchError((error) {
          emit(AddNewAttendanceErrorState(error.toString()));
          print(error.toString());
        });
      } else {
        emit(AttendanceNotTakenState());
      }
    } catch (e) {
      print(e.toString());
      emit(AddNewAttendanceErrorState(e.toString()));
    }
  }

  List<LessonAttendance>? classLessonAttendace;
  DateTime filterByDate = DateTime.now();
  Future<void> updateDate({required DateTime? date}) async {
    allTime = false;
    if (date != null) {
      filterByDate = date;
      emit(UpdateDateState());
      if (selectedClassName != null) {
        await filterNotesByClass(selectedClassName);
        await filterExamResultsByClass(selectedClassName);
        await filterAttendanceByClass(selectedClassName);
      }
    }
  }

  bool allTime = false;
  void changeAllTime(bool value) async {
    allTime = value;
    emit(ChangeAllTimeState());
    if (selectedClassName != null) {
      await filterNotesByClass(selectedClassName);
      await filterExamResultsByClass(selectedClassName);
      await filterAttendanceByClass(selectedClassName);
    }
  }

  Future<void> filterAttendanceByClass(dynamic className) async {
    try {
      emit(GetLessonAttendanceLoadingState());
      classLessonAttendace = [];
      selectedClassName = className;

      await teacherPath!
          .collection('classes')
          .where('name', isEqualTo: className)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          Query<Map<String, dynamic>> query = value.docs[0].reference
              .collection('attendance')
              .where('teacher', isEqualTo: teacherName);
          if (!allTime) {
            query = query
                .where('datetime',
                    isGreaterThanOrEqualTo: DateTime(filterByDate.year,
                        filterByDate.month, filterByDate.day))
                .where('datetime',
                    isLessThan: DateTime(filterByDate.year, filterByDate.month,
                        filterByDate.day + 1));
          }
          await query.orderBy('datetime', descending: true).get().then((value) async {
            value.docs.forEach((element) {
              classLessonAttendace!.add(LessonAttendance.fromMap(element.data(),
                  attendanceId: element.id));
            });
            print(classLessonAttendace);
            print(value.docs.length);
            emit(GetLessonAttendanceSuccessState());
            await getStudentsNames();
          }).catchError((error) {
            emit(GetLessonAttendanceErrorState());
            print(error.toString());
          });
        }
      });
    } catch (e) {
      print(e);
      emit(SomethingWentWrong());
    }
  }

  Future<void> deleteClassAttendance(String? attendanceId) async {
    try {
      emit(DeleteLessonAttendanceLoadingState());
      await teacherPath!
          .collection('classes')
          .doc(selectedClassName)
          .collection('attendance')
          .doc(attendanceId)
          .delete()
          .then((value) async {
        emit(DeleteLessonAttendanceSuccessState());
        await filterAttendanceByClass(selectedClassName);
      }).catchError((error) {
        emit(DeleteLessonAttendanceErrorState());
      });
    } catch (e) {
      print(e.toString());
      emit(DeleteLessonAttendanceErrorState());
    }
  }

  Future<void> saveAttendanceToExcel({
    required LessonAttendance lessonAttendance,
    required String filePath,
  }) async {
    if (await Permission.storage.status == PermissionStatus.granted) {
      try {
        // Create an instance of the Excel package
        var excel = Excel.createExcel();
        print(await Permission.storage.status == PermissionStatus.granted);
        // Add a sheet to the excel file
        var sheet = excel[excel.getDefaultSheet()!];

        // Add headers to the sheet
        sheet.updateCell(CellIndex.indexByString("A1"), "Student ID");
        sheet.updateCell(CellIndex.indexByString("B1"), "Student Name");
        sheet.updateCell(CellIndex.indexByString("C1"), "Lesson");
        sheet.updateCell(CellIndex.indexByString("D1"), "Is Present");

        // Add data to the sheet
        for (var i = 0; i < students.length; i++) {
          if (lessonAttendance.attendance.containsKey(students[i].id)) {
            sheet.updateCell(
                CellIndex.indexByString("A${i + 2}"), students[i].id);
            sheet.updateCell(
                CellIndex.indexByString("B${i + 2}"), students[i].name);
            sheet.updateCell(CellIndex.indexByString("C${i + 2}"),
                lessonAttendance.lessonName);
            sheet.updateCell(CellIndex.indexByString("D${i + 2}"),
                lessonAttendance.attendance[students[i].id]);
          }
        }

        final directory = Directory(filePath);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final fileName =
            '${lessonAttendance.lessonName}_${DateTime.now().microsecondsSinceEpoch}.xlsx';
        final file = File('$filePath/$fileName');
        await file.writeAsBytes(excel.encode()!);

        emit(SavetoExcelSuccessState());
      } catch (e) {
        emit(SavetoExcelErrorState());
        print(e.toString());
      }
    } else {
      requestWritePermission();
    }
  }

  bool sendToAll = true;
  String? selectedSubject;
  void selectSubject(String? value) {
    selectedSubject = value;
    emit(SelectSubjectSuccessState());
  }

  void changeSendToAll(bool? value) async {
    sendToAll = value!;
    if (!sendToAll) {
      await getStudentsNames();
    }
    emit(ChangeSendToAllStateSuccessState());
  }

  Future<String?> pickFile(
      {FileType type = FileType.any, List<String>? allowedExtensions}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        String filePath = result.files.single.path!;

        emit(SelectFileSuccessState());
        // Use the file path to access the selected file
        return filePath;
      } else {
        // User canceled the file picker
        return null;
      }
    } catch (e) {
      print('Error picking Excel file: $e');
      return null;
    }
  }

  Map<String, String> filesURLs = {};
  List<UploadFileInfo> uploadFileInfos = [];

  Future<void> pickAndUploadFile() async {
    try {
      String? filePath = await pickFile();

      String fileName = filePath!.split('/').last;
      String uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';

      String progressText = '0%';

      // Upload the file to Firebase Storage
      firebase_storage.UploadTask uploadTask = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('classes_files/$uniqueFileName')
          .putFile(File(filePath));
      uploadFileInfos.add(UploadFileInfo(
          fileName: uniqueFileName,
          progress: progressText,
          uploadTask: uploadTask));
      uploadTask.snapshotEvents
          .listen((firebase_storage.TaskSnapshot snapshot) async {
        // Calculate the progress percentage
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
        progressText = '${(progress * 100).toStringAsFixed(2)}%';
        print(progressText);
        int index = uploadFileInfos
            .indexWhere((info) => info.fileName == uniqueFileName);
        uploadFileInfos[index].progress = progressText;
        emit(UploadProgressState());
        // Wait for the upload to complete

        if (progress == 1 &&
            snapshot.state == firebase_storage.TaskState.success) {
          // Get the download URL for the uploaded file
          await snapshot.ref.getDownloadURL().then((url) {
            filesURLs[uniqueFileName] = url;
            print(filesURLs);
            emit(UploadFileSuccessState());
          }).catchError((error) {
            print(error.toString());
            uploadFileInfos[index].progress = 'Failed';
            emit(UploadFileErrorState());
          });
        }
        // Update your UI with the progress percentage
        print('Upload progress: $progress%');
      }).onError((error) {
        if (error.code == 'canceled') {
          // Handle upload cancellation
          print('File upload canceled');
        } else {
          // Handle other Firebase Storage errors
          print('Error uploading file: ${error.code}');
        }
      });
    } on firebase_storage.FirebaseException catch (e) {
      if (e.code == 'firebase_storage/canceled') {
        // Handle upload cancellation
        print('File upload canceled');
      } else {
        // Handle other Firebase Storage errors
        print('Error uploading file: ${e.code}');
      }
    } catch (e) {
      // Handle other errors
      print('Error uploading file: $e');
    }
  }

  Future<void> cancelFileUpload(int index) async {
    await uploadFileInfos[index].uploadTask.cancel().then((value) {
      uploadFileInfos.removeAt(index);
      emit(CancelFileUploadSuccessState());
    }).onError((error, stackTrace) async {
      print('Cancel Error: ${error.toString()}');
      await deleteFile(index);
    }).catchError((error) {
      print(error.toString());
      emit(CancelFileUploadErrorState());
    });
    print(filesURLs);
  }

  Future<void> deleteFile(int index) async {
    try {
      await firebase_storage.FirebaseStorage.instanceFor(
              bucket: 'smartschool-6aee1.appspot.com')
          .refFromURL(filesURLs[uploadFileInfos[index].fileName]!)
          .delete()
          .then((value) {
        filesURLs.remove(uploadFileInfos[index].fileName);
        uploadFileInfos.removeAt(index);
        emit(DeleteUploadedFile());
      }).catchError((error) {
        print(error.toString());
      });
    } on FirebaseException catch (e) {
      // Handle the Firebase exception
      print('Firebase error: $e');
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
    }
  }

  List<String> selectedStudents = [];
  void getSelectedStudents(List<String> students) {
    selectedStudents = students;
    emit(SelectStudentState());
    print(selectedStudents);
  }

  Future<void> sendNote(String title, String content) async {
    emit(NoteSendLoadingState());
    if (sendToAll) {
      try {
        // Save download URL in Firestore
        await teacherPath!
            .collection('classes')
            .where('name', isEqualTo: selectedClassName)
            .get()
            .then(
          (value) {
            if (value.docs.isNotEmpty) {
              teacherPath!
                  .collection('classes')
                  .doc(value.docs[0].id)
                  .collection('notes')
                  .doc()
                  .set({
                'title': title,
                'content': content.isEmpty ? null : content,
                'subject': selectedSubject,
                'to': 'All',
                'from': teacherName,
                'files': filesURLs.isEmpty ? null : filesURLs,
                'datetime': DateTime.now()
              });
            }
          },
        ).then((value) async {
          emit(NoteSendSuccessState());

          print('send to class');
          NotificationHelper.sendNotification(
              title: 'Class Note',
              body: title,
              receiverToken: '/topics/$selectedClassName');

          filesURLs = {};
          uploadFileInfos = [];
        }).catchError((error) {
          print(error.toString());
          emit(NoteSendErrorState());
        });
      } catch (e) {
        print(
            'Error uploading file to Firebase Storage and saving URL in Firestore: $e');
      }
    } else {
      selectedStudents.forEach((studentReceiver) async {
        try {
          // Save download URL in Firestore
          await teacherPath!
              .collection('classes')
              .where('name', isEqualTo: selectedClassName)
              .get()
              .then(
            (value) {
              if (value.docs.isNotEmpty) {
                value.docs[0].reference.collection('notes').doc().set({
                  'title': title,
                  'content': content.isEmpty ? null : content,
                  'subject': selectedSubject,
                  'to': studentReceiver,
                  'from': teacherName,
                  'files': filesURLs.isEmpty ? null : filesURLs,
                  'datetime': DateTime.now()
                });
              }
            },
          ).then((value) async {
            emit(NoteSendSuccessState());

            String parentId = students
                .where((element) => element.name == studentReceiver)
                .toList()[0]
                .parent!;
            String? deviceToken = await getDeviceToken(parentId);
            if (deviceToken != null) {
              NotificationHelper.sendNotification(
                  title: 'Class Note', body: title, receiverToken: deviceToken);
            }

            filesURLs = {};
            uploadFileInfos = [];
          }).catchError((error) {
            print(error.toString());
            emit(NoteSendErrorState());
          });
        } catch (e) {
          print(
              'Error uploading file to Firebase Storage and saving URL in Firestore: $e');
        }
      });
    }
  }

  Future<String?> getDeviceToken(String parentID) async {
    final parentDocRef = db.collection('Parents').doc(parentID);

    try {
      final parentDoc = await parentDocRef.get();
      if (parentDoc.exists) {
        final parentData = parentDoc.data();
        if (parentData != null && parentData.containsKey('device_token')) {
          return parentData['device_token'];
        }
      }
    } catch (e) {
      print('Error getting device token: $e');
    }

    return null;
  }

  List<NoteModel>? notes;
  Future<void> filterNotesByClass(dynamic className) async {
    try {
      notes = [];
      emit(GetNotesByClassLoadingState());
      selectedClassName = className;
      await teacherPath!
          .collection('classes')
          .where('name', isEqualTo: className)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          Query<Map<String, dynamic>> query = value.docs[0].reference
              .collection('notes')
              .where('from', isEqualTo: teacherName);
          if (!allTime) {
            query = query
                .where('datetime',
                    isGreaterThanOrEqualTo: DateTime(filterByDate.year,
                        filterByDate.month, filterByDate.day))
                .where('datetime',
                    isLessThan: DateTime(filterByDate.year, filterByDate.month,
                        filterByDate.day + 1));
          }
          await query.orderBy('datetime', descending: true)
          .get().then((value) {
            value.docs.forEach((element) {
              notes!.add(NoteModel.fromMap(element.data(), id: element.id));
            });
            print(notes);
            print(value.docs.length);
            emit(GetNotesByClassSuccessState());
          }).catchError((error) {
            emit(GetNotesByClassErrorState());
            print(error.toString());
          });
        }
      });
    } catch (e) {
      print(e);
      emit(SomethingWentWrong());
    }
  }

  void resetSelection() {
    notes = null;
    ClassExamsResults = null;
    classLessonAttendace = null;
    selectedClassName = null;
    selectedStudents = [];
    selectedSubject = null;
  }

  void deleteNote(
      {required String noteId,
      required Map<String, dynamic>? noteFiles}) async {
    emit(DeleteNotesByClassLoadingState());
    // don't forget to delete files
    await teacherPath!
        .collection('classes')
        .doc(selectedClassName)
        .collection('notes')
        .doc(noteId)
        .delete()
        .then((value) async {
      emit(DeleteNotesByClassSuccessState());
      if (noteFiles != null) {
        noteFiles.forEach((fileName, fileURL) async {
          try {
            await firebase_storage.FirebaseStorage.instanceFor(
                    bucket: 'smartschool-6aee1.appspot.com')
                .refFromURL(fileURL)
                .delete()
                .then((value) {
              print('File deleted');
            }).catchError((error) {
              print(error.toString());
            });
          } on FirebaseException catch (e) {
            // Handle the Firebase exception
            print('Firebase error: $e');
          } catch (e) {
            // Handle other exceptions
            print('Error: $e');
          }
        });
      }

      await filterNotesByClass(selectedClassName);
    }).catchError((error) {
      emit(DeleteNotesByClassErrorState());
    });
  }

  void signOut() {
    CacheHelper.removeData(key: 'id').then((value) {
      CacheHelper.removeData(key: 'role');
      userID = null;
      userRole = null;
      teacherPath = null;
      teacher = null;
      emit(UserSignOutSuccessState());
    });
  }

  Future<void> downloadTemplate() async {
    emit(DownloadGradeTemplateLoadingState());
    if (await Permission.storage.request().isGranted) {
      try {
        // Create an instance of the Excel package
        if (selectedClassName != null) {
          var excel = Excel.createExcel();

          // Add a sheet to the excel file
          var sheet = excel[excel.getDefaultSheet()!];

          // Add headers to the sheet
          sheet.updateCell(CellIndex.indexByString("A1"), "ID");
          sheet.updateCell(CellIndex.indexByString("B1"), "Name");
          sheet.updateCell(CellIndex.indexByString("C1"), "Grades");

          // Add data to the sheet
          for (var i = 0; i < students.length; i++) {
            sheet.updateCell(
                CellIndex.indexByString("A${i + 2}"), students[i].id);
            sheet.updateCell(
                CellIndex.indexByString("B${i + 2}"), students[i].name);
            sheet.updateCell(
                CellIndex.indexByString("C${i + 2}"), ""); // Empty grade column
          }
          const filePath = "/storage/emulated/0/Download";
          final directory = Directory(filePath);
          if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
          final fileName = '${selectedClassName}_grade_template_${DateTime.now().microsecondsSinceEpoch}.xlsx';
          print("i'm here");
          File('$filePath/$fileName').writeAsBytesSync(excel.encode()!);

          emit(DownloadGradeTemplateSuccessState());
        } else {
          emit(ClassNotSelectedState());
        }
      } catch (e) {
        emit(DownloadGradeTemplateErrorState());
        print(e.toString());
      }
    } else {
      emit(DownloadGradeTemplateErrorState());
      await requestWritePermission();
    }
  }

  String? gradeFilePath;
  void deleteGradeFile() {
    gradeFilePath = null;
    emit(DeleteGradeFileSuccessState());
  }

  Future<void> selectGradesFile() async {
    try {
      gradeFilePath =
          await pickFile(type: FileType.custom, allowedExtensions: ['xlsx']);
    } catch (e) {
      print(e);
    }
  }

  Map<String?, dynamic> grades = {};
  void checkFileFormatAndUploadGrades(
      {required String examType, required double maximumAchievableGrade}) {
    print('upload file grade');
    try {
      if (gradeFilePath != null) {
        var bytes = File(gradeFilePath!).readAsBytesSync();
        final excel = Excel.decodeBytes(bytes);
        excel.tables.forEach((key, value) async {
          final rows = value.rows;
          if (rows.isNotEmpty) {
            final firstRow = rows.first;

            // Check if headers are present and in the correct order
            if (firstRow.length >= 3 &&
                firstRow[0]?.value?.toString().toLowerCase() == 'id' &&
                firstRow[1]?.value?.toString().toLowerCase() == 'name' &&
                firstRow[2]?.value?.toString().toLowerCase() == 'grades') {
              // Check if all values under the columns are not empty

              for (int i = 1; i < rows.length; i++) {
                final row = rows[i];
                if (row.length >= 3 &&
                    row[0]?.value?.toString().isEmpty == true &&
                    row[1]?.value?.toString().isEmpty == true &&
                    row[2]?.value?.toString().isEmpty == true) {
                  continue;
                } else {
                  if (row.length >= 3 &&
                      row[0]?.value?.toString().isEmpty == false &&
                      row[1]?.value?.toString().isEmpty == false) {
                    if (row[2] != null) {
                      if (row[2]?.value.runtimeType == double) {
                        grades[row[0]?.value?.toString()] = row[2]?.value;
                      } else {
                        grades[row[0]?.value?.toString()] =
                            row[2]?.value.toString();
                      }
                    }

                    // Values are not empty, continue processing
                    // ...
                  } else {
                    // Handle the case where empty values are found
                    emit(CheckGradeTemplateFormatState(
                        'Empty values found in ID, Name, or Grades columns.'));
                    print(
                        'Error: Empty values found in ID, Name, or Grades columns.');
                    return;
                  }
                }
              }
              // If all checks pass, proceed with further actions
              // ...
              emit(GradeFileValidationSuccess());
              print(grades);
              /*await uploadGrades(
                  examType: examType,
                  maximumAchievableGrade: maximumAchievableGrade);*/
            } else {
              // Handle the case where headers are missing or in incorrect order
              emit(CheckGradeTemplateFormatState(
                  'Grade template headers do not match.'));
              print('Error: Grade template headers do not match.');
              grades = {};
              return;
            }
          } else {
            // Handle the case where the sheet is empty
            emit(CheckGradeTemplateFormatState('Grade template is empty.'));
            print('Error: Grade template is empty.');
            grades = {};
            return;
          }
        });
      } else {
        emit(GradeFileNotSelectedState());
      }
    } catch (e) {
      print(e.toString());
      grades = {};
      emit(GradeFileValidationError());
    }
  }

  Future<void> uploadGrades(
      {required String examType,
      required double maximumAchievableGrade}) async {
    try {
      emit(UploadGradesLoadingState());
      await teacherPath!
          .collection('classes')
          .doc(selectedClassName)
          .collection('exams results')
          .doc()
          .set({
        'teacher': teacherName,
        'subject': selectedSubject,
        'exam_type': examType,
        'datetime': DateTime.now(),
        'maximum_achievable_grade': maximumAchievableGrade,
        'grades': grades
      }).then((value) async {
        emit(UploadGradesSuccessState());
        gradeFilePath = null;
        await NotificationHelper.sendNotification(
            title: 'New Grades Available',
            body:
                "We have just sent your child's grades.",
            receiverToken: '/topics/$selectedClassName');
      }).catchError((error) {
        emit(UploadGradesErrorState());
        print(error.toString());
      });
    } catch (e) {
      print(e.toString());
      emit(UploadGradesErrorState());
    }
  }

  List<ExamResults>? ClassExamsResults;
  Future<void> filterExamResultsByClass(dynamic className) async {
    try {
      emit(GetGradesLoadingState());
      ClassExamsResults = [];
      selectedClassName = className;

      await teacherPath!
          .collection('classes')
          .where('name', isEqualTo: className)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          Query<Map<String, dynamic>> query = value.docs[0].reference
              .collection('exams results')
              .where('teacher', isEqualTo: teacherName);
          if (!allTime) {
            query = query
                .where('datetime',
                    isGreaterThanOrEqualTo: DateTime(filterByDate.year,
                        filterByDate.month, filterByDate.day))
                .where('datetime',
                    isLessThan: DateTime(filterByDate.year, filterByDate.month,
                        filterByDate.day + 1));
          }
          await query.orderBy('datetime', descending: true).get().then((value) async {
            value.docs.forEach((element) {
              ClassExamsResults!
                  .add(ExamResults.fromMap(element.data(), res_id: element.id));
            });
            print(ClassExamsResults);
            print(value.docs.length);
            emit(GetGradesSuccessState());
            await getStudentsNames();
          }).catchError((error) {
            emit(GetGradesErrorState());
            print(error.toString());
          });
        }
      });
    } catch (e) {
      print(e);
      emit(SomethingWentWrong());
    }
  }

  void deleteExamResults({required String examResultsId}) async {
    try {
      emit(DeleteExamResultsLoadingState());
      await teacherPath!
          .collection('classes')
          .doc(selectedClassName)
          .collection('exams results')
          .doc(examResultsId)
          .delete()
          .then((value) async {
        emit(DeleteExamResultsSuccessState());
        await filterExamResultsByClass(selectedClassName);
      }).catchError((error) {
        emit(DeleteExamResultsErrorState());
      });
    } catch (e) {
      print(e.toString());
      emit(DeleteExamResultsErrorState());
    }
  }

  Future<void> updateStudentGrade(
      {required String id,
      required double grade,
      required ExamResults examResults}) async {
    try {
      print(examResults.id);
      emit(UpdateExamResultsLoadingState());
      Map<String?, dynamic> updatedGrades = examResults.grades;
      updatedGrades[id] = grade;
      teacherPath!
          .collection('classes')
          .doc(selectedClassName)
          .collection('exams results')
          .doc(examResults.id)
          .update({'grades': updatedGrades}).then((value) async {
        emit(UpdateExamResultsSuccessState());
        await filterExamResultsByClass(selectedClassName);
      }).catchError(((error) {
        print(error.toString());
        emit(UpdateExamResultsErrorState());
      }));
    } catch (e) {
      print(e.toString());
      emit(UpdateExamResultsErrorState());
    }
  }

  void modifyGrade({required double grade, required String id}) {
    grades[id] = grade;
    emit(ModifyGradeSuccessState());
  }
}
