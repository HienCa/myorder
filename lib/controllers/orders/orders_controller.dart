// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/order_detail.dart';

class OrderController extends GetxController {
  // getOrderById(String Order_id) async {
  //   try {
  //     DocumentSnapshot order =
  //         await firestore.collection('Orders').doc(Order_id).get();
  //     if (order.exists) {
  //       final userData = order.data();
  //       if (userData != null && userData is Map<String, dynamic>) {
  //         String Order_id = userData['Order_id'] ?? '';
  //         String name = userData['name'] ?? '';

  //         int active = userData['active'] ?? 1;
  //         return Order(Order_id: Order_id, name: name, active: active);
  //       }
  //     }
  //   } catch (e) {
  //     print('Error fetching user data: $e');
  //     return Order(Order_id: Order_id, name: "", active: 1);
  //   }
  // }

  // final Rx<List<model.Order>> _Orders = Rx<List<model.Order>>([]);
  // List<model.Order> get Orders => _Orders.value;

  // getOrders(String keySearch) async {
  //   if (keySearch.isEmpty) {
  //     _Orders.bindStream(
  //       firestore.collection('orders').snapshots().map(
  //         (QuerySnapshot query) {
  //           List<model.Order> retValue = [];
  //           for (var element in query.docs) {
  //             retValue.add(model.Order.fromSnap(element));
  //             print(element);
  //           }
  //           return retValue;
  //         },
  //       ),
  //     );
  //   } else {
  //     _Orders.bindStream(firestore
  //         .collection('orders')
  //         .orderBy('name')
  //         .snapshots()
  //         .map((QuerySnapshot query) {
  //       List<model.Order> retVal = [];
  //       for (var elem in query.docs) {
  //         String name = elem['name'].toLowerCase();
  //         String search = keySearch.toLowerCase().trim();
  //         if (name.contains(search)) {
  //           retVal.add(model.Order.fromSnap(elem));
  //         }
  //       }
  //       return retVal;
  //     }));
  //   }
  // }

  // final Rx<List<model.Order>> _OrdersActive = Rx<List<model.Order>>([]);
  // List<model.Order> get OrdersActive => _OrdersActive.value;
  // getOrdersActive() async {
  //   _OrdersActive.bindStream(
  //     firestore.collection('orders').snapshots().map(
  //       (QuerySnapshot query) {
  //         List<model.Order> retValue = [];
  //         for (var element in query.docs) {
  //           retValue.add(model.Order.fromSnap(element));
  //           print(element);
  //         }
  //         return retValue;
  //       },
  //     ),
  //   );
  // }

  // tao order
  //them tung orderdetail
  void createOrder(String table_id, List<OrderDetail> orderDetailList,
      BuildContext context) async {
    try {
      //kiểm tra xem bàn đã được order chưa
      var tableOrdered = await firestore
          .collection("orders")
          .where("table_id", isEqualTo: table_id)
          .where("active", isEqualTo: ACTIVE)
          .get();

      if (tableOrdered.docs.isEmpty) {
        //nếu bàn đang trống thì tạo order mới
        var allDocs = await firestore.collection('orders').get();
        int len = allDocs.docs.length;
        // bo sung them note neu can
        model.Order Order = model.Order(
          order_id: 'Order-$len',
          table_id: table_id,
          employee_id: authController.user.uid,
          order_status: FOOD_STATUS_IN_CHEFT,
          note: "",
          create_at: DateTime.now(),
          payment_at: null,
          active: 1,
        );
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('orders');

        await usersCollection.doc('Order-$len').set(Order.toJson());

        // add order detail
        var allDocsOrderDetail = await firestore
            .collection('orders')
            .doc('Order-$len')
            .collection("orderDetails")
            .get();
        int orderDetaillen =
            allDocsOrderDetail.docs.length; // lay count cua order detail

        for (OrderDetail orderDetail in orderDetailList) {
          orderDetail.order_detail_id = "OrderDetail-$orderDetaillen";

          await firestore
              .collection('orders')
              .doc('Order-$len')
              .collection("orderDetails")
              .doc("OrderDetail-$orderDetaillen")
              .set(orderDetail.toJson());

          orderDetaillen++;
        }

        // cập nhật trạng thái bàn empty -> serving
        await firestore.collection('tables').doc(table_id).update({
          "status": TABLE_STATUS_SERVING, // đang phục vụ
        });
      } else {
        // thêm foods vào order hiện tại đang phục vụ
        // add order detail
        var order_id = "";
        for (var doc in tableOrdered.docs) {
          // Lấy order_id từ mỗi tài liệu và thêm vào danh sách
          order_id = doc.id;
        }
        var allDocsOrderDetail = await firestore
            .collection('orders')
            .doc(order_id) //order_id của bàn hiện đang được phục vụ
            .collection("orderDetails")
            .get();

        print(order_id);
        int orderDetaillen =
            allDocsOrderDetail.docs.length; // lay count cua order detail

        for (OrderDetail orderDetail in orderDetailList) {
          orderDetail.order_detail_id = "OrderDetail-$orderDetaillen";

          await firestore
              .collection('orders')
              .doc(order_id) //order_id của bàn hiện đang được phục vụ
              .collection("orderDetails")
              .doc("OrderDetail-$orderDetaillen")
              .set(orderDetail.toJson());

          orderDetaillen++;
        }
      }

      Get.snackbar(
        'THÀNH CÔNG!',
        'Thêm mới thành công!',
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

  // updateOrder(
  //   String Order_id,
  //   String name,
  //   bool active,
  // ) async {
  //   try {
  //     final tableCollection = FirebaseFirestore.instance.collection('orders');
  //     bool isFound = false;
  //     final List<QueryDocumentSnapshot> notMatchingOrderDocs = [];

  //     final existingTableQuery =
  //         await tableCollection.where('Order_id', isNotEqualTo: Order_id).get();
  //     for (final doc in existingTableQuery.docs) {
  //       notMatchingOrderDocs.add(doc);
  //     }
  //     for (final doc in notMatchingOrderDocs) {
  //       final String namedb = doc.get('name') as String;
  //       if (namedb == name) {
  //         isFound = true;
  //         break;
  //       }
  //     }

  //     if (isFound) {
  //       Get.snackbar(
  //         'Thất bại!',
  //         'Tên khu vực đã tồn tại!',
  //         backgroundColor: backgroundFailureColor,
  //         colorText: Colors.white,
  //       );
  //     } else {
  //       await firestore.collection('orders').doc(Order_id).update({
  //         "name": name.trim(),
  //         "active": active ? ACTIVE : DEACTIVE,
  //       });
  //       Get.snackbar(
  //         'THÀNH CÔNG!',
  //         'Cập nhật thông tin thành công!',
  //         backgroundColor: backgroundSuccessColor,
  //         colorText: Colors.white,
  //       );
  //       update();
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Cập nhật thất bại!',
  //       e.toString(),
  //       backgroundColor: backgroundFailureColor,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  // // Block account
  // updateToggleActive(
  //   String Order_id,
  //   int active,
  // ) async {
  //   try {
  //     await firestore.collection('orders').doc(Order_id).update({
  //       "active": active == ACTIVE ? DEACTIVE : ACTIVE,
  //     });

  //     Get.snackbar(
  //       'THÀNH CÔNG!',
  //       'Cập nhật thông tin thành công!',
  //       backgroundColor: backgroundSuccessColor,
  //       colorText: Colors.white,
  //     );
  //     update();
  //   } catch (e) {
  //     Get.snackbar(
  //       'Cập nhật thất bại!',
  //       e.toString(),
  //       backgroundColor: backgroundFailureColor,
  //       colorText: Colors.white,
  //     );
  //   }
  // }
}
