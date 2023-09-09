// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/category.dart' as model;
import 'package:myorder/models/category.dart';

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

          int active = userData['active'] ?? 1;
          return model.Category(category_id: category_id, name: name, active: active);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return model.Category(category_id: category_id, name: "", active: 1);
    }
  }

  final Rx<List<Category>> _categories = Rx<List<Category>>([]);
  List<Category> get categories => _categories.value;
  getCategories() async {
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
  }

  void createCategory(
    String name,
  ) async {
    try {
      if (name.isNotEmpty) {
        var allDocs = await firestore.collection('categories').get();
        int len = allDocs.docs.length;

        model.Category category = model.Category(
          category_id: 'Category-$len',
          name: name,
          active: 1,
        );
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('categories');

        await usersCollection.doc('Category-$len').set(category.toJson());
        Get.snackbar(
          'THÀNH CÔNG!',
          'Thêm đơn vị tính mới thành công!',
          backgroundColor: backgroundSuccessColor,
          colorText: Colors.white,
        );
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
    String name,
  ) async {
    try {
      await firestore.collection('categories').doc(category_id).update({
        "name": name,
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
