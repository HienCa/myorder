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
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/recipe_detail.dart';
import 'package:myorder/utils.dart';

class IngredientController extends GetxController {
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

  getIngredientById(String ingredient_id) async {
    try {
      DocumentSnapshot ingredient =
          await firestore.collection('ingredients').doc(ingredient_id).get();
      if (ingredient.exists) {
        final data = ingredient.data();
        if (data != null && data is Map<String, dynamic>) {
          String ingredient_id = data['ingredient_id'] ?? "";
          String name = data['name'] ?? "";
          String image = data['image'] ?? "";
          String unit_id = data['unit_id'] ?? "";
          // int is_weight = data['is_weight'] ?? 0;
          int active = data['active'] ?? 0;
          return Ingredient(
              ingredient_id: ingredient_id,
              name: name,
              image: image,
              // is_weight: is_weight,
              active: active,
              unit_id: unit_id);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  final Rx<List<Ingredient>> _ingredients = Rx<List<Ingredient>>([]);
  List<Ingredient> get ingredients => _ingredients.value;
  getIngredients(String keySearch) async {
    if (keySearch.isEmpty) {
      _ingredients.bindStream(
        firestore
            .collection('ingredients')
            // .where('active', isEqualTo: ACTIVE)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<Ingredient> retValue = [];
            for (var element in query.docs) {
              Ingredient ingredient = Ingredient.fromSnap(element);

              RecipeDetail recipeDetail = RecipeDetail(
                  recipe_detail_id: "",
                  ingredient_id: ingredient.ingredient_id,
                  quantity: 1,
                  unit_name: "",
                  name: ingredient.name);

              // if (ingredient.is_weight == ACTIVE) {
              //   recipeDetail.quantity = 0.1;
              // }
              ingredient.recipeDetail = recipeDetail;

              DocumentSnapshot unit = await firestore
                  .collection('units')
                  .doc(ingredient.unit_id)
                  .get();
              if (unit.exists) {
                final userData = unit.data();
                if (userData != null && userData is Map<String, dynamic>) {
                  String unit_name = userData['name'] ?? '';
                  ingredient.recipeDetail!.unit_name = unit_name;
                }
              }
              retValue.add(ingredient);
            }
            return retValue;
          },
        ),
      );
    } else {
      _ingredients.bindStream(firestore
          .collection('ingredients')
          // .where('active', isEqualTo: ACTIVE)
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<Ingredient> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            Ingredient ingredient = Ingredient.fromSnap(elem);
            RecipeDetail recipeDetail = RecipeDetail(
                recipe_detail_id: "",
                ingredient_id: ingredient.ingredient_id,
                quantity: 1,
                unit_name: "",
                name: ingredient.name);
            ingredient.recipeDetail = recipeDetail;
            // if (ingredient.is_weight == ACTIVE) {
            recipeDetail.quantity = 0.1;
            // }

            DocumentSnapshot unit = await firestore
                .collection('units')
                .doc(ingredient.unit_id)
                .get();
            if (unit.exists) {
              final userData = unit.data();
              if (userData != null && userData is Map<String, dynamic>) {
                String unit_name = userData['name'] ?? '';
                ingredient.recipeDetail!.unit_name = unit_name;
              }
            }
            retVal.add(ingredient);
          }
        }
        return retVal;
      }));
    }
  }

  final Rx<List<Ingredient>> _ingredientsOfFood = Rx<List<Ingredient>>([]);
  List<Ingredient> get ingredientsOfFood => _ingredientsOfFood.value;
  getIngredientsOfFood(String keySearch) async {
    if (keySearch.isEmpty) {
      _ingredientsOfFood.bindStream(
        firestore
            .collection('ingredients')
            // .where('active', isEqualTo: ACTIVE)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<Ingredient> retValue = [];
            for (var element in query.docs) {
              Ingredient ingredient = Ingredient.fromSnap(element);

              RecipeDetail recipeDetail = RecipeDetail(
                  recipe_detail_id: "",
                  ingredient_id: ingredient.ingredient_id,
                  quantity: 1,
                  unit_name: "",
                  name: ingredient.name);

              // if (ingredient.is_weight == ACTIVE) {
              //   recipeDetail.quantity = 0.1;
              // }
              ingredient.recipeDetail = recipeDetail;

              DocumentSnapshot unit = await firestore
                  .collection('units')
                  .doc(ingredient.unit_id)
                  .get();
              if (unit.exists) {
                final userData = unit.data();
                if (userData != null && userData is Map<String, dynamic>) {
                  String unit_name = userData['name'] ?? '';
                  ingredient.recipeDetail!.unit_name = unit_name;
                }
              }

              retValue.add(ingredient);
            }
            return retValue;
          },
        ),
      );
    } else {
      _ingredientsOfFood.bindStream(firestore
          .collection('ingredients')
          // .where('active', isEqualTo: ACTIVE)
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<Ingredient> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            Ingredient ingredient = Ingredient.fromSnap(elem);
            RecipeDetail recipeDetail = RecipeDetail(
                recipe_detail_id: "",
                ingredient_id: ingredient.ingredient_id,
                quantity: 1,
                unit_name: "",
                name: ingredient.name);
            ingredient.recipeDetail = recipeDetail;
            // if (ingredient.is_weight == ACTIVE) {
            recipeDetail.quantity = 0.1;
            // }

            DocumentSnapshot unit = await firestore
                .collection('units')
                .doc(ingredient.unit_id)
                .get();
            if (unit.exists) {
              final userData = unit.data();
              if (userData != null && userData is Map<String, dynamic>) {
                String unit_name = userData['name'] ?? '';
                ingredient.recipeDetail!.unit_name = unit_name;
              }
            }
            retVal.add(ingredient);
          }
        }
        return retVal;
      }));
    }
  }

  void createIngredient(
    String name,
    File? image,
    // int is_weight,
    String unit_id,
  ) async {
    try {
      if (name.isNotEmpty) {
        String downloadUrl = "";
        if (image != null) {
          downloadUrl = await _uploadToStorage(image);
        }

        String id = Utils.generateUUID();
        Ingredient ingredient = Ingredient(
          ingredient_id: id,
          name: name,
          image: downloadUrl,
          // is_weight: is_weight,
          active: 1,
          unit_id: unit_id,
        );
        CollectionReference ingredientsCollection =
            FirebaseFirestore.instance.collection('ingredients');

        await ingredientsCollection.doc(id).set(ingredient.toJson());
      } else {
        Get.snackbar(
          'Error!',
          'Thêm thất bại!',
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

  updateIngredient(
    String ingredient_id,
    String name,
    File? newImage,
    // int is_weight,
    String unit_id,
  ) async {
    String downloadUrl = "";
    try {
      if (newImage != null) {
        print("Image Selected");

        downloadUrl = await _uploadToStorage(newImage);

        await firestore.collection('ingredients').doc(ingredient_id).update({
          // "is_weight": is_weight,
          "name": name.trim(),
          "unit_id": unit_id.trim(),
          "image": downloadUrl,
        });
      } else {
        print("NO Image Selected");

        await firestore.collection('ingredients').doc(ingredient_id).update({
          "name": name.trim(),
          // "is_weight": is_weight,
          "unit_id": unit_id.trim(),
        });
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
    String ingredient_id,
    int active,
  ) async {
    try {
      await firestore.collection('ingredients').doc(ingredient_id).update({
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
}
