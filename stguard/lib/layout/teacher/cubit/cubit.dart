import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/models/country_model.dart';
import 'package:st_tracker/models/school_model.dart';
import 'package:st_tracker/models/student_attendance.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/models/teacher_model.dart';
import 'package:st_tracker/modules/teacher/add_attendance/add_attendance_screen.dart';
import 'package:st_tracker/modules/teacher/history/history_screen.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';

class TeacherCubit extends Cubit<TeacherStates> {
  TeacherCubit() : super(TeacherInitState());
  static TeacherCubit get(context) => BlocProvider.of(context);

  static const _databaseName = "attendance_db.db";
  static const _databaseVersion = 1;

  static const tableLesson = 'lesson';
  static const columnLessonName = 'name';
  static const columnGrade = 'grade';
  static const columnDatetime = 'datetime';

  static const tableStAttendLesson = 'st_attend_lesson';
  static const columnStID = 'st_id';
  static const columnStName = 'student_name';
  static const columnLesson = 'lesson';
  static const columnIsPresent = 'is_present';

  static late Database _database;
  void initDatabase() async {
    /* await databaseFactory.deleteDatabase('attendance_db.db').then((value) {
      print('database deleted');
    });*/
    await openDatabase(
      _databaseName,
      version: _databaseVersion,
      onCreate: _onCreate,
      onOpen: (db) {
        _database = db;
        getLessons();
        print('database opened');
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    db.transaction((txn) async {
      await txn.execute('''
      CREATE TABLE $tableLesson (
        $columnLessonName TEXT NOT NULL,
        $columnGrade TEXT NOT NULL,
        $columnDatetime DATETIME NOT NULL,
        PRIMARY KEY ($columnLessonName, $columnDatetime)
        )

      
    ''');
      await txn.execute('''
      CREATE TABLE $tableStAttendLesson (
        $columnStID TEXT,
        $columnStName TEXT,
        $columnLesson TEXT,
        $columnIsPresent INTEGER,
        PRIMARY KEY ($columnStID, $columnLesson),
        FOREIGN KEY ($columnLesson) REFERENCES $tableLesson($columnLessonName) ON DELETE CASCADE
      )
    ''');
    }).then((value) {
      print('tables created');
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> insertAttendance() async {
    if (attendance.isNotEmpty) {
      _database.transaction((txn) async {
        await txn.rawInsert('''
      INSERT INTO $tableLesson (
        $columnLessonName,
        $columnDatetime,
        $columnGrade
      ) VALUES (?, ?, ?)
    ''', [lessonName, DateTime.now().toString(), selectedGrade]).then((value) {
          print('$value inserted successfully');
        });

        attendance.values.forEach((element) async {
          await txn.rawInsert('''
      INSERT INTO $tableStAttendLesson (
        $columnStID,
        $columnStName,
        $columnLesson,
        $columnIsPresent
      ) VALUES (?, ?, ?, ?)
    ''', [
            element.stID,
            element.stName,
            lessonName,
            element.isPresent
          ]).then((value) {
            print('student attendance');
            print('$value inserted successfully');
          });
        });
      }).then((value) {
        emit(AddNewAttendanceSuccessState());
        getLessons();
      }).catchError((error) {
        emit(AddNewAttendanceErrorState(error.toString()));
      });
    }
  }

  List<LessonModel> lessons = [];
  void getLessons() async {
    await _database.rawQuery('''
      SELECT 
        $columnLessonName, 
        $columnGrade, 
        $columnDatetime
      FROM 
        $tableLesson
    ''').then((value) {
      print(value);
      lessons = [];
      value.forEach((element) {
        lessons.add(LessonModel.fromMap(element));
      });
      emit(GetLessonsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetLessonsErrorState());
    });
  }

  List<StudentAttendanceModel> lessonAttendance = [];
  void getLessonAttendance(String lesson_name) async {
    emit(GetLessonAttendanceLoadingState());
    await _database.rawQuery('''
      SELECT 
        $tableStAttendLesson.$columnStID AS student_id,
        $tableStAttendLesson.$columnLesson AS lesson,
        $tableStAttendLesson.$columnStName AS student_name,
        $tableStAttendLesson.$columnIsPresent AS is_present
      FROM 
        $tableStAttendLesson
        JOIN $tableLesson ON $tableStAttendLesson.$columnLesson = $tableLesson.$columnLessonName
      WHERE 
        $tableStAttendLesson.$columnLesson = ?
    ''', [lesson_name]).then((value) {
      lessonAttendance = [];
      value.forEach((element) {
        lessonAttendance.add(StudentAttendanceModel.fromMap(element));
      });
      print(lessonAttendance);
      emit(GetLessonAttendanceSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetLessonAttendanceErrorState());
    });
  }

  String? lessonName;
  void setLessonName(lesson) {
    lessonName = lesson;
    emit(SetLessonNameState());
  }

  TeacherModel? teacher;
  void getTeacherInfo() async {
    emit(GetUserInfoLoading());
    if (userID != null) {
      await db.collection('Teachers').doc(userID).get().then((value) {
        if (value.data() != null) {
          print(value.data()!);
          teacher = TeacherModel.fromJson(value.data()!);
          emit(GetUserInfoSuccess());
        } else {
          emit(GetUserInfoError());
        }
      }).catchError((error) {
        print(error.toString());
        emit(GetUserInfoError());
      });
    }
  }

  List<dynamic> grades = [];

  Future<void> getGrades() async {
    grades = [];
    emit(GetGradesLoadingState());

    if (teacherPath != null) {
      await teacherPath!.get().then((value) {
        print(value.data());
        if (value.data() != null) {
          grades = value['classes names'];
          selectedGrade = grades[0];
          emit(GetGradesSuccessState());
        }
      }).catchError((error) {
        print(error.toString());
        emit(GetGradesErrorState());
      });
    }
  }

  String? selectedGrade;
  void selectGrade(String value) {
    selectedGrade = value;
    emit(SelectGradeSuccess());
  }

  List<Widget> screens = [
    HistoryScreen(),
    AddAttendanceScreen(),
  ];
  int currentIndex = 0;
  void switchScreen(var index) {
    currentIndex = index;
    if (index == 1) {
      getGrades();
    }
    emit(SwitchScreenState());
  }

  List<StudentModel> students = [];

  void getStudentsNames() {
    students = [];
    emit(GetStudentNamesLoading());
    attendance = {};
    if (teacherPath != null) {
      teacherPath!
          .collection('Students')
          .where('class_name', isEqualTo: selectedGrade)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.forEach((element) {
            students.add(StudentModel.fromJson(element.data()));
          });
          emit(GetStudentNamesSuccess());
          print(students);
        } else {
          emit(GetStudentNamesError());
        }
      }).catchError((error) {
        print(error.toString());
        emit(GetStudentNamesError());
      });
    }
  }

  Map<String, dynamic> attendance = {};
  void addtoAttendance(String stID, var stName, int isPresent) {
    attendance[stID] = Attendance(
        stID: stID,
        lesson: lessonName!,
        grade: selectedGrade!,
        stName: stName,
        isPresent: isPresent);

    print(attendance[stID].isPresent);
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

  Future<void> saveAttendanceToExcel(LessonModel lesson, String filePath,
      List<StudentAttendanceModel> attendanceData) async {
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
        for (var i = 0; i < attendanceData.length; i++) {
          sheet.updateCell(
              CellIndex.indexByString("A${i + 2}"), attendanceData[i].stID);
          sheet.updateCell(CellIndex.indexByString("B${i + 2}"),
              attendanceData[i].studentName);
          sheet.updateCell(CellIndex.indexByString("C${i + 2}"),
              attendanceData[i].lessonName);
          sheet.updateCell(CellIndex.indexByString("D${i + 2}"),
              attendanceData[i].isPresent);
        }
        File('$filePath/${lesson.name}.xlsx').writeAsBytesSync(excel.encode()!);

        emit(SavetoExcelSuccessState());
      } catch (e) {
        emit(SavetoExcelErrorState());
      }
    }
  }

  FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>>? teacherPath;
  Future<void> getTeacherPath() async {
    emit(GetTeacherPathLoadingState());
    await db
        .collection('Teachers')
        .doc(userID)
        .collection('Community')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        teacherPath = db
            .collection('Countries')
            .doc(value.docs[0]['country'])
            .collection('Schools')
            .doc(value.docs[0]['school']);

        emit(GetTeacherPathSuccessState());
      } else {
        emit(NeedtoJoinCommunityState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetTeacherPathErrorState());
    });
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
}
