// ignore_for_file: non_constant_identifier_names, avoid_print, library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/chef_bar.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/food.dart' as modelFood;
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/utils.dart';

class ChefBarOtherController extends GetxController {
  final Rx<List<ChefBar>> _chefs = Rx<List<ChefBar>>([]);
  List<ChefBar> get chefs => _chefs.value;

  getChefs(String keySearch) async {
    print("GET CHEF..........");
    if (keySearch.isEmpty) {
      _chefs.bindStream(
        firestore
            .collection('chefs')
            .orderBy('create_at', descending: true)
            .snapshots()
            .map(
          (QuerySnapshot query) {
            List<ChefBar> retValue = [];
            for (var element in query.docs) {
              retValue.add(ChefBar.fromSnap(element));
              print(element);
            }
            print("CÓ ${retValue.length} TRONG BẾP");
            return retValue;
          },
        ),
      );
    } else {
      _chefs.bindStream(firestore
          .collection('chefs')
          .orderBy('create_at', descending: true)
          .snapshots()
          .map((QuerySnapshot query) {
        List<ChefBar> retVal = [];
        for (var elem in query.docs) {
          String name = elem['table_name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(ChefBar.fromSnap(elem));
          }
        }
        print("GET CHEF..........${retVal.length}");

        return retVal;
      }));
    }
  }

  //BAR
  final Rx<List<ChefBar>> _bars = Rx<List<ChefBar>>([]);
  List<ChefBar> get bars => _bars.value;

  getBars(String keySearch) async {
    print("GET BAR..........");

    if (keySearch.isEmpty) {
      _bars.bindStream(
        firestore
            .collection('bars')
            .orderBy('create_at', descending: true)
            .snapshots()
            .map(
          (QuerySnapshot query) {
            List<ChefBar> retValue = [];
            for (var element in query.docs) {
              retValue.add(ChefBar.fromSnap(element));
              print(element);
            }
            return retValue;
          },
        ),
      );
    } else {
      _bars.bindStream(firestore
          .collection('bars')
          .orderBy('create_at', descending: true)
          .snapshots()
          .map((QuerySnapshot query) {
        List<ChefBar> retVal = [];
        for (var elem in query.docs) {
          String name = elem['table_name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(ChefBar.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  //Other
  final Rx<List<ChefBar>> _others = Rx<List<ChefBar>>([]);
  List<ChefBar> get others => _others.value;

  getOthers(String keySearch) async {
    print("GET OTHER..........");

    if (keySearch.isEmpty) {
      _others.bindStream(
        firestore
            .collection('others')
            .orderBy('create_at', descending: true)
            .snapshots()
            .map(
          (QuerySnapshot query) {
            List<ChefBar> retValue = [];
            for (var element in query.docs) {
              retValue.add(ChefBar.fromSnap(element));
              print(element);
            }
            return retValue;
          },
        ),
      );
    } else {
      _others.bindStream(firestore
          .collection('others')
          .orderBy('create_at', descending: true)
          .snapshots()
          .map((QuerySnapshot query) {
        List<ChefBar> retVal = [];
        for (var elem in query.docs) {
          String name = elem['table_name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(ChefBar.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  //lấy 1 order
  final Rx<model.Order> _orderDetailOfChef = Rx<model.Order>(model.Order(
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
      total_slot: 1));
  model.Order get orderDetailOfChef => _orderDetailOfChef.value;
  getChefByOrder(String chef_bar_id, String keySearch) async {
    _orderDetailOfChef.bindStream(
      firestore
          .collection('orders')
          .doc(chef_bar_id)
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
              total_slot: 1);
          retValue.order_id = chef_bar_id;

          List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng

          for (var element in query.docs) {
            OrderDetail orderDetail =
                OrderDetail.fromSnap(element); // map đơn hàng chi tiết
            if (orderDetail.category_code == CATEGORY_FOOD &&
                (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                    orderDetail.food_status == FOOD_STATUS_COOKING)) {
              orderDetails.add(orderDetail);
            }
          }
          retValue.order_details = orderDetails;
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
          if (keySearch != '') {
            retValue.order_details =
                retValue.order_details.where((orderDetail) {
              return (orderDetail.food!.name
                  .toLowerCase()
                  .contains(keySearch.toLowerCase()));
            }).toList();
          }

          return retValue;
        },
      ),
    );
  }

  //lấy 1 order
  final Rx<model.Order> _orderDetailOfBar = Rx<model.Order>(model.Order(
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
      total_slot: 1));
  model.Order get orderDetailOfBar => _orderDetailOfBar.value;
  getBarByOrder(String chef_bar_id, String keySearch) async {
    _orderDetailOfBar.bindStream(
      firestore
          .collection('orders')
          .doc(chef_bar_id)
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
              total_slot: 1);
          retValue.order_id = chef_bar_id;

          List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng

          for (var element in query.docs) {
            OrderDetail orderDetail =
                OrderDetail.fromSnap(element); // map đơn hàng chi tiết
            print(orderDetail.category_code == CATEGORY_DRINK);
            if (orderDetail.category_code == CATEGORY_DRINK &&
                (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                    orderDetail.food_status == FOOD_STATUS_COOKING)) {
              orderDetails.add(orderDetail);
            }
          }
          retValue.order_details = orderDetails;
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
          if (keySearch != '') {
            retValue.order_details =
                retValue.order_details.where((orderDetail) {
              return (orderDetail.food!.name
                  .toLowerCase()
                  .contains(keySearch.toLowerCase()));
            }).toList();
          }
          return retValue;
        },
      ),
    );
  }

  //lấy 1 order
  final Rx<model.Order> _orderDetailOfOther = Rx<model.Order>(model.Order(
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
      total_slot: 1));
  model.Order get orderDetailOfOther => _orderDetailOfOther.value;
  getOtherByOrder(String chef_bar_id, String keySearch) async {
    _orderDetailOfOther.bindStream(
      firestore
          .collection('orders')
          .doc(chef_bar_id)
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
              total_slot: 1);
          retValue.order_id = chef_bar_id;

          List<OrderDetail> orderDetails = []; //danh sách chi tiết đơn hàng

          for (var element in query.docs) {
            OrderDetail orderDetail =
                OrderDetail.fromSnap(element); // map đơn hàng chi tiết
            if (orderDetail.category_code == CATEGORY_OTHER &&
                (orderDetail.food_status == FOOD_STATUS_IN_CHEF ||
                    orderDetail.food_status == FOOD_STATUS_COOKING)) {
              orderDetails.add(orderDetail);
            }
          }
          retValue.order_details = orderDetails;
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
          if (keySearch != '') {
            retValue.order_details =
                retValue.order_details.where((orderDetail) {
              return (orderDetail.food!.name
                  .toLowerCase()
                  .contains(keySearch.toLowerCase()));
            }).toList();
          }
          return retValue;
        },
      ),
    );
  }

  //CẬP NHẬT TẤT CẢ TRẠNG THÁI MÓN
  updateFoodStatus(String order_id, List<OrderDetail> orderDetailList) async {
    try {
      if (order_id != '') {
        print(
            "=================CẬP NHẬT TRẠNG THÁI MÓN=======================");
        print(
            "=================$FOOD_STATUS_IN_CHEF_STRING -> $FOOD_STATUS_COOKING_STRING=======================");
        print(
            "=================$FOOD_STATUS_COOKING_STRING -> $FOOD_STATUS_FINISH_STRING=======================");
        //Cập nhật trạng thái món ăn theo foodStatus

        for (OrderDetail item in orderDetailList) {
          if (item.isSelected) {
            if (item.food_status == FOOD_STATUS_IN_CHEF) {
              //CHỜ CHẾ BIẾN -> ĐANG CHẾ BIẾN
              await firestore
                  .collection('orders')
                  .doc(order_id)
                  .collection('orderDetails')
                  .doc(item.order_detail_id)
                  .update({
                "food_status": FOOD_STATUS_COOKING,
              });

              print(
                  "${item.food!.name}: ${item.food_status}:FOOD_STATUS_IN_CHEF -> $FOOD_STATUS_COOKING: FOOD_STATUS_COOKING");
            } else if (item.food_status == FOOD_STATUS_COOKING) {
              //ĐANG CHẾ BIẾN -> HOÀN THÀNH
              await firestore
                  .collection('orders')
                  .doc(order_id)
                  .collection('orderDetails')
                  .doc(item.order_detail_id)
                  .update({
                "food_status": FOOD_STATUS_FINISH,
                "chef_bar_status": CHEF_BAR_STATUS_DEACTIVE,
              });

              print(
                  "${item.food!.name}: ${item.food_status}:FOOD_STATUS_COOKING -> $FOOD_STATUS_FINISH:FOOD_STATUS_FINISH\n chef_bar_status: CHEF_BAR_STATUS_DEACTIVE");
            }
            update();
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
      Utils.showToast('Cập nhật trạng thái món thất bại!', TypeToast.ERROR);
    }
  }

  //CẬP NHẬT HỦY TRẠNG THÁI MÓN
  updateFoodStatusCancel(
      String order_id, List<OrderDetail> orderDetailList) async {
    try {
      if (order_id != '') {
        print(
            "=================CẬP NHẬT TRẠNG THÁI MÓN=======================");
        print(
            "=================$FOOD_STATUS_IN_CHEF_STRING -> $FOOD_STATUS_CANCEL_STRING=======================");
        //Cập nhật trạng thái món ăn theo foodStatus

        for (OrderDetail item in orderDetailList) {
          if (item.isSelected) {
            if (item.food_status == FOOD_STATUS_IN_CHEF) {
              //CHỜ CHẾ BIẾN -> ĐANG CHẾ BIẾN
              await firestore
                  .collection('orders')
                  .doc(order_id)
                  .collection('orderDetails')
                  .doc(item.order_detail_id)
                  .update({
                "food_status": FOOD_STATUS_CANCEL,
                "chef_bar_status": CHEF_BAR_STATUS_DEACTIVE,
              });

              print(
                  "${item.food!.name}: ${item.food_status}:FOOD_STATUS_IN_CHEF -> $FOOD_STATUS_CANCEL: FOOD_STATUS_CANCEL");
            }
            update();
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
      Utils.showToast('Cập nhật trạng thái món thất bại!', TypeToast.ERROR);
    }
  }

  //CẬP NHẬT TRẠNG THÁI MÓN TỪNG MÓN
  updateFoodStatusById(String order_id, OrderDetail orderDetail) async {
    try {
      if (order_id != '') {
        print(
            "=================CẬP NHẬT TRẠNG THÁI MÓN=======================");
        //Cập nhật trạng thái món ăn theo foodStatus

        if (orderDetail.isSelected) {
          if (orderDetail.food_status == FOOD_STATUS_IN_CHEF) {
            //CHỜ CHẾ BIẾN -> ĐANG CHẾ BIẾN
            await firestore
                .collection('orders')
                .doc(order_id)
                .collection('orderDetails')
                .doc(orderDetail.order_detail_id)
                .update({
              "food_status": FOOD_STATUS_COOKING,
            });

            print(
                "${orderDetail.food!.name}: ${orderDetail.food_status} -> $FOOD_STATUS_COOKING: FOOD_STATUS_COOKING");
          } else if (orderDetail.food_status == FOOD_STATUS_COOKING) {
            //ĐANG CHẾ BIẾN -> HOÀN THÀNH
            await firestore
                .collection('orders')
                .doc(order_id)
                .collection('orderDetails')
                .doc(orderDetail.order_detail_id)
                .update({
              "food_status": FOOD_STATUS_FINISH,
              "chef_bar_status": CHEF_BAR_STATUS_DEACTIVE,
            });

            print(
                "${orderDetail.food!.name}: ${orderDetail.food_status} -> $FOOD_STATUS_FINISH:FOOD_STATUS_FINISH\n chef_bar_status: CHEF_BAR_STATUS_DEACTIVE");
          }
          update();
        }
      }
    } catch (e) {
      Utils.showToast('Cập nhật trạng thái món thất bại!', TypeToast.ERROR);
    }
  }
}
