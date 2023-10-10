// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/bill.dart';
import 'package:myorder/models/food_order_detail.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/table.dart' as table;
import 'package:myorder/utils.dart';

class ReportController extends GetxController {
  final Rx<int> _numberOfOrder = Rx<int>(0);
  int get numberOfOrder => _numberOfOrder.value;

  void getOrders() {
    FirebaseFirestore.instance
        .collection('orders')
        .where("active", isEqualTo: ACTIVE)
        .where('order_status', isEqualTo: ORDER_STATUS_SERVING)
        .snapshots()
        .listen((QuerySnapshot query) {
      final int count = query.size;
      _numberOfOrder.value = count;
      print("Đơn hàng hôm nay đang phục vụ: $count");
    });
  }

  final Rx<int> _numberOfBills = Rx<int>(0);
  int get numberOfBills => _numberOfBills.value;

  void getBills() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    FirebaseFirestore.instance
        .collection('bills')
        .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
        .where('payment_at', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .listen((QuerySnapshot query) {
      final int count = query.size;
      _numberOfBills.value = count;
      print("Đơn hàng hôm nay đã thanh toán: $count");

    });
  }
}
