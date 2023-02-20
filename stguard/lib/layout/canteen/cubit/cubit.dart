import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/models/canteen_model.dart';
import 'package:st_tracker/models/canteen_product_model.dart';
import 'package:st_tracker/models/country_model.dart';
import 'package:st_tracker/models/school_model.dart';
import 'package:st_tracker/modules/canteen/add_product/add_product_screen.dart';
import 'package:st_tracker/modules/canteen/products/products_screen.dart';
import 'package:st_tracker/shared/components/constants.dart';

class CanteenCubit extends Cubit<CanteenStates> {
  CanteenCubit() : super(CanteenInitState());
  static CanteenCubit get(context) => BlocProvider.of(context);

  CanteenWorkerModel? canteen;
  FirebaseFirestore db = FirebaseFirestore.instance;

  void getCanteenInfo() async {
    emit(GetUserInfoLoading());
    if (userID != null) {
      await db.collection('Canteen Workers').doc(userID).get().then((value) {
        if (value.data() != null) {
          print(value.data()!);
          canteen = CanteenWorkerModel.fromJson(value.data()!);
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

  CollectionReference<Map<String, dynamic>>? canteenPath;
  void getCanteenPath() {
    canteenPath = null;
    emit(GetCanteenPathLoadingState());
    db
        .collection('Canteen Workers')
        .doc(userID)
        .collection('Community')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        canteenPath = db
            .collection('Countries')
            .doc(value.docs[0]['country'])
            .collection('Schools')
            .doc(value.docs[0]['school'])
            .collection('Canteen');

        emit(GetCanteenPathSuccessState());
        await getCategories();
      } else {
        emit(NeedtoJoinCommunityState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetCanteenPathErrorState());
    });
  }

  void resetId() {
    db.runTransaction((transaction) async {
      db
          .collection('Canteen Workers')
          .doc(userID)
          .collection('Community')
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs[0].reference.delete().then((value) {
            emit(ResetIDSuccessState());
            getCanteenPath();
          });
        }
      });
    }).catchError((error) {
      print(error.toString());
      emit(ResetIDErrorState());
    });
  }

  void addCanteen(String id) {
    emit(AddCanteenLoadingState());
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
        if (value.docs.isNotEmpty &&
            value.docs[0]['role'] == 'canteen worker') {
          db
              .collection('Canteen Workers')
              .doc(userID)
              .collection('Community')
              .doc(id)
              .set({
            'uid': value.docs[0].id,
            'country': pickedCountry!.id,
            'school': pickedSchool!.id
          }).then((value) {
            emit(AddCanteenSucessState());
            getCanteenPath();
          });
        }
      });
    }).catchError((error) {
      print(error.toString());
      emit(AddCanteenErrorState(error.toString()));
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

  List<Widget> screens = [
    AddProductScreen(),
    ProductsScreen(),
  ];
  int currentIndex = 0;
  void switchScreen(var index) {
    currentIndex = index;
    emit(SwitchScreenState());
  }

  List<String> categories = ['All'];
  List<CanteenProductModel> products = [];
  List<String> selectedProducts = [];
  Future<void> getCategories() async {
    emit(GetCategoriesLoadingState());

    if (canteenPath != null) {
      await canteenPath!.get().then((value) {
        canteenPath!
            .doc(value.docs[0].id)
            .collection('categories')
            .get()
            .then((value) async {
          categories = ['All'];
          products = [];
          value.docs.forEach((element) {
            categories.add(element.id);
          });
          emit(GetCategoriesSuccessState());
          await getProducts();
          print(value.docs);
        });
      }).catchError((error) {
        print(error.message);
        emit(GetCategoriesErrorState());
      });
    }
  }

  Future<void> getProducts({String category = 'All'}) async {
    emit(GetProductsLoadingState());
    products = [];
    if (canteenPath != null) {
      if (category == 'All') {
        categories.forEach((category) async {
          await getProductbyCategory(category);
        });
      } else {
        await getProductbyCategory(category);
      }
    }
  }

  Future<void> getProductbyCategory(category) async {
    await canteenPath!.get().then((value) {
      canteenPath!
          .doc(value.docs[0].id)
          .collection('categories')
          .doc(category)
          .collection('Products')
          .get()
          .then((value) {
        value.docs.forEach(
          (product) {
            products
                .add(CanteenProductModel.fromMap(product.id, product.data()));
          },
        );
        emit(GetProductsSuccessState());

        print(value.docs);
      });
    }).catchError((error) {
      emit(GetProductsErrorState());

      print(error.message);
    });
  }

  void selectProduct(String id) {
    if (selectedProducts.contains(id)) {
      selectedProducts.remove(id);
    } else {
      selectedProducts.add(id);
    }

    emit(SelectProductState());
    print(selectedProducts);
  }

  bool bottomSheetShown = false;
  void showBottomSheet(bool sheetState) {
    bottomSheetShown = sheetState;
    emit(ShowBottomSheetState());
  }
}
