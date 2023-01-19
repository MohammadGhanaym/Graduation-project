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
  void getStudentsData() {
    studentsData = [];
    emit(GetStudentDataLoading());
    if (CacheHelper.getData(key: 'IDsList') != null) {
      IDs = List<String>.from(CacheHelper.getData(key: 'IDsList'));
      if (IDs.isNotEmpty) {
        IDs.forEach((studentID) async {
          await FirebaseFirestore.instance
              .collection('students')
              .doc(studentID)
              .get()
              .then((value) {
            //print(DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()));
            studentsData.add(studentModel.fromJson(value.data()));
            print(studentsData);
            print(studentsData[0]!.image);
            emit(GetStudentDataSuccess());
          }).catchError((error) {
            print(error.toString());
            emit(GetStudentDataError());
          });
        });
      }
    }
  }

  List<String> IDs = [];
  void getData() {
    cancelListeners();
    transListeners = {};
    attendListeners = {};
    if (CacheHelper.getData(key: 'IDsList') != null) {
      IDs = List<String>.from(CacheHelper.getData(key: 'IDsList'));
      if (IDs.isNotEmpty) {
        IDs.forEach((id) async {
          addNewTranscation(id);
          addNewAttendance(id);
        });
      }
    }
  }

  void addFamilyMember(String id) async {
    userID ??= CacheHelper.getData(key: 'id');

    emit(AddFamilyMemberLoading());
    int inSchool = 0;
    await FirebaseFirestore.instance
        .collection('students')
        .where('uid', isEqualTo: id)
        .count()
        .get()
        .then((value) async {
      inSchool = value.count;
      if (inSchool == 1) {
        List<String> ids_lst = [];
        if (CacheHelper.getData(key: 'IDsList') != null) {
          ids_lst = List<String>.from(CacheHelper.getData(key: 'IDsList'));
        }
        if (ids_lst.contains(id)) {
          emit(FamilyMemberAlreadyExisted('You added this member before'));
        } else {
          FirebaseFirestore.instance.collection('students').doc(id).set(
              {'parent': userID}, SetOptions(merge: true)).then((value) async {
            ids_lst.add(id);
            await CacheHelper.saveData(key: 'IDsList', value: ids_lst)
                .then((value) {
              initBackgroundService(action: 'refresh');
              addNewTranscation(id);
              addNewAttendance(id);
              getStudentsData();

              emit(AddFamilyMemberSuccess());
            }).catchError((error) {
              emit(AddFamilyMemberError());
            });
          }).catchError((error) {
            emit(AddFamilyMemberError());
          });
        }
      } else {
        emit(IDNotFound(
            "Oops! We couldn't find anyone matching student ID $id"));
      }
    });

    // stop service and then start it to listen to changes
    //initBackgroundService();
    //addNewTranscation(id);
    //addNewAttendance(id);
    //getStudentsData();
    //getDataFromActivityTable();
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
            where: "id IN (${IDs.map((_) => '?').join(', ')})",
            whereArgs: IDs)
        .then((value) {
      activities = [];
      value.forEach(
        (element) {
          activities.add(ActivityModel.fromJson(element));
        },
      );
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

  bool isActivated = true; // child settings
  bool settingsVisibility = true;
  void changeSettingsVisibility() {
    settingsVisibility = !settingsVisibility;
    print(settingsVisibility);
    emit(ShowSettingsState());
  }

  void showSettings() {
    isActivated = !isActivated;
    print('showSettings');
    print(isActivated);
    emit(ShowSettingsState());
  }

  Future<void> deactivateDigitalID(String id) async {
    transListeners[id].cancel();
    attendListeners[id].cancel();

    transListeners.remove(id);
    attendListeners.remove(id);

    IDs.remove(id);
    print(IDs);
    await CacheHelper.saveData(key: 'IDsList', value: IDs).then((value) {
      emit(DeactivateDigitalIDSuccess());
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
        CacheHelper.saveData(key: '$id-pocket_money', value: pocket_money)
            .then((value) {
          balance = balance - pocket_money;
          updateBalance();
          emit(SetPocketMoneySuccessState());
        });
      }).catchError((error) {
        emit(SetPocketMoneyErrorState());
      });
    }
  }

  void getMaxPocketMoney({required var id}) {
    pocket_money = 0.0;

    if (CacheHelper.getData(key: '$id-pocket_money') != null) {
      pocket_money = CacheHelper.getData(key: '$id-pocket_money');
    }
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

  Future<void> updateAllergens(id) async{
    emit(UpdateAllergiesLoadingState());

    FirebaseFirestore.instance.collection('students').doc(id).update({
      'allergens': selectedAllergens.isNotEmpty
          ? selectedAllergens
          : null
    }).then((value) {
      emit(UpdateAllergiesSuccessState());
      getAllergies(id);
    }).catchError((error) {
      print(error);
      emit(UpdateAllergiesErrorState(error.toString()));
    });
  }
}
