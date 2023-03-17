import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sqflite/sqflite.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/models/activity_model.dart';
import 'package:st_tracker/models/country_model.dart';
import 'package:st_tracker/models/parent_model.dart';
import 'package:st_tracker/models/school_model.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/models/product_model.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/background_service.dart';

class ParentCubit extends Cubit<ParentStates> {
  ParentCubit() : super(ParentInitState());

  static ParentCubit get(context) => BlocProvider.of(context);

  late Database database;

  void createDatabase() async {
    /*await databaseFactory.deleteDatabase('activities.db').then((value) {
      print('database deleted');
    });*/
    database = await openDatabase(
      'activities.db',
      version: 1,
      onCreate: (db, version) async {
        print('db created');
        await db.transaction((txn) async {
          // create student_activity table
          await txn.execute('''
                    CREATE TABLE student_activity(
                      id TEXT NOT NULL,
                      activity TEXT,
                      date DATETIME,
                      trans_id TEXT
                      )
                  ''').then((value) {
            print('Table Created');
          }).catchError((error) {
            print(error.toString());
            return error;
          });
          // create canteenTransactions table
          await txn.execute('''
                CREATE TABLE products(
                    trans_id TEXT NOT NULL,
                    product TEXT NOT NULL,
                    price TEXT NOT NULL,
                    quantity INT NOT NULL
                    )
                  ''').then((value) {
            print('Table Created');
          }).catchError((error) {
            print(error.toString());
            return error;
          });
        });
      },
      onOpen: (db) {
        database = db;
        getMyStudents();

        print('db opened');
      },
    );
  }

  Future<void> clearHistory() async {
    await database.rawDelete('DELETE FROM student_activity');
    await database.rawDelete('DELETE FROM products');

    await getDataFromActivityTable();
  }

  Map<String, DocumentReference<Map<String, dynamic>>> studentsPaths = {};
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<void> getMyStudents() async {
    studentsPaths = {};

    emit(GetStudentsPathsLoading());
    await db
        .collection('Parents')
        .doc(userID)
        .collection('Students')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((st) {
          print(st.data());

          studentsPaths[st.id] = db
              .collection('Countries')
              .doc(st['country'])
              .collection('Schools')
              .doc(st['school'])
              .collection('Students')
              .doc(st.id);
        });
        emit(GetStudentsPathsSuccess());
      } else {
        emit(GetStudentsPathsError('No students found'));
      }
    }).catchError((error) {
      print(error.toString());
      print('paths error');
      emit(GetStudentsPathsError(error.toString()));
    });
    await getStudentsData();
    await listentoNewData();
    await getDataFromActivityTable();
  }

  List<StudentModel?> studentsData = [];
  Future<void> getStudentsData() async {
    studentsData = [];
    emit(GetStudentDataLoading());
    if (studentsPaths.isNotEmpty) {
      studentsPaths.forEach(
        (stId, stDoc) async {
          await stDoc.get().then((value) {
            if (value.data() != null) {
              studentsData.add(StudentModel.fromJson(value.data()));
              emit(GetStudentDataSuccess());
            }
          }).catchError((error) {
            print(error.toString());
            emit(GetStudentDataError());
          });
        },
      );
    } else {
      emit(GetStudentDataError());
    }
  }

  Future<void> listentoNewData() async {
    cancelListeners();
    print('*' * 100);
    print(transListeners.length);
    print(attendListeners.length);
    print('*' * 100);

    studentsPaths.forEach((stId, stDoc) async {
      await addNewAttendance(stId, stDoc);
      await addNewTranscation(stId, stDoc);
    });
  }

  List<Country> countries = [];
  Future<void> getCountries() async {
    countries = [];
    emit(GetCountriesLoadingState());
    await db.collection('Countries').get().then((value) {
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
  Future<void> getSchools() async {
    schools = [];
    emit(GetSchoolsLoadingState());

    await db
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

  Future<void> addFamilyMember(String id) async {
    WriteBatch batch = db.batch();
    emit(AddFamilyMemberLoading());

    CollectionReference stColl = db
        .collection('Countries')
        .doc(pickedCountry!.id)
        .collection('Schools')
        .doc(pickedSchool!.id)
        .collection('Students');
    await stColl.where('uid', isEqualTo: id).get().then((st) async {
      if (st.docs.isNotEmpty) {
        if (studentsPaths.keys.contains(id)) {
          emit(FamilyMemberAlreadyExisted('You added this member before'));
        } else {
          batch.update(st.docs[0].reference, {'parent': userID});
          batch.set(
              db
                  .collection('Parents')
                  .doc(userID)
                  .collection('Students')
                  .doc(id),
              {'country': pickedCountry!.id, 'school': pickedSchool!.id});
          batch.commit().then((value) async {
            emit(AddFamilyMemberSuccess());
            await getMyStudents();
            await refreshBackgroundService();
          }).catchError((error) {
            print(error.toString());
            emit(AddFamilyMemberError());
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
  }

  Future<void> addNewTranscation(
      String studentID, DocumentReference<Map<String, dynamic>> stDoc) async {
    print('before listener');

    transListeners[studentID] =
        stDoc.collection('CanteenTransactions').snapshots().listen((event) {
      if (event.docChanges.isNotEmpty) {
        event.docChanges.forEach((trans) {
          if (trans.type == DocumentChangeType.added) {
            print('Im here in trans');

            trans.doc.reference.delete().then((value) async {
              await insertToActivityTable(
                  id: studentID,
                  activityType: trans.doc['total_price'].toString(),
                  date: trans.doc['date'].toDate(),
                  transId: trans.doc.id);

              trans.doc['products'].forEach((product) async {
                await insertToTransactionsTable(
                    trans_id: trans.doc.id,
                    product: product['name'],
                    price: product['price'],
                    quantity: product['quantity']);
              });
            });
          }
        });
      }
    });
  }

  Future<void> addNewAttendance(
      String studentID, DocumentReference<Map<String, dynamic>> stDoc) async {
    print('addNewAttendance:{$studentID}');
    attendListeners[studentID] =
        stDoc.collection('SchoolAttendance').snapshots().listen((event) async {
      event.docChanges.forEach((studentMove) async {
        if (studentMove.type == DocumentChangeType.added) {
          SchoolAttendanceModel attendStatus =
              SchoolAttendanceModel.fromJson(studentMove.doc.data()!);

          await studentMove.doc.reference.delete().then((value) async {
            await insertToActivityTable(
                id: studentID,
                activityType:
                    "${attendStatus.action[0].toUpperCase()}${attendStatus.action.substring(1)}",
                date: attendStatus.date);
          }).catchError((error) {
            print(error.toString());
          });
        }
      });
    });
  }

  Future<void> insertToTransactionsTable(
      {required String trans_id,
      required String product,
      required dynamic price,
      required dynamic quantity}) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO products(trans_id, product, price, quantity) VALUES("$trans_id", "$product", "$price", "$quantity")')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((err) {
        print('Error when inserting into products table! ${err.toString()}');
      });
    });
  }

  Future<void> insertToActivityTable(
      {required String id,
      required String activityType,
      required DateTime date,
      String? transId}) async {
    await database
        .rawInsert(
            'INSERT INTO student_activity(id, date, activity, trans_id) VALUES("$id","$date", "$activityType", "$transId")')
        .then((value) async {
      print('$value inserted successfully');
      await getDataFromActivityTable();
    }).catchError((err) {
      print(
          'Error when inserting into student_activity table! ${err.toString()}');
    });
  }

  List<ActivityModel> activities = [];

  Future<void> getDataFromActivityTable() async {
    print('getDataFromActivityTable');

    emit(ParentGetDataBaseLoadingState());
    if (studentsPaths.isNotEmpty) {
      //SELECT * FROM student_activity ORDER BY date DESC
      await database
          .query('student_activity',
              orderBy: 'date DESC',
              where: "id IN (${studentsPaths.keys.map((_) => '?').join(', ')})",
              whereArgs: studentsPaths.keys.toList())
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
      }).catchError((error) {});
    } else {
      activities = [];
      emit(ParentGeStudentActivityErrorState());
    }
  }

  List<ProductModel> products = [];
  Future<void> getDataFromTransactionsTable(String trans_id) async {
    emit(ParentGetDataBaseLoadingState());
    //SELECT * FROM canteenTransactions ORDER BY date DESC'
    await database.query('products',
        where: 'trans_id = ?', whereArgs: [trans_id]).then((value) {
      print(value);
      products = [];
      value.forEach((element) {
        products.add(ProductModel.fromJson(element));
      });

      emit(ParentGeSchoolTransactionsSuccessState());
    });
  }

  StudentLocationModel? location;
  Future<void> getLocation(String id) async {
    emit(GetStudentLocationLoadingState());
    await studentsPaths[id]!.collection('Location').get().then((value) {
      location = StudentLocationModel.fromJson(value.docs[0].data());
      emit(GetStudentLocationSuccessState());
    }).catchError((error) {
      print(error);
    });
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
  Future<void> getAttendanceHistory(st_id) async {
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

  Future<void> changeDigitalIDState(String id) async {
    db.runTransaction((transaction) async {
      DocumentSnapshot st = await transaction.get(studentsPaths[id]!);
      transaction.update(studentsPaths[id]!,
          {'parent': st.get('parent') == null ? userID : null});
    }).catchError((error) {
      print(error);
      emit(DeactivateDigitalIDError());
    }).whenComplete(() async {
      emit(DeactivateDigitalIDSuccess());
      await getActiveState(id);
    });
  }

  String? active;
  Future<void> getActiveState(String id) async {
    emit(GetDigitalIDStateLoading());
    await studentsPaths[id]!.get().then((value) {
      if (value.data()!.containsKey('parent')) {
        active = value['parent'];
      }
      emit(GetDigitalIDStateSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(GetDigitalIDStateError(error.toString()));
    });
  }

  Future<void> unpairDigitalID(String id) async {
    print('digital id');
    WriteBatch batch = db.batch();
    batch.delete(
        db.collection('Parents').doc(userID).collection('Students').doc(id));
    batch.update(studentsPaths[id]!, {'parent': null});
    batch.commit().then((value) async {
      active = null;
      studentsPaths.remove(id);
      if (attendListeners[id] != null) {
        attendListeners[id]!.cancel();
        attendListeners.remove(id);
      }
      if (transListeners[id] != null) {
        transListeners[id]!.cancel();
        transListeners.remove(id);
      }

      print('batch commited: unpairDigitalID');
      print(studentsPaths.keys.toList());

      emit(UnpairDigitalIDSuccess());
      await getMyStudents();
      await refreshBackgroundService();
    }).catchError((error) {
      print(error);
      emit(UnpairDigitalIDError());
    });
  }

  ParentModel? parent;
  Future<void> getParentInfo() async {
    emit(GetUserInfoLoading());
    if (userID != null) {
      await db.collection('Parents').doc(userID).get().then((value) {
        if (value.data() != null) {
          print(value.data()!);
          parent = ParentModel.fromJson(value.data()!);
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

  Future<void> updateBalance(double amount) async {
    print(amount);
    print(parent!.balance);
    print(amount + parent!.balance);
    emit(UpdateBalanceLoading());
    await db
        .collection('Parents')
        .doc(userID)
        .update({'balance': parent!.balance + amount}).then((value) {
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

  Future<void> updatePocketMoney({required String id}) async {
    emit(SetPocketMoneyLoadingState());

    if (pocket_money < parent!.balance) {
      await studentsPaths[id]!
          .update({'pocket money': pocket_money}).then((value) async {
        emit(SetPocketMoneySuccessState());
        await getMaxPocketMoney(id: id);
      }).catchError((error) {
        print(error);
        emit(SetPocketMoneyErrorState());
      });
    }
  }

  Future<void> getMaxPocketMoney({required String id}) async {
    emit(GetPocketMoneyLoadingState());
    await studentsPaths[id]!.get().then((value) {
      pocket_money = value['pocket money'].toDouble();
      emit(GetPocketMoneySuccessState());
    }).catchError((error) {
      print(error);
      emit(GetPocketMoneyErrorState());
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
  Future<void> getAllergies(id) async {
    selectedAllergens = [];
    allergens = [Icons.add];
    emit(GetAllergiesLoadingState());

    await studentsPaths[id]!.get().then((value) {
      if (value.data()!.containsKey('allergies')) {
        if (value['allergies'] != null) {
          value['allergies'].forEach((element) {
            allergens.add(element);
            selectedAllergens.add(element);
          });
          emit(GetAllergiesSucessState());
        } else {
          print('No allergies found');
          emit(GetAllergiesErrorState('No allergies Found'));
        }
      }
    }).catchError((error) {
      print(error);
      emit(GetAllergiesErrorState(error.toString()));
    });
  }

  Future<void> updateAllergens(id) async {
    emit(UpdateAllergiesLoadingState());

    await studentsPaths[id]!.update({
      'allergies': selectedAllergens.isNotEmpty ? selectedAllergens : null
    }).then((value) async {
      emit(UpdateAllergiesSuccessState());
      await getAllergies(id);
    }).catchError((error) {
      print(error);
      emit(UpdateAllergiesErrorState(error.toString()));
    });
  }

  Future<void> startBackgroundService() async {
    if (!await FlutterBackgroundService().isRunning()) {
      await BackgroundService.initializeService();
    }
  }

  Future<void> refreshBackgroundService() async {
    FlutterBackgroundService().invoke('stopService');
    await Future.delayed(const Duration(seconds: 5));
    await BackgroundService.initializeService();
  }

  void stopBackgroundService() {
    FlutterBackgroundService().invoke('stopService');
  }

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  OutlineInputBorder? border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    cardNumber = creditCardModel!.cardNumber;
    expiryDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;
    emit(CreditCardModelChangeState());
  }

  List<dynamic> rechargeAmounts = [200, 400, 600, 1000, 2000, 'Other'];
}
