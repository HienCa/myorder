// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/food_order_detail.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/table.dart' as table;
import 'package:myorder/models/order_detail.dart';

class OrderController extends GetxController {
  //don hang
  final Rx<List<model.Order>> _orders = Rx<List<model.Order>>([]);
  List<model.Order> get orders => _orders.value;
  getOrders(String employeeIdSelected, String keySearch) async {
    if (keySearch.isEmpty && employeeIdSelected == defaultEmployee) {
      //lấy tất cả don hang
      print("lấy tất cả");

      _orders.bindStream(
        firestore
            .collection('orders')
            .where("active", isEqualTo: ACTIVE)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<model.Order> retValue = [];
            for (var element in query.docs) {
              String order_id = element["order_id"].toString();
              model.Order order = model.Order.fromSnap(element);

              // Truy vấn collection orderDetailArrayList
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
                totalAmount += orderDetail.price * orderDetail.quantity;
              }
              print(orderDetails);
              print(totalAmount);
              order.total_amount = totalAmount;
              order.order_details = orderDetails; // danh sách chi tiết đơn hàng
              // lấy tên bàn, tên bàn đã gộp
              String table_id = element['table_id'];
              DocumentSnapshot tableCollection =
                  await firestore.collection('tables').doc(table_id).get();
              if (tableCollection.exists) {
                final tableData = tableCollection.data();
                if (tableData != null && tableData is Map<String, dynamic>) {
                  String name = tableData['name'] ?? '';
                  int total_slot = tableData['total_slot'] ?? '';
                  int status = tableData['status'] ?? '';
                  int active = tableData['active'] ?? '';
                  String area_id = tableData['area_id'] ?? '';
                  order.table = table.Table(
                      table_id: table_id,
                      name: name,
                      total_slot: total_slot,
                      status: status,
                      active: active,
                      area_id: area_id);
                }
              }

              retValue.add(order);
            }
            return retValue;
          },
        ),
      );
    } else if (employeeIdSelected.isNotEmpty && keySearch.isEmpty) {
      // chỉ theo nhan vien - không search
      print("chỉ theo nhan vien - không search");

      _orders.bindStream(
        firestore
            .collection('orders')
            .where('employee_id', isEqualTo: employeeIdSelected)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<model.Order> retValue = [];
            for (var element in query.docs) {
              String order_id = element["order_id"].toString();

              model.Order order = model.Order.fromSnap(element);

              // Truy vấn collection orderDetailArrayList
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
                totalAmount += orderDetail.price * orderDetail.quantity;
              }
              print(orderDetails);
              print(totalAmount);
              order.total_amount = totalAmount;
              order.order_details = orderDetails; // danh sách chi tiết đơn hàng
              // lấy tên bàn, tên bàn đã gộp
              String table_id = element['table_id'];
              DocumentSnapshot tableCollection =
                  await firestore.collection('tables').doc(table_id).get();
              if (tableCollection.exists) {
                final tableData = tableCollection.data();
                if (tableData != null && tableData is Map<String, dynamic>) {
                  String name = tableData['name'] ?? '';
                  int total_slot = tableData['total_slot'] ?? '';
                  int status = tableData['status'] ?? '';
                  int active = tableData['active'] ?? '';
                  String area_id = tableData['area_id'] ?? '';
                  order.table = table.Table(
                      table_id: table_id,
                      name: name,
                      total_slot: total_slot,
                      status: status,
                      active: active,
                      area_id: area_id);
                  print(name);
                }
              }
              retValue.add(order);
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

      _orders.bindStream(firestore
          .collection('orders')
          .where('employee_id', isEqualTo: employeeIdSelected)
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<model.Order> retVal = [];
        for (var elem in query.docs) {
          String table_id = elem['table_id'];
          String name = elem['table_id'].toLowerCase();
          String search = keySearch.toLowerCase().trim();

          if (name.contains(search)) {
            String order_id = elem["order_id"].toString();

            model.Order order = model.Order.fromSnap(elem);

            // Truy vấn collection orderDetailArrayList
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
              totalAmount += orderDetail.price * orderDetail.quantity;
            }
            print(orderDetails);
            print(totalAmount);
            order.total_amount = totalAmount;
            order.order_details = orderDetails; // danh sách chi tiết đơn hàng
            // lấy tên bàn, tên bàn đã gộp
            String table_id = elem['table_id'];
            DocumentSnapshot tableCollection =
                await firestore.collection('tables').doc(table_id).get();
            if (tableCollection.exists) {
              final tableData = tableCollection.data();
              if (tableData != null && tableData is Map<String, dynamic>) {
                String name = tableData['name'] ?? '';
                int total_slot = tableData['total_slot'] ?? '';
                int status = tableData['status'] ?? '';
                int active = tableData['active'] ?? '';
                String area_id = tableData['area_id'] ?? '';
                order.table = table.Table(
                    table_id: table_id,
                    name: name,
                    total_slot: total_slot,
                    status: status,
                    active: active,
                    area_id: area_id);
                print(name);
              }
            }

            retVal.add(order);
          }
        }
        return retVal;
      }));
    } else if (employeeIdSelected == defaultEmployee && keySearch.isNotEmpty) {
      //tìm kiếm theo nhan vien
      print("tìm kiếm theo nhan vien");
      _orders.bindStream(firestore
          .collection('orders')
          .orderBy('name')
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<model.Order> retVal = [];
        for (var elem in query.docs) {
          String name = elem['table_id'];
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            String order_id = elem["order_id"].toString();

            model.Order order = model.Order.fromSnap(elem);

            // Truy vấn collection orderDetailArrayList
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
              totalAmount += orderDetail.price * orderDetail.quantity;
            }
            print(orderDetails);
            print(totalAmount);
            order.total_amount = totalAmount;
            order.order_details = orderDetails; // danh sách chi tiết đơn hàng
            // lấy tên bàn, tên bàn đã gộp
            String table_id = elem['table_id'];
            DocumentSnapshot tableCollection =
                await firestore.collection('tables').doc(table_id).get();
            if (tableCollection.exists) {
              final tableData = tableCollection.data();
              if (tableData != null && tableData is Map<String, dynamic>) {
                String name = tableData['name'] ?? '';
                int total_slot = tableData['total_slot'] ?? '';
                int status = tableData['status'] ?? '';
                int active = tableData['active'] ?? '';
                String area_id = tableData['area_id'] ?? '';
                order.table = table.Table(
                    table_id: table_id,
                    name: name,
                    total_slot: total_slot,
                    status: status,
                    active: active,
                    area_id: area_id);
                print(name);
              }
            }
            retVal.add(order);
          }
        }
        return retVal;
      }));
    }
  }

  final Rx<model.Order> _orderDetail = Rx<model.Order>(model.Order(
      order_id: '',
      order_status: 0,
      create_at: Timestamp.now(),
      active: 1,
      employee_id: '',
      table_id: ''));

  model.Order get orderDetail => _orderDetail.value;
  getOrderDetailById(model.Order order) async {
    _orderDetail.bindStream(
      firestore
          .collection('orders')
          .doc(order.order_id)
          .collection('orderDetails')
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          model.Order retValue = model.Order(
              order_id: '',
              order_status: 0,
              create_at: Timestamp.now(),
              active: 1,
              employee_id: '',
              table_id: '');
          retValue.order_id = order.order_id;
          List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng
          for (var element in query.docs) {
            OrderDetail orderDetail =
                OrderDetail.fromSnap(element); // map đơn hàng chi tiết

            orderDetails.add(orderDetail);
          }
          retValue.order_details = orderDetails;
          // Tính tổng số tiền cho đơn hàng
          double totalAmount = 0;
          for (int i = 0; i < orderDetails.length; i++) {
            // lấy thông tin của món ăn
            DocumentSnapshot foodCollection = await firestore
                .collection('foods')
                .doc(orderDetails[i].food_id)
                .get();
            if (foodCollection.exists) {
              final foodData = foodCollection.data();
              if (foodData != null && foodData is Map<String, dynamic>) {
                String food_name = foodData['name'] ?? '';
                String image = foodData['image'] ?? '';

                retValue.order_details[i].food = FoodOrderDetail(
                    food_id: orderDetails[i].food_id,
                    name: food_name,
                    image: image);
                print(food_name);
              }
            }
            totalAmount += retValue.order_details[i].price *
                retValue.order_details[i].quantity;
          }
          print(orderDetails);
          print(totalAmount);
          retValue.total_amount = totalAmount; // tính tổng tiền
          print("retValue.total_amount: ${retValue.total_amount}");
          // lấy tên bàn, tên bàn đã gộp
          DocumentSnapshot tableCollection =
              await firestore.collection('tables').doc(order.table_id).get();
          if (tableCollection.exists) {
            final tableData = tableCollection.data();
            if (tableData != null && tableData is Map<String, dynamic>) {
              String name = tableData['name'] ?? '';
              int total_slot = tableData['total_slot'] ?? '';
              int status = tableData['status'] ?? '';
              int active = tableData['active'] ?? '';
              String area_id = tableData['area_id'] ?? '';
              retValue.table = table.Table(
                  table_id: order.table_id,
                  name: name,
                  total_slot: total_slot,
                  status: status,
                  active: active,
                  area_id: area_id);
            }
          }
          print("ORDER DETAIL: ${retValue.total_amount}");
          return retValue;
        },
      ),
    );
  }

  // tao order
  //them tung orderdetail
  void createOrder(String table_id, List<OrderDetail> orderDetailList,
      BuildContext context) async {
    try {
      //kiểm tra xem don hang đã được order chưa
      var tableOrdered = await firestore
          .collection("orders")
          .where("table_id", isEqualTo: table_id)
          .where("active", isEqualTo: ACTIVE)
          .get();

      if (tableOrdered.docs.isEmpty) {
        //nếu don hang đang trống thì tạo order mới
        var allDocs = await firestore.collection('orders').get();
        int len = allDocs.docs.length;
        // bo sung them note neu can
        model.Order Order = model.Order(
          order_id: 'Order-$len',
          table_id: table_id,
          employee_id: authController.user.uid,
          order_status: FOOD_STATUS_IN_CHEFT,
          note: "",
          create_at: Timestamp.fromDate(DateTime.now()),
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

        // cập nhật trạng thái don hang empty -> serving
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
            .doc(order_id) //order_id của don hang hiện đang được phục vụ
            .collection("orderDetails")
            .get();

        print(order_id);
        int orderDetaillen =
            allDocsOrderDetail.docs.length; // lay count cua order detail

        for (OrderDetail orderDetail in orderDetailList) {
          orderDetail.order_detail_id = "OrderDetail-$orderDetaillen";

          await firestore
              .collection('orders')
              .doc(order_id) //order_id của don hang hiện đang được phục vụ
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

  //HỦY MÓN
  cancelFoodByOrder(
    // cung cấp order detail id (đại diện cho món ăn) thuộc order nào
    String order_id,
    String order_detail_id,
  ) async {
    try {
      if (order_id != "" && order_detail_id != "") {
        // cho order detail (món ăn) về trạng thái hủy
        await firestore
            .collection('orders')
            .doc(order_id)
            .collection('orderDetails')
            .doc(order_detail_id)
            .update({
          "food_status": FOOD_STATUS_CANCEL,
        });
        Get.snackbar(
          'THÀNH CÔNG!',
          'Hủy món thành công!',
          backgroundColor: backgroundSuccessColor,
          colorText: Colors.white,
        );
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Hủy món thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }
}
