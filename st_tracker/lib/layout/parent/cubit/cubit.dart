import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/models/transactions_model.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';
import 'package:st_tracker/shared/network/remote/dio_helper.dart';

class ParentCubit extends Cubit<ParentStates> {
  ParentCubit() : super(ParentInitState());

  static ParentCubit get(context) => BlocProvider.of(context);

  var database;

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
          // create schoolAttendance table
          await txn
              .execute(
                  'CREATE TABLE schoolAttendance(id TEXT, activity TEXT ,date DATETIME)')
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
        getDataFromAttendanceDatabase(db);
        getDataFromTransactionsTable(db);
      },
    ).then((value) {
      return value;
    });
  }

  void clearHistory() {
    databaseFactory.deleteDatabase('activities.db').then((value) {
      print('database deleted');
    }).then((value) {
      emit(ClearDatabaseSuccess());
      getDataFromAttendanceDatabase(database);
      getDataFromTransactionsTable(database);
    });
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
    CacheHelper.saveData(key: 'st_id', value: id);
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
        int notify_id = random.nextInt(pow(2, 31).toInt() - 1);
        trans['products'].forEach((product) {
          String notify_body =
              '${product['name']}      -${product['price']} EGP      ${DateFormat('EE, hh:mm a').format(DateTime.now())}';

          /*DioHelper.sendNotification(
              notification_title: 'Purchase', notification_body: notify_body);*/

          print('*' * 40);
          print(product.toString());
          print('*' * 40);
          insertToTransactionsTable(
                  trans_id: trans.id,
                  st_id: studentID!,
                  date: trans['date'].toDate(),
                  product: product['name'],
                  price: product['price'])
              .then((value) {
            FirebaseFirestore.instance
                .collection('canteen transactions')
                .doc(studentID)
                .collection('transactions')
                .doc(trans.id)
                .delete()
                .then((value) {
              emit(TransactionDeleteSuccess());

              print('transcation deleted');
              print(studentID);
            }).catchError((error) {
              print(error.toString());
            });
          });
        });
      });
      print('after listener');
      emit(ParentAddNewTranscationSuccessState());
    });
  }

  void addNewAttendance() {}

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

  insertToAttendanceDatabase(
      {required String id,
      required String activityType,
      required DateTime date}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO schoolAttendance(id, date, activityType) VALUES($id,$date, $activityType)')
          .then((value) {
        print('$value inserted successfully');
        emit(ParentInsertAttendanceDatabaseSuccessState());

        getDataFromAttendanceDatabase(database);
      }).catchError((err) {
        print(
            'Error when inserting into schoolAttendance table! ${err.toString()}');
      });
    });
  }

  List<TransactionsModel> canteen_transactions = [];

  void getDataFromAttendanceDatabase(Database database) async {
    emit(ParentGetDataBaseLoadingState());
    await database
        .rawQuery('SELECT * FROM schoolAttendance ORDER BY date DESC')
        .then((value) {
      emit(ParentGeSchoolAttendanceSuccessState());
    });
  }

  void getDataFromTransactionsTable(Database database) async {
    emit(ParentGetDataBaseLoadingState());

    await database
        .rawQuery('SELECT * FROM canteenTransactions ORDER BY date DESC')
        .then((value) {
      print(value);
      canteen_transactions = [];
      value.forEach((element) {
        canteen_transactions.add(TransactionsModel.fromJson(element));
      });

      emit(ParentGeSchoolTransactionsSuccessState());
    });
  }
}
