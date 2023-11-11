// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously, unused_local_variable, library_prefixes

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/chef_bar.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/table.dart' as table;
import 'package:myorder/models/food.dart' as modelFood;
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/utils.dart';

class OrderController extends GetxController {
  //BOOKING
  /* 
    ************* TẠO ĐƠN HÀNG BOOKING
    - Khi booking thì chỉ ghi nhận đơn hàng.
    - Không cập nhật trạng thái bàn sang BOOKING -> bàn vẫn ở trạng thái EMPTY và có thể nhận khách
    - Trạng thái đơn hàng (active) booking là ACTIVE
    - Trạng thái đơn hàng (order_status) booking là ORDER_STATUS_BOOKING
    -Chưa gửi bếp/bar

    ************* LẤY THÔNG TIN ĐƠN HÀNG
  Kiểm tra đơn hàng BOOKING (có customer_time_booking), 
    1. Nếu trước thời gian booking 30p và sau 1h thì:
     Kiểm tra bàn đã được booking có EMPTY không?
      - Nếu có thì sẽ cập nhật trạng thái:
          TABLE: EMPTY -> BOOKING

      - Nếu không EMPTY thì không cập nhật -> Yêu cầu nhân viên đổi bàn khác phù hợp -> xin lỗi khách -> sự bất tiện của quán

      ->>>> Nếu khách đã tới -> xác nhận đơn hàng -> cần phục vụ
          TABLE: BOOKING -> SERVING
          Trạng thái đơn hàng (order_status) booking là ORDER_STATUS_SERVING
          GỬI BẾP BAR NẾU CÓ ORDER TỪ TRƯỚC

    2. Nếu sau thời gian booking 1h thì:
      - Cập nhật hủy phục vụ đơn hàng booking này (active) là DEACTIVE
      - Trạng thái đơn hàng (order_status) booking là ORDER_STATUS_CANCEL
      - Trường hợp khách đến sau 1 giờ thì chọn bàn phục vụ bình thường, không cần booking -> quá giờ quy định.
  */

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
            // .where('order_status', isEqualTo: ORDER_STATUS_SERVING)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<model.Order> retValue = [];
            for (var element in query.docs) {
              String order_id = element["order_id"].toString();

              model.Order order = model.Order.fromSnap(element);

              //Thông tin nhân viên phụ trách đơn hàng
              DocumentSnapshot employeeCollection = await firestore
                  .collection('employees')
                  .doc(order.employee_id)
                  .get();
              if (employeeCollection.exists) {
                final employeeData = employeeCollection.data();
                if (employeeData != null &&
                    employeeData is Map<String, dynamic>) {
                  String name = employeeData['name'] ?? '';
                  order.employee_name = name;
                }
              }
              print("Nhân viên order: ${order.employee_name}");

              // Truy vấn collection orderDetailArrayList
              var orderDetailCollection = firestore
                  .collection('orders')
                  .doc(order_id)
                  .collection('orderDetails');

              // Tính tổng số tiền cho đơn hàng
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
                    modelFood.Food food =
                        modelFood.Food.fromSnap(foodCollection);
                    orderDetail.food = food;
                  }
                }
                orderDetails.add(orderDetail);
                //không tính món đã hủy
              }

              if (order.total_amount < 0) {
                order.total_amount = 0;
              }
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

                //CHECK BOOKING

                if (Utils.isNearBookingTime(order.customer_time_booking)) {
                  //KIỂM TRA TRƯỚC GIỜ BOOKING 30P VÀ TRỄ 1H

                  //- Nếu không EMPTY thì không cập nhật -> Yêu cầu nhân viên đổi bàn khác phù hợp -> xin lỗi khách -> sự bất tiện của quán
                  if (order.table!.status == TABLE_STATUS_EMPTY) {
                    // cập nhật trạng thái don hang empty -> serving
                    await firestore.collection('tables').doc(table_id).update({
                      "status": TABLE_STATUS_BOOKING, // đang booking
                    });
                  }
                } else if (Utils.isAfterOneHourFromBookingTime(
                    order.customer_time_booking)) {
                  //KIỂM TRA SAU GIỜ BOOKING 1H
                  await firestore
                      .collection('orders')
                      .doc(order.order_id)
                      .update({
                    "active": DEACTIVE, // đang booking
                    "order_status": ORDER_STATUS_CANCEL, // đang booking
                  });
                  // cập nhật trạng thái don hang empty -> serving
                  await firestore.collection('tables').doc(table_id).update({
                    "status": TABLE_STATUS_EMPTY, // đang booking
                  });
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
            .where("active", isEqualTo: ACTIVE)
            // .where('order_status', isEqualTo: ORDER_STATUS_SERVING)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<model.Order> retValue = [];
            for (var element in query.docs) {
              String order_id = element["order_id"].toString();

              model.Order order = model.Order.fromSnap(element);

              //Thông tin nhân viên phụ trách đơn hàng
              DocumentSnapshot employeeCollection = await firestore
                  .collection('employees')
                  .doc(order.employee_id)
                  .get();
              if (employeeCollection.exists) {
                final employeeData = employeeCollection.data();
                if (employeeData != null &&
                    employeeData is Map<String, dynamic>) {
                  String name = employeeData['name'] ?? '';
                  order.employee_name = name;
                }
              }
              print("Nhân viên order: ${order.employee_name}");

              // Truy vấn collection orderDetailArrayList
              var orderDetailCollection = firestore
                  .collection('orders')
                  .doc(order_id)
                  .collection('orderDetails');

              // Tính tổng số tiền cho đơn hàng
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
                    modelFood.Food food =
                        modelFood.Food.fromSnap(foodCollection);
                    orderDetail.food = food;
                  }
                }
                orderDetails.add(orderDetail);
              }

              order.order_details = orderDetails; // danh sách chi tiết đơn hàng
              if (order.total_amount < 0) {
                order.total_amount = 0;
              }
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

                //CHECK BOOKING

                if (Utils.isNearBookingTime(order.customer_time_booking)) {
                  //KIỂM TRA TRƯỚC GIỜ BOOKING 30P VÀ TRỄ 1H

                  //- Nếu không EMPTY thì không cập nhật -> Yêu cầu nhân viên đổi bàn khác phù hợp -> xin lỗi khách -> sự bất tiện của quán
                  if (order.table!.status == TABLE_STATUS_EMPTY) {
                    // cập nhật trạng thái don hang empty -> serving
                    await firestore.collection('tables').doc(table_id).update({
                      "status": TABLE_STATUS_BOOKING, // đang booking
                    });
                  }
                } else if (Utils.isAfterOneHourFromBookingTime(
                    order.customer_time_booking)) {
                  //KIỂM TRA SAU GIỜ BOOKING 1H
                  await firestore
                      .collection('orders')
                      .doc(order.order_id)
                      .update({
                    "active": DEACTIVE, // đang booking
                    "order_status": ORDER_STATUS_CANCEL, // đang booking
                  });
                  // cập nhật trạng thái don hang empty -> serving
                  await firestore.collection('tables').doc(table_id).update({
                    "status": TABLE_STATUS_EMPTY, // đang booking
                  });
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
          .where("active", isEqualTo: ACTIVE)
          // .where('order_status', isEqualTo: ORDER_STATUS_SERVING)
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

            //Thông tin nhân viên phụ trách đơn hàng
            DocumentSnapshot employeeCollection = await firestore
                .collection('employees')
                .doc(order.employee_id)
                .get();
            if (employeeCollection.exists) {
              final employeeData = employeeCollection.data();
              if (employeeData != null &&
                  employeeData is Map<String, dynamic>) {
                String name = employeeData['name'] ?? '';
                order.employee_name = name;
              }
            }
            print("Nhân viên order: ${order.employee_name}");

            // Truy vấn collection orderDetailArrayList
            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order_id)
                .collection('orderDetails');

            // Tính tổng số tiền cho đơn hàng
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
                  modelFood.Food food = modelFood.Food.fromSnap(foodCollection);
                  orderDetail.food = food;
                }
              }
              orderDetails.add(orderDetail);
            }

            order.order_details = orderDetails; // danh sách chi tiết đơn hàng
            if (order.total_amount < 0) {
              order.total_amount = 0;
            }
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

              //CHECK BOOKING

              if (Utils.isNearBookingTime(order.customer_time_booking)) {
                //KIỂM TRA TRƯỚC GIỜ BOOKING 30P VÀ TRỄ 1H

                //- Nếu không EMPTY thì không cập nhật -> Yêu cầu nhân viên đổi bàn khác phù hợp -> xin lỗi khách -> sự bất tiện của quán
                if (order.table!.status == TABLE_STATUS_EMPTY) {
                  // cập nhật trạng thái don hang empty -> serving
                  await firestore.collection('tables').doc(table_id).update({
                    "status": TABLE_STATUS_BOOKING, // đang booking
                  });
                }
              } else if (Utils.isAfterOneHourFromBookingTime(
                  order.customer_time_booking)) {
                //KIỂM TRA SAU GIỜ BOOKING 1H
                await firestore
                    .collection('orders')
                    .doc(order.order_id)
                    .update({
                  "active": DEACTIVE, // đang booking
                  "order_status": ORDER_STATUS_CANCEL, // đang booking
                });
                // cập nhật trạng thái don hang empty -> serving
                await firestore.collection('tables').doc(table_id).update({
                  "status": TABLE_STATUS_EMPTY, // đang booking
                });
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
          .where("active", isEqualTo: ACTIVE)
          // .where('order_status', isEqualTo: ORDER_STATUS_SERVING)
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

            //Thông tin nhân viên phụ trách đơn hàng
            DocumentSnapshot employeeCollection = await firestore
                .collection('employees')
                .doc(order.employee_id)
                .get();
            if (employeeCollection.exists) {
              final employeeData = employeeCollection.data();
              if (employeeData != null &&
                  employeeData is Map<String, dynamic>) {
                String name = employeeData['name'] ?? '';
                order.employee_name = name;
              }
            }
            print("Nhân viên order: ${order.employee_name}");

            // Truy vấn collection orderDetailArrayList
            var orderDetailCollection = firestore
                .collection('orders')
                .doc(order_id)
                .collection('orderDetails');

            // Tính tổng số tiền cho đơn hàng
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
                  modelFood.Food food = modelFood.Food.fromSnap(foodCollection);
                  orderDetail.food = food;
                }
              }

              orderDetails.add(orderDetail);
            }

            order.order_details = orderDetails; // danh sách chi tiết đơn hàng
            if (order.total_amount < 0) {
              order.total_amount = 0;
            }
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

              //CHECK BOOKING

              if (Utils.isNearBookingTime(order.customer_time_booking)) {
                //KIỂM TRA TRƯỚC GIỜ BOOKING 30P VÀ TRỄ 1H

                //- Nếu không EMPTY thì không cập nhật -> Yêu cầu nhân viên đổi bàn khác phù hợp -> xin lỗi khách -> sự bất tiện của quán
                if (order.table!.status == TABLE_STATUS_EMPTY) {
                  // cập nhật trạng thái don hang empty -> serving
                  await firestore.collection('tables').doc(table_id).update({
                    "status": TABLE_STATUS_BOOKING, // đang booking
                  });
                }
              } else if (Utils.isAfterOneHourFromBookingTime(
                  order.customer_time_booking)) {
                //KIỂM TRA SAU GIỜ BOOKING 1H
                await firestore
                    .collection('orders')
                    .doc(order.order_id)
                    .update({
                  "active": DEACTIVE, // đang booking
                  "order_status": ORDER_STATUS_CANCEL, // đang booking
                });
                // cập nhật trạng thái don hang empty -> serving
                await firestore.collection('tables').doc(table_id).update({
                  "status": TABLE_STATUS_EMPTY, // đang booking
                });
              }
            }
            retVal.add(order);
          }
        }
        return retVal;
      }));
    }
  }

  //Tổng hóa đơn
  //lấy thông tin chi tiết

  final Rx<model.Order> _order = Rx<model.Order>(model.Order.empty());

  //lấy 1 order

  model.Order get order => _order.value;
  getTotalAmountById(model.Order order) async {
    _order.bindStream(
      firestore
          .collection('orders')
          .where('order_id', isEqualTo: order.order_id)
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          model.Order order = model.Order.empty();
          for (var element in query.docs) {
            order = model.Order.fromSnap(element); // map đơn hàng chi tiết
          }
          return order;
        },
      ),
    );
  }

  //lấy thông tin chi tiết

  final Rx<model.Order> _orderDetail = Rx<model.Order>(model.Order(
      order_id: '',
      order_status: 0,
      create_at: Timestamp.now(),
      active: 1,
      employee_id: '',
      table_id: '',
      table_merge_ids: [],
      table_merge_names: [],
      order_code: '',
      total_amount: 0,
      is_vat: 0,
      discount_amount_all: 0,
      discount_amount_food: 0,
      discount_amount_drink: 0,
      discount_reason: '',
      is_discount: 0,
      total_vat_amount: 0,
      total_discount_amount: 0,
      discount_percent: 0,
      discount_amount_other: 0,
      total_slot: 1,
      total_surcharge_amount: 0,
      customer_name: '',
      customer_phone: '',
      customer_time_booking: Timestamp.now(),
      deposit_amount: 0));

  //lấy 1 order

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
              table_id: '',
              table_merge_ids: [],
              table_merge_names: [],
              order_code: '',
              total_amount: 0,
              is_vat: 0,
              discount_amount_all: 0,
              discount_amount_food: 0,
              discount_amount_drink: 0,
              discount_reason: '',
              is_discount: 0,
              total_vat_amount: 0,
              total_discount_amount: 0,
              discount_percent: 0,
              discount_amount_other: 0,
              total_slot: 1,
              total_surcharge_amount: 0,
              customer_name: '',
              customer_phone: '',
              customer_time_booking: Timestamp.now(),
              deposit_amount: 0);
          retValue.order_id = order.order_id;

          List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng

          for (var element in query.docs) {
            OrderDetail orderDetail =
                OrderDetail.fromSnap(element); // map đơn hàng chi tiết
            orderDetails.add(orderDetail);
          }
          retValue.order_details = orderDetails;

          for (int i = 0; i < orderDetails.length; i++) {
            //New quantity
            orderDetails[i].new_quantity = orderDetails[i].quantity;

            // lấy thông tin của món
            String collectionName = 'foods';
            // lấy thông tin của món kèm
            if (orderDetails[i].is_addition) {
              collectionName = 'additionFoods';
            } else {
              // lấy thông tin của món ăn thường
              collectionName = 'foods';
            }
            DocumentSnapshot foodCollection = await firestore
                .collection(collectionName)
                .doc(orderDetails[i].food_id)
                .get();
            if (foodCollection.exists) {
              final foodData = foodCollection.data();
              if (foodData != null && foodData is Map<String, dynamic>) {
                modelFood.Food food = modelFood.Food.fromSnap(foodCollection);
                retValue.order_details[i].food = food;
                print(
                    "IMAGE===============${retValue.order_details[i].food!.image}");
                List<modelFood.Food> listFoodComboDetail = [];
                if (food.food_combo_ids.isNotEmpty) {
                  // Lấy thông tin món combo
                  print("===============COMBO CỦA ${food.name}===========");

                  for (String item in food.food_combo_ids) {
                    var foodSnapshot =
                        await firestore.collection("foods").doc(item).get();

                    modelFood.Food food = modelFood.Food.fromSnap(foodSnapshot);

                    print(food.name);
                    listFoodComboDetail.add(food);
                  }
                }
                retValue.order_details[i].listCombo = listFoodComboDetail;
              }
            }
          }
          DocumentSnapshot orderCollection =
              await firestore.collection('orders').doc(order.order_id).get();
          if (orderCollection.exists) {
            final orderData = orderCollection.data();
            if (orderData != null && orderData is Map<String, dynamic>) {
              order = model.Order.fromSnap(orderCollection);
              retValue.total_amount = order.total_amount;
              retValue.total_vat_amount = order.total_vat_amount;
              retValue.total_discount_amount = order.total_discount_amount;
              retValue.is_vat = order.is_vat;
              retValue.is_discount = order.is_discount;
              print(order.total_amount);
            }
          }

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
          retValue.table_id = order.table_id;
          print(retValue.table!.table_id);
          print("ORDER DETAIL: ${retValue.total_amount}");

          //Thông tin nhân viên phụ trách đơn hàng
          if (order.employee_id != "") {
            DocumentSnapshot employeeCollection = await firestore
                .collection('employees')
                .doc(order.employee_id)
                .get();
            if (employeeCollection.exists) {
              final employeeData = employeeCollection.data();
              if (employeeData != null &&
                  employeeData is Map<String, dynamic>) {
                String name = employeeData['name'] ?? '';
                order.employee_name = name;
              }
            }
          }
          return retValue;
        },
      ),
    );
  }

  final Rx<model.Order> _orderDetailOrigin = Rx<model.Order>(model.Order(
      order_id: '',
      order_status: 0,
      create_at: Timestamp.now(),
      active: 1,
      employee_id: '',
      table_id: '',
      table_merge_ids: [],
      table_merge_names: [],
      order_code: '',
      total_amount: 0,
      is_vat: 0,
      discount_amount_all: 0,
      discount_amount_food: 0,
      discount_amount_drink: 0,
      discount_reason: '',
      is_discount: 0,
      total_vat_amount: 0,
      total_discount_amount: 0,
      discount_percent: 0,
      discount_amount_other: 0,
      total_slot: 1,
      total_surcharge_amount: 0,
      customer_name: '',
      customer_phone: '',
      customer_time_booking: Timestamp.now(),
      deposit_amount: 0));

  model.Order get orderDetailOrigin => _orderDetailOrigin.value;
  getOrderDetailOriginById(model.Order order) async {
    _orderDetailOrigin.bindStream(
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
              table_id: '',
              table_merge_ids: [],
              table_merge_names: [],
              order_code: '',
              total_amount: 0,
              is_vat: 0,
              discount_amount_all: 0,
              discount_amount_food: 0,
              discount_amount_drink: 0,
              discount_reason: '',
              is_discount: 0,
              total_vat_amount: 0,
              total_discount_amount: 0,
              discount_percent: 0,
              discount_amount_other: 0,
              total_slot: 1,
              total_surcharge_amount: 0,
              customer_name: '',
              customer_phone: '',
              customer_time_booking: Timestamp.now(),
              deposit_amount: 0);
          retValue.order_id = order.order_id;

          List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng

          for (var element in query.docs) {
            OrderDetail orderDetail =
                OrderDetail.fromSnap(element); // map đơn hàng chi tiết
            orderDetails.add(orderDetail);
          }
          retValue.order_details = orderDetails;
          // Tính tổng số tiền cho đơn hàng
          for (int i = 0; i < orderDetails.length; i++) {
            // lấy thông tin của món ăn
            DocumentSnapshot foodCollection = await firestore
                .collection('foods')
                .doc(orderDetails[i].food_id)
                .get();
            if (foodCollection.exists) {
              final foodData = foodCollection.data();
              if (foodData != null && foodData is Map<String, dynamic>) {
                // String food_name = foodData['name'] ?? '';
                // String image = foodData['image'] ?? '';
                // String category_id = foodData['category_id'] ?? '';

                // retValue.order_details[i].food = FoodOrderDetail(
                //     food_id: orderDetails[i].food_id,
                //     name: food_name,
                //     image: image,
                //     category_id: category_id);
                // print(food_name);

                modelFood.Food food = modelFood.Food.fromSnap(foodCollection);
                retValue.order_details[i].food = food;
              }
            }
          }
          DocumentSnapshot orderCollection =
              await firestore.collection('orders').doc(order.order_id).get();
          if (orderCollection.exists) {
            final orderData = orderCollection.data();
            if (orderData != null && orderData is Map<String, dynamic>) {
              double total_amount = orderData['total_amount'] ?? 0;
              retValue.total_amount = total_amount;
              print(total_amount);
            }
          }

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
          retValue.table_id = order.table_id;
          print(retValue.table!.table_id);
          print("ORDER DETAIL: ${retValue.total_amount}");

          //Thông tin nhân viên phụ trách đơn hàng
          if (order.employee_id != "") {
            DocumentSnapshot employeeCollection = await firestore
                .collection('employees')
                .doc(order.employee_id)
                .get();
            if (employeeCollection.exists) {
              final employeeData = employeeCollection.data();
              if (employeeData != null &&
                  employeeData is Map<String, dynamic>) {
                String name = employeeData['name'] ?? '';
                order.employee_name = name;
              }
            }
          }
          return retValue;
        },
      ),
    );
  }

  // tao order
  //them tung orderdetail
  void createOrder(String table_id, String table_name,
      List<OrderDetail> orderDetailList, bool isGift, BuildContext context,
      [int? slot]) async {
    try {
      //kiểm tra xem don hang đã được order chưa
      var tableOrdered = await firestore
          .collection("orders")
          .where("table_id", isEqualTo: table_id)
          .where("active", isEqualTo: ACTIVE)
          .get();

      if (tableOrdered.docs.isEmpty) {
        //nếu don hang đang trống thì tạo order mới
        String id = Utils.generateUUID();
        // bo sung them note neu can
        model.Order Order = model.Order(
          order_id: id,
          table_id: table_id,
          employee_id: authController.user.uid,
          order_status: ORDER_STATUS_SERVING,
          note: "",
          create_at: Timestamp.fromDate(DateTime.now()),
          payment_at: null,
          is_vat: 0,
          discount_amount_all: 0,
          discount_amount_food: 0,
          discount_amount_drink: 0,
          active: 1,
          table_merge_ids: [],
          table_merge_names: [],
          order_code: id.substring(0, 8),
          total_amount: 0,
          discount_reason: '',
          is_discount: 0,
          total_vat_amount: 0,
          total_discount_amount: 0,
          discount_percent: 0,
          discount_amount_other: 0,
          total_slot: 1,
          total_surcharge_amount: 0,
          customer_name: '',
          customer_phone: '',
          customer_time_booking: null,
          deposit_amount: 0,
        );

        if (slot! > 0) {
          Order.total_slot = slot;
        }
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('orders');

        await usersCollection.doc(id).set(Order.toJson());

        // add order detail
        var allDocsOrderDetail = await firestore
            .collection('orders')
            .doc(id)
            .collection("orderDetails")
            .get();
        double totalAmount = 0;
        for (OrderDetail orderDetail in orderDetailList) {
          String idDetail = Utils.generateUUID();
          orderDetail.order_detail_id = idDetail;
          //nếu là món tặng -> không tính tiền món ăn
          if (isGift) {
            orderDetail.is_gift = true;
            orderDetail.price = 0;
          } else {
            orderDetail.is_gift = false;
          }
          // //nếu là món nước -> trạng thái Hoàn Thành
          // if (orderDetail.category_code == CATEGORY_DRINK) {
          //   orderDetail.food_status = FOOD_STATUS_FINISH;
          // }
          totalAmount += (orderDetail.price * orderDetail.quantity);

          //Thông báo cho bếp rằng khách yêu cầu dừng chế biến
          //Hiện tại chỉ có món ăn cần chế biến
          // if (orderDetail.category_code == CATEGORY_FOOD) {
          //   //MÓN ĂN
          //   orderDetail.chef_bar_status = CHEF_BAR_STATUS_ACTIVE;
          // }else if (orderDetail.category_code == CATEGORY_OTHER) {
          //   //MÓN KHÁC
          //   orderDetail.chef_bar_status = CHEF_BAR_STATUS_ACTIVE;
          // }
          orderDetail.chef_bar_status = CHEF_BAR_STATUS_ACTIVE;

          await firestore
              .collection('orders')
              .doc(id)
              .collection("orderDetails")
              .doc(idDetail)
              .set(orderDetail.toJson());
        }
        // cập nhật tổng tiền cho order
        await firestore.collection('orders').doc(id).update({
          "total_amount": totalAmount,
        });
        // cập nhật trạng thái don hang empty -> serving
        await firestore.collection('tables').doc(table_id).update({
          "status": TABLE_STATUS_SERVING, // đang phục vụ
        });

        //GỬI BẾP BAR
        sendToChefBar(id, table_name, orderDetailList);
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
            .doc(order_id) //order_id của don hang hiện tại
            .get();

        double totalAmount = 0;

        for (OrderDetail orderDetail in orderDetailList) {
          String idDetail = Utils.generateUUID();

          orderDetail.order_detail_id = idDetail;
          //nếu là món tặng -> không tính tiền món ăn
          if (isGift) {
            orderDetail.is_gift = true;
            orderDetail.price = 0;
          } else {
            orderDetail.is_gift = false;
          }
          //nếu là món nước -> trạng thái Hoàn Thành
          // if (orderDetail.category_code == CATEGORY_DRINK) {
          //   orderDetail.food_status = FOOD_STATUS_FINISH;
          // }
          totalAmount += (orderDetail.price * orderDetail.quantity);

          //Thông báo cho bếp rằng khách yêu cầu dừng chế biến
          //Hiện tại chỉ có món ăn cần chế biến
          if (orderDetail.category_code == CATEGORY_FOOD) {
            //MÓN ĂN
            orderDetail.chef_bar_status = CHEF_BAR_STATUS_ACTIVE;
          }

          await firestore
              .collection('orders')
              .doc(order_id) //order_id của don hang hiện đang được phục vụ
              .collection("orderDetails")
              .doc(idDetail)
              .set(orderDetail.toJson());

          //cập nhật lại total_amount

          var orderCollection =
              await firestore.collection("orders").doc(order_id).get();
          var orderData = orderCollection.data();

          double totalAmountOrigin = 0;
          if (orderCollection.exists && orderData is Map<String, dynamic>) {
            double totalAmountCurrent = orderCollection['total_amount'] ?? 0;
            await firestore.collection("orders").doc(order_id).update({
              "total_amount": totalAmount + totalAmountCurrent,
            });
          }
        }

        //GỬI BẾP BAR
        sendToChefBar(order_id, table_name, orderDetailList);
      }

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

  //BOOKING
  /* 
    ************* TẠO ĐƠN HÀNG BOOKING
    - Khi booking thì chỉ ghi nhận đơn hàng.
    - Không cập nhật trạng thái bàn sang BOOKING -> bàn vẫn ở trạng thái EMPTY và có thể nhận khách
    - Trạng thái đơn hàng (active) booking là ACTIVE
    - Trạng thái đơn hàng (order_status) booking là ORDER_STATUS_BOOKING
    -Chưa gửi bếp/bar

    ************* LẤY THÔNG TIN ĐƠN HÀNG
  Kiểm tra đơn hàng BOOKING (có customer_time_booking), 
    1. Nếu trước thời gian booking 30p và sau 1h thì:
     Kiểm tra bàn đã được booking có EMPTY không?
      - Nếu có thì sẽ cập nhật trạng thái:
          TABLE: EMPTY -> BOOKING

      - Nếu không EMPTY thì không cập nhật -> Yêu cầu nhân viên đổi bàn khác phù hợp -> xin lỗi khách -> sự bất tiện của quán

      ->>>> Nếu khách đã tới -> xác nhận đơn hàng -> cần phục vụ
          TABLE: BOOKING -> SERVING
          Trạng thái đơn hàng (order_status) booking là ORDER_STATUS_SERVING
          GỬI BẾP BAR NẾU CÓ ORDER TỪ TRƯỚC

    2. Nếu sau thời gian booking 1h thì:
      - Cập nhật hủy phục vụ đơn hàng booking này (active) là DEACTIVE
      - Trạng thái đơn hàng (order_status) booking là ORDER_STATUS_CANCEL
      - Trường hợp khách đến sau 1 giờ thì chọn bàn phục vụ bình thường, không cần booking -> quá giờ quy định.
  */

  void createOrderBooking(
      String customer_name,
      String customer_phone,
      String customer_time_booking,
      double deposit_amount,
      String table_id,
      String table_name,
      List<OrderDetail> orderDetailList,
      bool isGift,
      BuildContext context,
      int slot) async {
    try {
      //nếu don hang đang trống thì tạo order mới
      String id = Utils.generateUUID();
      // bo sung them note neu can
      model.Order Order = model.Order(
        order_id: id,
        table_id: table_id,
        employee_id: authController.user.uid,
        order_status: ORDER_STATUS_BOOKING,
        note: "",
        create_at: Timestamp.fromDate(DateTime.now()),
        payment_at: null,
        is_vat: 0,
        discount_amount_all: 0,
        discount_amount_food: 0,
        discount_amount_drink: 0,
        active: 1,
        table_merge_ids: [],
        table_merge_names: [],
        order_code: id.substring(0, 8),
        total_amount: 0,
        discount_reason: '',
        is_discount: 0,
        total_vat_amount: 0,
        total_discount_amount: 0,
        discount_percent: 0,
        discount_amount_other: 0,
        total_slot: slot,
        total_surcharge_amount: 0,
        customer_name: customer_name,
        customer_phone: customer_phone,
        customer_time_booking:
            Timestamp.fromDate(DateTime.parse(customer_time_booking)),
        deposit_amount: deposit_amount,
      );

      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('orders');

      await usersCollection.doc(id).set(Order.toJson());

      // add order detail
      var allDocsOrderDetail = await firestore
          .collection('orders')
          .doc(id)
          .collection("orderDetails")
          .get();
      double totalAmount = 0;
      for (OrderDetail orderDetail in orderDetailList) {
        String idDetail = Utils.generateUUID();
        orderDetail.order_detail_id = idDetail;
        //nếu là món tặng -> không tính tiền món ăn
        if (isGift) {
          orderDetail.is_gift = true;
          orderDetail.price = 0;
        } else {
          orderDetail.is_gift = false;
        }

        totalAmount += (orderDetail.price * orderDetail.quantity);

        orderDetail.chef_bar_status = CHEF_BAR_STATUS_ACTIVE;

        await firestore
            .collection('orders')
            .doc(id)
            .collection("orderDetails")
            .doc(idDetail)
            .set(orderDetail.toJson())
            .then((value) async {
          // cập nhật tổng tiền cho order
          await firestore.collection('orders').doc(id).update({
            "total_amount": totalAmount,
          });
        });
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

  //HỦY MÓN
  cancelFoodByOrder(
    // cung cấp order detail id (đại diện cho món ăn) thuộc order nào
    BuildContext context,
    model.Order order,
    OrderDetail orderDetail,
  ) async {
    try {
      if (order.order_id != "" && orderDetail.order_detail_id != "") {
        // cho order detail (món ăn) về trạng thái hủy
        double newTotalAmount = order.total_amount - orderDetail.price;
        if (newTotalAmount <= 0) {
          newTotalAmount = 0;
        }
        await firestore
            .collection('orders')
            .doc(order.order_id)
            .collection('orderDetails')
            .doc(orderDetail.order_detail_id)
            .update({
          "food_status": FOOD_STATUS_CANCEL,
        }).then((_) async {
          await firestore.collection('orders').doc(order.order_id).update({
            "total_amount": newTotalAmount,
          });
        });

        update();
        Utils.showSuccessFlushbar(context, '', 'Hủy món thành công!');
      }
    } catch (e) {
      Utils.showErrorFlushbar(context, '', 'Hủy món thất bại!');
    }
  }

//================================DELETE==================================
// DocumentReference docRef =
//             FirebaseFirestore.instance.collection('orders').doc(order.order_id);

//         try {
//           // Gọi phương thức delete để xóa document
//           await docRef.delete();
//           print('Document deleted successfully');
//         } catch (e) {
//           print('Error deleting document: $e');
//         }
//=================================

  //HỦY ĐƠN HÀNG
  cancelOrder(
    //cập nhật trạng thái bàn -> bàn trống
    BuildContext context,
    model.Order order,
  ) async {
    try {
      if (order.order_id != "") {
        // cập nhật trạng thái bàn -> bàn trống
        await firestore.collection('tables').doc(order.table_id).update({
          "status": TABLE_STATUS_EMPTY, // trống
        });
        await firestore.collection('orders').doc(order.order_id).update({
          "order_status": ORDER_STATUS_CANCEL, // đơn hàng đã hủy
          "payment_at": Timestamp.now(), // đơn hàng đã hủy
          "active": DEACTIVE, // đơn hàng đã hủy
        });
        update();

        Navigator.pop(context);

        Utils.showSuccessFlushbar(context, '', 'Hủy đơn hàng thành công!');
      }
    } catch (e) {
      Utils.showErrorFlushbar(context, '', 'Hủy đơn hàng thất bại!');
    }
  }

  //CHUYỂN BÀN
  moveTable(
      //cập nhật collection order file table_id thành id bàn muốn chuyển
      // đổi trạng thái 2 bàn
      //bàn cũ -> trống
      //bàn mới -> đang phục vụ
      BuildContext context,
      model.Order order,
      table.Table newTable) async {
    try {
      if (order.order_id != "" && newTable.table_id != "") {
        // Kiểm tra bàn muốn chuyển có đang trống
        var tableOrdered = await firestore
            .collection("tables")
            .where("table_id", isEqualTo: newTable.table_id)
            .where("status", isEqualTo: TABLE_STATUS_EMPTY)
            .get();
        if (tableOrdered.docs.isNotEmpty) {
          // nếu là bàn trống
          await firestore.collection('orders').doc(order.order_id).update({
            "table_id": newTable.table_id, // cập nhật table_id mới
          });
          await firestore.collection('tables').doc(order.table_id).update({
            "status": TABLE_STATUS_EMPTY, // cập nhật lại trạng thái bàn cũ
          });
          await firestore.collection('tables').doc(newTable.table_id).update({
            "status": TABLE_STATUS_SERVING, // cập nhật lại trạng thái bàn mới
          });
          update();
          // Utils.showSuccessFlushbar(context, '', 'Chuyển bàn thành công!');
        } else {
          Utils.showErrorFlushbar(context, '', 'Chuyển bàn thất bại!');
        }

        // Navigator.pop(context);
      }
    } catch (e) {
      Utils.showErrorFlushbar(context, '', 'Chuyển bàn thất bại!');
    }
  }

  updateSlot(model.Order order, int new_slot, BuildContext context) async {
    try {
      await firestore.collection('orders').doc(order.order_id).update({
        "total_slot":
            new_slot, // cập nhật trạng thái bàn trống sau khi không còn gộp
      }).then((_) async {
        Utils.showSuccessFlushbar(context, 'SỐ LƯỢNG KHÁCH',
            'Cập nhật số lượng khách của bàn ${order.table!.name} thành công!');
      });
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }

  //GỘP BÀN
  mergeTable(
      BuildContext context, model.Order order, List<dynamic> tableIds) async {
    try {
      if (order.order_id.isNotEmpty && tableIds.isNotEmpty) {
        print("tableIds: $tableIds");

        // Lấy thông tin đơn hàng cần gộp bàn
        var orderSnapshot =
            await firestore.collection("orders").doc(order.order_id).get();

        if (!orderSnapshot.exists) {
          Get.snackbar(
            'Không tìm thấy!',
            'Không tìm thấy thông tin đơn hàng.',
            backgroundColor: backgroundFailureColor,
            colorText: Colors.white,
          );
          return;
        }

        model.Order orderData = model.Order.fromSnap(orderSnapshot);

        print(
            "=====================Data Json: Đơn hàng cần gộp bàn=====================");
        print(orderSnapshot.data());

        if (tableIds != []) {
          // Kiểm tra bàn muốn gộp có đang trống
          List tableNames = [];
          for (int i = 0; i < tableIds.length; i++) {
            print("tableIds[i]: ${tableIds[i]}");

            // Kiểm tra bàn có trống không
            var tableOrdered =
                await firestore.collection("tables").doc(tableIds[i]).get();
            print(tableOrdered.exists);
            var tableData = tableOrdered.data();
            print(
                "tableData is Map<String, dynamic>: ${tableData is Map<String, dynamic>}");

            if (tableOrdered.exists && tableData is Map<String, dynamic>) {
              String name = tableOrdered['name'] ?? '';
              int status = tableOrdered['status'] ?? '';
              tableNames.add(tableOrdered.data()?['name']); //lấy tên bàn

              if (status == TABLE_STATUS_EMPTY) {
                print("Index valid: $i");
                print("Index valid: ${tableIds[i]} - $name");

                // Cập nhật trạng thái bàn gộp
                await firestore.collection('tables').doc(tableIds[i]).update({
                  "status": TABLE_STATUS_MERGED,
                }).then((_) {
                  // Cập nhật table_merge_ids
                  return firestore
                      .collection('orders')
                      .doc(order.order_id)
                      .update({
                    "table_merge_ids": FieldValue.arrayUnion(tableIds),
                  });
                }).then((_) {
                  // Cập nhật table_merge_names
                  return firestore
                      .collection('orders')
                      .doc(order.order_id)
                      .update({
                    "table_merge_names": FieldValue.arrayUnion(tableNames),
                  });
                }).then((_) {
                  Utils.showSuccessFlushbar(context, '', 'Gộp bàn thành công!');
                }).catchError((error) {
                  Utils.showErrorFlushbar(context, '', 'Gộp bàn thất bại!');
                });
              }
            } else {
              print("Index invalid: $i");
              print("Index invalid: ${tableIds[i]}");
              break;
            }
          }
        } else {
          print("Tất cả các bàn cần gộp không còn trống");
          Utils.showErrorFlushbar(context, '', 'Gộp bàn thất bại!');
        }

        // Navigator.pop(context);
      }
    } catch (e) {
      // Get.snackbar(
      //   'Gộp bàn thất bại!',
      //   e.toString(),
      //   backgroundColor: backgroundFailureColor,
      //   colorText: Colors.white,
      // );
    }
  }

  //HỦY GỘP BÀN
  cancelMergeTableById(
      BuildContext context, String tableId, String tableName) async {
    try {
      if (tableId != "") {
        // lấy ra đơn hàng đang nắm giữ table_id muốn bỏ gộp bàn
        var order = await firestore
            .collection("orders")
            .where("table_merge_ids", arrayContains: tableId)
            .where("active", isEqualTo: ACTIVE)
            .where("order_status", isEqualTo: ACTIVE)
            .get();
        model.Order orderData = model.Order.fromSnap(order.docs.first);
        if (orderData.order_id != "") {
          // Xóa table_id trong table_merge_ids của order
          // FieldValue.arrayUnion([tableId]) - thêm vào mảng
          await firestore.collection('orders').doc(orderData.order_id).update({
            "table_merge_ids": FieldValue.arrayRemove(
                [tableId]), // xóa phần tử trong table_merge_ids của order
          });
          await firestore.collection('orders').doc(orderData.order_id).update({
            "table_merge_names": FieldValue.arrayRemove(
                [tableName]), // xóa phần tử trong table_merge_names của order
          });
          await firestore.collection('tables').doc(tableId).update({
            "status":
                TABLE_STATUS_EMPTY, // cập nhật trạng thái bàn trống sau khi không còn gộp
          });

          Utils.showSuccessFlushbar(context, '', 'Hủy gộp bàn thành công!');
        } else {
          Utils.showErrorFlushbar(context, '', 'Hủy gộp bàn thất bại!');
        }

        Navigator.pop(context);
      }
    } catch (e) {
      // Get.snackbar(
      //   'Hủy gộp bàn thất bại!',
      //   e.toString(),
      //   backgroundColor: backgroundFailureColor,
      //   colorText: Colors.white,
      // );
    }
  }

  //TÁCH MÓN
  splitFood(
    BuildContext context,
    model.Order order,
    List<OrderDetail> orderDetailNeedSplitArray,
    // List<OrderDetail> orderDetailOriginArray,
    table.Table targetTable,
  ) async {
    try {
      print("===========================TÁCH MÓN=========================");
      if (orderDetailNeedSplitArray.isNotEmpty && targetTable.table_id != "") {
        double totalAmountSplit = 0;
        for (int i = 0; i < orderDetailNeedSplitArray.length; i++) {
          if (orderDetailNeedSplitArray[i].isSelected) {
            totalAmountSplit += (orderDetailNeedSplitArray[i].price *
                orderDetailNeedSplitArray[i].quantity); //tiền món muốn tách

            print(orderDetailNeedSplitArray[i]);
            // Lấy thông tin order detail của phần tử thứ i
            var orderCollection = await firestore
                .collection("orders")
                .doc(order.order_id)
                .collection("orderDetails")
                .doc(orderDetailNeedSplitArray[i].order_detail_id)
                .get();
            print(
                "Order Detail: ${orderDetailNeedSplitArray[i].order_detail_id}");
            print(orderCollection.exists);
            var orderDetailData = orderCollection.data();
            print(
                "orderDetailData is Map<String, dynamic>: ${orderDetailData is Map<String, dynamic>}");

            if (orderCollection.exists &&
                orderDetailData is Map<String, dynamic>) {
              String order_detail_id = orderCollection['order_detail_id'] ?? '';
              String food_id = orderCollection['food_id'] ?? '';
              double price = orderCollection['price'] ?? 0;
              int quantity =
                  orderCollection['quantity'] ?? 1; // số lượng ban đầu
              int food_status =
                  orderCollection['food_status'] ?? FOOD_STATUS_IN_CHEF;

              // Cập nhật đơn hàng cần tách: số lượng
              int newQuantity =
                  quantity - orderDetailNeedSplitArray[i].quantity;
              print("Số lượng trước: $quantity");
              print("Số lượng tách: ${orderDetailNeedSplitArray[i].quantity}");
              print("Số lượng sau: $newQuantity");
              // nếu chuyển hết thì xóa món ăn ở đơn hàng cần tách
              if (newQuantity == 0) {
                await firestore
                    .collection("orders")
                    .doc(order.order_id)
                    .collection("orderDetails")
                    .doc(orderDetailNeedSplitArray[i].order_detail_id)
                    .delete();
              } else {
                // newQuantity > 0
                await firestore
                    .collection("orders")
                    .doc(order.order_id)
                    .collection("orderDetails")
                    .doc(orderDetailNeedSplitArray[i].order_detail_id)
                    .update({
                  "quantity": newQuantity,
                });
              }
            }
          }
        }

        //kiểm tra xem don hang đã được order chưa
        var tableOrdered = await firestore
            .collection("orders")
            .where("table_id", isEqualTo: targetTable.table_id)
            .where("active", isEqualTo: ACTIVE)
            .get();

        var orderCollection =
            await firestore.collection("orders").doc(order.order_id).get();
        var orderData = orderCollection.data();

        double totalAmountOrigin = 0;
        if (orderCollection.exists && orderData is Map<String, dynamic>) {
          totalAmountOrigin = orderCollection['total_amount'] ?? 0;
        }

        if (tableOrdered.docs.isEmpty) {
          //nếu don hang đang trống thì tạo order mới
          var allDocs = await firestore.collection('orders').get();
          String id = Utils.generateUUID();
          // bo sung them note neu can
          model.Order Order = model.Order(
              order_id: id,
              table_id: targetTable.table_id,
              employee_id: authController.user.uid,
              order_status: FOOD_STATUS_IN_CHEF,
              note: "",
              create_at: Timestamp.fromDate(DateTime.now()),
              payment_at: null,
              is_vat: 0,
              discount_amount_all: 0,
              discount_amount_food: 0,
              discount_amount_drink: 0,
              active: 1,
              table_merge_ids: [],
              table_merge_names: [],
              order_code: id.substring(0, 8),
              total_amount: 0,
              discount_reason: '',
              is_discount: 0,
              total_vat_amount: 0,
              total_discount_amount: 0,
              discount_percent: 0,
              discount_amount_other: 0,
              total_slot: 1,
              total_surcharge_amount: 0,
              customer_name: '',
              customer_phone: '',
              customer_time_booking: Timestamp.now(),
              deposit_amount: 0);
          // cập nhật lại tổng tiền cho order

          Order.total_amount = totalAmountSplit;

          CollectionReference usersCollection =
              FirebaseFirestore.instance.collection('orders');

          await usersCollection.doc(id).set(Order.toJson());

          // add order detail
          var allDocsOrderDetail = await firestore
              .collection('orders')
              .doc(id)
              .collection("orderDetails")
              .get();

          for (OrderDetail orderDetail in orderDetailNeedSplitArray) {
            String idDetail = Utils.generateUUID();

            orderDetail.order_detail_id = idDetail;
            if (orderDetail.isSelected) {
              await firestore
                  .collection('orders')
                  .doc(id)
                  .collection("orderDetails")
                  .doc(idDetail)
                  .set(orderDetail.toJson());
            }
          }

          // cập nhật trạng thái don hang empty -> serving
          await firestore
              .collection('tables')
              .doc(targetTable.table_id)
              .update({
            "status": TABLE_STATUS_SERVING, // đang phục vụ
          });

          await firestore.collection("orders").doc(order.order_id).update({
            "total_amount": totalAmountOrigin - totalAmountSplit,
          });
        } else {
          var allDocsOrderDetail = await firestore
              .collection('orders')
              .doc(
                  order.order_id) //order_id của don hang hiện đang được phục vụ
              .collection("orderDetails")
              .get();

          for (OrderDetail orderDetail in orderDetailNeedSplitArray) {
            String idDetail = Utils.generateUUID();

            orderDetail.order_detail_id = idDetail;
            if (orderDetail.isSelected) {
              await firestore
                  .collection('orders')
                  .doc(order
                      .order_id) //order_id của don hang hiện đang được phục vụ
                  .collection("orderDetails")
                  .doc(idDetail)
                  .set(orderDetail.toJson());
            }
          }
          await firestore.collection("orders").doc(order.order_id).update({
            "total_amount": totalAmountOrigin + totalAmountSplit,
          });
        }

        update();
        Utils.showSuccessFlushbar(context, '', 'Tách món thành công!');
      }
    } catch (e) {
      Utils.showErrorFlushbar(context, '', 'Tách món thất bại!');
    }
  }

  //Cập nhật số lượng món
  updateQuantity(
    BuildContext context,
    String order_id,
    List<OrderDetail> orderDetailNeedUpdate,
  ) async {
    try {
      print(
          "===========================CẬP NHẬT SỐ LƯỢNG MÓN=========================");
      if (orderDetailNeedUpdate.isNotEmpty) {
        for (int i = 0; i < orderDetailNeedUpdate.length; i++) {
          print("Món: ${orderDetailNeedUpdate[i].food!.name}");
          print("SL: ${orderDetailNeedUpdate[i].quantity}");
          print("----------------------------------------");

          await firestore
              .collection("orders")
              .doc(order_id)
              .collection("orderDetails")
              .doc(orderDetailNeedUpdate[i].order_detail_id)
              .update({
            "quantity": orderDetailNeedUpdate[i].quantity,
          });
        }

        //Cập nhật số lượng món còn trong bếp - bar - khác - thông báo
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc(order_id)
            .collection('orderDetails')
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          List<OrderDetail> orderDetailsChef = [];
          List<OrderDetail> orderDetailsBar = [];
          List<OrderDetail> orderDetailsOther = [];

          for (var element in querySnapshot.docs) {
            OrderDetail orderDetail =
                OrderDetail.fromSnap(element); // map đơn hàng chi tiết
            //Chỉ đếm món ăn còn trong bếp
            if (orderDetail.category_code == CATEGORY_FOOD &&
                (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                    orderDetail.food_status == FOOD_STATUS_COOKING)) {
              //BẾP
              orderDetailsChef.add(orderDetail);
            } else if (orderDetail.category_code == CATEGORY_DRINK &&
                (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                    orderDetail.food_status == FOOD_STATUS_COOKING)) {
              //BAR
              orderDetailsBar.add(orderDetail);
            } else if (orderDetail.category_code == CATEGORY_OTHER &&
                (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                    orderDetail.food_status == FOOD_STATUS_COOKING)) {
              //KHÁC
              orderDetailsOther.add(orderDetail);
            }
          }
          //Cập nhật thông tin quantity trong bep bar khác theo don hang order_id
          //Neu khong con mon nao thi xoa
          if (orderDetailsChef.isNotEmpty) {
            await firestore.collection("chefs").doc(order_id).update({
              "quantity": orderDetailsChef.length,
            });
          } else {
            await firestore.collection("chefs").doc(order_id).delete();
          }

          if (orderDetailsBar.isNotEmpty) {
            await firestore.collection("bars").doc(order_id).update({
              "quantity": orderDetailsBar.length,
            });
          } else {
            await firestore.collection("bars").doc(order_id).delete();
          }

          if (orderDetailsOther.isNotEmpty) {
            await firestore.collection("others").doc(order_id).update({
              "quantity": orderDetailsOther.length,
            });
          } else {
            await firestore.collection("others").doc(order_id).delete();
          }

          update();
        }
      }
    } catch (e) {
      Utils.showErrorFlushbar(context, '', 'Cập nhật thất bại!');
    }
  }

  //Cập nhật số lượng món cách mới
  updateNewQuantity(
    BuildContext context,
    String order_id,
    List<OrderDetail> orderDetailNeedUpdate,
  ) async {
    try {
      print(
          "===========================CẬP NHẬT SỐ LƯỢNG MÓN=========================");
      if (orderDetailNeedUpdate.isNotEmpty) {
        for (int i = 0; i < orderDetailNeedUpdate.length; i++) {
          print("Món: ${orderDetailNeedUpdate[i].food!.name}");
          print("SL: ${orderDetailNeedUpdate[i].quantity}");
          print("----------------------------------------");

          if (orderDetailNeedUpdate[i].isSelected) {
            await firestore
                .collection("orders")
                .doc(order_id)
                .collection("orderDetails")
                .doc(orderDetailNeedUpdate[i].order_detail_id)
                .update({
              "quantity": orderDetailNeedUpdate[i].new_quantity,
            });
          }
        }

        //Cập nhật số lượng món còn trong bếp - bar - khác - thông báo
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc(order_id)
            .collection('orderDetails')
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          List<OrderDetail> orderDetailsChef = [];
          List<OrderDetail> orderDetailsBar = [];
          List<OrderDetail> orderDetailsOther = [];

          for (var element in querySnapshot.docs) {
            OrderDetail orderDetail =
                OrderDetail.fromSnap(element); // map đơn hàng chi tiết
            //Chỉ đếm món ăn còn trong bếp
            if (orderDetail.category_code == CATEGORY_FOOD &&
                (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                    orderDetail.food_status == FOOD_STATUS_COOKING)) {
              //BẾP
              orderDetailsChef.add(orderDetail);
            } else if (orderDetail.category_code == CATEGORY_DRINK &&
                (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                    orderDetail.food_status == FOOD_STATUS_COOKING)) {
              //BAR
              orderDetailsBar.add(orderDetail);
            } else if (orderDetail.category_code == CATEGORY_OTHER &&
                (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                    orderDetail.food_status == FOOD_STATUS_COOKING)) {
              //KHÁC
              orderDetailsOther.add(orderDetail);
            }
          }
          //Cập nhật thông tin quantity trong bep bar khác theo don hang order_id
          //Neu khong con mon nao thi xoa
          if (orderDetailsChef.isNotEmpty) {
            await firestore.collection("chefs").doc(order_id).update({
              "quantity": orderDetailsChef.length,
            });
          } else {
            await firestore.collection("chefs").doc(order_id).delete();
          }

          if (orderDetailsBar.isNotEmpty) {
            await firestore.collection("bars").doc(order_id).update({
              "quantity": orderDetailsBar.length,
            });
          } else {
            await firestore.collection("bars").doc(order_id).delete();
          }

          if (orderDetailsOther.isNotEmpty) {
            await firestore.collection("others").doc(order_id).update({
              "quantity": orderDetailsOther.length,
            });
          } else {
            await firestore.collection("others").doc(order_id).delete();
          }

          update();
        }
      }
    } catch (e) {
      Utils.showErrorFlushbar(context, '', 'Cập nhật thất bại!');
    }
  }

  //GỬI BẾP BAR
  sendToChefBar(String order_id, String table_name,
      List<OrderDetail> orderDetails) async {
    try {
      if (order_id != "") {
        for (OrderDetail item in orderDetails) {
          // if (item.food_status == FOOD_STATUS_IN_CHEF) {
          ChefBar chefBarItem = ChefBar(
            chef_bar_id: order_id,
            table_name: table_name,
            create_at: Timestamp.now(),
            quantity: 0,
          );

          // lấy thông tin của món
          String collectionName = 'foods';
          // lấy thông tin của món kèm
          if (item.is_addition) {
            collectionName = 'additionFoods';
          } else {
            // lấy thông tin của món ăn thường
            collectionName = 'foods';
          }
          DocumentSnapshot foodCollection = await firestore
              .collection(collectionName)
              .doc(item.food_id)
              .get();
          if (foodCollection.exists) {
            final foodData = foodCollection.data();
            if (foodData != null && foodData is Map<String, dynamic>) {
              int category_code = foodData['category_code'] ?? 0;

              if (category_code == CATEGORY_FOOD) {
                //MÓN ĂN
                CollectionReference chefCollection =
                    FirebaseFirestore.instance.collection('chefs');

                DocumentSnapshot chefDocument =
                    await chefCollection.doc(order_id).get();

                // Chưa tồn tại thì thêm vào
                if (!chefDocument.exists) {
                  await chefCollection.doc(order_id).set(chefBarItem.toJson());
                }

                //Cập nhật số lượng món còn trong bếp - thông báo
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('orders')
                    .doc(order_id)
                    .collection('orderDetails')
                    .get();

                List<OrderDetail> orderDetails = [];

                for (var element in querySnapshot.docs) {
                  OrderDetail orderDetail =
                      OrderDetail.fromSnap(element); // map đơn hàng chi tiết
                  //Chỉ đếm món ăn còn trong bếp
                  if (orderDetail.category_code == CATEGORY_FOOD &&
                      (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                          orderDetail.food_status == FOOD_STATUS_COOKING)) {
                    orderDetails.add(orderDetail);
                  }
                }
                //Cập nhật thông tin quantity trong bep theo don hang order_id
                await firestore.collection("chefs").doc(order_id).update({
                  "quantity": orderDetails.length,
                });
              } else if (category_code == CATEGORY_DRINK) {
                //ĐỒ UỐNG

                CollectionReference barCollection =
                    FirebaseFirestore.instance.collection('bars');
                DocumentSnapshot barDocument =
                    await barCollection.doc(order_id).get();

                // Chưa tồn tại thì thêm vào
                if (!barDocument.exists) {
                  await barCollection.doc(order_id).set(chefBarItem.toJson());
                }

                //Cập nhật số lượng món nước còn trong quầy bar - thông báo
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('orders')
                    .doc(order_id)
                    .collection('orderDetails')
                    .get();

                List<OrderDetail> orderDetails = [];

                for (var element in querySnapshot.docs) {
                  OrderDetail orderDetail =
                      OrderDetail.fromSnap(element); // map đơn hàng chi tiết
                  //Chỉ đếm món ăn còn trong bar
                  if (orderDetail.category_code == CATEGORY_DRINK &&
                      (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                          orderDetail.food_status == FOOD_STATUS_COOKING)) {
                    orderDetails.add(orderDetail);
                  }
                }
                //Cập nhật thông tin quantity trong quầy bar theo don hang order_id
                await firestore.collection("bars").doc(order_id).update({
                  "quantity": orderDetails.length,
                });
              } else if (category_code == CATEGORY_OTHER) {
                //KHÁC

                CollectionReference otherChefBarCollection =
                    FirebaseFirestore.instance.collection('others');
                DocumentSnapshot otherChefBarDocument =
                    await otherChefBarCollection.doc(order_id).get();

                // Chưa tồn tại thì thêm vào
                if (!otherChefBarDocument.exists) {
                  await otherChefBarCollection
                      .doc(order_id)
                      .set(chefBarItem.toJson());
                }

                //Cập nhật số lượng món khác còn trong KHÁC - thông báo
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('orders')
                    .doc(order_id)
                    .collection('orderDetails')
                    .get();

                List<OrderDetail> orderDetails = [];

                for (var element in querySnapshot.docs) {
                  OrderDetail orderDetail =
                      OrderDetail.fromSnap(element); // map đơn hàng chi tiết
                  //Chỉ đếm món khác còn trong Khác
                  if (orderDetail.category_code == CATEGORY_OTHER &&
                      (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                          orderDetail.food_status == FOOD_STATUS_COOKING)) {
                    orderDetails.add(orderDetail);
                  }
                }
                //Cập nhật thông tin quantity trong KHÁC theo don hang order_id
                await firestore.collection("others").doc(order_id).update({
                  "quantity": orderDetails.length,
                });
              }
            }
          }
          // }
        }
      }
    } catch (e) {
      Utils.showToast('Gửi Bếp/Bar thất bại! + $e', TypeToast.ERROR);
    }
  }

  //CẬP NHẬT TRẠNG THÁI MÓN
  updateFoodStatus(model.Order order) async {
    try {
      if (order.order_id != '') {
        //Cập nhật trạng thái món ăn theo foodStatus
        for (OrderDetail item in order.order_details) {
          if (item.food_status == FOOD_STATUS_IN_CHEF ||
              item.food_status == FOOD_STATUS_COOKING) {
            print("=====================ĐÃ HOÀN TẤT MÓN=====================");
            await firestore
                .collection('orders')
                .doc(order.order_id)
                .collection('orderDetails')
                .doc(item.order_detail_id)
                .update({
              "food_status": FOOD_STATUS_FINISH,
              "chef_bar_status": CHEF_BAR_STATUS_DEACTIVE,
            });

            //Cập nhật số lượng món còn trong bếp - bar - khác - thông báo
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('orders')
                .doc(order.order_id)
                .collection('orderDetails')
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              //Khi "Hoàn tất món thì tất cả món trong bếp đã hoàn thành không cần chế biến nữa"
              //Neu khong con mon nao thi xoa

              await firestore.collection("chefs").doc(order.order_id).delete();

              await firestore.collection("bars").doc(order.order_id).delete();

              await firestore.collection("others").doc(order.order_id).delete();

              update();
            }
          }
        }

        update();
      }
      update();
    } catch (e) {
      Utils.showToast('Cập nhật trạng thái món thất bại!', TypeToast.ERROR);
    }
  }

  //UPDATE BOOKING
  //CẬP NHẬT TRẠNG THÁI MÓN ĐƠN
  updateServingTableById(table.Table table) async {
    try {
      if (table.table_id != '') {
        //Cập nhật trạng thái món ăn theo foodStatus
        await firestore.collection('tables').doc(table.table_id).update({
          "status": TABLE_STATUS_SERVING,
        }).then((_) {
          Utils.showToast('Bàn đã sẵn sàng phục vụ!', TypeToast.SUCCESS);
        });
        update();
      }
    } catch (e) {
      Utils.showToast('Cập nhật trạng thái thất bại!', TypeToast.ERROR);
    }
  }

  //CẬP NHẬT TRẠNG THÁI MÓN ĐƠN
  updateFoodStatusById(OrderDetail orderDetail, int foodStatus) async {
    try {
      if (orderDetail.order_detail_id != '') {
        //Cập nhật trạng thái món ăn theo foodStatus

        await firestore
            .collection('orders')
            .doc(order.order_id)
            .collection('orderdetails')
            .doc(order.order_id)
            .update({
          "food_status": foodStatus,
        });
        update();
      }
    } catch (e) {
      Utils.showToast('Cập nhật trạng thái món thất bại!', TypeToast.ERROR);
    }
  }

  //ÁP DỤNG THUẾ
  applyVat(
    BuildContext context,
    model.Order order,
    List<OrderDetail> orderDetail,
  ) async {
    try {
      if (order.order_id != "") {
        double totalAmount = 0;
        double total = 0;
        for (OrderDetail orderDetail in orderDetail) {
          total += (orderDetail.price * orderDetail.quantity);
        }
        //Phan tram vat dua vao tong tien order detail -> khong tinh da giam gia

        double vat_price = (total * VAT_PERCENT) / 100;
        totalAmount = order.total_amount + vat_price;
        print("APPLY VAT");

        print(order.order_id);
        print(total);
        print(vat_price);
        print(totalAmount);
        // cập nhật lại tổng tiền cho order
        await firestore.collection('orders').doc(order.order_id).update({
          "total_amount": totalAmount,
          "total_vat_amount": vat_price,
          "is_vat": ACTIVE,
        }).then((_) async {
          Utils.showToast('Áp dụng VAT thành công!', TypeToast.SUCCESS);
        });
        update();
      }
    } catch (e) {
      Utils.showToast('Áp dụng VAT thất bại!', TypeToast.ERROR);
    }
  }

  //KHÔNG ÁP DỤNG THUẾ
  cancelVat(
    BuildContext context,
    model.Order order,
    List<OrderDetail> orderDetail,
  ) async {
    try {
      if (order.order_id != "") {
        double totalAmount = 0;
        double total = 0;
        for (OrderDetail orderDetail in orderDetail) {
          total += (orderDetail.price * orderDetail.quantity);
        }
        //Phan tram vat dua vao tong tien order detail -> khong tinh da giam gia
        double vat_price = (total * VAT_PERCENT) / 100;
        totalAmount = order.total_amount - vat_price;

        // cập nhật lại tổng tiền cho order
        await firestore.collection('orders').doc(order.order_id).update({
          "total_amount": totalAmount,
          "total_vat_amount": 0.0,
          "is_vat": DEACTIVE,
        }).then((_) async {
          Utils.showToast('Hủy VAT thành công!', TypeToast.SUCCESS);
        });
        update();
      }
    } catch (e) {
      Utils.showToast('Hủy VAT thành công!', TypeToast.ERROR);
    }
  }

  //ÁP DỤNG GIẢM GIÁ
  applyDiscount(BuildContext context, model.Order order, int category_code,
      double discount_price, int discount_percent) async {
    try {
      if (order.order_id != "" && order.total_amount > 0) {
        double totalAmount = 0;
        double total = 0;

        double discount_amount_all = 0;
        double discount_amount_food = 0;
        double discount_amount_drink = 0;
        double discount_amount_other = 0;

        for (OrderDetail orderDetail in order.order_details) {
          //ap dung theo danh muc: mon an - mon nuoc - mon khac
          if (category_code == orderDetail.category_code) {
            total += (orderDetail.price * orderDetail.quantity);
          } else {
            //ap dung tat ca
            total += (orderDetail.price * orderDetail.quantity);
          }
        }

        total = total < 0 ? 0 : total;

        //giảm tối đa số tiền món hiện có theo danh mục
        //vd: muốn giảm 500k theo món ăn
        //mà món ăn trong order chỉ có 400k -> chỉ giảm tối đá
        print(discount_price);
        print(total);
        print(discount_price > total);
        if (discount_price > total) {
          discount_price = total;
          print("discount_price = total $total");
        }

        //tính phần trăm sẽ giảm theo loại cần giảm
        double discount_percent_amount = (total * discount_percent) / 100;
        print("discount_percent_amount: $discount_percent_amount");

        // cập nhật số tiền áp dụng theo từng loại

        if (category_code == CATEGORY_FOOD) {
          discount_amount_food =
              discount_price > 0 ? discount_price : discount_percent_amount;
          print("Tổng tiền theo món ăn: $total");
        } else if (category_code == CATEGORY_DRINK) {
          discount_amount_drink =
              discount_price > 0 ? discount_price : discount_percent_amount;
          print("Tổng tiền theo món nước: $total");
        } else if (category_code == CATEGORY_OTHER) {
          discount_amount_other =
              discount_price > 0 ? discount_price : discount_percent_amount;
          print("Tổng tiền theo món khác: $total");
        } else {
          discount_amount_all =
              discount_price > 0 ? discount_price : discount_percent_amount;
        }

        //tính lại tổng tiền của hóa đơn
        print(order.total_amount);

        totalAmount =
            order.total_amount - discount_price - discount_percent_amount;
        print("totalAmount: $totalAmount");

        double total_discount_amount = 0;
        if (discount_price > 0) {
          total_discount_amount = discount_price;
        } else {
          total_discount_amount = discount_percent_amount;
          print("total_discount_amount: $total_discount_amount");
        }
        if (discount_price > 0 || discount_percent > 0) {
          // cập nhật lại tổng tiền cho order
          await firestore.collection('orders').doc(order.order_id).update({
            "total_amount": totalAmount,
            "total_discount_amount": total_discount_amount,
            "discount_percent": discount_percent,
            "discount_amount_all": discount_amount_all,
            "discount_amount_food": discount_amount_food,
            "discount_amount_drink": discount_amount_drink,
            "discount_amount_other": discount_amount_other,
            "is_discount": ACTIVE,
          }).then((_) async {
            Utils.myPop(context);
            Utils.showToast('Áp dụng giảm giá thành công!', TypeToast.SUCCESS);
          });
          update();
        }
      }
    } catch (e) {
      Utils.showToast('Áp dụng giảm giá thất bại!', TypeToast.ERROR);
    }
  }

  //KHÔNG ÁP DỤNG GIẢM GIÁ
  cancelDiscount(
    BuildContext context,
    model.Order order,
    List<OrderDetail> orderDetail,
  ) async {
    try {
      if (order.order_id != "") {
        double totalAmount = 0;

        for (OrderDetail orderDetail in orderDetail) {
          totalAmount += (orderDetail.price * orderDetail.quantity);
        }
        // huy áp dụng giảm giá và thuế cho đơn hàng
        await firestore.collection('orders').doc(order.order_id).update({
          "total_discount_amount": 0.0,
          "total_amount": totalAmount + order.total_vat_amount,
          "is_discount": DEACTIVE,
        }).then((_) =>
            {Utils.showToast('Hủy giảm giá thành công!', TypeToast.SUCCESS)});

        update();
      }
    } catch (e) {
      Utils.showToast('Hủy giảm giá thành công!', TypeToast.ERROR);
    }
  }

  //===================CLEAR DATA ORDER========================================
  deleteOrdersAndDetails() async {
    try {
      // Lấy tất cả tài liệu trong bộ sưu tập "orders"
      var ordersSnapshot = await firestore.collection('orders').get();

// Lặp qua từng tài liệu và xóa
      for (var orderDoc in ordersSnapshot.docs) {
        // Xóa tài liệu trong bộ sưu tập "orderdetails"
        var orderDetailsSnapshot = await firestore
            .collection('orders')
            .doc(orderDoc.id)
            .collection('orderdetails')
            .get();

        for (var orderDetailDoc in orderDetailsSnapshot.docs) {
          await firestore
              .collection('orders')
              .doc(orderDoc.id)
              .collection('orderdetails')
              .doc(orderDetailDoc.id)
              .delete();
        }

        // Xóa tài liệu trong bộ sưu tập "orders"
        await firestore.collection('orders').doc(orderDoc.id).delete();
      }
    } catch (e) {
      Get.snackbar(
        'Hủy thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }

  //===================CLEAR DATA BILL========================================
  deleteBills() async {
    try {
      // Lấy tất cả tài liệu trong bộ sưu tập "bills"
      var billsSnapshot = await firestore.collection('bills').get();

      // Lặp qua từng tài liệu và xóa
      for (var billDoc in billsSnapshot.docs) {
        // Xóa tài liệu trong bộ sưu tập "bills"
        await firestore.collection('bills').doc(billDoc.id).delete();
      }
    } catch (e) {
      Get.snackbar(
        'Hủy thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }
}
