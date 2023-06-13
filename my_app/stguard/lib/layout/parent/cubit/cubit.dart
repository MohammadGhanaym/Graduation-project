import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stguard/layout/parent/cubit/states.dart';
import 'package:stguard/models/activity_model.dart';
import 'package:stguard/models/class_note.dart';
import 'package:stguard/models/country_model.dart';
import 'package:stguard/models/download_file.dart';
import 'package:stguard/models/notification_model.dart';
import 'package:stguard/models/parent_model.dart';
import 'package:stguard/models/school_model.dart';
import 'package:stguard/models/student_attendance.dart';
import 'package:stguard/models/student_model.dart';
import 'package:stguard/models/product_model.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/components/constants.dart';
import 'package:stguard/shared/network/local/cache_helper.dart';

import '../../../models/exam_results_model.dart';

class ParentCubit extends Cubit<ParentStates> {
  ParentCubit() : super(ParentInitState());
  static ParentCubit get(context) => BlocProvider.of(context);
  late Database database;

  void createDatabase() async {
    try {
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
            });
            // create notification table
            await txn.execute('''
                CREATE TABLE notification(
                      id INTEGER PRIMARY KEY AUTOINCREMENT,
                      title TEXT,
                      date DATETIME,
                      body TEXT
                    )
                  ''').then((value) {
              print('notification Table Created');
            }).catchError((error) {
              print(error.toString());
              return error;
            });
          });
        },
        onOpen: (db) async {
          database = db;
          print('db opened');
          await listenToNotification();
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  int? notificationCount = 0;
  Future<void> listenToNotification() async {
    await getNotificationCount();
    FirebaseMessaging.onMessage.listen((event) async {
      print('onMessage');
      try {
        notificationCount = CacheHelper.getData(key: 'notificationCount');
        notificationCount ??= 0;
        notificationCount = notificationCount! + 1;
        await CacheHelper.saveData(
            key: 'notificationCount', value: notificationCount);
        emit(NewNotificationState());
        Map<String, dynamic> notification = event.toMap()['notification'];
        print(notification);
        print(notification['title']);
        if (notification.containsKey('title') &&
            notification.containsKey('body')) {
          await insertNotification(notification['title'], notification['body']);
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  Future<void> getNotificationCount() async {
    notificationCount = CacheHelper.getData(key: 'notificationCount');
    emit(UpdateNotificationCountState());
  }

  Future<void> resetNotificationCount() async {
    notificationCount = null;
    await CacheHelper.removeData(key: 'notificationCount');
    emit(ResetNotificationCountState());
  }

  List<NotificationModel>? notifications;
  Future<void> getNotifications() async {
    emit(GetNotificationsLoadingState());
    notifications = [];

    try {
      await database.transaction((txn) async {
        final results = await txn.query('notification', orderBy: 'date DESC');
        for (final result in results) {
          final NotificationModel notification =
              NotificationModel.fromMap(result);
          notifications!.add(notification);
        }
      });

      print(notifications);
      emit(GetNotificationsSuccessState());
    } catch (error) {
      print('Error when getting notifications: $error');
      emit(GetNotificationsErrorState());
    }
  }

  Future<void> insertNotification(String title, String body) async {
    try {
      emit(InsertNotificationsLoadingState());
      final DateTime now = DateTime.now();
        await database.transaction((txn) async {
          await txn.rawInsert(
            'INSERT INTO notification(title, date, body) VALUES(?, ?, ?)',
            [title, now.toIso8601String(), body],
          );
        }).then((value) async {
          print('Notification inserted successfully');
          emit(InsertNotificationsSuccessState());
          await getNotifications();
        });
    
    } catch (error) {
      emit(InsertNotificationsErrorState());
      print('Error when inserting notification: $error');
    }
  }

  Future<void> clearHistory() async {
    await database.rawDelete('DELETE FROM student_activity');
    await database.rawDelete('DELETE FROM products');
    await database.rawDelete('DELETE FROM notification');

    await getDataFromActivityTable();
  }

  bool deleteLoading = false;
  Future<void> deleteNotification(int notificationId) async {
    deleteLoading = true;
    emit(DeleteNotificationLoadingState());

    try {
      await database.delete(
        'notification',
        where: 'id = ?',
        whereArgs: [notificationId],
      ).then((value) async {
        await getNotifications(); // Refresh the notifications list after deletion
        emit(DeleteNotificationSuccessState());
      });
    } catch (error) {
      print('Error when deleting notification: $error');
      emit(DeleteNotificationErrorState());
    }
    deleteLoading = false;
  }

  Map<String, DocumentReference<Map<String, dynamic>>> studentsPaths = {};
  Map<String, DocumentReference<Map<String, dynamic>>> schoolPaths = {};
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<void> getMyStudents() async {
    studentsPaths = {};
    schoolPaths = {};
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
          schoolPaths[st.id] = db
              .collection('Countries')
              .doc(st['country'])
              .collection('Schools')
              .doc(st['school']);

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
    await listentoNewData();
    await getDataFromActivityTable();
  }

  Map<String, StudentModel?> studentsData = {};
  Future<void> getStudentsData(
      String stId, DocumentReference<Map<String, dynamic>> stDoc) async {
    await stDoc.get().then((value) {
      if (value.data() != null) {
        studentsData[stId] = StudentModel.fromJson(value.data());
        emit(GetStudentDataSuccess());
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetStudentDataError());
    });
  }

  bool studentDataLoading = true;

  Future<void> listentoNewData() async {
    emit(GetStudentDataLoading());

    studentsData = {};

    try {
      studentDataLoading = true;
      cancelListeners();

      if (studentsPaths.isNotEmpty) {
        await Future.forEach(studentsPaths.entries, (entry) async {
          final stId = entry.key;
          final stDoc = entry.value;

          await getStudentsData(stId, stDoc);
          await addNewAttendance(stId, stDoc);
          await addNewTranscation(stId, stDoc);
        });
      } else {
        emit(GetStudentDataError());
      }
    } catch (e) {
      print(e.toString());
    } finally {
      studentDataLoading = false;
    }
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
        } else if (st.docs[0]['parent'] != null) {
          emit(FamilyMemberAlreadyHasParent(
              'This student ID is already connected to another parent'));
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
            FirebaseMessaging.instance
                .subscribeToTopic(st.docs[0]['class_name'])
                .then((value) {
              print('subscribed to ${st.docs[0]['class_name']}');
            }).catchError((error) {
              print(error.toString());
            });
            emit(AddFamilyMemberSuccess());
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
  bool activityLoading = true;
  Future<void> getDataFromActivityTable() async {
    print('getDataFromActivityTable');
    activityLoading = true;
    emit(ParentGetDataBaseLoadingState());
    if (studentsPaths.isNotEmpty) {
      //SELECT * FROM student_activity ORDER BY date DESC
      Database database = await openDatabase('activities.db');
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
        activityLoading = false;
      }).catchError((error) {
        emit(ParentGeStudentActivityErrorState());
        activityLoading = false;
      });
    } else {
      activities = [];
      emit(ParentGeStudentActivityErrorState());
      activityLoading = false;
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
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? locationListener;
  GoogleMapController? mapControllerl;
  void setMapController(GoogleMapController controller) {
    mapControllerl = controller;
  }

  Future<void> getLocation(String id) async {
    location = null;
    emit(GetStudentLocationLoadingState());
    locationListener = studentsPaths[id]!
        .collection('Location')
        .doc('location')
        .snapshots()
        .listen((event) {
      if (event.exists) {
        if (event.data() != null) {
          location = StudentLocationModel.fromJson(event.data()!);
          if (mapControllerl != null) {
            mapControllerl!
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(location!.lat, location!.long),
              zoom: 14.4746,
            )));
          }

          emit(GetStudentLocationSuccessState());
        }
      }
    });
  }

  void openMap({required double lat, required double long}) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      print(
          availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

      await availableMaps.first.showMarker(
        coords: Coords(lat, long),
        title: "Location",
      );
    } catch (e) {
      print(e.toString());
    }
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

  Future<void> getSettingsData(StudentModel st) async {
    pocket_money = st.pocketMoney.toDouble();
    calorie = st.calorieLimit;
    allergies = [Icons.add];
    selectedAllergies = [];
    if (st.allergies != null) {
      st.allergies!.forEach((element) {
        allergies.add(element);
        selectedAllergies.add(element);
      });
    }
    active = st.parent;
    await getLocation(st.id);
    await getClassNotes(st);
    await getStudentAttendance(st);
    await getStudentGrades(st);

    settingsVisibility = true;
    isPaired = true;
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
      FirebaseMessaging.instance
          .unsubscribeFromTopic(studentsData[id]!.className!)
          .then((value) {
        print('unsbuscribe');
      });
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
        hideBottomSheet();
        await getMaxPocketMoney(id: id);
        await getStudentsData(id, studentsPaths[id]!);
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

  List<dynamic> selectedAllergies = [];
  void addAllergen(value) {
    selectedAllergies.add(value);
    emit(AddAllergenState());
  }

  void removeAllergen(value) {
    selectedAllergies.remove(value);
    emit(RemoveAllergenState());
  }

  List<dynamic> allergies = [];
  Future<void> getAllergies(id) async {
    selectedAllergies = [];
    allergies = [Icons.add];
    emit(GetAllergiesLoadingState());

    await studentsPaths[id]!.get().then((value) {
      if (value.data()!.containsKey('allergies')) {
        if (value['allergies'] != null) {
          value['allergies'].forEach((element) {
            allergies.add(element);
            selectedAllergies.add(element);
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

  void resetSelectedAllergies() {
    selectedAllergies = [];
    allergies.forEach((element) {
      if (element.runtimeType != IconData) {
        selectedAllergies.add(element);
      }
    });
  }

  bool confirmAllergiesSelection = false;
  void changeAllergiesSelectionState({bool state = false}) {
    confirmAllergiesSelection = state;
  }

  Future<void> updateAllergens(id) async {
    emit(UpdateAllergiesLoadingState());

    await studentsPaths[id]!.update({
      'allergies': selectedAllergies.isNotEmpty ? selectedAllergies : null
    }).then((value) async {
      emit(UpdateAllergiesSuccessState());
      confirmAllergiesSelection = false;
      await getAllergies(id);
      await getStudentsData(id, studentsPaths[id]!);
    }).catchError((error) {
      print(error);
      emit(UpdateAllergiesErrorState(error.toString()));
    });
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
      cardNumber = '';
      expiryDate = '';
      cardHolderName = '';
      cvvCode = '';
      isCvvFocused = false;
    }).catchError((error) {
      emit(UpdateBalanceError());
    });
  }

  double calorie = 0.0;

  void updateCalorie({required String id, required double value}) async {
    emit(UpdateCalorieLoadingState());
    await studentsPaths[id]!.update({'calorie': value}).then((value) async {
      emit(UpdateCalorieSuccessState());
      await getStudentsData(id, studentsPaths[id]!);
      await getCalorie(id: id);
    }).catchError((error) {
      emit(UpdateCalorieErrorState());
      print(error.toString());
    });
  }

  Future<void> getCalorie({required String id}) async {
    emit(GetCalorieLoadingState());
    await studentsPaths[id]!.get().then((value) {
      calorie = value['calorie'].toDouble();
      emit(GetCalorieSuccessState());
    }).catchError((error) {
      print(error);
      emit(GetCalorieErrorState());
    });
  }

  List<NoteModel> notes = [];
  Future<void> getClassNotes(StudentModel st) async {
    notes = [];
    emit(GetNotesLoadingState());
    schoolPaths[st.id]!
        .collection('classes')
        .where('name', isEqualTo: st.className)
        .get()
        .then((value) {
      print('note here');
      if (value.docs.isNotEmpty) {
        print('note here2');
        print(value.docs);
        value.docs[0].reference
            .collection('notes')
            .where('to', whereIn: ['All', st.name])
            .orderBy('datetime', descending: true)
            .get()
            .then((value) {
              print('note here3');
              if (value.docs.isNotEmpty) {
                print('note here4');
                value.docs.forEach((element) {
                  notes.add(NoteModel.fromMap(element.data()));
                });
                print(notes);
                emit(GetNotesSuccessState());
              } else {
                emit(GetNotesErrorState());
              }
            })
            .catchError((error) {
              print(error);
              emit(GetNotesErrorState());
            });
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetNotesErrorState());
    });
  }

  Future<bool> checkFileExists(String fileName) async {
    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/$fileName');
    return await file.exists();
  }

  Future<void> openDownloadedFile(String fileName) async {
    requestWritePermission();
    Directory tempDir = await getTemporaryDirectory();
    File downloadedFile = File('${tempDir.path}/$fileName');

    if (await downloadedFile.exists()) {
      print('File exists at path: ${downloadedFile.path}');
      // Open the downloaded file using the default system application
      await OpenFile.open(downloadedFile.path).then((value) {
        print('File opened');
      }).catchError((error) {
        print(error.toString());
      });
    } else {
      print('File does not exist at path: ${downloadedFile.path}');
      // Handle the case where the file does not exist
    }
  }

  Map<String, DownloadFileInfo> downloadFilesInfo = {};
  Future<void> downloadFile(
      {required String fileName, required String fileUrl}) async {
    emit(FileDownloadLoadingState());
    double progress = 0.0;
    try {
      // Create a reference to the file in Firebase Storage
      print(fileUrl);
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instanceFor(
                  bucket: 'smartschool-6aee1.appspot.com')
              .refFromURL(fileUrl);

      // Download the file to a temporary directory
      Directory tempDir = await getTemporaryDirectory();
      print(tempDir.path);
      print(fileName);
      //String filePath = "/storage/emulated/0/Documents";
      File file = File('${tempDir.path}/$fileName');
      firebase_storage.DownloadTask downloadTask = ref.writeToFile(file);
      downloadFilesInfo[fileName] =
          DownloadFileInfo(progress: progress, downloadTask: downloadTask);

      downloadTask.snapshotEvents.listen((snapshot) async {
        // You can access the download progress from the `snapshot.bytesTransferred` and `snapshot.totalBytes` properties
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Download Progress: $progress%');
        downloadFilesInfo[fileName]!.progress = progress;
        emit(DownloadFileProgress());
        if (progress == 1 &&
            snapshot.state == firebase_storage.TaskState.success) {
          emit(FileDownloadSuccessState());
          downloadFilesInfo.remove(fileName);
        }
      }).onError((error) {
        print('Error: ${error.toString()}');
        emit(FileDownloadErrorState());
      });
    } catch (e) {
      emit(FileDownloadErrorState());
      print('Error: ${e.toString()}');
    }
  }

  Future<void> deleteFile(String fileName) async {
    if (downloadFilesInfo.keys.contains(fileName)) {
      downloadFilesInfo[fileName]!.downloadTask.cancel().then((value) {
        print('download cancel');
        downloadFilesInfo.remove(fileName);
        emit(CancelDownloadState());
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }
    Directory tempDir = await getTemporaryDirectory();
    try {
      File file = File('${tempDir.path}/$fileName');
      await file.delete().then((value) {
        emit(DeleteFileSuccessState());
      });
      print('File deleted successfully');
    } catch (e) {
      print('Failed to delete file: $e');
    }
  }

  List<LessonAttendance>? studentAttendance;
  Future<void> getStudentAttendance(StudentModel st) async {
    studentAttendance = [];
    emit(GetAttendanceLoadingState());
    schoolPaths[st.id]!
        .collection('classes')
        .where('name', isEqualTo: st.className)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        print(value.docs);
        value.docs[0].reference
            .collection('attendance')
            .orderBy('datetime', descending: true)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            value.docs.forEach((element) {
              studentAttendance!.add(LessonAttendance.fromMap(element.data()));
            });
            print(studentAttendance);
            emit(GetAttendanceSuccessState());
          } else {
            emit(GetAttendanceErrorState());
          }
        }).catchError((error) {
          print(error);
          emit(GetAttendanceErrorState());
        });
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetAttendanceErrorState());
    });
  }

// Write your code here
  /// *************************************
  List<ExamResults>? studentResults;
  Future<void> getStudentGrades(StudentModel st) async {
    studentResults = [];
    emit(GetGradesLoadingState());
    await schoolPaths[st.id]!
        .collection('classes')
        .where('name', isEqualTo: st.className)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        print(value.docs);
        value.docs[0].reference
            .collection('exams results')
            .orderBy('datetime', descending: true)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            value.docs.forEach((element) {
              studentResults!.add(ExamResults.fromMap(element.data()));
            });
            print(studentResults);
            emit(GetGradesSuccessState());
          } else {
            emit(GetGradesErrorState());
          }
        }).catchError((error) {
          print(error.toString());
          emit(GetGradesErrorState());
        });
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetGradesErrorState());
    });
  }

  /// *************************************

  void signOut() async {
    await CacheHelper.removeData(key: 'id').then((value) async {
      cancelListeners();
      userID = null;
      userRole = null;
      parent = null;
      studentsPaths.clear();
      schoolPaths.clear();
      activities.clear();
      await CacheHelper.removeData(key: 'role');
      emit(UserSignOutSuccessState());
      database.close();
    });
  }
}
