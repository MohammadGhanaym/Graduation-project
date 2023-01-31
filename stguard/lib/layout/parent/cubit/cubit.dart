import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sqflite/sqflite.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/models/activity_model.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/models/product_model.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/background_service.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

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
      onCreate: (db, version) async {
        print('db created');
        await db.transaction((txn) async {
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
                  'CREATE TABLE products(trans_id TEXT, product TEXT, price )')
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
      },
    );
  }

  void clearHistory() async {
    await database.rawDelete('DELETE FROM student_activity');
    await database.rawDelete('DELETE FROM products');

    getDataFromActivityTable();
  }

  List<studentModel?> studentsData = [];
  List<String> studentIDs = [];

  void getStudentsData() async {
    studentsData = [];
    studentIDs = [];
    emit(GetStudentDataLoading());
    await FirebaseFirestore.instance
        .collection('students')
        .where('parent', isEqualTo: userID)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((student) {
          studentsData.add(studentModel.fromJson(student.data()));
          studentIDs.add(student['uid']);
        });
        emit(GetStudentDataSuccess());
        listentoNewData();
      }
      getDataFromActivityTable();
    }).catchError((error) {
      print(error.toString());
      emit(GetStudentDataError());
      
    });
  }

  void listentoNewData() {
    cancelListeners();
    transListeners = {};
    attendListeners = {};
    if (studentIDs.isNotEmpty) {
      studentIDs.forEach((ID) {
        addNewTranscation(ID);
        addNewAttendance(ID);
      });
    }
  }

  void addFamilyMember(String id) async {
    userID ??= CacheHelper.getData(key: 'id');

    emit(AddFamilyMemberLoading());
    int inSchool = 0;
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.runTransaction((transaction) async {
      await db
          .collection('students')
          .where('uid', isEqualTo: id)
          .count()
          .get()
          .then((value) async {
        inSchool = value.count;
        if (inSchool == 1) {
          if (studentIDs.contains(id)) {
            print(studentIDs);
            emit(FamilyMemberAlreadyExisted('You added this member before'));
          } else {
            db
                .collection('students')
                .doc(id)
                .update({'parent': userID}).then((value) async {
              db.collection('students').doc(id).update({'active': true}).then(
                (value) {
                  initBackgroundService(action: 'refresh');
                  getStudentsData();
                  getDataFromActivityTable();
                  print(studentIDs);
                  emit(AddFamilyMemberSuccess());
                },
              );
            });
          }
        } else {
          emit(IDNotFound(
              "Oops! We couldn't find anyone matching student ID $id"));
        }
      }).catchError((error) {
        print(error.toString());
        emit(AddFamilyMemberError());
      });
    });
  }

  void addNewTranscation(String studentID) {
    print('before listener');

    transListeners[studentID] = FirebaseFirestore.instance
        .collection('canteen transactions')
        .doc(studentID)
        .collection('transactions')
        .snapshots()
        .listen((event) async {
      print('inside listener');
      print(event.docs.length);
      event.docs.forEach((trans) async {
        print(trans.id);
        await FirebaseFirestore.instance
            .collection('canteen transactions')
            .doc(studentID)
            .collection('transactions')
            .doc(trans.id)
            .delete()
            .then((value) {
          insertToActivityTable(
              id: studentID,
              activityType: trans['total_price'],
              date: trans['date'].toDate(),
              transId: trans.id);

          trans['products'].forEach((product) {
            insertToTransactionsTable(
                trans_id: trans.id,
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
    });
  }

  void addNewAttendance(String studentID) {
    //studentID = CacheHelper.getData(key: 'st_id');
    attendListeners[studentID] = FirebaseFirestore.instance
        .collection('students')
        .doc(studentID)
        .snapshots()
        .listen((event) async {
      SchoolAttendanceModel attendanceStatus =
          SchoolAttendanceModel.fromJson(event.data()!['attendance status']);

      if (attendanceStatus.arrived) {
        await FirebaseFirestore.instance
            .collection('students')
            .doc(studentID)
            .update({
          'attendance status': {'arrive': false, 'leave': attendanceStatus.left}
        }).then((value) {
          insertToActivityTable(
              id: studentID, activityType: 'Arrived', date: DateTime.now());
        });
      } else if (attendanceStatus.left) {
        await FirebaseFirestore.instance
            .collection('students')
            .doc(studentID)
            .update({
          'attendance status': {
            'arrive': attendanceStatus.arrived,
            'leave': false
          }
        }).then((value) {
          insertToActivityTable(
              id: studentID, activityType: 'Left', date: DateTime.now());
        });
      }
    });
  }

  Future<void> insertToTransactionsTable(
      {required String trans_id,
      required String product,
      required dynamic price}) async {
    Database insert_database = await openDatabase('activities.db');

    await insert_database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO products(trans_id, product, price) VALUES("$trans_id", "$product", "$price")')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((err) {
        print('Error when inserting into products table! ${err.toString()}');
      });
    });
  }

  insertToActivityTable(
      {required String id,
      required String activityType,
      required DateTime date,
      String? transId}) async {
    Database insert_database = await openDatabase('activities.db');
    await insert_database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO student_activity(id, date, activity, trans_id) VALUES("$id","$date", "$activityType", "$transId")')
          .then((value) {
        print('$value inserted successfully');
        getDataFromActivityTable();
      }).catchError((err) {
        print(
            'Error when inserting into student_activity table! ${err.toString()}');
      });
    });
  }

  List<ActivityModel> activities = [];

  void getDataFromActivityTable() async {
    print('getDataFromActivityTable');
    Database activity_database = await openDatabase('activities.db');
    emit(ParentGetDataBaseLoadingState());
    //SELECT * FROM student_activity ORDER BY date DESC
    await activity_database
        .query('student_activity',
            orderBy: 'date DESC',
            where: "id IN (${studentIDs.map((_) => '?').join(', ')})",
            whereArgs: studentIDs)
        .then((value) {
      activities = [];
      value.forEach(
        (element) {
          activities.add(ActivityModel.fromJson(element));
        },
      );
      print('student activities 2023');
      print(activities);
      emit(ParentGeStudentActivitySuccessState());
    }).catchError((error) {
      activities = [];
      emit(ParentGeStudentActivityErrorState());
    });
  }

  List<ProductModel> products = [];
  void getDataFromTransactionsTable(String trans_id) async {
    Database product_database = await openDatabase('activities.db');
    emit(ParentGetDataBaseLoadingState());
    //SELECT * FROM canteenTransactions ORDER BY date DESC'
    await product_database.query('products',
        where: 'trans_id = ?', whereArgs: [trans_id]).then((value) {
      print(value);
      products = [];
      value.forEach((element) {
        products.add(ProductModel.fromJson(element));
      });

      emit(ParentGeSchoolTransactionsSuccessState());
    });
  }

  void initBackgroundService({action}) async {
    if (action == 'start') {
      if (!await FlutterBackgroundService().isRunning()) {
        await BackgroundService.initializeService();
      }
    }

    if (action == 'refresh') {
      FlutterBackgroundService().invoke('stopService');
      await BackgroundService.initializeService();
    }

    if (action == 'stop') {
      FlutterBackgroundService().invoke('stopService');
    }
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

  List<ActivityModel> attendance_history = [];
  void getAttendanceHistory(st_id) async {
    Database database = await openDatabase('activities.db');
    emit(AttendanceHistoryLoading());
    await database.query(
      'student_activity',
      orderBy: 'date DESC',
      where: 'trans_id = "null" AND id=?',
      whereArgs: [st_id],
    ).then((value) {
      print(value);
      attendance_history = [];
      value.forEach((element) {
        attendance_history.add(ActivityModel.fromJson(element));
      });
      emit(AttendanceHistorySuccess());
    });
  }

  bool isPaired = true; // child settings
  bool settingsVisibility = true;
  void changeSettingsVisibility() {
    settingsVisibility = !settingsVisibility;
    print(settingsVisibility);
    emit(ShowSettingsState());
  }

  void showSettings() {
    isPaired = !isPaired;
    print('showSettings');
    print(isPaired);
    emit(ShowSettingsState());
  }

  bool active = false;
  void changeDigitalIDState(String id) {
    active = !active;
    FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .update({'active': active}).then((value) {
      emit(DeactivateDigitalIDSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(DeactivateDigitalIDError());
    });
  }

  void getActiveState(String id) async{
   await FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .get()
        .then((value) {
      if (value.data() != null) {
        active = value['active'];
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  void unpairDigitalID(String id) async {
    initBackgroundService(action: 'stop');

   await FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .update({'parent': null, 'active': false}).then((value) {
      active = false;
      studentIDs.remove(id);
      print('unpairDigitalID');
      print(studentIDs);
      transListeners[id].cancel();
      attendListeners[id].cancel();

      transListeners.remove(id);
      attendListeners.remove(id);
      emit(UnpairDigitalIDSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(UnpairDigitalIDError());
    });
  }

  double balance = 0.00;
  void getBalance() {
    emit(GetBalanceLoading());
    if (userID != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get()
          .then((value) {
        print(value.data());
        if (value.data()!.containsKey('balance')) {
          balance = value['balance'].toDouble();
          emit(GetBalanceSuccess());
        }
      }).catchError((error) {
        print(error.toString());
        emit(GetBalanceError());
      });
    }
  }

  void cashRecharge({required var code}) {
    emit(RechargeLoadingState());
    FirebaseFirestore.instance
        .collection('school')
        .doc('referenceCodes')
        .get()
        .then((value) {
      print(value.data());
      if (value.data() != null) {
        if (value.data()!.containsKey(code)) {
          FirebaseFirestore.instance
              .collection('school')
              .doc('referenceCodes')
              .update({code: FieldValue.delete()}).then((v) {
            balance = balance + value[code];
            updateBalance();
            emit(RechargeSuccessState(value[code].toString()));
          }).catchError((error) {
            emit(RechargeErrorState(error.toString()));
          });
        } else {
          emit(RechargeErrorState('Invalid Reference Code'));
        }
      } else {
        emit(RechargeErrorState('Invalid Reference Code'));
      }
    }).catchError((error) {
      emit(RechargeErrorState(error.toString()));
    });
  }

  void updateBalance() {
    emit(UpdateBalanceLoading());

    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .update({'balance': balance}).then((value) {
      emit(UpdateBalanceSuccess());
    }).catchError((error) {
      emit(UpdateBalanceError());
    });
  }

  double pocket_money = 0.0;
  void setPocketMoney({required double money}) {
    pocket_money = money.roundToDouble();
    emit(ChangeSliderState());
  }

  void updatePocketMoney({required var id}) {
    emit(SetPocketMoneyLoadingState());

    if (pocket_money < balance) {
      FirebaseFirestore.instance
          .collection('students')
          .doc(id)
          .update({'pocket money': pocket_money}).then((value) {
        emit(SetPocketMoneySuccessState());
      }).catchError((error) {
        emit(SetPocketMoneyErrorState());
      });
    }
  }

  void getMaxPocketMoney({required var id})async {
    pocket_money = 0.0;

    await FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .get()
        .then((value) {
      if (value.data() != null) {
        pocket_money = value['pocket money'];
      }

      emit(SetPocketMoneySuccessState());
    }).catchError((error) {
      emit(SetPocketMoneyErrorState());
    });
  }

  bool isBottomSheetShown = false;
  void showBottomSheet() {
    isBottomSheetShown = true;
    emit(ShowBottomSheetState());
  }

  void hideBottomSheet() {
    isBottomSheetShown = false;
    emit(ShowBottomSheetState());
  }

  List<dynamic> selectedAllergens = [];
  void addAllergen(value) {
    selectedAllergens.add(value);
    emit(AddAllergenState());
  }

  void removeAllergen(value) {
    selectedAllergens.remove(value);
    emit(RemoveAllergenState());
  }

  List<dynamic> allergens = [];
  void getAllergies(id) async {
    selectedAllergens = [];
    allergens = [Icons.add];
    emit(GetAllergiesLoadingState());
    await FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .get()
        .then((value) {
      emit(GetAllergiesSucessState());
      print(value.data());
      if (value['allergens'] != null) {
        value['allergens'].forEach((element) {
          allergens.add(element);
          selectedAllergens.add(element);
        });
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetAllergiesErrorState(error.toString()));
    });
  }

  Future<void> updateAllergens(id) async {
    emit(UpdateAllergiesLoadingState());

    FirebaseFirestore.instance.collection('students').doc(id).update({
      'allergens': selectedAllergens.isNotEmpty ? selectedAllergens : null
    }).then((value) {
      emit(UpdateAllergiesSuccessState());
      getAllergies(id);
    }).catchError((error) {
      print(error);
      emit(UpdateAllergiesErrorState(error.toString()));
    });
  }
}
