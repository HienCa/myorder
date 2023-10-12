// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/bill.dart';
import 'package:myorder/models/food_order_detail.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/table.dart' as table;
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/order/order_screen.dart';

class BillController extends GetxController {
  //hóa đơn
  final Rx<List<Bill>> _bills = Rx<List<Bill>>([]);
  List<Bill> get bills => _bills.value;
  getBills(int timeOption, String keySearch) async {
    if (keySearch.isEmpty) {
      //lấy theo time - không search
      print("lấy hóa đơn theo time - không search");
      DateTime now = DateTime.now();
      DateTime startDate;
      DateTime endDate;
      // final List<String> TIME_OPTION = <String>[
      //   'Hôm nay',
      //   'Hôm qua',
      //   'Tuần này',
      //   'Tháng này',
      //   'Tháng trước',
      //   '3 tháng gần nhất',
      //   'Năm nay',
      //   'Năm trước',
      //   '3 năm gần nhất',
      //   'Tất cả các năm',
      // ];
      switch (timeOption) {
        case 0: //hôm nay
          print("Thời gian: hôm nay");

          startDate = DateTime(now.year, now.month, now.day);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
          break;
        case 1: //hôm qua
          print("Thời gian: hôm qua");

          startDate = DateTime(now.year, now.month, now.day - 1);
          endDate = DateTime(now.year, now.month, now.day - 1, 23, 59, 59, 999);
          break;
        case 2: //tuần này
          print("Thời gian: tuần này");

          startDate = now.subtract(Duration(days: now.weekday - 1));
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
          break;
        case 3: //tháng này
          print("Thời gian: tháng này");

          startDate = DateTime(now.year, now.month, 1);
          endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
          break;
        case 4: //tháng trước
          print("Thời gian: tháng trước");

          startDate = DateTime(now.year, now.month - 1, 1);
          endDate = DateTime(now.year, now.month, 0, 23, 59, 59, 999);
          break;
        case 5: //3 tháng gần nhất
          print("Thời gian: 3 năm gần nhất");

          startDate = DateTime(now.year, now.month - 2, now.day);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
          break;
        case 6: //năm nay
          print("Thời gian: 3 năm gần nhất");

          startDate = DateTime(now.year, 1, 1);
          endDate = DateTime(now.year, 12, 31, 23, 59, 59, 999);
          break;
        case 7: //năm trước
          print("Thời gian: năm trước");

          startDate = DateTime(now.year - 1, 1, 1);
          endDate = DateTime(now.year - 1, 12, 31, 23, 59, 59, 999);
          break;
        case 8: //3 năm gần nhất
          print("Thời gian: 3 năm gần nhất");

          startDate = DateTime(now.year - 2, now.month, now.day);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
          break;
        case 9: //tất cả các năm
          print("Thời gian: tất cả các năm");

          startDate = DateTime(1970, 1, 1);
          // endDate = DateTime(2100, 12, 31, 23, 59, 59, 999);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
          break;
        default:
          return [];
      }
      _bills.bindStream(
        firestore
            .collection('bills')
            .where('payment_at',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('payment_at',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            // .where('order_status', isNotEqualTo: ORDER_STATUS_CANCEL)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<Bill> retValue = [];
            for (var element in query.docs) {
              print('===============================================');
              String order_id = element["order_id"].toString();

              Bill bill = Bill.fromSnap(element);

              //Thông tin đơn hàng
              DocumentSnapshot orderCollection =
                  await firestore.collection('orders').doc(order_id).get();
              if (orderCollection.exists) {
                final orderData = orderCollection.data();
                if (orderData != null && orderData is Map<String, dynamic>) {
                  String order_code = orderData['order_code'] ?? '';
                  String employee_id = orderData['employee_id'] ?? '';
                  String table_id = orderData['table_id'] ?? '';
                  int order_status = orderData['order_status'] ?? '';
                  String note = orderData['note'] ?? '';
                  Timestamp create_at = orderData['create_at'] ?? '';
                  Timestamp payment_at = orderData['payment_at'] ?? '';
                  String vat_id = orderData['vat_id'] ?? '';
                  String discount_id = orderData['discount_id'] ?? '';
                  List table_merge_names = orderData['table_merge_names'] ?? [];
                  List table_merge_ids = orderData['table_merge_ids'] ?? [];
                  bill.order!.order_code = order_code;
                  bill.order!.employee_id = employee_id;
                  bill.order!.table_id = table_id;
                  bill.order!.order_status = order_status;
                  bill.order!.note = note;
                  bill.order!.create_at = create_at;
                  bill.order!.payment_at = payment_at;
                  bill.order!.vat_id = vat_id;
                  bill.order!.discount_id = discount_id;
                  bill.order!.table_merge_ids = table_merge_ids;
                  bill.order!.table_merge_names = table_merge_names;

                  print(bill.order!.employee_id);
                  print(bill.order!.table_id);
                  print(bill.order!.order_status);
                  print(bill.order!.note);
                  print(bill.order!.create_at);
                  print(bill.order!.payment_at);
                  print(bill.order!.vat_id);
                  print(bill.order!.discount_id);
                  print(bill.order!.table_merge_ids);
                  print(bill.order!.table_merge_names);
                }
              }

              //Thông tin nhân viên phụ trách đơn hàng
              DocumentSnapshot employeeCollection = await firestore
                  .collection('employees')
                  .doc(bill.order!.employee_id)
                  .get();
              if (employeeCollection.exists) {
                final employeeData = employeeCollection.data();
                if (employeeData != null &&
                    employeeData is Map<String, dynamic>) {
                  String name = employeeData['name'] ?? '';
                  bill.order!.employee_name = name;
                }
              }

              print("Nhân viên order: ${bill.order!.employee_name}");

              // Truy vấn collection orderDetails
              var orderDetailCollection = firestore
                  .collection('orders')
                  .doc(order_id)
                  .collection('orderDetails');

              // Tính tổng số tiền cho đơn hàng
              double totalAmount = 0;
              List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng
              var orderDetailQuery = await orderDetailCollection.get();
              for (var doc in orderDetailQuery.docs) {
                var orderDetail = OrderDetail.fromSnap(doc);
                // lấy thông tin của món ăn
                DocumentSnapshot foodCollection = await firestore
                    .collection('foods')
                    .doc(orderDetail.food_id)
                    .get();
                if (foodCollection.exists) {
                  final foodData = foodCollection.data();
                  if (foodData != null && foodData is Map<String, dynamic>) {
                    String food_name = foodData['name'] ?? '';
                    String image = foodData['image'] ?? '';

                    orderDetail.food = FoodOrderDetail(
                        food_id: orderDetail.food_id,
                        name: food_name,
                        image: image);
                    print(food_name);
                  }
                }
                orderDetails.add(orderDetail);
              }
              bill.order_details = orderDetails;

              int vat_percent = 0; // vat được áp dụng
              // lấy thông tin thuế
              if (bill.order!.vat_id != "") {
                DocumentSnapshot vatCollection = await firestore
                    .collection('vats')
                    .doc(bill.order!.vat_id)
                    .get();
                if (vatCollection.exists) {
                  final vatData = vatCollection.data();
                  if (vatData != null && vatData is Map<String, dynamic>) {
                    String name = vatData['name'] ?? '';
                    vat_percent = vatData['vat_percent'] ?? 0; // lấy % vat
                    bill.order!.vat_name = name;
                  }
                }
              }
              print(bill.order!.vat_id);
              print("VAT đã áp dụng: ${bill.order!.vat_name} - $vat_percent");

              // lấy thông tin giảm giá
              double discount_price = 0; // giảm giá được áp dụng
              if (bill.order!.discount_id != "") {
                DocumentSnapshot discountCollection = await firestore
                    .collection('discounts')
                    .doc(bill.order!.discount_id)
                    .get();

                if (discountCollection.exists) {
                  final discountData = discountCollection.data();
                  if (discountData != null &&
                      discountData is Map<String, dynamic>) {
                    String name = discountData['name'] ?? '';
                    discount_price = discountData['discount_price'] ?? 0;
                    bill.order!.discount_name = name;
                  }
                }
              }
              print(bill.order!.discount_id);
              print(
                  "Discount đã áp dụng: ${bill.order!.discount_name} - $discount_price");

              // lấy tên bàn, tên bàn đã gộp
              DocumentSnapshot tableCollection = await firestore
                  .collection('tables')
                  .doc(bill.order!.table_id)
                  .get();
              if (tableCollection.exists) {
                final tableData = tableCollection.data();
                if (tableData != null && tableData is Map<String, dynamic>) {
                  String name = tableData['name'] ?? '';
                  int total_slot = tableData['total_slot'] ?? '';
                  int status = tableData['status'] ?? '';
                  int active = tableData['active'] ?? '';
                  String area_id = tableData['area_id'] ?? '';
                  bill.order!.table = table.Table(
                      table_id: bill.order!.table_id,
                      name: name,
                      total_slot: total_slot,
                      status: status,
                      active: active,
                      area_id: area_id);
                }
              }

              retValue.add(bill);
            }
            return retValue;
          },
        ),
      );
    } else if (keySearch.isNotEmpty) {
      // lấy theo time - có search
      print("lấy hóa đơn theo time - có search");
      print("Chuỗi tìm kiếm: $keySearch");
      DateTime now = DateTime.now();
      DateTime startDate;
      DateTime endDate;
      // final List<String> TIME_OPTION = <String>[
      //   'Hôm nay',
      //   'Hôm qua',
      //   'Tuần này',
      //   'Tháng này',
      //   'Tháng trước',
      //   '3 tháng gần nhất',
      //   'Năm nay',
      //   'Năm trước',
      //   '3 năm gần nhất',
      //   'Tất cả các năm',
      // ];
      switch (timeOption) {
        case 0: //hôm nay
          startDate = DateTime(now.year, now.month, now.day);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
          break;
        case 1: //hôm qua
          startDate = DateTime(now.year, now.month, now.day - 1);
          endDate = DateTime(now.year, now.month, now.day - 1, 23, 59, 59, 999);
          break;
        case 2: //tuần này
          startDate = now.subtract(Duration(days: now.weekday - 1));
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
          break;
        case 3: //tháng này
          startDate = DateTime(now.year, now.month, 1);
          endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
          break;
        case 4: //tháng trước
          startDate = DateTime(now.year, now.month - 1, 1);
          endDate = DateTime(now.year, now.month, 0, 23, 59, 59, 999);
          break;
        case 5: //3 tháng gần nhất
          startDate = DateTime(now.year, now.month - 2, now.day);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
          break;
        case 6: //năm nay
          startDate = DateTime(now.year, 1, 1);
          endDate = DateTime(now.year, 12, 31, 23, 59, 59, 999);
          break;
        case 7: //năm trước
          startDate = DateTime(now.year - 1, 1, 1);
          endDate = DateTime(now.year - 1, 12, 31, 23, 59, 59, 999);
          break;
        case 8: //3 năm gần nhất
          startDate = DateTime(now.year - 2, now.month, now.day);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
          break;
        case 9: //tất cả các năm
          startDate = DateTime(1970, 1, 1);
          // endDate = DateTime(2100, 12, 31, 23, 59, 59, 999);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
          break;
        default:
          return [];
      }
      _bills.bindStream(
        firestore
            .collection('bills')
            .where('payment_at',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('payment_at',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .where('order_status', isNotEqualTo: ORDER_STATUS_CANCEL)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<Bill> retValue = [];
            for (var element in query.docs) {
              print('===============================================');
              String order_id = element["order_id"].toString();

              Bill bill = Bill.fromSnap(element);

              //Thông tin đơn hàng
              DocumentSnapshot orderCollection =
                  await firestore.collection('orders').doc(order_id).get();
              if (orderCollection.exists) {
                final orderData = orderCollection.data();
                if (orderData != null && orderData is Map<String, dynamic>) {
                  String employee_id = orderData['employee_id'] ?? '';
                  String table_id = orderData['table_id'] ?? '';
                  int order_status = orderData['order_status'] ?? '';
                  String note = orderData['note'] ?? '';
                  Timestamp create_at = orderData['create_at'] ?? '';
                  Timestamp payment_at = orderData['payment_at'] ?? '';
                  String vat_id = orderData['vat_id'] ?? '';
                  String discount_id = orderData['discount_id'] ?? '';

                  bill.order!.employee_id = employee_id;
                  bill.order!.table_id = table_id;
                  bill.order!.order_status = order_status;
                  bill.order!.note = note;
                  bill.order!.create_at = create_at;
                  bill.order!.payment_at = payment_at;
                  bill.order!.vat_id = vat_id;
                  bill.order!.discount_id = discount_id;

                  // print(bill.order!.employee_id);
                  // print(bill.order!.table_id);
                  // print(bill.order!.order_status);
                  // print(bill.order!.note);
                  // print(bill.order!.create_at);
                  // print(bill.order!.payment_at);
                  // print(bill.order!.vat_id);
                  // print(bill.order!.discount_id);
                }
              }

              //Thông tin nhân viên phụ trách đơn hàng
              DocumentSnapshot employeeCollection = await firestore
                  .collection('employees')
                  .doc(bill.order!.employee_id)
                  .get();
              if (employeeCollection.exists) {
                final employeeData = employeeCollection.data();
                if (employeeData != null &&
                    employeeData is Map<String, dynamic>) {
                  String name = employeeData['name'] ?? '';
                  bill.order!.employee_name = name;
                }
              }
              // lấy tên bàn, tên bàn đã gộp
              DocumentSnapshot tableCollection = await firestore
                  .collection('tables')
                  .doc(bill.order!.table_id)
                  .get();
              if (tableCollection.exists) {
                final tableData = tableCollection.data();
                if (tableData != null && tableData is Map<String, dynamic>) {
                  String name = tableData['name'] ?? '';
                  int total_slot = tableData['total_slot'] ?? '';
                  int status = tableData['status'] ?? '';
                  int active = tableData['active'] ?? '';
                  String area_id = tableData['area_id'] ?? '';
                  bill.order!.table = table.Table(
                      table_id: bill.order!.table_id,
                      name: name,
                      total_slot: total_slot,
                      status: status,
                      active: active,
                      area_id: area_id);
                }
              }
              //lọc theo tên nhân viên, tên bàn
              if (bill.order!.employee_name!
                      .toLowerCase()
                      .contains(keySearch.toLowerCase()) ||
                  bill.order!.table!.name
                      .toLowerCase()
                      .contains(keySearch.toLowerCase())) {
                print("Nhân viên order: ${bill.order!.employee_name}");

                // Truy vấn collection orderDetails
                var orderDetailCollection = firestore
                    .collection('orders')
                    .doc(order_id)
                    .collection('orderDetails');

                // Tính tổng số tiền cho đơn hàng
                double totalAmount = 0;
                List<OrderDetail> orderDetails =
                    []; //danh sách chi tiết đơn hàng
                var orderDetailQuery = await orderDetailCollection.get();
                for (var doc in orderDetailQuery.docs) {
                  var orderDetail = OrderDetail.fromSnap(doc);
                  // lấy thông tin của món ăn
                  DocumentSnapshot foodCollection = await firestore
                      .collection('foods')
                      .doc(orderDetail.food_id)
                      .get();
                  if (foodCollection.exists) {
                    final foodData = foodCollection.data();
                    if (foodData != null && foodData is Map<String, dynamic>) {
                      String food_name = foodData['name'] ?? '';
                      String image = foodData['image'] ?? '';

                      orderDetail.food = FoodOrderDetail(
                          food_id: orderDetail.food_id,
                          name: food_name,
                          image: image);
                      print(food_name);
                    }
                  }
                  orderDetails.add(orderDetail);
                }
                bill.order_details = orderDetails;

                int vat_percent = 0; // vat được áp dụng
                // lấy thông tin thuế
                if (bill.order!.vat_id != "") {
                  DocumentSnapshot vatCollection = await firestore
                      .collection('vats')
                      .doc(bill.order!.vat_id)
                      .get();
                  if (vatCollection.exists) {
                    final vatData = vatCollection.data();
                    if (vatData != null && vatData is Map<String, dynamic>) {
                      String name = vatData['name'] ?? '';
                      vat_percent = vatData['vat_percent'] ?? 0; // lấy % vat
                      bill.order!.vat_name = name;
                    }
                  }
                }
                print(bill.order!.vat_id);
                print("VAT đã áp dụng: ${bill.order!.vat_name} - $vat_percent");

                // lấy thông tin giảm giá
                double discount_price = 0; // giảm giá được áp dụng
                if (bill.order!.discount_id != "") {
                  DocumentSnapshot discountCollection = await firestore
                      .collection('discounts')
                      .doc(bill.order!.discount_id)
                      .get();

                  if (discountCollection.exists) {
                    final discountData = discountCollection.data();
                    if (discountData != null &&
                        discountData is Map<String, dynamic>) {
                      String name = discountData['name'] ?? '';
                      discount_price = discountData['discount_price'] ?? 0;
                      bill.order!.discount_name = name;
                    }
                  }
                }
                print(bill.order!.discount_id);
                print(
                    "Discount đã áp dụng: ${bill.order!.discount_name} - $discount_price");
                print("Tổng hóa đơn: ${bill.total_amount}");

                retValue.add(bill);
              }
            }
            return retValue;
          },
        ),
      );
    }
  }

  // tao hóa đơn

  void createBill(model.Order order, double? vat_amount,
      double? discount_amount, BuildContext context) async {
    try {
      String id = Utils.generateUUID();

      //total_amount: tổng tiền đơn hàng đã cộng trừ vat và discount -> số tiền thực tế phải trả
      //vat_amount: tổng tiền vat đã áp dụng cho đơn hàng
      //discount_amount: tổng tiền giảm giá đã áp dụng cho đơn hàng
      Timestamp now = Timestamp.now();

      Bill bill = Bill(
          bill_id: id,
          order_id: order.order_id,
          total_amount: order.total_amount ?? 0.0,
          total_estimate_amount: 0.0,
          vat_amount: vat_amount ?? 0,
          discount_amount: discount_amount ?? 0,
          payment_at: now);
      bill.total_estimate_amount =
          bill.total_amount - bill.vat_amount + bill.discount_amount;
      //tối thiểu là 0đ
      if (bill.total_estimate_amount < 0) {
        bill.total_estimate_amount = 0;
      }
      if (bill.total_amount < 0) {
        bill.total_amount = 0;
      }
      CollectionReference billsCollection =
          FirebaseFirestore.instance.collection('bills');

      await billsCollection.doc(id).set(bill.toJson());

      //Cập nhật trạng thái đơn hàng -> đã thanh toán
      await firestore.collection('orders').doc(order.order_id).update({
        "order_status": ORDER_STATUS_PAID, // đã thanh toán
        "payment_at": now, // đã thanh toán
        "active": DEACTIVE // đã thanh toán
      });
      print("Table: ${order.table_id}");
      //Cập nhật trạng thái bàn -> trống
      await firestore.collection('tables').doc(order.table_id).update({
        "status": TABLE_STATUS_EMPTY, // đã thanh toán
      });
      //Cập nhật trạng thái các bàn đã gộp -> trống
      for (var i = 0; i < order.table_merge_ids.length; i++) {
        await firestore
            .collection('tables')
            .doc(order.table_merge_ids[i])
            .update({
          "status": TABLE_STATUS_EMPTY, // đã thanh toán
        });
      }
      Get.snackbar(
        'THÀNH CÔNG!',
        'Thanh toán thành công!',
        backgroundColor: backgroundSuccessColor,
        colorText: Colors.white,
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const OrderPage())); // do nó nằm trong bottomBar nên không push được NO Material
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
