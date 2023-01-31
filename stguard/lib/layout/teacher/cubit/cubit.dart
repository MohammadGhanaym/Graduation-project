import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/models/student_attendance.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/modules/teacher/add_attendance/add_attendance_screen.dart';
import 'package:st_tracker/modules/teacher/history/history_screen.dart';

class TeacherCubit extends Cubit<TeacherStates> {
  TeacherCubit() : super(TeacherInitState());
  static TeacherCubit get(context) => BlocProvider.of(context);

  static final _databaseName = "attendance_db.db";
  static final _databaseVersion = 1;

  static final tableLesson = 'lesson';
  static final columnLessonName = 'name';
  static final columnGrade = 'grade';
  static final columnDatetime = 'datetime';

  static final tableStAttendLesson = 'st_attend_lesson';
  static final columnStID = 'st_id';
  static final columnStName = 'student_name';
  static final columnLesson = 'lesson';
  static final columnIsPresent = 'is_present';

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
        FOREIGN KEY ($columnLesson) REFERENCES $tableLesson($columnLessonName)
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
    }).catchError((error) {
      print(error.toString());
    });
  }

  String? lessonName;
  void setLessonName(lesson) {
    lessonName = lesson;
    emit(SetLessonNameState());
  }

  List<dynamic> grades = [];

  Future<void> getGrades() async {
    grades = [];
    await FirebaseFirestore.instance
        .collection('school')
        .doc('schoolID')
        .get()
        .then((value) {
      if (value.data() != null) {
        grades = value['grades'];
        selectedGrade = grades[0];
        emit(GetGradesSuccessState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetGradesErrorState());
    });
  }

  String? selectedGrade;
  void selectGrade(var value) {
    selectedGrade = grades[value];
    emit(SelectGradeSuccess());
  }

  List<Widget> screens = [HistoryScreen(), AddAttendanceScreen()];
  int currentIndex = 0;
  void switchScreen(var index) {
    currentIndex = index;
    if (index == 1) {
      getGrades();
    }
    emit(SwitchScreenState());
  }

  List<studentModel> students = [];

  void getStudentsNames() {
    students = [];
    emit(GetStudentNamesLoading());

    FirebaseFirestore.instance
        .collection('students')
        .where('grade', isEqualTo: selectedGrade)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          students.add(studentModel.fromJson(element.data()));
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
}
