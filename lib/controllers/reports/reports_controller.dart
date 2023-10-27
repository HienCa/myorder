// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/bill.dart';
import 'package:myorder/models/food_order_detail.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/report.dart';
import 'package:myorder/models/table.dart' as table;
import 'package:myorder/utils.dart';

class ReportController extends GetxController {
  final Rx<Report> _reportServingOrder = Rx<Report>(Report.empty());
  Report get reportServingOrder => _reportServingOrder.value;

  void getReportServingOrders() {
    Report report = Report.empty();
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    FirebaseFirestore.instance
        .collection('orders')
        .where("active", isEqualTo: ACTIVE)
        .where('order_status', isEqualTo: ORDER_STATUS_SERVING)
        // .where('create_at', isGreaterThanOrEqualTo: startOfDay)
        // .where('create_at', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .listen((QuerySnapshot query) {
      final int count = query.size;
      report.quantity = count;

      print("Đơn hàng đang phục vụ hôm nay: $count");
      double totalAmount = 0;
      for (var element in query.docs) {
        model.Order order =
            model.Order.fromSnap(element); // map đơn hàng chi tiết
        totalAmount += order.total_amount;
      }
      report.total_amount = totalAmount;

      _reportServingOrder.value = report;
    });
  }

  final Rx<Report> _reportBills = Rx<Report>(Report.empty());
  Report get reportBills => _reportBills.value;
  void getBills() {
    Report report = Report.empty();

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
      report.quantity = count;

      print("Đơn hàng đã thanh toán hôm nay: $count");
      double totalAmount = 0;
      for (var element in query.docs) {
        model.Order order =
            model.Order.fromSnap(element); // map đơn hàng chi tiết
        totalAmount += order.total_amount;
      }
      report.total_amount = totalAmount;

      _reportBills.value = report;
    });
  }

  //Đơn hàng đã hủy

  final Rx<Report> _reportCancelOrder = Rx<Report>(Report.empty());
  Report get reportCancelOrder => _reportCancelOrder.value;

  void getNumberOfCanceledOrders() {
    Report report = Report.empty();

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    FirebaseFirestore.instance
        .collection('orders')
        .where("active", isEqualTo: DEACTIVE)
        .where('order_status', isEqualTo: ORDER_STATUS_CANCEL)
        .where('payment_at', isGreaterThanOrEqualTo: startOfDay)
        .where('payment_at', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .listen((QuerySnapshot query) {
      final int count = query.size;
      report.quantity = count;

      print("Đơn hàng đã hủy hôm nay: $count");
      double totalAmount = 0;
      for (var element in query.docs) {
        model.Order order =
            model.Order.fromSnap(element); // map đơn hàng chi tiết
        totalAmount += order.total_amount;
      }
      report.total_amount = totalAmount;

      _reportCancelOrder.value = report;
    });
  }
}
