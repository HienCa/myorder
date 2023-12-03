// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/food.dart' as model;
import 'package:myorder/models/food_combo.dart';
import 'package:myorder/models/food_order.dart';
import 'package:myorder/utils.dart';

class FoodController extends GetxController {
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Upload image', 'Bạn đã tải lên image thành công!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  void pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      Get.snackbar('Upload image', 'Bạn đã tải lên image thành công!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
    Reference ref = firebaseStorage.ref().child('profilePics/$fileName');

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  getFoodById(String foodId) async {
    try {
      DocumentSnapshot Food =
          await firestore.collection('foods').doc(foodId).get();
      if (Food.exists) {
        final foodData = Food.data();
        if (foodData != null && foodData is Map<String, dynamic>) {
          String food_id = foodData['food_id'] ?? "";
          String name = foodData['name'] ?? "";
          String image = foodData['image'] ?? "";
          double price = foodData['price'] ?? 0;
          double price_with_temporary = foodData['price_with_temporary'] ?? 0;
          print(price_with_temporary);
          print(foodData['price_with_temporary']);
          Timestamp temporary_price_from_date =
              foodData['temporary_price_from_date'];
          Timestamp temporary_price_to_date =
              foodData['temporary_price_to_date'];
          // double temporary_price = foodData['temporary_price'] ?? 0;
          // double temporary_percent = foodData['temporary_percent'] ?? 0;
          String category_id = foodData['category_id'] ?? "";
          int category_code = foodData['category_code'] ?? CATEGORY_FOOD;
          String unit_id = foodData['unit_id'] ?? "";
          String vat_id = foodData['vat_id'] ?? "";
          int temporary_percent = foodData['temporary_percent'];
          int active = foodData['active'];
          List<String> food_combo_ids = foodData['food_combo_ids'] ?? [];
          List<String> addition_food_ids = foodData['addition_food_ids'] ?? [];
          // Lấy thông tin món combo
          List<model.Food> listFoodComboDetail = [];
          for (String item in food_combo_ids) {
            var foodSnapshot =
                await firestore.collection("orders").doc(item).get();

            if (!foodSnapshot.exists) {
              Get.snackbar(
                'Không tìm thấy!',
                'Không tìm thấy thông tin food.',
                backgroundColor: backgroundFailureColor,
                colorText: Colors.white,
              );
              return;
            }

            model.Food food = model.Food.fromSnap(foodSnapshot);
            listFoodComboDetail.add(food);
          }

          // Lấy thông tin món bán kèm
          List<model.Food> listAdditionFoodDetail = [];
          for (String item in addition_food_ids) {
            var foodSnapshot =
                await firestore.collection("orders").doc(item).get();

            if (!foodSnapshot.exists) {
              Get.snackbar(
                'Không tìm thấy!',
                'Không tìm thấy thông tin food.',
                backgroundColor: backgroundFailureColor,
                colorText: Colors.white,
              );
              return;
            }

            model.Food food = model.Food.fromSnap(foodSnapshot);
            listAdditionFoodDetail.add(food);
          }

          return model.Food(
            food_id: food_id,
            name: name,
            image: image,
            price: price,
            price_with_temporary: price_with_temporary,
            temporary_price_from_date: temporary_price_from_date,
            temporary_price_to_date: temporary_price_to_date,
            // temporary_price: temporary_price,
            // temporary_percent: temporary_percent,
            category_id: category_id,
            unit_id: unit_id,
            vat_id: vat_id,
            temporary_percent: temporary_percent,
            active: active, category_code: category_code,
            food_combo_ids: food_combo_ids,
            food_combo_details: listFoodComboDetail,
            addition_food_ids: addition_food_ids,
            addition_food_details: listAdditionFoodDetail,
            max_order_limit: 0,
            current_order_count: 0,
            quanity_start_date_time: null,
            quanity_end_date_time: null,
            is_addition_food: DEACTIVE,
          );
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  final Rx<List<model.Food>> _foods = Rx<List<model.Food>>([]);
  List<model.Food> get foods => _foods.value;
  getfoods(String keySearch, int isAdditionFood) async {
    if (keySearch.isEmpty) {
      _foods.bindStream(
        firestore
            .collection('foods')
            .where('is_addition_food', isEqualTo: isAdditionFood)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<model.Food> retValue = [];
            for (var element in query.docs) {
              model.Food food = model.Food.fromSnap(element);

              List<model.Food> listFoodComboDetail = [];
              if (food.food_combo_ids.isNotEmpty) {
                // Lấy thông tin món combo
                print("===============COMBO CỦA ${food.name}===========");

                for (String item in food.food_combo_ids) {
                  var foodSnapshot =
                      await firestore.collection("foods").doc(item).get();

                  model.Food food = model.Food.fromSnap(foodSnapshot);

                  print(food.name);
                  listFoodComboDetail.add(food);
                }
              }

              food.food_combo_details = listFoodComboDetail;
              retValue.add(food);
            }
            return retValue;
          },
        ),
      );
    } else {
      _foods.bindStream(firestore
          .collection('foods')
          .orderBy('name')
          .where('is_addition_food', isEqualTo: isAdditionFood)
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<model.Food> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            model.Food food = model.Food.fromSnap(elem);

            List<model.Food> listFoodComboDetail = [];
            if (food.food_combo_ids.isNotEmpty) {
              // Lấy thông tin món combo
              print("===============COMBO CỦA ${food.name}===========");

              for (String item in food.food_combo_ids) {
                var foodSnapshot =
                    await firestore.collection("foods").doc(item).get();

                model.Food food = model.Food.fromSnap(foodSnapshot);

                print(food.name);
                listFoodComboDetail.add(food);
              }
            }

            food.food_combo_details = listFoodComboDetail;
            retVal.add(food);
          }
        }
        return retVal;
      }));
    }
  }

  final Rx<List<model.Food>> _foodAll = Rx<List<model.Food>>([]);
  List<model.Food> get foodAll => _foodAll.value;
  getAllFood(String keySearch) async {
    if (keySearch.isEmpty) {
      _foodAll.bindStream(
        firestore.collection('foods').snapshots().asyncMap(
          (QuerySnapshot query) async {
            List<model.Food> retValue = [];
            for (var element in query.docs) {
              model.Food food = model.Food.fromSnap(element);

              List<model.Food> listFoodComboDetail = [];
              if (food.food_combo_ids.isNotEmpty) {
                // Lấy thông tin món combo
                print("===============COMBO CỦA ${food.name}===========");

                for (String item in food.food_combo_ids) {
                  var foodSnapshot =
                      await firestore.collection("foods").doc(item).get();

                  model.Food food = model.Food.fromSnap(foodSnapshot);

                  print(food.name);
                  listFoodComboDetail.add(food);
                }
              }

              food.food_combo_details = listFoodComboDetail;
              retValue.add(food);
            }
            return retValue;
          },
        ),
      );
    } else {
      _foodAll.bindStream(firestore
          .collection('foods')
          .orderBy('name')
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<model.Food> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            model.Food food = model.Food.fromSnap(elem);

            List<model.Food> listFoodComboDetail = [];
            if (food.food_combo_ids.isNotEmpty) {
              // Lấy thông tin món combo
              print("===============COMBO CỦA ${food.name}===========");

              for (String item in food.food_combo_ids) {
                var foodSnapshot =
                    await firestore.collection("foods").doc(item).get();

                model.Food food = model.Food.fromSnap(foodSnapshot);

                print(food.name);
                listFoodComboDetail.add(food);
              }
            }

            food.food_combo_details = listFoodComboDetail;
            retVal.add(food);
          }
        }
        return retVal;
      }));
    }
  }

  final Rx<List<FoodCombo>> _foodCombos = Rx<List<FoodCombo>>([]);
  List<FoodCombo> get foodCombos => _foodCombos.value;

  getFoodCombos(String keySearch) async {
    if (keySearch.isEmpty) {
      _foodCombos.bindStream(
        firestore.collection('foodCombos').snapshots().map(
          (QuerySnapshot query) {
            List<FoodCombo> retValue = [];
            for (var element in query.docs) {
              if (element.exists) {
                retValue.add(FoodCombo.fromSnap(element));
                print(element);
              }
            }
            // if (retValue.isNotEmpty) {
            //   for (var item in retValue[0].listFood) {
            //     print(item.name);
            //     print(item.price);
            //     print(item.food_id);
            //     print(item.unit_id);
            //     print(item.category_code);
            //     print(item.category_id);
            //   }
            // }
            return retValue;
          },
        ),
      );
    } else {
      _foodCombos.bindStream(
        firestore
            .collection('foodCombos')
            .orderBy('name')
            .snapshots()
            .map((QuerySnapshot query) {
          List<FoodCombo> retVal = [];
          for (var elem in query.docs) {
            if (elem.exists) {
              String name = elem['name'].toLowerCase();
              String search = keySearch.toLowerCase().trim();
              if (name.contains(search)) {
                retVal.add(FoodCombo.fromSnap(elem));
              }
            }
          }
          return retVal;
        }),
      );
    }
  }

  //goi mon
  final Rx<List<FoodOrder>> _foodsToOrder = Rx<List<FoodOrder>>([]);
  List<FoodOrder> get foodsToOrder => _foodsToOrder.value;
  getfoodsToOrder(String keySearch, String categoryIdSelected) async {
    if (keySearch.isEmpty && categoryIdSelected == defaultCategory) {
      //lấy tất cả mon an
      print("lấy tất cả");

      _foodsToOrder.bindStream(
        firestore
            .collection('foods')
            .where("active", isEqualTo: ACTIVE)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<FoodOrder> retValue = [];
            for (var element in query.docs) {
              FoodOrder food = FoodOrder.fromSnap(element);
              print("food.max_order_limit");
              print(food.max_order_limit);
              print(food.current_order_count);


              food.isSelected = false;
              food.quantity = 1;

              // Lấy thông tin món combo
              List<model.Food> listFoodComboDetail = [];
              if (food.food_combo_ids.isNotEmpty) {
                print("===============COMBO CỦA ${food.name}===========");

                for (String item in food.food_combo_ids) {
                  var foodSnapshot =
                      await firestore.collection("foods").doc(item).get();

                  model.Food food = model.Food.fromSnap(foodSnapshot);

                  print(food.name);
                  listFoodComboDetail.add(food);
                }
              }
              food.food_combo_details = listFoodComboDetail;

              // Lấy thông tin món bán kèm
              List<FoodOrder> listAdditionFoodDetail = [];
              if (food.addition_food_ids.isNotEmpty) {
                print("===============MÓN BÁN KÈM CỦA ${food.name}===========");

                for (String item in food.addition_food_ids) {
                  var foodSnapshot =
                      await firestore.collection("foods").doc(item).get();

                  FoodOrder additionFood = FoodOrder.fromSnap(foodSnapshot);
                  additionFood.isSelected = false;
                  additionFood.quantity = 1;

                  print(additionFood.name);
                  listAdditionFoodDetail.add(additionFood);
                }
              }

              food.addition_food_details = listAdditionFoodDetail;

              retValue.add(food);
            }
            Utils.showDataJson(query);
            return retValue;
          },
        ),
      );
    } else if (categoryIdSelected.isNotEmpty && keySearch.isEmpty) {
      // chỉ theo danh muc - không search
      print("chỉ theo danh muc - không search");

      _foodsToOrder.bindStream(
        firestore
            .collection('foods')
            .where('category_id', isEqualTo: categoryIdSelected)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<FoodOrder> retValue = [];
            for (var element in query.docs) {
              FoodOrder food = FoodOrder.fromSnap(element);
              food.isSelected = false;
              food.quantity = 1;

              // Lấy thông tin món combo
              List<model.Food> listFoodComboDetail = [];
              if (food.food_combo_ids.isNotEmpty) {
                print("===============COMBO CỦA ${food.name}===========");

                for (String item in food.food_combo_ids) {
                  var foodSnapshot =
                      await firestore.collection("foods").doc(item).get();

                  model.Food food = model.Food.fromSnap(foodSnapshot);

                  print(food.name);
                  listFoodComboDetail.add(food);
                }
              }

              food.food_combo_details = listFoodComboDetail;

              // Lấy thông tin món bán kèm
              List<FoodOrder> listAdditionFoodDetail = [];
              if (food.addition_food_ids.isNotEmpty) {
                print("===============MÓN BÁN KÈM CỦA ${food.name}===========");

                for (String item in food.addition_food_ids) {
                  var foodSnapshot =
                      await firestore.collection("foods").doc(item).get();

                  FoodOrder additionFood = FoodOrder.fromSnap(foodSnapshot);
                  additionFood.isSelected = false;
                  additionFood.quantity = 1;

                  print(additionFood.name);
                  listAdditionFoodDetail.add(additionFood);
                }
              }

              food.addition_food_details = listAdditionFoodDetail;
              retValue.add(food);
            }
            Utils.showDataJson(query);

            return retValue;
          },
        ),
      );
    } else if (categoryIdSelected.isNotEmpty &&
        categoryIdSelected != defaultCategory &&
        keySearch.isNotEmpty) {
      // theo danh muc và có search
      print("theo danh muc và có search");

      _foodsToOrder.bindStream(firestore
          .collection('foods')
          .where('category_id', isEqualTo: categoryIdSelected)
          .orderBy('name')
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<FoodOrder> retValue = [];
        for (var element in query.docs) {
          FoodOrder food = FoodOrder.fromSnap(element);
          food.isSelected = false;
          food.quantity = 1;
          String name = element['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            List<model.Food> listFoodComboDetail = [];
            if (food.food_combo_ids.isNotEmpty) {
              // Lấy thông tin món combo
              print("===============COMBO CỦA ${food.name}===========");

              for (String item in food.food_combo_ids) {
                var foodSnapshot =
                    await firestore.collection("foods").doc(item).get();

                model.Food food = model.Food.fromSnap(foodSnapshot);

                print(food.name);
                listFoodComboDetail.add(food);
              }
            }

            food.food_combo_details = listFoodComboDetail;
            retValue.add(food);
          }
        }
        Utils.showDataJson(query);

        return retValue;
      }));
    } else if (categoryIdSelected == defaultCategory && keySearch.isNotEmpty) {
      //tìm kiếm theo danh muc
      print("tìm kiếm theo danh muc");
      _foodsToOrder.bindStream(firestore
          .collection('foods')
          .where("active", isEqualTo: ACTIVE)
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<FoodOrder> retValue = [];
        for (var element in query.docs) {
          FoodOrder food = FoodOrder.fromSnap(element);
          food.isSelected = false;
          food.quantity = 1;
          String name = element['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            List<model.Food> listFoodComboDetail = [];
            if (food.food_combo_ids.isNotEmpty) {
              // Lấy thông tin món combo
              print("===============COMBO CỦA ${food.name}===========");

              for (String item in food.food_combo_ids) {
                var foodSnapshot =
                    await firestore.collection("foods").doc(item).get();

                model.Food food = model.Food.fromSnap(foodSnapshot);

                print(food.name);
                listFoodComboDetail.add(food);
              }
            }

            food.food_combo_details = listFoodComboDetail;
            retValue.add(food);
          }
        }
        Utils.showDataJson(query);
        return retValue;
      }));
    }
  }

  getfoodsToOrderCategoryCode(String keySearch, int categoryIdCode) async {
    if (keySearch.isEmpty) {
      //lấy tất cả mon an
      print("lấy tất cả");

      _foodsToOrder.bindStream(
        firestore
            .collection('foods')
            .where("active", isEqualTo: ACTIVE)
            .where("category_code", isEqualTo: categoryIdCode)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<FoodOrder> retValue = [];
            for (var element in query.docs) {
              FoodOrder food = FoodOrder.fromSnap(element);
              print(food.temporary_price_from_date);
              print(food.temporary_price_to_date);
              print("category_code: ${food.category_code}");

              food.isSelected = false;
              food.quantity = 1;

              // Lấy thông tin món combo
              List<model.Food> listFoodComboDetail = [];
              if (food.food_combo_ids.isNotEmpty) {
                print("===============COMBO CỦA ${food.name}===========");

                for (String item in food.food_combo_ids) {
                  var foodSnapshot =
                      await firestore.collection("foods").doc(item).get();

                  model.Food food = model.Food.fromSnap(foodSnapshot);

                  print(food.name);
                  listFoodComboDetail.add(food);
                }
              }
              food.food_combo_details = listFoodComboDetail;

              // Lấy thông tin món bán kèm
              List<FoodOrder> listAdditionFoodDetail = [];
              if (food.addition_food_ids.isNotEmpty) {
                print("===============MÓN BÁN KÈM CỦA ${food.name}===========");

                for (String item in food.addition_food_ids) {
                  var foodSnapshot =
                      await firestore.collection("foods").doc(item).get();

                  FoodOrder additionFood = FoodOrder.fromSnap(foodSnapshot);
                  additionFood.isSelected = false;
                  additionFood.quantity = 1;

                  print(additionFood.name);
                  listAdditionFoodDetail.add(additionFood);
                }
              }

              food.addition_food_details = listAdditionFoodDetail;

              retValue.add(food);
            }
            Utils.showDataJson(query);
            return retValue;
          },
        ),
      );
    } else if (keySearch.isNotEmpty) {
      //tìm kiếm theo danh muc
      print("tìm kiếm theo danh muc");
      _foodsToOrder.bindStream(firestore
          .collection('foods')
          .where("active", isEqualTo: ACTIVE)
          .where("category_code", isEqualTo: categoryIdCode)
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<FoodOrder> retValue = [];
        for (var element in query.docs) {
          FoodOrder food = FoodOrder.fromSnap(element);
          food.isSelected = false;
          food.quantity = 1;
          String name = element['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            List<model.Food> listFoodComboDetail = [];
            if (food.food_combo_ids.isNotEmpty) {
              // Lấy thông tin món combo
              print("===============COMBO CỦA ${food.name}===========");

              for (String item in food.food_combo_ids) {
                var foodSnapshot =
                    await firestore.collection("foods").doc(item).get();

                model.Food food = model.Food.fromSnap(foodSnapshot);

                print(food.name);
                listFoodComboDetail.add(food);
              }
            }

            food.food_combo_details = listFoodComboDetail;
            retValue.add(food);
          }
        }
        Utils.showDataJson(query);
        return retValue;
      }));
    }
  }

  void createFood(
      String name,
      File? image,
      String price,
      String? price_with_temporary,
      DateTime? temporary_price_from_date,
      DateTime? temporary_price_to_date,
      String category_id,
      String unit_id,
      String? vat_id,
      int temporary_percent,
      int category_code,
      List<String> food_combo_ids,
      List<String> addition_food_ids) async {
    try {
      if (name.isNotEmpty && category_id.isNotEmpty && unit_id.isNotEmpty) {
        String downloadUrl = "";
        if (image != null) {
          downloadUrl = await _uploadToStorage(image);
        }

        String id = Utils.generateUUID();
        if (price_with_temporary != "") {
          model.Food Food = model.Food(
              food_id: id,
              name: name,
              image: downloadUrl,
              price: double.tryParse(price) ?? 0.0,
              price_with_temporary:
                  double.tryParse(price_with_temporary!) ?? 0.0,
              temporary_price_from_date:
                  Timestamp.fromDate(temporary_price_from_date!),
              temporary_price_to_date:
                  Timestamp.fromDate(temporary_price_to_date!),
              category_id: category_id,
              unit_id: unit_id,
              vat_id: vat_id,
              temporary_percent: temporary_percent,
              active: 1,
              category_code: category_code,
              food_combo_ids: food_combo_ids,
              food_combo_details: [],
              addition_food_ids: addition_food_ids,
              addition_food_details: [],
              max_order_limit: 0,
              current_order_count: 0,
              quanity_start_date_time: null,
              quanity_end_date_time: null,
              is_addition_food: DEACTIVE);
          CollectionReference foodsCollection =
              FirebaseFirestore.instance.collection('foods');

          await foodsCollection.doc(id).set(Food.toJson());
        } else {
          model.Food Food = model.Food(
              food_id: id,
              name: name,
              image: downloadUrl,
              price: double.tryParse(price) ?? 0.0,
              price_with_temporary:
                  double.tryParse(price_with_temporary!) ?? 0.0,
              temporary_price_from_date: null,
              temporary_price_to_date: null,
              category_id: category_id,
              unit_id: unit_id,
              vat_id: vat_id,
              temporary_percent: temporary_percent,
              active: 1,
              category_code: category_code,
              food_combo_ids: food_combo_ids,
              food_combo_details: [],
              addition_food_ids: addition_food_ids,
              addition_food_details: [],
              max_order_limit: 0,
              current_order_count: 0,
              quanity_start_date_time: null,
              quanity_end_date_time: null,
              is_addition_food: DEACTIVE);
          CollectionReference foodsCollection =
              FirebaseFirestore.instance.collection('foods');

          await foodsCollection.doc(id).set(Food.toJson());
        }

        // Get.snackbar(
        //   'THÀNH CÔNG!',
        //   'Thêm món mới thành công!',
        //   backgroundColor: backgroundSuccessColor,
        //   colorText: Colors.white,
        // );
      } else {
        Get.snackbar(
          'Error!',
          'Thêm món thất bại!',
          backgroundColor: backgroundFailureColor,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error!',
        e.message ?? 'Có lỗi xãy ra.',
      );
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    }
  }

  void createFoodHasCombo(
      String name,
      File? image,
      String price,
      String? price_with_temporary,
      DateTime? temporary_price_from_date,
      DateTime? temporary_price_to_date,
      String category_id,
      String unit_id,
      String? vat_id,
      int temporary_percent,
      int category_code,
      List<FoodCombo> listCombo) async {
    try {
      if (name.isNotEmpty && category_id.isNotEmpty && unit_id.isNotEmpty) {
        for (FoodCombo item in listCombo) {
          print("Combo item: ${item.name}");
        }

        String downloadUrl = "";
        if (image != null) {
          downloadUrl = await _uploadToStorage(image);
        }

        String id = Utils.generateUUID();
        if (price_with_temporary != "") {
          print("MÓN ĂN CÓ GIÁ THỜI VỤ");

          FoodCombo food = FoodCombo(
            food_id: id,
            name: name,
            image: downloadUrl,
            price: double.tryParse(price) ?? 0.0,
            price_with_temporary:
                double.tryParse((price_with_temporary ?? '0')),
            temporary_price_from_date:
                Timestamp.fromDate(temporary_price_from_date!),
            temporary_price_to_date:
                Timestamp.fromDate(temporary_price_to_date!),
            category_id: category_id,
            unit_id: unit_id,
            vat_id: vat_id,
            temporary_percent: temporary_percent,
            active: 1,
            category_code: category_code,
            listFood: listCombo,
          );
          CollectionReference foodsCollection =
              FirebaseFirestore.instance.collection('foodCombos');

          await foodsCollection.doc(id).set(food.toJson());
        } else {
          print("MÓN ĂN KHÔNG CÓ GIÁ THỜI VỤ");

          FoodCombo food = FoodCombo(
            food_id: id,
            name: name,
            image: downloadUrl,
            price: double.tryParse(price) ?? 0.0,
            price_with_temporary:
                double.tryParse((price_with_temporary ?? '0')),
            // temporary_price_from_date:
            //     Timestamp.fromDate(temporary_price_from_date!),
            // temporary_price_to_date:
            //     Timestamp.fromDate(temporary_price_to_date!),
            category_id: category_id,
            unit_id: unit_id,
            vat_id: vat_id,
            temporary_percent: temporary_percent,
            active: 1,
            category_code: category_code,
            listFood: listCombo,
          );
          CollectionReference foodsCollection =
              FirebaseFirestore.instance.collection('foodCombos');

          await foodsCollection.doc(id).set(food.toJson());
        }
      } else {
        Get.snackbar(
          'Error!',
          'Thêm món thất bại!',
          backgroundColor: backgroundFailureColor,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error!',
        e.message ?? 'Có lỗi xãy ra.',
      );
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    }
  }

  updateFood(
      String food_id,
      String name,
      String? image,
      File? newImage,
      String price,
      String? price_with_temporary,
      DateTime? temporary_price_from_date,
      DateTime? temporary_price_to_date,
      String category_id,
      int category_code,
      String unit_id,
      String vat_id,
      int temporary_percent,
      List<String> food_combo_ids,
      List<String> addition_food_ids) async {
    // var doc = await firestore.collection('foods').doc(Food_id).get();
    String downloadUrl = "";
    try {
      print("food_id $food_id");
      print("category_id $category_id");
      print("unit_id $unit_id");
      print("image $image");
      print("price $price");
      print("price_with_temporary $price_with_temporary");
      if (newImage != null) {
        print("Image Selected");

        // Xóa ảnh cũ nếu có
        // await _deleteOldProfilePhoto(doc);// nếu xóa thì dùng chung ảnh có thể mất hết

        // Tải ảnh mới lên Firebase Storage và nhận URL
        downloadUrl = await _uploadToStorage(newImage);
        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore.collection('foods').doc(food_id).update({
          "food_combo_ids": [],
          "addition_food_ids": [],
        }).then((value) async {
          await firestore.collection('foods').doc(food_id).update({
            "food_id": food_id.trim(),
            "name": name.trim(),
            "image": downloadUrl,
            "price": double.tryParse(price) ?? 0.0,
            "vat_id": vat_id.trim(),
            "price_with_temporary":
                double.tryParse(price_with_temporary!) ?? 0.0,
            "temporary_price_from_date": temporary_price_from_date,
            "temporary_price_to_date": temporary_price_to_date,
            "is_addition_food": DEACTIVE,

            // "active": active,
            "category_id": category_id.trim(),
            "category_code": category_code,
            "unit_id": unit_id.trim(),
            "temporary_percent": temporary_percent,
            "food_combo_ids": FieldValue.arrayUnion(food_combo_ids),
            "addition_food_ids": FieldValue.arrayUnion(addition_food_ids),
          });
        });
      } else {
        print("NO Image Selected");

        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore.collection('foods').doc(food_id).update({
          "food_combo_ids": [],
          "addition_food_ids": [],
        }).then((value) async {
          await firestore.collection('foods').doc(food_id).update({
            "food_id": food_id.trim(),
            "name": name.trim(),
            "image": image,
            "price": double.tryParse(price) ?? 0.0,
            "vat_id": vat_id.trim(),
            "price_with_temporary":
                double.tryParse(price_with_temporary!) ?? 0.0,
            "temporary_price_from_date": temporary_price_from_date,
            "temporary_price_to_date": temporary_price_to_date,
            "is_addition_food": DEACTIVE,

            // "active": active,
            "category_id": category_id.trim(),
            "category_code": category_code,
            "unit_id": unit_id.trim(),
            "temporary_percent": temporary_percent,
            "food_combo_ids": FieldValue.arrayUnion(food_combo_ids),
            "addition_food_ids": FieldValue.arrayUnion(addition_food_ids),
          });
        });
      }
      // Get.snackbar(
      //   'THÀNH CÔNG!',
      //   'Cập nhật thông tin thành công!',
      //   backgroundColor: backgroundSuccessColor,
      //   colorText: Colors.white,
      // );
      update();
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }

  updateQuantityFoodOrder(
    String food_id,
    double max_order_limit,
    // double current_order_count,
    Timestamp start_date_time,
    Timestamp end_date_time,
    BuildContext context,
  ) async {
    try {
      if (food_id != "") {
        await firestore.collection('foods').doc(food_id).update({
          "max_order_limit": max_order_limit,
          "current_order_count": max_order_limit,
          "start_date_time": start_date_time,
          "end_date_time": end_date_time,
        }).then((value) => {Utils.myPopSuccess(context)});
      }

      update();
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }

  

  // Block account
  updateToggleActive(
    String Food_id,
    int active,
  ) async {
    try {
      await firestore.collection('foods').doc(Food_id).update({
        "active": active == ACTIVE ? DEACTIVE : ACTIVE,
      });

      Get.snackbar(
        'THÀNH CÔNG!',
        'Cập nhật thông tin thành công!',
        backgroundColor: backgroundSuccessColor,
        colorText: Colors.white,
      );
      update();
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }

  _deleteOldProfilePhoto(DocumentSnapshot doc) async {
    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String oldDownloadUrl = data['image'];
      if (oldDownloadUrl.isNotEmpty) {
        try {
          // Tạo tham chiếu đến file trong Firebase Storage
          Reference storageRef =
              FirebaseStorage.instance.refFromURL(oldDownloadUrl);

          // Kiểm tra URL tải xuống để kiểm tra sự tồn tại của tệp
          await storageRef.getDownloadURL();

          // Nếu không xảy ra lỗi, tệp tồn tại và có thể xóa
          await storageRef.delete();
        } catch (e) {
          // Xử lý lỗi nếu tệp không tồn tại hoặc có lỗi khác
          print("Error deleting file: $e");
        }
      }
    }
  }
}
