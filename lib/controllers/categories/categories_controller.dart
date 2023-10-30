// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/category.dart' as model;
import 'package:myorder/models/category.dart';
import 'package:myorder/utils.dart';

class CategoryController extends GetxController {
  getCategoryById(String category_id) async {
    try {
      DocumentSnapshot category =
          await firestore.collection('categories').doc(category_id).get();
      if (category.exists) {
        final userData = category.data();
        if (userData != null && userData is Map<String, dynamic>) {
          String category_id = userData['category_id'] ?? '';
          String name = userData['name'] ?? '';
          int category_code = userData['category_code'] ?? CATEGORY_ALL;

          int active = userData['active'] ?? 1;
          return model.Category(
              category_id: category_id,
              name: name,
              active: active,
              category_code: category_code);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return model.Category(
          category_id: category_id,
          name: "",
          active: 1,
          category_code: CATEGORY_ALL);
    }
  }

  final Rx<List<Category>> _categories = Rx<List<Category>>([]);
  List<Category> get categories => _categories.value;

  getCategories(String keySearch) async {
    if (keySearch.isEmpty) {
      _categories.bindStream(
        firestore.collection('categories').snapshots().map(
          (QuerySnapshot query) {
            List<Category> retValue = [];
            for (var element in query.docs) {
              retValue.add(Category.fromSnap(element));
              print(element);
            }
            return retValue;
          },
        ),
      );
    } else {
      _categories.bindStream(firestore
          .collection('categories')
          .orderBy('name')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Category> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(Category.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  final Rx<List<Category>> _categoriesActive = Rx<List<Category>>([]);
  List<Category> get categoriesActive => _categoriesActive.value;
  getCategoriesActive() async {
    _categoriesActive.bindStream(
      firestore
          .collection('categories')
          .where("active", isEqualTo: 1)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Category> retValue = [];
          retValue.add(Category(
              category_id: defaultCategory,
              name: 'Tất cả món',
              active: 1,
              category_code:
                  CATEGORY_ALL)); // thêm một phần tử tất cả để gọi all
          for (var element in query.docs) {
            retValue.add(Category.fromSnap(element));
            print(element);
          }
          return retValue;
        },
      ),
    );
  }

  void createCategory(
    String name,
    int code,
  ) async {
    try {
      if (name.isNotEmpty) {
        String id = Utils.generateUUID();

        model.Category category = model.Category(
          category_id: id,
          name: name.trim(),
          active: 1,
          category_code: code,
        );
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('categories');

        await usersCollection.doc(id).set(category.toJson());
        // .then((_) => Get.snackbar(
        //       'THÀNH CÔNG!',
        //       'Thêm đơn vị tính mới thành công!',
        //       backgroundColor: backgroundSuccessColor,
        //       colorText: Colors.white,
        //     ));
      } else {
        Get.snackbar(
          'Error!',
          'Thêm đơn vị tính thất bại!',
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

  updateCategory(
    String category_id,
    int category_code,
    String name,
  ) async {
    try {
      await firestore.collection('categories').doc(category_id).update({
        "name": name.trim(),
        "category_code": category_code,
      }).then((_) async {
        // Sử dụng Transaction để đảm bảo tính nhất quán khi cập nhật nhiều documents
        // Tìm tất cả foods có category_code bằng category_code cũ
        QuerySnapshot foodsQuery = await firestore
            .collection('foods')
            .where("category_id", isEqualTo: category_id)
            .get();

        // Lặp qua từng food và cập nhật category_code mới
        for (QueryDocumentSnapshot foodDoc in foodsQuery.docs) {
          await firestore.collection('foods').doc(foodDoc['food_id']).update({
            "category_code": category_code,
          });
          print(foodDoc['food_id']);
        }
      });
      // .then((_) => Get.snackbar(
      //       'THÀNH CÔNG!',
      //       'Cập nhật thông tin thành công!',
      //       backgroundColor: backgroundSuccessColor,
      //       colorText: Colors.white,
      //     ));

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
    String category_id,
    int active,
  ) async {
    try {
      await firestore.collection('categories').doc(category_id).update({
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
