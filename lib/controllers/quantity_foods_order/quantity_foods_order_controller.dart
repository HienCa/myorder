// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/quantity_food_order.dart';
import 'package:myorder/utils.dart';

class QuantityFoodOrderController extends GetxController {
  getVatById(String quantity_food_order_id) async {
    try {
      DocumentSnapshot quantityFoodOrder = await firestore
          .collection('quantityFoodOrder')
          .doc(quantity_food_order_id)
          .get();
      if (quantityFoodOrder.exists) {
        final data = quantityFoodOrder.data();
        if (data != null && data is Map<String, dynamic>) {
          String quantity_food_order_id = data['quantity_food_order_id'] ?? '';
          String food_id = data['food_id'] ?? '';
          double max_order_limit = data['max_order_limit'] ?? 0;
          double current_order_count = data['current_order_count'] ?? 0;
          Timestamp start_date_time = data['start_date_time'];
          Timestamp end_date_time = data['end_date_time'];
          Timestamp create_at = data['create_at'];
          int active = data['active'] ?? 0;
          return QuantityFoodOrder(
              quantity_food_order_id: quantity_food_order_id,
              food_id: food_id,
              max_order_limit: max_order_limit,
              current_order_count: current_order_count,
              start_date_time: start_date_time,
              end_date_time: end_date_time,
              create_at: create_at,
              active: active);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  final Rx<List<QuantityFoodOrder>> _quantityFoodOrders =
      Rx<List<QuantityFoodOrder>>([]);
  List<QuantityFoodOrder> get vats => _quantityFoodOrders.value;
  getVats(String keySearch) async {
    if (keySearch.isEmpty) {
      _quantityFoodOrders.bindStream(
        firestore
            .collection('quantityFoodOrders')
            .where("active", isEqualTo: ACTIVE)
            .snapshots()
            .map(
          (QuerySnapshot query) {
            List<QuantityFoodOrder> retValue = [];
            for (var element in query.docs) {
              retValue.add(QuantityFoodOrder.fromSnap(element));
              print(element);
            }
            return retValue;
          },
        ),
      );
    } else {
      _quantityFoodOrders.bindStream(firestore
          .collection('vats')
          .orderBy('name')
          .snapshots()
          .map((QuerySnapshot query) {
        List<QuantityFoodOrder> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(QuantityFoodOrder.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  void createQuantityFoodOrders(
    String quantity_food_order_id,
    String food_id,
    double max_order_limit,
    Timestamp start_date_time,
    Timestamp end_date_time,
  ) async {
    try {
      if (food_id.isNotEmpty) {
        String id = Utils.generateUUID();
        QuantityFoodOrder quantityFoodOrder = QuantityFoodOrder(
            quantity_food_order_id: quantity_food_order_id,
            food_id: food_id,
            max_order_limit: max_order_limit,
            current_order_count: 0,
            start_date_time: start_date_time,
            end_date_time: end_date_time,
            create_at: Timestamp.now(),
            active: ACTIVE);

        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('quantityFoodOrders');

        await usersCollection.doc(id).set(quantityFoodOrder.toJson());
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

  updateVat(
    String quantity_food_order_id,
    String food_id,
    double max_order_limit,
    double current_order_count,
    Timestamp start_date_time,
    Timestamp end_date_time,
  ) async {
    try {
      await firestore
          .collection('quantityFoodOrders')
          .doc(quantity_food_order_id)
          .update({
        'food_id': food_id,
        'max_order_limit': max_order_limit,
        'current_order_count': current_order_count,
        'start_date_time': start_date_time,
        'end_date_time': end_date_time,
        // 'active': ACTIVE
      });

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
