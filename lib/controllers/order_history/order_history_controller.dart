// ignore_for_file: non_constant_identifier_names, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/order_history.dart';

class OrderHistoryController extends GetxController {
  final Rx<List<OrderHistory>> _orderHistory = Rx<List<OrderHistory>>([]);
  List<OrderHistory> get orderHistory => _orderHistory.value;
  getAllOrderHistory(String order_id, String keySearch) async {
    if (keySearch.isEmpty) {
      _orderHistory.bindStream(
        firestore
            .collection('orders')
            .doc(order_id)
            .collection('orderHistory')
            .orderBy('create_at')
            .snapshots()
            .map(
          (QuerySnapshot query) {
            List<OrderHistory> retValue = [];
            for (var element in query.docs) {
              retValue.add(OrderHistory.fromSnap(element));
              print(element);
            }
            return retValue;
          },
        ),
      );
    } else {
      _orderHistory.bindStream(firestore
          .collection('orders')
          .doc(order_id)
          .collection('orderHistory')
          .orderBy('create_at')
          .snapshots()
          .map((QuerySnapshot query) {
        List<OrderHistory> retVal = [];
        for (var elem in query.docs) {
          String name = elem['employee_name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(OrderHistory.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  void createOrderHistory(
    OrderHistory orderHistory,
  ) async {
    try {
      if (orderHistory.order_id != "") {
        CollectionReference usersCollection = FirebaseFirestore.instance
            .collection('orders')
            .doc(orderHistory.order_id)
            .collection('orderHistory');

        await usersCollection
            .doc(orderHistory.history_id)
            .set(orderHistory.toJson());
      } else {
        Get.snackbar(
          'Error!',
          'Thêm lịch sử đơn hàng thất bại!',
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
}
