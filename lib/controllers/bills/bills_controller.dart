// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/bill.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/order_detail.dart';

class BillController extends GetxController {
  //hóa đơn
  final Rx<List<Bill>> _bills = Rx<List<Bill>>([]);
  List<Bill> get bills => _bills.value;
  getBills(String employeeIdSelected, String keySearch) async {
    if (keySearch.isEmpty && employeeIdSelected == defaultEmployee) {
      //lấy tất cả hóa đơn
      print("lấy tất cả");

      _bills.bindStream(
        firestore
            .collection('orders')
            .where("active", isEqualTo: ACTIVE)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<Bill> retValue = [];
            for (var element in query.docs) {
              String order_id = element["order_id"].toString();

              Bill order = Bill.fromSnap(element);

              // //Thông tin nhân viên phụ trách đơn hàng
              // DocumentSnapshot employeeCollection = await firestore
              //     .collection('employees')
              //     .doc(order.employee_id)
              //     .get();
              // if (employeeCollection.exists) {
              //   final employeeData = employeeCollection.data();
              //   if (employeeData != null &&
              //       employeeData is Map<String, dynamic>) {
              //     String name = employeeData['name'] ?? '';
              //     order.employee_name = name;
              //   }
              // }
              // print("Nhân viên order: ${order.employee_name}");

              // // Truy vấn collection orderDetailArrayList
              // var orderDetailCollection = firestore
              //     .collection('orders')
              //     .doc(order_id)
              //     .collection('orderDetails');

              // // Tính tổng số tiền cho đơn hàng
              // double totalAmount = 0;
              // List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng
              // var orderDetailQuery = await orderDetailCollection.get();
              // for (var doc in orderDetailQuery.docs) {
              //   var orderDetail = OrderDetail.fromSnap(doc);
              //   // lấy thông tin của món ăn
              //   DocumentSnapshot foodCollection = await firestore
              //       .collection('foods')
              //       .doc(orderDetail.food_id)
              //       .get();
              //   if (foodCollection.exists) {
              //     final foodData = foodCollection.data();
              //     if (foodData != null && foodData is Map<String, dynamic>) {
              //       String food_name = foodData['name'] ?? '';
              //       String image = foodData['image'] ?? '';

              //       orderDetail.food = FoodOrderDetail(
              //           food_id: orderDetail.food_id,
              //           name: food_name,
              //           image: image);
              //       print(food_name);
              //     }
              //   }
              //   orderDetails.add(orderDetail);
              //   //không tính món đã hủy

              //   if (orderDetail.food_status != FOOD_STATUS_CANCEL) {
              //     totalAmount += orderDetail.price * orderDetail.quantity;
              //   }
              // }
              // print(orderDetails);
              // print(totalAmount);
              // order.total_amount = totalAmount;
              // order.order_details = orderDetails; // danh sách chi tiết đơn hàng
              // // lấy tên bàn, tên bàn đã gộp
              // String table_id = element['table_id'];
              // DocumentSnapshot tableCollection =
              //     await firestore.collection('tables').doc(table_id).get();
              // if (tableCollection.exists) {
              //   final tableData = tableCollection.data();
              //   if (tableData != null && tableData is Map<String, dynamic>) {
              //     String name = tableData['name'] ?? '';
              //     int total_slot = tableData['total_slot'] ?? '';
              //     int status = tableData['status'] ?? '';
              //     int active = tableData['active'] ?? '';
              //     String area_id = tableData['area_id'] ?? '';
              //     order.table = table.Table(
              //         table_id: table_id,
              //         name: name,
              //         total_slot: total_slot,
              //         status: status,
              //         active: active,
              //         area_id: area_id);
              //   }
              // }

              retValue.add(order);
            }
            return retValue;
          },
        ),
      );
    } else if (employeeIdSelected.isNotEmpty && keySearch.isEmpty) {
      // chỉ theo nhan vien - không search
      print("chỉ theo nhan vien - không search");

      _bills.bindStream(
        firestore
            .collection('orders')
            .where('employee_id', isEqualTo: employeeIdSelected)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<Bill> retValue = [];
            for (var element in query.docs) {
              String order_id = element["order_id"].toString();

              Bill order = Bill.fromSnap(element);

              //Thông tin nhân viên phụ trách đơn hàng
              // DocumentSnapshot employeeCollection = await firestore
              //     .collection('employees')
              //     .doc(order.employee_id)
              //     .get();
              // if (employeeCollection.exists) {
              //   final employeeData = employeeCollection.data();
              //   if (employeeData != null &&
              //       employeeData is Map<String, dynamic>) {
              //     String name = employeeData['name'] ?? '';
              //     order.employee_name = name;
              //   }
              // }
              // print("Nhân viên order: ${order.employee_name}");

              // // Truy vấn collection orderDetailArrayList
              // var orderDetailCollection = firestore
              //     .collection('orders')
              //     .doc(order_id)
              //     .collection('orderDetails');

              // // Tính tổng số tiền cho đơn hàng
              // double totalAmount = 0;
              // List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng
              // var orderDetailQuery = await orderDetailCollection.get();
              // for (var doc in orderDetailQuery.docs) {
              //   var orderDetail = OrderDetail.fromSnap(doc);
              //   // lấy thông tin của món ăn
              //   DocumentSnapshot foodCollection = await firestore
              //       .collection('foods')
              //       .doc(orderDetail.food_id)
              //       .get();
              //   if (foodCollection.exists) {
              //     final foodData = foodCollection.data();
              //     if (foodData != null && foodData is Map<String, dynamic>) {
              //       String food_name = foodData['name'] ?? '';
              //       String image = foodData['image'] ?? '';

              //       orderDetail.food = FoodOrderDetail(
              //           food_id: orderDetail.food_id,
              //           name: food_name,
              //           image: image);
              //       print(food_name);
              //     }
              //   }
              //   orderDetails.add(orderDetail);
              //   //không tính món đã hủy

              //   if (orderDetail.food_status != FOOD_STATUS_CANCEL) {
              //     totalAmount += orderDetail.price * orderDetail.quantity;
              //   }
              // }
              // print(orderDetails);
              // print(totalAmount);
              // order.total_amount = totalAmount;
              // order.order_details = orderDetails; // danh sách chi tiết đơn hàng
              // // lấy tên bàn, tên bàn đã gộp
              // String table_id = element['table_id'];
              // DocumentSnapshot tableCollection =
              //     await firestore.collection('tables').doc(table_id).get();
              // if (tableCollection.exists) {
              //   final tableData = tableCollection.data();
              //   if (tableData != null && tableData is Map<String, dynamic>) {
              //     String name = tableData['name'] ?? '';
              //     int total_slot = tableData['total_slot'] ?? '';
              //     int status = tableData['status'] ?? '';
              //     int active = tableData['active'] ?? '';
              //     String area_id = tableData['area_id'] ?? '';
              //     order.table = table.Table(
              //         table_id: table_id,
              //         name: name,
              //         total_slot: total_slot,
              //         status: status,
              //         active: active,
              //         area_id: area_id);
              //     print(name);
              //   }
              // }
              // retValue.add(order);
            }
            return retValue;
          },
        ),
      );
    } else if (employeeIdSelected.isNotEmpty &&
        employeeIdSelected != defaultEmployee &&
        keySearch.isNotEmpty) {
      // theo nhan vien và có search
      print("theo nhan vien và có search");

      _bills.bindStream(firestore
          .collection('orders')
          .where('employee_id', isEqualTo: employeeIdSelected)
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<Bill> retVal = [];
        for (var elem in query.docs) {
          String table_id = elem['table_id'];
          String name = elem['table_id'].toLowerCase();
          String search = keySearch.toLowerCase().trim();

          if (name.contains(search)) {
            String order_id = elem["order_id"].toString();

            Bill order = Bill.fromSnap(elem);

            //Thông tin nhân viên phụ trách đơn hàng
            // DocumentSnapshot employeeCollection = await firestore
            //     .collection('employees')
            //     .doc(order.employee_id)
            //     .get();
            // if (employeeCollection.exists) {
            //   final employeeData = employeeCollection.data();
            //   if (employeeData != null &&
            //       employeeData is Map<String, dynamic>) {
            //     String name = employeeData['name'] ?? '';
            //     order.employee_name = name;
            //   }
            // }
            // print("Nhân viên order: ${order.employee_name}");

            // // Truy vấn collection orderDetailArrayList
            // var orderDetailCollection = firestore
            //     .collection('orders')
            //     .doc(order_id)
            //     .collection('orderDetails');

            // // Tính tổng số tiền cho đơn hàng
            // double totalAmount = 0;
            // List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng
            // var orderDetailQuery = await orderDetailCollection.get();
            // for (var doc in orderDetailQuery.docs) {
            //   var orderDetail = OrderDetail.fromSnap(doc);
            //   // lấy thông tin của món ăn
            //   DocumentSnapshot foodCollection = await firestore
            //       .collection('foods')
            //       .doc(orderDetail.food_id)
            //       .get();
            //   if (foodCollection.exists) {
            //     final foodData = foodCollection.data();
            //     if (foodData != null && foodData is Map<String, dynamic>) {
            //       String food_name = foodData['name'] ?? '';
            //       String image = foodData['image'] ?? '';

            //       orderDetail.food = FoodOrderDetail(
            //           food_id: orderDetail.food_id,
            //           name: food_name,
            //           image: image);
            //       print(food_name);
            //     }
            //   }
            //   orderDetails.add(orderDetail);
            //   //không tính món đã hủy

            //   if (orderDetail.food_status != FOOD_STATUS_CANCEL) {
            //     totalAmount += orderDetail.price * orderDetail.quantity;
            //   }
            // }
            // print(orderDetails);
            // print(totalAmount);
            // order.total_amount = totalAmount;
            // order.order_details = orderDetails; // danh sách chi tiết đơn hàng
            // // lấy tên bàn, tên bàn đã gộp
            // String table_id = elem['table_id'];
            // DocumentSnapshot tableCollection =
            //     await firestore.collection('tables').doc(table_id).get();
            // if (tableCollection.exists) {
            //   final tableData = tableCollection.data();
            //   if (tableData != null && tableData is Map<String, dynamic>) {
            //     String name = tableData['name'] ?? '';
            //     int total_slot = tableData['total_slot'] ?? '';
            //     int status = tableData['status'] ?? '';
            //     int active = tableData['active'] ?? '';
            //     String area_id = tableData['area_id'] ?? '';
            //     order.table = table.Table(
            //         table_id: table_id,
            //         name: name,
            //         total_slot: total_slot,
            //         status: status,
            //         active: active,
            //         area_id: area_id);
            //     print(name);
            //   }
            // }

            // retVal.add(order);
          }
        }
        return retVal;
      }));
    } else if (employeeIdSelected == defaultEmployee && keySearch.isNotEmpty) {
      //tìm kiếm theo nhan vien
      print("tìm kiếm theo nhan vien");
      _bills.bindStream(firestore
          .collection('orders')
          .orderBy('name')
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<Bill> retVal = [];
        for (var elem in query.docs) {
          String name = elem['table_id'];
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            String order_id = elem["order_id"].toString();

            Bill order = Bill.fromSnap(elem);

            //Thông tin nhân viên phụ trách đơn hàng
            // DocumentSnapshot employeeCollection = await firestore
            //     .collection('employees')
            //     .doc(order.employee_id)
            //     .get();
            // if (employeeCollection.exists) {
            //   final employeeData = employeeCollection.data();
            //   if (employeeData != null &&
            //       employeeData is Map<String, dynamic>) {
            //     String name = employeeData['name'] ?? '';
            //     order.employee_name = name;
            //   }
            // }
            // print("Nhân viên order: ${order.employee_name}");

            // // Truy vấn collection orderDetailArrayList
            // var orderDetailCollection = firestore
            //     .collection('orders')
            //     .doc(order_id)
            //     .collection('orderDetails');

            // // Tính tổng số tiền cho đơn hàng
            // double totalAmount = 0;
            // List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng
            // var orderDetailQuery = await orderDetailCollection.get();
            // for (var doc in orderDetailQuery.docs) {
            //   var orderDetail = OrderDetail.fromSnap(doc);

            //   // lấy thông tin của món ăn
            //   DocumentSnapshot foodCollection = await firestore
            //       .collection('foods')
            //       .doc(orderDetail.food_id)
            //       .get();
            //   if (foodCollection.exists) {
            //     final foodData = foodCollection.data();
            //     if (foodData != null && foodData is Map<String, dynamic>) {
            //       String food_name = foodData['name'] ?? '';
            //       String image = foodData['image'] ?? '';

            //       orderDetail.food = FoodOrderDetail(
            //           food_id: orderDetail.food_id,
            //           name: food_name,
            //           image: image);
            //       print(food_name);
            //     }
            //   }

            //   orderDetails.add(orderDetail);
            //   //không tính món đã hủy

            //   if (orderDetail.food_status != FOOD_STATUS_CANCEL) {
            //     totalAmount += orderDetail.price * orderDetail.quantity;
            //   }
            // }
            // print(orderDetails);
            // print(totalAmount);
            // order.total_amount = totalAmount;
            // order.order_details = orderDetails; // danh sách chi tiết đơn hàng
            // // lấy tên bàn, tên bàn đã gộp
            // String table_id = elem['table_id'];
            // DocumentSnapshot tableCollection =
            //     await firestore.collection('tables').doc(table_id).get();
            // if (tableCollection.exists) {
            //   final tableData = tableCollection.data();
            //   if (tableData != null && tableData is Map<String, dynamic>) {
            //     String name = tableData['name'] ?? '';
            //     int total_slot = tableData['total_slot'] ?? '';
            //     int status = tableData['status'] ?? '';
            //     int active = tableData['active'] ?? '';
            //     String area_id = tableData['area_id'] ?? '';
            //     order.table = table.Table(
            //         table_id: table_id,
            //         name: name,
            //         total_slot: total_slot,
            //         status: status,
            //         active: active,
            //         area_id: area_id);
            //     print(name);
            //   }
            // }
            // retVal.add(order);
          }
        }
        return retVal;
      }));
    }
  }

  // final Rx<Bill> _orderDetail = Rx<Bill>(Bill(bill_id: '', order: model.Order(), order_detail: null, total_amount: null
  //     ));

  // //lấy 1 order
  // Bill get orderDetail => _orderDetail.value;
  // getOrderDetailById(Bill order) async {
  //   _orderDetail.bindStream(
  //     firestore
  //         .collection('orders')
  //         .doc(order.order_id)
  //         .collection('orderDetails')
  //         .snapshots()
  //         .asyncMap(
  //       (QuerySnapshot query) async {
  //         Bill retValue = Bill(
  //             order_id: '',
  //             order_status: 0,
  //             create_at: Timestamp.now(),
  //             active: 1,
  //             employee_id: '',
  //             table_id: '',
  //             vat_id: '',
  //             discount_id: '');
  //         retValue.order_id = order.order_id;
  //         List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng

  //         for (var element in query.docs) {
  //           OrderDetail orderDetail =
  //               OrderDetail.fromSnap(element); // map đơn hàng chi tiết

  //           orderDetails.add(orderDetail);
  //         }
  //         retValue.order_details = orderDetails;
  //         // Tính tổng số tiền cho đơn hàng
  //         double totalAmount = 0;
  //         for (int i = 0; i < orderDetails.length; i++) {
  //           // lấy thông tin của món ăn
  //           DocumentSnapshot foodCollection = await firestore
  //               .collection('foods')
  //               .doc(orderDetails[i].food_id)
  //               .get();
  //           if (foodCollection.exists) {
  //             final foodData = foodCollection.data();
  //             if (foodData != null && foodData is Map<String, dynamic>) {
  //               String food_name = foodData['name'] ?? '';
  //               String image = foodData['image'] ?? '';

  //               retValue.order_details[i].food = FoodOrderDetail(
  //                   food_id: orderDetails[i].food_id,
  //                   name: food_name,
  //                   image: image);
  //               print(food_name);
  //             }
  //           }
  //           //không tính món đã hủy
  //           if (retValue.order_details[i].food_status != FOOD_STATUS_CANCEL) {
  //             totalAmount += retValue.order_details[i].price *
  //                 retValue.order_details[i].quantity;
  //           }
  //         }

  //         print(orderDetails);
  //         print(totalAmount);
  //         retValue.total_amount = totalAmount; // tính tổng tiền
  //         // lấy tên bàn, tên bàn đã gộp
  //         DocumentSnapshot tableCollection =
  //             await firestore.collection('tables').doc(order.table_id).get();
  //         if (tableCollection.exists) {
  //           final tableData = tableCollection.data();
  //           if (tableData != null && tableData is Map<String, dynamic>) {
  //             String name = tableData['name'] ?? '';
  //             int total_slot = tableData['total_slot'] ?? '';
  //             int status = tableData['status'] ?? '';
  //             int active = tableData['active'] ?? '';
  //             String area_id = tableData['area_id'] ?? '';
  //             retValue.table = table.Table(
  //                 table_id: order.table_id,
  //                 name: name,
  //                 total_slot: total_slot,
  //                 status: status,
  //                 active: active,
  //                 area_id: area_id);
  //           }
  //         }

  //         print("ORDER DETAIL: ${retValue.total_amount}");

  //         //Thông tin nhân viên phụ trách đơn hàng
  //         if (order.employee_id != "") {
  //           DocumentSnapshot employeeCollection = await firestore
  //               .collection('employees')
  //               .doc(order.employee_id)
  //               .get();
  //           if (employeeCollection.exists) {
  //             final employeeData = employeeCollection.data();
  //             if (employeeData != null &&
  //                 employeeData is Map<String, dynamic>) {
  //               String name = employeeData['name'] ?? '';
  //               order.employee_name = name;
  //             }
  //           }
  //         }
  //         print("Nhân viên order: ${order.employee_name}");

  //         int vat_percent = 0; // vat được áp dụng
  //         // lấy thông tin thuế
  //         if (order.vat_id != "") {
  //           DocumentSnapshot vatCollection =
  //               await firestore.collection('vats').doc(order.vat_id).get();
  //           if (vatCollection.exists) {
  //             final vatData = vatCollection.data();
  //             if (vatData != null && vatData is Map<String, dynamic>) {
  //               String name = vatData['name'] ?? '';
  //               vat_percent = vatData['vat_percent'] ?? 0; // lấy % vat
  //               retValue.vat_name = name;
  //             }
  //           }
  //         }
  //         print(order.vat_id);
  //         print("VAT đã áp dụng: ${retValue.vat_name} - $vat_percent");

  //         // lấy thông tin giảm giá
  //         double discount_price = 0; // giảm giá được áp dụng
  //         if (order.discount_id != "") {
  //           DocumentSnapshot discountCollection = await firestore
  //               .collection('discounts')
  //               .doc(order.discount_id)
  //               .get();

  //           if (discountCollection.exists) {
  //             final discountData = discountCollection.data();
  //             if (discountData != null &&
  //                 discountData is Map<String, dynamic>) {
  //               String name = discountData['name'] ?? '';
  //               discount_price = discountData['discount_price'] ?? 0;
  //               retValue.discount_name = name;
  //             }
  //           }
  //         }
  //         print(order.discount_id);
  //         print(
  //             "DISCOUNT đã áp dụng: ${retValue.discount_name} - $discount_price");

  //         print("Tổng tiền ban đầu: ${retValue.total_amount}");

  //         //TỔNG HÓA ĐƠN CẦN THANH TOÁN:
  //         //totalAmount: tổng tiền hóa đơn
  //         //vat_percent: phần trăm thuế được áp dụng
  //         //vat_price: tiền thuế được áp dụng
  //         //discount_price: giảm giá được áp dụng

  //         double vat_price = (totalAmount * vat_percent) / 100;
  //         totalAmount = totalAmount - discount_price + vat_price;

  //         retValue.total_vat_amount = vat_price;
  //         retValue.total_discount_amount = discount_price;

  //         retValue.total_amount = totalAmount;
  //         print("Tổng tiền sau discount - vat: ${retValue.total_amount}");

  //         return retValue;
  //       },
  //     ),
  //   );
  // }

  // tao hóa đơn

  void createBill(model.Order order, double? vat_amount, double? discount_amount,
      BuildContext context) async {
    try {
      var allDocs = await firestore.collection('bills').get();
      int len = allDocs.docs.length;
      
      //total_amount: tổng tiền đơn hàng đã cộng trừ vat và discount -> số tiền thực tế phải trả
      //vat_amount: tổng tiền vat đã áp dụng cho đơn hàng
      //discount_amount: tổng tiền giảm giá đã áp dụng cho đơn hàng

      Bill bill = Bill(
          bill_id: 'Bill-$len', order_id: order.order_id, total_amount: order.total_amount ?? 0, vat_amount: vat_amount ?? 0, discount_amount: discount_amount ?? 0);

      CollectionReference billsCollection =
          FirebaseFirestore.instance.collection('bills');

      await billsCollection.doc('Bill-$len').set(bill.toJson());

      //Cập nhật trạng thái đơn hàng -> đã thanh toán
      await firestore.collection('orders').doc(order.order_id).update({
        "order_status": ORDER_STATUS_PAID, // đã thanh toán
        "payment_at": Timestamp.now(), // đã thanh toán
        "active": DEACTIVE // đã thanh toán
      });

      Get.snackbar(
        'THÀNH CÔNG!',
        'Thanh toán thành công!',
        backgroundColor: backgroundSuccessColor,
        colorText: Colors.white,
      );
      Navigator.pop(context);
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
