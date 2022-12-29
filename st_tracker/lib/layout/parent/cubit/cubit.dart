import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sqflite/sqflite.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/models/activity_model.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/background_service.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';

class ParentCubit extends Cubit<ParentStates> {
  ParentCubit() : super(ParentInitState());

  static ParentCubit get(context) => BlocProvider.of(context);

  late Database database;

  void createDatabase() async {
    /*databaseFactory.deleteDatabase('activities.db').then((value) {
      print('database deleted');
    });*/
    database = await openDatabase(
      'activities.db',
      version: 1,
      onCreate: (db, version) {
        print('db created');
        db.transaction((txn) async {
          // create student_activity table
          await txn
              .execute(
                  'CREATE TABLE student_activity(id TEXT, activity TEXT ,date DATETIME, trans_id TEXT)')
              .then((value) {
            print('Table Created');
          }).catchError((error) {
            print(error.toString());
            return error;
          });
          // create canteenTransactions table
          await txn
              .execute(
                  'CREATE TABLE canteenTransactions(trans_id TEXT, st_id TEXT, date DATETIME, product TEXT, price )')
              .then((value) {
            print('Table Created');
          }).catchError((error) {
            print(error.toString());
            return error;
          });
        });
      },
      onOpen: (db) {
        database = db;
        print('db opened');
        getDataFromActivityTable(db);
      },
    ).then((value) {
      return value;
    });
  }

  void clearHistory() {
    database.rawDelete('DELETE FROM student_activity');
    getDataFromTransactionsTable(database);
  }

  List<studentModel?> studentsData = [];
  void getStudentsData() {
    studentsData = [];

    studentID = CacheHelper.getData(key: 'st_id');
    emit(GetStudentDataLoading());
    if (studentID != null)
      FirebaseFirestore.instance
          .collection('students')
          .doc(studentID)
          .get()
          .then((value) {
        //print(DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()));
        studentsData.add(studentModel.fromJson(value.data()));
        print(studentsData[0]!.image);
        emit(GetStudentDataSuccess());
      }).catchError((error) {
        print(error.toString());
        emit(GetStudentDataError());
      });
  }

  void addFamilyMember(String id) {
    studentID = id;
    CacheHelper.saveData(key: 'st_id', value: id).then((value) {
      emit(AddFamilyMemberSuccess());
    });
  }

  void addNewTranscation() {
    studentID = CacheHelper.getData(key: 'st_id');
    print('before listener');
    trans_listener = FirebaseFirestore.instance
        .collection('canteen transactions')
        .doc(studentID)
        .collection('transactions')
        .snapshots()
        .listen((event) {
      print('inside listener');
      print(event.docs.length);
      event.docs.forEach((trans) {
        print(trans.id);
        FirebaseFirestore.instance
            .collection('canteen transactions')
            .doc(studentID)
            .collection('transactions')
            .doc(trans.id)
            .delete()
            .then((value) {
          insertToActivityTable(
              id: studentID!,
              activityType: trans['total_price'],
              date: trans['date'].toDate(),
              transId: trans.id);

          trans['products'].forEach((product) {
            insertToTransactionsTable(
                trans_id: trans.id,
                st_id: studentID!,
                date: trans['date'].toDate(),
                product: product['name'],
                price: product['price']);
          });
          emit(TransactionDeleteSuccess());

          print('transcation deleted');
          print(studentID);
        }).catchError((error) {
          print(error.toString());
        });
      });
      print('after listener');
      emit(ParentAddNewTranscationSuccessState());
    });
  }

  void addNewAttendance() {
    studentID = CacheHelper.getData(key: 'st_id');
    FirebaseFirestore.instance
        .collection('students')
        .doc(studentID)
        .snapshots()
        .listen((event) {
      SchoolAttendanceModel attendanceStatus =
          SchoolAttendanceModel.fromJson(event.data()!['attendance status']);

      if (attendanceStatus.arrived) {
        FirebaseFirestore.instance
            .collection('students')
            .doc(studentID)
            .update({
          'attendance status': {'arrive': false, 'leave': false}
        }).then((value) {
          insertToActivityTable(
              id: studentID!, activityType: 'Arrived', date: DateTime.now());
        });
      } else if (attendanceStatus.left) {
        FirebaseFirestore.instance
            .collection('students')
            .doc(studentID)
            .update({
          'attendance status': {'arrive': false, 'leave': false}
        }).then((value) {
          insertToActivityTable(
              id: studentID!, activityType: 'Left', date: DateTime.now());
        });
      }
    });
  }

  Future<void> insertToTransactionsTable(
      {required String trans_id,
      required String st_id,
      required DateTime date,
      required String product,
      required dynamic price}) async {
    Database database = await openDatabase('activities.db');

    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO canteenTransactions(trans_id, st_id, date, product, price) VALUES("$trans_id","$st_id","$date", "$product", "$price")')
          .then((value) {
        print('$value inserted successfully');
        getDataFromTransactionsTable(database);
      }).catchError((err) {
        print(
            'Error when inserting into canteenTransactions table! ${err.toString()}');
      });
    });
  }

  insertToActivityTable(
      {required String id,
      required String activityType,
      required DateTime date,
      String? transId}) async {
    Database database = await openDatabase('activities.db');
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO student_activity(id, date, activity, trans_id) VALUES("$id","$date", "$activityType", "$transId")')
          .then((value) {
        print('$value inserted successfully');
        getDataFromActivityTable(database);
      }).catchError((err) {
        print(
            'Error when inserting into student_activity table! ${err.toString()}');
      });
    });
  }

  List<ActivityModel> activities = [];

  void getDataFromActivityTable(Database database) async {
    emit(ParentGetDataBaseLoadingState());
    await database
        .rawQuery('SELECT * FROM student_activity ORDER BY date DESC')
        .then((value) {
      activities = [];
      value.forEach(
        (element) {
          activities.add(ActivityModel.fromJson(element));
        },
      );
      emit(ParentGeStudentActivitySuccessState());
    });
  }

  void getDataFromTransactionsTable(Database database) async {
    emit(ParentGetDataBaseLoadingState());

    await database
        .rawQuery('SELECT * FROM canteenTransactions ORDER BY date DESC')
        .then((value) {
      print(value);
      value.forEach((element) {});

      emit(ParentGeSchoolTransactionsSuccessState());
    });
  }

  void initBackgroundService() {
    BackgroundService.initializeService();
  }

  void openMap({required double lat, required double long}) async {
    final availableMaps = await MapLauncher.installedMaps;
    print(
        availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

    await availableMaps.first.showMarker(
      coords: Coords(lat, long),
      title: "Location",
    );
  }
}
