import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/models/canteen_model.dart';
import 'package:st_tracker/models/canteen_product_model.dart';
import 'package:st_tracker/models/country_model.dart';
import 'package:st_tracker/models/parent_model.dart';
import 'package:st_tracker/models/school_model.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/modules/canteen/inventory/inventory_screen.dart';
import 'package:st_tracker/modules/canteen/products/products_screen.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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

  DocumentReference<Map<String, dynamic>>? schoolCanteenPath;
  void getCanteenPath() {
    schoolCanteenPath = null;
    emit(GetCanteenPathLoadingState());
    db
        .collection('Canteen Workers')
        .doc(userID)
        .collection('Community')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        schoolCanteenPath = db
            .collection('Countries')
            .doc(value.docs[0]['country'])
            .collection('Schools')
            .doc(value.docs[0]['school']);

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

  List<Widget> screens = [ProductsScreen(), CanteenInventoryScreen()];
  int currentIndex = 0;
  void switchScreen(var index) {
    currentIndex = index;
    emit(SwitchScreenState());
  }

  List<String> categories = ['All'];
  Map<String, CanteenProductModel> products = {};
  Future<void> getCategories() async {
    emit(GetCategoriesLoadingState());

    if (schoolCanteenPath != null) {
      await schoolCanteenPath!.collection('Canteen').get().then((value) {
        schoolCanteenPath!
            .collection('Canteen')
            .doc(value.docs[0].id)
            .collection('categories')
            .get()
            .then((value) async {
          categories = ['All'];

          value.docs.forEach((element) {
            categories.add(element.id);
          });
          emit(GetCategoriesSuccessState());
          await getProducts();
          print(value.docs);
        });
      }).catchError((error) {
        print(error.toString());
        emit(GetCategoriesErrorState());
      });
    }
  }

  Future<void> getProducts({String category = 'All'}) async {
    emit(GetProductsLoadingState());
    products = {};
    if (schoolCanteenPath != null) {
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
    await schoolCanteenPath!.collection('Canteen').get().then((value) {
      schoolCanteenPath!
          .collection('Canteen')
          .doc(value.docs[0].id)
          .collection('categories')
          .doc(category)
          .collection('Products')
          .get()
          .then((value) {
        value.docs.forEach(
          (product) {
            products[product.id] = CanteenProductModel.fromMap(product.data());
          },
        );
        emit(GetProductsSuccessState());

        print(value.docs);
      });
    }).catchError((error) {
      emit(GetProductsErrorState());

      print(error.toString());
    });
  }

  Map<String, CanteenProductModel> selectedProducts = {};
  Map<String, int> itemQuantities = {};
  void selectProduct(String id, CanteenProductModel selectedProduct) {
    if (selectedProducts.keys.contains(id)) {
      selectedProducts.remove(id);
      itemQuantities.remove(id);
    } else {
      selectedProducts[id] = selectedProduct;
      itemQuantities[id] = 1;
    }

    emit(SelectProductState());
    print(selectedProducts);
  }

  void updateQuantities(String action, String id) {
    if (action == 'add') {
      itemQuantities[id] = itemQuantities[id]! + 1;
    } else if (itemQuantities[id]! > 1) {
      itemQuantities[id] = itemQuantities[id]! - 1;
    }
    calTotalPrice();
  }

  double totalPrice = 0.0;
  int itemsCount = 0;
  void calTotalPrice() {
    totalPrice = 0.0;
    selectedProducts.forEach((id, p) {
      totalPrice += p.price * itemQuantities[id]!;
      itemsCount += itemQuantities[id]!;
      print(p.price);
      print(itemQuantities[id]);
    });
    print(totalPrice);
    emit(CalculateTotalPriceState());
  }

  void cancelSelectedProducts() {
    selectedProducts = {};
    bottomSheetShown = false;
    emit(CancelSelectedProductState());
  }

  bool bottomSheetShown = false;
  void showBottomSheet(bool sheetState) {
    bottomSheetShown = sheetState;
    emit(ShowBottomSheetState());
  }

  Map<String, CanteenProductModel> inventorySearchResults = {};
  void getSearchResults({String search = 'All'}) {
    inventorySearchResults = {};
    if (search == 'All') {
      inventorySearchResults = products;
    } else {
      products.forEach((id, product) {
        if (product.name.toLowerCase().contains(search.toLowerCase())) {
          inventorySearchResults[id] = product;
        }
      });
    }
    emit(GetInventorySearchResultssSuccessState());
  }

  File? itemImage;

  final ImagePicker picker = ImagePicker();

  Future<void> getItemImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      itemImage = File(pickedFile.path);
      emit(ItemImagePickedSucessState());
    } else {
      print('No Image Selected.');
      emit(ItemImagePickedErrorState());
    }
  }

  Future<void> uploadItemImage(
      {required String name,
      required double price,
      required String category,
      required List<String> itemAllergies}) async {
    emit(UploadItemImageLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('items_images/${Uri.file(itemImage!.path).pathSegments.last}')
        .putFile(itemImage!)
        .then((p0) async {
      await p0.ref.getDownloadURL().then((value) {
        emit(UploadItemImageSuccessState());
        print(value);
        addNewItem(
            category: category,
            name: name,
            price: price,
            image: value,
            itemAllergies: itemAllergies);
      }).catchError((error) {
        print(error);
        emit(UploadItemImageErrorState());
      });
    }).catchError((error) {
      emit(UploadItemImageErrorState());
      print(error.toString());
    });
  }

  List<String> ingredients = [];
  Future<void> checkAllergens({
    required String name,
    required double price,
    required String category,
  }) async {
    List<String> itemAllergies = [];

    ingredients.forEach((ingredient) {
      allergies.forEach((allergy, allergens) {
        for (String allergen in allergens) {
          if (allergen.toLowerCase().contains(ingredient.toLowerCase()) ||
              allergen
                  .toLowerCase()
                  .contains(ingredient.toLowerCase().split(' ').last) ||
              ingredient.toLowerCase().contains(allergen.toLowerCase())) {
            itemAllergies.add(allergy);
            break;
          }
        }
      });
    });
    await uploadItemImage(
        name: name,
        price: price,
        category: category,
        itemAllergies: itemAllergies);
  }

  Map<String, List<String>> allergies = {};
  void getAllergies() async {
    emit(GetAllergiesLoadingState());
    await db.collection('Allergies').get().then((value) {
      value.docs.forEach((allergy) {
        allergies[allergy['name']] = allergy['allergens'];
      });
      emit(GetAllergiesSuccessState());
    }).catchError((error) {
      emit(GetAllergiesErrorState());
      print(error.toString());
    });
  }

  void addIngredient(String ingredient) {
    ingredients.add(ingredient);
    emit(AddIngredientSuccessState());
  }

  void removeIngredient(String ingredient) {
    ingredients.remove(ingredient);
    emit(RemoveIngredientSuccessState());
  }

  void addNewItem(
      {required String name,
      required double price,
      required String category,
      required String image,
      required List<String> itemAllergies}) async {
    emit(UploadItemDataLoadingState());
    await schoolCanteenPath!.collection('Canteen').get().then((value) {
      schoolCanteenPath!
          .collection('Canteen')
          .doc(value.docs[0].id)
          .collection('categories')
          .doc(category)
          .collection('Products')
          .doc()
          .set({
        'name': name,
        'price': price,
        'image': image,
        'allergies': itemAllergies
      }).then((value) {
        emit(UploadItemDataSuccessState());
        getProducts();
      });
    }).catchError((error) {
      emit(UploadItemDataErrorState());

      print(error.toString());
    });
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? buyerListener;
  void listentoBuyer() {
    emit(StartListeningBuyerDataState());
    buyerListener = schoolCanteenPath!
        .collection('Canteen')
        .snapshots()
        .listen((event) async {
      if (event.docChanges.isNotEmpty) {
        if (event.docChanges[0].type == DocumentChangeType.modified) {
          print(event.docChanges[0].doc.data());
          await getBuyerData(event.docChanges[0].doc['CurrentBuyer']);
        }
      }
    });
  }

  Future<void> getBuyerData(String buyerID) async {
    emit(PaymentLoadingState());
    // info of interest: parent, spending limit, totday's spending, allergies
    await schoolCanteenPath!
        .collection('Students')
        .where('uid', isEqualTo: buyerID)
        .get()
        .then((value) {
      print(value.docs[0].data());
      analyzeBuyerData(value.docs[0].data());
    }).catchError((error) {
      print('getBuyerData');
      print(error.toString());
      emit(PaymentErrorState());
    });
  }

  StudentModel? buyer;

  void analyzeBuyerData(Map<String, dynamic> buyerData) {
    buyer = StudentModel.fromJson(buyerData);
    if (buyer!.parent == null) {
      emit(IDDeactivatedState());
    } else if (buyer!.dailySpending != null) {
      if (buyer!.dailySpending!['value'] + totalPrice > buyer!.pocketMoney) {
        emit(SpendingLimitExceededState());
      }
    } else if (buyer!.allergies != null) {
      for (CanteenProductModel product in selectedProducts.values) {
        if (product.allergies != null) {
          for (String allergy in product.allergies!) {
            if (buyer!.allergies!.contains(allergy)) {
              emit(ProductsContainAllergensState());
            }
          }
        }
      }
    } else {
      completePayment(buyer!.parent!);
    }
  }

  final batch = FirebaseFirestore.instance.batch();
  void completePayment(String parentID) async {
    ParentModel? parent;
    final parentDocRef = db.collection('Parents').doc(parentID);
    await parentDocRef.get().then((parentDoc) async {
      if (parentDoc.exists) {
        parent = ParentModel.fromJson(parentDoc.data()!);
        if (parent!.balance <= totalPrice) {
          batch.update(parentDocRef, {'balance': parent!.balance - totalPrice});
          await updateCanteenData();
          await setTransaction();
        }
      }
    }).catchError((error) {
      print('completePayment');
      print(error.toString());
      emit(PaymentErrorState());
    });
  }

  Future<void> updateCanteenData() async {
    await schoolCanteenPath!.collection('Canteen').get().then((canteen) async {
      if (canteen.docs.isNotEmpty) {
        await canteen.docs[0].reference.get().then((canteenData) async {
          if (canteenData.data() != null) {
            batch.update(canteenData.reference, {'CurrentBuyer': null});

            if (canteenData.data()!.containsKey('daily revenue')) {
              batch.update(canteenData.reference, {
                'daily revenue': canteenData['daily revenue'] + totalPrice,
                'updateTime': DateTime.now()
              });
            } else {
              batch.update(canteenData.reference,
                  {'daily revenue': totalPrice, 'updateTime': DateTime.now()});
            }

            if (canteenData.data()!.containsKey('daily revenue')) {
              batch.update(canteenData.reference, {
                'daily transactions': canteenData['daily transactions'] + 1,
                'updateTime': DateTime.now()
              });
            } else {
              batch.update(canteenData.reference,
                  {'daily transactions': 1, 'updateTime': DateTime.now()});
            }
          }
        }).catchError((error) {
          print('updateCanteenData');
          print(error.toString());
          emit(PaymentErrorState());
        });
      } else {
        print('updateCanteenData');
        print('canteen is empty');
        emit(PaymentErrorState());
      }
    }).catchError((error) {
      print('updateCanteenData');
      print(error.toString());
      emit(PaymentErrorState());
    });
  }

  Map<String, dynamic> createTranscation() {
    List<Map<String, dynamic>> purchasedProducts = [];
    selectedProducts.forEach((id, p) {
      purchasedProducts.add(
          {'name': p.name, 'price': p.price, 'quantity': itemQuantities[id]});
    });

    return {
      'date': DateTime.now(),
      'products': purchasedProducts,
      'total_price': totalPrice
    };
  }

  Future<void> setTransaction() async {
    await schoolCanteenPath!
        .collection('Students')
        .where('uid', isEqualTo: buyer!.id)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        if (value.docs[0].data().containsKey('dailySpending')) {
          batch.update(value.docs[0].reference, {
            'dailySpending': {
              'value': totalPrice + value.docs[0].data()['dailySpending'],
              'updateTime': DateTime.now()
            }
          });
        } else {
          batch.update(value.docs[0].reference, {
            'dailySpending': {'value': totalPrice, 'updateTime': DateTime.now()}
          });
        }

        batch.set(
            value.docs[0].reference.collection('CanteenTransactions').doc(),
            createTranscation());

        await batch.commit().then((value) {
          emit(PaymentSuccessState());
          if (buyerListener != null) {
            buyerListener!.cancel();
          }
        }).catchError((error) {
          print('batch commit error');
          print(error.toString());
          emit(PaymentErrorState());
        });
      }
    }).catchError((error) {
      print('setTransaction');
      print(error.toString());
      emit(PaymentErrorState());
    });
  }
}
