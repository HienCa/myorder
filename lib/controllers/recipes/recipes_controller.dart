// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/recipe_detail.dart';
import 'package:myorder/models/vat.dart';
import 'package:myorder/models/vat.dart' as model;
import 'package:myorder/utils.dart';

class RecipeController extends GetxController {
  getVatById(String vat_id) async {
    try {
      DocumentSnapshot Vat =
          await firestore.collection('vats').doc(vat_id).get();
      if (Vat.exists) {
        final userData = Vat.data();
        if (userData != null && userData is Map<String, dynamic>) {
          String vat_id = userData['vat_id'] ?? '';
          String name = userData['name'] ?? '';
          int vat_percent = userData['vat_percent'] ?? 0;

          int active = userData['active'] ?? 1;
          return model.Vat(
              vat_id: vat_id,
              name: name,
              active: active,
              vat_percent: vat_percent);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return Vat(vat_id: vat_id, name: "", active: 1, vat_percent: 0);
    }
  }

  final Rx<List<RecipeDetail>> _recipeOfFood = Rx<List<RecipeDetail>>([]);
  List<RecipeDetail> get recipeOfFood => _recipeOfFood.value;
  getRecipeOfFood(
    String food_id,
    String keySearch,
  ) async {
    if (keySearch.isEmpty) {
      _recipeOfFood.bindStream(
        firestore
            .collection('foods')
            .doc(food_id)
            .collection('recipes')
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<RecipeDetail> retValue = [];
            for (var element in query.docs) {
              RecipeDetail recipeDetail = RecipeDetail.fromSnap(element);
              recipeDetail.new_quantity = recipeDetail.quantity;
              retValue.add(recipeDetail);
            }
            return retValue;
          },
        ),
      );
    } else {
      _recipeOfFood.bindStream(firestore
          .collection('foods')
          .doc(food_id)
          .collection('recipes')
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<RecipeDetail> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            RecipeDetail recipeDetail = RecipeDetail.fromSnap(elem);
            recipeDetail.new_quantity = recipeDetail.quantity;

            retVal.add(recipeDetail);
          }
        }
        return retVal;
      }));
    }
  }

  Future<void> createRecipe(
      String food_id, List<Ingredient> ingredients) async {
    try {
      if (ingredients.isNotEmpty) {
        for (Ingredient ingredient in ingredients) {
          if (ingredient.isSelected == true) {
            String id = Utils.generateUUID();
            CollectionReference usersCollection = FirebaseFirestore.instance
                .collection('foods')
                .doc(food_id)
                .collection("recipes");
            RecipeDetail recipeDetail = ingredient.recipeDetail!;
            recipeDetail.recipe_detail_id = id;
            await usersCollection.doc(id).set(recipeDetail.toJson());
          }
        }
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
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    }
  }

  //CẬP NHẬT SỐ LƯỢNG NGUYÊN LIỆU MÓN
  updateRecipeDetail(String food_id, List<RecipeDetail> recipeDetails) async {
    try {
      if (food_id.isNotEmpty) {
        for (RecipeDetail recipeDetail in recipeDetails) {
          if (recipeDetail.quantity != recipeDetail.new_quantity) {
            await firestore
                .collection('foods')
                .doc(food_id)
                .collection("recipes")
                .doc(recipeDetail.recipe_detail_id)
                .update({
              "quantity": recipeDetail.new_quantity,
            });
          }
        }
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

  //XÓA NGUYÊN LIỆU MÓN
  deleteRecipeDetail(String food_id, RecipeDetail recipeDetail) async {
    try {
      if (food_id.isNotEmpty && recipeDetail.recipe_detail_id.isNotEmpty) {
        await firestore
            .collection('foods')
            .doc(food_id)
            .collection("recipes")
            .doc(recipeDetail.recipe_detail_id)
            .delete();
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
}
