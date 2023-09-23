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

  
}
