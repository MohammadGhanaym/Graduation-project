import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:stguard/layout/canteen/cubit/states.dart';
import 'package:stguard/models/canteen_details_model.dart';
import 'package:stguard/models/canteen_model.dart';
import 'package:stguard/models/canteen_product_model.dart';
import 'package:stguard/models/country_model.dart';
import 'package:stguard/models/parent_model.dart';
import 'package:stguard/models/school_model.dart';
import 'package:stguard/models/student_model.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/components/constants.dart';
import 'package:stguard/shared/network/local/cache_helper.dart';
import 'package:stguard/shared/network/remote/notification_helper.dart';

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
  bool canteenPathLoading = true;
  Future<void> getCanteenPath() async {
    canteenPathLoading = true;
    schoolCanteenPath = null;
    emit(GetCanteenPathLoadingState());
    await db
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
        await getCanteenDetails();
        await getTrans();
        canteenPathLoading = false;
      } else {
        emit(NeedtoJoinCommunityState());
        canteenPathLoading = false;
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetCanteenPathErrorState());
      canteenPathLoading = false;
    });
  }

  Future<void> resetId() async {
    await db
        .collection('Canteen Workers')
        .doc(userID)
        .collection('Community')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs[0].reference.delete().then((value) async {
          emit(ResetIDSuccessState());
          await getCanteenPath();
        }).catchError((error) {
          print(error.toString());
          emit(ResetIDErrorState());
        });
      }
    });
  }

  void addCanteen(String id) {
    emit(AddCanteenLoadingState());
    db
        .collection('Countries')
        .doc(pickedCountry!.id)
        .collection('Schools')
        .doc(pickedSchool!.id)
        .collection('SchoolStaff')
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty && value.docs[0]['role'] == 'canteen worker') {
        db
            .collection('Canteen Workers')
            .doc(userID)
            .collection('Community')
            .doc(id)
            .set({
          'uid': value.docs[0].id,
          'country': pickedCountry!.id,
          'school': pickedSchool!.id
        }).then((value) async {
          emit(AddCanteenSucessState());
          await getCanteenPath();
        }).catchError((error) {
          print(error.toString());
          emit(AddCanteenErrorState(error.toString()));
        });
      }
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

  Future<void> getProducts(
      {String category = 'All', String search = ""}) async {
    emit(GetProductsLoadingState());
    products = {};
    if (schoolCanteenPath != null) {
      if (category == 'All') {
        categories.forEach((category) async {
          await getProductbyCategory(category, search);
        });
      } else {
        await getProductbyCategory(category, search);
      }
    }
  }

  Future<void> getProductbyCategory(String category, String search) async {
    await schoolCanteenPath!.collection('Canteen').get().then((value) async {
      await schoolCanteenPath!
          .collection('Canteen')
          .doc(value.docs[0].id)
          .collection('categories')
          .doc(category)
          .collection('Products')
          .get()
          .then((value) {
        value.docs.forEach(
          (product) {
            if (search.isNotEmpty) {
              if (product['name']
                  .toLowerCase()
                  .contains(search.toLowerCase())) {
                products[product.id] =
                    CanteenProductModel.fromMap(product.data(), category);
              }
            } else {
              products[product.id] =
                  CanteenProductModel.fromMap(product.data(), category);
            }
          },
        );

        emit(GetProductsSuccessState());
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

  double totalPrice = 0;
  double totalCalories = 0.0;

  int itemsCount = 0;
  void calTotalPriceAndCalories() {
    totalPrice = 0;
    itemsCount = 0;
    totalCalories = 0.0;
    selectedProducts.forEach((id, p) {
      totalPrice += p.price * itemQuantities[id]!;
      totalCalories += p.calories * itemQuantities[id]!;

      itemsCount += itemQuantities[id]!;
    });
    print(totalPrice);
    print(totalCalories);
    emit(CalculateTotalPriceAndCaloriesState());
  }

  void addQuantity(String id) {
    itemQuantities[id] = itemQuantities[id]! + 1;
    calTotalPriceAndCalories();
  }

  void removeQuantity(String id) {
    if (itemQuantities[id]! > 1) {
      itemQuantities[id] = itemQuantities[id]! - 1;
      calTotalPriceAndCalories();
    }
  }

  void cancelSelectedProducts() {
    selectedProducts = {};
    itemQuantities = {};
    bottomSheetShown = false;
    emit(CancelSelectedProductState());
  }

  bool bottomSheetShown = false;
  void showBottomSheet(bool sheetState) {
    bottomSheetShown = sheetState;
    emit(ShowBottomSheetState());
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
      required double calories,
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
            calories: calories,
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
  Future<void> checkAllergens(
      {required String name,
      required double price,
      required String category,
      required double calories}) async {
    List<String> itemAllergies = [];
    print(allergies);
    ingredients.forEach((ingredient) {
      allergies.forEach((allergy, allergens) {
        for (String allergen in allergens) {
          if (allergen.toLowerCase().contains(ingredient.toLowerCase()) ||
              ingredient.toLowerCase().contains(allergen.toLowerCase())) {
            print(allergy);
            if (!itemAllergies.contains(allergy)) {
              itemAllergies.add(allergy);
            }
            break;
          }
        }
      });
    });
    print(itemAllergies);
    await uploadItemImage(
        name: name,
        price: price,
        category: category,
        calories: calories,
        itemAllergies: itemAllergies);
  }

  Map<String, List<dynamic>> allergies = {};
  List<String> allergens = [];
  void getAllergies() async {
    allergies = {};
    allergens = [];
    emit(GetAllergiesLoadingState());
    await db.collection('Allergies').get().then((value) {
      value.docs.forEach((allergy) {
        print(allergy);
        allergies[allergy['name']] = allergy['allergens'];
        allergy['allergens'].forEach((allergen) {
          allergens.add(allergen);
        });
      });
      emit(GetAllergiesSuccessState());
      print(allergies);
      print(allergens);
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
      required double calories,
      required String image,
      required List<String> itemAllergies}) async {
    emit(UploadItemDataLoadingState());
    await schoolCanteenPath!
        .collection('Canteen')
        .get()
        .then((canteenData) async {
      if (!categories.contains(category)) {
        await db.runTransaction((transaction) async {
          transaction.set(
              canteenData.docs[0].reference
                  .collection('categories')
                  .doc(category),
              {
                'name': category
              }).set(
              canteenData.docs[0].reference
                  .collection('categories')
                  .doc(category)
                  .collection('Products')
                  .doc(),
              {
                'name': name,
                'price': price,
                'ingredients': ingredients,
                'calories': calories,
                'image': image,
                'allergies': itemAllergies
              });
        }).then((value) async {
          itemImage = null;
          itemAllergies = [];
          ingredients = [];
          await getProducts();
          await getCategories();
          emit(UploadItemDataSuccessState());
        }).catchError((error) {
          emit(UploadItemDataErrorState());
        });
      } else {
        await schoolCanteenPath!
            .collection('Canteen')
            .doc(canteenData.docs[0].id)
            .collection('categories')
            .doc(category)
            .collection('Products')
            .doc()
            .set({
          'name': name,
          'price': price,
          'calories': calories,
          'ingredients': ingredients,
          'image': image,
          'allergies': itemAllergies
        }).then((value) async {
          emit(UploadItemDataSuccessState());
          itemImage = null;
          itemAllergies = [];
          ingredients = [];
          await getProducts();
        }).catchError((error) {
          emit(UploadItemDataErrorState());
        });
      }
    }).catchError((error) async {
      emit(UploadItemDataErrorState());
      await firebase_storage.FirebaseStorage.instanceFor(
              bucket: 'smartschool-6aee1.appspot.com')
          .refFromURL(image)
          .delete()
          .catchError((error) {
        print(error.toString());
      });
      print(error.toString());
    });
  }

  void resetItemData() {
    ingredients = [];
    itemImage = null;
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? buyerListener;
  void listentoBuyer() {
    buyer = null;
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

  void cancelBuyerListener() {
    if (buyerListener != null) {
      buyerListener!.cancel();
    }
  }

  StudentModel? buyer;
  Future<void> getBuyerData(String? buyerID) async {
    emit(PaymentLoadingState());
    // info of interest: parent, spending limit, totday's spending, allergies
    if (buyerID != null) {
      await schoolCanteenPath!
          .collection('Students')
          .where('uid', isEqualTo: buyerID)
          .get()
          .then((value) async {
        print(value.docs[0].data());
        if (value.docs.isNotEmpty) {
          buyer = StudentModel.fromJson(value.docs[0].data());
          print('buyer');
          print(buyer);
          print(buyer!.dailySpending);
          if (buyer != null) {
            if (getDate(buyer!.dailySpending['updateTime'],
                    format: 'yyyy-MM-dd') !=
                getDate(DateTime.now(), format: 'yyyy-MM-dd')) {
              await value.docs[0].reference.update({
                'dailySpending': {'value': 0.0, 'updateTime': DateTime.now()}
              }).then(
                (value) async {
                  buyer!.resetDailySpending();
                },
              ).catchError((error) {
                cancelBuyerListener();
                cancelBuyer();
                emit(PaymentErrorState());
              });
            }
            if (getDate(buyer!.dailyCalorie['updateTime'],
                    format: 'yyyy-MM-dd') !=
                getDate(DateTime.now(), format: 'yyyy-MM-dd')) {
              await value.docs[0].reference.update({
                'dailyCalorie': {'value': 0.0, 'updateTime': DateTime.now()}
              }).then(
                (value) async {
                  buyer!.resetDailyCalorie();
                },
              ).catchError((error) {
                cancelBuyerListener();
                cancelBuyer();
                emit(PaymentErrorState());
              });
            }

            await analyzeBuyerData();
          } else {
            cancelBuyer();
            emit(PaymentErrorState());
          }
        } else {
          cancelBuyer();
          emit(PaymentErrorState());
        }
      }).catchError((error) {
        cancelBuyerListener();
        cancelBuyer();
        print('getBuyerData');
        print(error.toString());
        emit(PaymentErrorState());
      });
    }
  }

  String? result;
  Future<void> analyzeBuyerData() async {
    result = null;
    try {
      if (buyer!.parent == null) {
        print('ID is Deactivated');
        result = 'ID is Deactivated';
      } else if (totalPrice > buyer!.pocketMoney!) {
        print('Daily spending limit exceeded1');
        result = 'Daily spending limit exceeded';
      } else if (buyer!.dailySpending['value'] + totalPrice >
          buyer!.pocketMoney) {
        print('Daily spending limit exceeded');
        result = 'Daily spending limit exceeded';
      } else if (totalCalories > buyer!.calorieLimit) {
        result = 'Daily calorie limit exceeded';
        print('Daily calorie limit exceeded1');
      } else if (buyer!.dailyCalorie['value'] + totalCalories >
          buyer!.calorieLimit) {
        result = 'Daily calorie limit exceeded';
        print('Daily calorie limit exceeded2');
      } else if (buyer!.allergies != null) {
        print('One or more products contain allergens');
        print('checkallergies');
        bool hasAllergen = false;
        for (CanteenProductModel product in selectedProducts.values) {
          if (product.allergies != null) {
            for (String allergy in product.allergies!) {
              if (buyer!.allergies!.contains(allergy)) {
                result = 'One or more products contain allergens';
                hasAllergen = true;
                break;
              }
            }
          }
        }
      }
      if (result == null) {
        completePayment(buyer!.parent!);
      } else {
        cancelBuyerListener();
        cancelBuyer();
        emit(PaymentErrorState());
      }
    } catch (e) {
      cancelBuyerListener();
      cancelBuyer();
      emit(PaymentErrorState());
      print(e.toString());
    }
  }

  ParentModel? parent;
  WriteBatch batch = FirebaseFirestore.instance.batch();
  Future<void> completePayment(String parentID) async {
    batch = FirebaseFirestore.instance.batch();

    final parentDocRef = db.collection('Parents').doc(parentID);
    await parentDocRef.get().then((parentDoc) async {
      if (parentDoc.exists) {
        parent = ParentModel.fromJson(parentDoc.data()!);
        if (parent!.balance >= totalPrice) {
          batch.update(parentDocRef, {'balance': parent!.balance - totalPrice});
          await updateCanteenData();
          await setTransaction();
        } else {
          result = 'Not Enough Balance';
          cancelBuyerListener();
          cancelBuyer();
          emit(PaymentErrorState());
        }
      }
    }).catchError((error) {
      cancelBuyerListener();
      cancelBuyer();
      print('completePayment');
      print(error.toString());
      emit(PaymentErrorState());
    });
  }

  void cancelBuyer() async {
    await schoolCanteenPath!.collection('Canteen').get().then((canteen) async {
      if (canteen.docs.isNotEmpty) {
        await canteen.docs[0].reference.get().then((canteenData) async {
          if (canteenData.data() != null) {
            canteenData.reference.update({'CurrentBuyer': null});
          }
        });
      }
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
          cancelBuyerListener();
          cancelBuyer();
          print(error.toString());
          emit(PaymentErrorState());
        });
      } else {
        cancelBuyerListener();
        cancelBuyer();
        print('canteen is empty');
        emit(PaymentErrorState());
      }
    }).catchError((error) {
      cancelBuyerListener();
      cancelBuyer();
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
      'total_price': totalPrice,
      'buyer': {'name': buyer!.name, 'id': buyer!.id}
    };
  }

  Future<void> setTransaction() async {
    await schoolCanteenPath!
        .collection('Students')
        .where('uid', isEqualTo: buyer!.id)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        // update daily spending
        batch.update(value.docs[0].reference, {
          'dailySpending': {
            'value': value.docs[0].data().containsKey('dailySpending')
                ? totalPrice + value.docs[0].data()['dailySpending']['value']
                : totalPrice,
            'updateTime': DateTime.now()
          }
        });

        // update calorie
        batch.update(value.docs[0].reference, {
          'dailyCalorie': {
            'value': value.docs[0].data().containsKey('dailyCalorie')
                ? totalCalories + value.docs[0].data()['dailyCalorie']['value']
                : totalCalories,
            'updateTime': DateTime.now()
          }
        });

        batch.set(
            value.docs[0].reference.collection('CanteenTransactions').doc(),
            createTranscation());
        schoolCanteenPath!.collection('Canteen').get().then((value) async {
          if (value.docs.isNotEmpty) {
            batch.set(value.docs[0].reference.collection('Transactions').doc(),
                createTranscation());
            await batch.commit().then((value) async {
              cancelBuyerListener();
              cancelBuyer();
              emit(PaymentSuccessState());

              print('device token');
              print(parent!.deviceToken);
              if (parent!.deviceToken != null) {
                NotificationHelper.sendNotification(
                        title: '${buyer!.name!.split(' ')[0]} Purchased',
                        body:
                            '-$totalPrice',
                        receiverToken: parent!.deviceToken!)
                    .then((value) {
                  print(value.body);
                }).catchError((error) {
                  print(error.toString());
                });
              }
            }).catchError((error) {
              cancelBuyerListener();
              cancelBuyer();
              print('batch commit error');
              print(error.toString());
              emit(PaymentErrorState());
            });
          } else {
            cancelBuyerListener();
            cancelBuyer();
            emit(PaymentErrorState());
          }
        }).catchError((error) {
          cancelBuyerListener();
          cancelBuyer();
          emit(PaymentErrorState());
        });
      } else {
        cancelBuyerListener();
        cancelBuyer();
        emit(PaymentErrorState());
      }
    }).catchError((error) {
      cancelBuyerListener();
      cancelBuyer();
      print('setTransaction');
      print(error.toString());
      emit(PaymentErrorState());
    });
  }

  CanteenDetailsModel? canteenDetails;
  Future<void> getCanteenDetails() async {
    emit(GetCanteenDetailsLoadingState());
    await schoolCanteenPath!.collection('Canteen').get().then((canteen) async {
      if (canteen.docs.isNotEmpty) {
        await canteen.docs[0].reference.get().then((canteenData) async {
          if (canteenData.exists) {
            canteenDetails = CanteenDetailsModel.fromJson(canteenData.data());
            if (canteenDetails!.updateTime != null) {
              print(getDate(canteenDetails!.updateTime, format: 'yyyy-MM-dd'));
              print(getDate(DateTime.now(), format: 'yyyy-MM-dd'));
              if (getDate(canteenDetails!.updateTime, format: 'yyyy-MM-dd') !=
                  getDate(DateTime.now(), format: 'yyyy-MM-dd')) {
                await canteenData.reference.update({
                  'daily revenue': 0,
                  'daily transactions': 0,
                  'updateTime': DateTime.now()
                }).then((value) {
                  emit(GetCanteenDetailsSuccessState());
                  canteenDetails = null;
                }).catchError((error) {
                  emit(GetCanteenDetailsErrorState());
                  print(error.toString());
                });
              } else {
                emit(GetCanteenDetailsSuccessState());
              }
            }
          }
        }).catchError((error) {
          emit(GetCanteenDetailsErrorState());
          print(error.toString());
        });
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetCanteenDetailsErrorState());
    });
  }

  void updatePrice(
      {required String id,
      required String category,
      required double newPrice}) async {
    emit(UpdatePriceLoadingState());
    await schoolCanteenPath!.collection('Canteen').get().then((canteenData) {
      canteenData.docs[0].reference
          .collection('categories')
          .doc(category)
          .collection('Products')
          .doc(id)
          .update({'price': newPrice}).then((value) {
        emit(UpdatePriceSuccessState());
        getProducts();
      }).catchError((error) {
        emit(UpdatePriceErrorState());
      });
    }).catchError((error) {
      emit(UpdatePriceErrorState());
    });
  }

  void deleteItem(
      {required String id,
      required String category,
      required String image}) async {
    batch = FirebaseFirestore.instance.batch();
    emit(DeleteItemLoadingState());
    await schoolCanteenPath!.collection('Canteen').get().then((canteenData) {
      canteenData.docs[0].reference
          .collection('categories')
          .doc(category)
          .collection('Products')
          .doc(id)
          .delete()
          .then((value) async {
        emit(DeleteItemSuccessState());
        try {
          await firebase_storage.FirebaseStorage.instanceFor(
                  bucket: 'smartschool-6aee1.appspot.com')
              .refFromURL(image)
              .delete()
              .catchError((error) {
            print(error.toString());
          });
        } on FirebaseException catch (e) {
          // Handle the Firebase exception
          print('Firebase error: $e');
        } catch (e) {
          // Handle other exceptions
          print('Error: $e');
        }

        getProducts();
      }).catchError((error) {
        emit(DeleteItemErrorState());
      });
    }).catchError((error) {
      emit(DeleteItemErrorState());
    });
  }

  void deleteCategory(String category) async {
    emit(DeleteCategoryLoadingState());

    await schoolCanteenPath!.collection('Canteen').get().then((canteenData) {
      canteenData.docs[0].reference
          .collection('categories')
          .doc(category)
          .delete()
          .then((value) async {
        emit(DeleteCategorySuccessState());
        await getCategories();
      }).catchError((error) {
        emit(DeleteCategoryErrorState());
        print(error.toString());
      });
    });
  }

  void signOut() {
    CacheHelper.removeData(key: 'id').then((value) {
      CacheHelper.removeData(key: 'role');
      userID = null;
      userRole = null;
      canteen = null;
      canteenDetails = null;
      schoolCanteenPath = null;
      emit(UserSignOutSuccessState());
    });
  }

  List<TransactionModel>? transactions;
  DateTime getTransBy = DateTime.now();
  Future<void> setTransDate({required DateTime? date}) async {
    if (date != null) {
      getTransBy = date;
      emit(SetTransDateState());
      await getTrans();
    }
  }

  bool getTransLoading = false;
  Future<void> getTrans() async {
    try {
      getTransLoading = true;
      emit(GetCanteenTransLoadingState());
      transactions = [];
      await schoolCanteenPath!.collection('Canteen').get().then((value) async {
        await value.docs[0].reference
            .collection('Transactions')
            .where('date',
                isGreaterThanOrEqualTo:
                    DateTime(getTransBy.year, getTransBy.month, getTransBy.day))
            .where('date',
                isLessThan: DateTime(
                    getTransBy.year, getTransBy.month, getTransBy.day + 1))
            .orderBy('date', descending: true)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            transactions!.add(TransactionModel.fromMap(element.data()));
          });
          emit(GetCanteenTransSuccessState());
          print(transactions);
        }).catchError((error) {
          print(error.toString());
          emit(GetCanteenTransErrorState());
        });
      }).catchError((error) {
        print(error.toString());
        emit(GetCanteenTransErrorState());
      });
      getTransLoading = false;
    } catch (e) {
      print(e.toString());
      getTransLoading = false;
      emit(GetCanteenTransErrorState());
    }
  }
}
