// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/discount.dart';


class DiscountController extends GetxController {
  getDiscountById(String discount_id) async {
    try {
      DocumentSnapshot discount =
          await firestore.collection('discounts').doc(discount_id).get();
      if (discount.exists) {
        final userData = discount.data();
        if (userData != null && userData is Map<String, dynamic>) {
          String discount_id = userData['discount_id'] ?? '';
          String name = userData['name'] ?? '';
          double discount_price = userData['discount_price'] ?? 0;
          int active = userData['active'] ?? 1;
          return Discount(
              discount_id: discount_id,
              name: name,
              active: active,
              discount_price: discount_price);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return Discount(discount_id: discount_id, name: "", active: 1, discount_price: 0);
    }
  }

  final Rx<List<Discount>> _discounts = Rx<List<Discount>>([]);
  List<Discount> get discounts => _discounts.value;
  getDiscounts(String keySearch) async {
    if (keySearch.isEmpty) {
      _discounts.bindStream(
        firestore.collection('discounts').snapshots().map(
          (QuerySnapshot query) {
            List<Discount> retValue = [];
            for (var element in query.docs) {
              retValue.add(Discount.fromSnap(element));
              print(element);
            }
            return retValue;
          },
        ),
      );
    } else {
      _discounts.bindStream(firestore
          .collection('discounts')
          .orderBy('name')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Discount> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(Discount.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  void createDiscount(
    String name,
    String discount_price,
  ) async {
    try {
      if (name.isNotEmpty) {
        var allDocs = await firestore.collection('discounts').get();
        int len = allDocs.docs.length;

        Discount discount = Discount(
          discount_id: 'Discount-$len',
          name: name.trim().toUpperCase(),
          active: 1,
          discount_price: double.tryParse(discount_price) ?? 0,
        );
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('discounts');

        await usersCollection.doc('Discount-$len').set(discount.toJson());
        Get.snackbar(
          'THÀNH CÔNG!',
          'Thêm discount mới thành công!',
          backgroundColor: backgroundSuccessColor,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error!',
          'Thêm discount thất bại!',
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

  updateDiscount(
    String discount_id,
    String name,
    String discount_price,
  ) async {
    try {
      await firestore.collection('discounts').doc(discount_id).update({
        "name": name.trim().toUpperCase(),
        "discount_price": double.tryParse(discount_price) ?? 0,
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
    String discount_id,
    int active,
  ) async {
    try {
      await firestore.collection('discounts').doc(discount_id).update({
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
