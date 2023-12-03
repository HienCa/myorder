// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/daily_sales.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/utils.dart';

class DailySalesController extends GetxController {
  getDailySaleById(String daily_sale_id) async {
    try {
      DocumentSnapshot dailySale =
          await firestore.collection('dailySales').doc(daily_sale_id).get();
      if (dailySale.exists) {
        final userData = dailySale.data();
        if (userData != null && userData is Map<String, dynamic>) {
          String daily_sale_id = userData['daily_sale_id'] ?? '';
          String name = userData['name'] ?? '';
          Timestamp date_apply = userData['date_apply'] ?? '';
          int active = userData['active'] ?? 1;
          return DailySales(
              daily_sale_id: daily_sale_id,
              name: name,
              active: active,
              date_apply: date_apply);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return DailySales(
          daily_sale_id: daily_sale_id,
          name: "",
          active: 1,
          date_apply: Timestamp.now());
    }
  }

  final Rx<List<DailySales>> _dailySales = Rx<List<DailySales>>([]);
  List<DailySales> get dailySales => _dailySales.value;
  getDailySales(String keySearch) async {
    if (keySearch.isEmpty) {
      _dailySales.bindStream(
        firestore
            .collection('dailySales')
            .orderBy('date_apply', descending: true)
            .snapshots()
            .map(
          (QuerySnapshot query) {
            List<DailySales> retValue = [];
            for (var element in query.docs) {
              retValue.add(DailySales.fromSnap(element));
              print(element);
            }
            return retValue;
          },
        ),
      );
    } else {
      _dailySales.bindStream(firestore
          .collection('dailySales')
          .orderBy('date_apply', descending: true)
          .snapshots()
          .map((QuerySnapshot query) {
        List<DailySales> retVal = [];
        for (var elem in query.docs) {
          String name = elem['name'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search)) {
            retVal.add(DailySales.fromSnap(elem));
          }
        }
        return retVal;
      }));
    }
  }

  Future<bool> isDailySalesByDateTime(DateTime targetDateTime) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('dailySales')
          .where('date_apply', isEqualTo: Timestamp.fromDate(targetDateTime))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Lỗi khi truy vấn: $error');
      return false;
    }
  }

  Future<void> setUpDailySalesByDateTime(DateTime targetDateTime) async {
    //Tìm daily sale theo ngày hiện tại
    //lấy thông tin chi tiết tất cả món của daily sale detail (đã có sẵn food_id và quantity)
    //cập nhật quantity cho tất cả món
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('dailySales')
          .where('date_apply', isEqualTo: Timestamp.fromDate(targetDateTime))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("TỒN TẠI DAILY SALE");
        DailySales dailySales = DailySales.fromSnap(querySnapshot.docs.first);

        //thông tin chi tiết daily sale
        var dailySaleDetailCollection = FirebaseFirestore.instance
            .collection('dailySales')
            .doc(dailySales.daily_sale_id)
            .collection('dailySaleDetails');

        var dailySaleDetailCollectionQuery =
            await dailySaleDetailCollection.get();

        for (var dailySaleDetailData in dailySaleDetailCollectionQuery.docs) {
          DailySaleDetail dailySaleDetai =
              DailySaleDetail.fromSnap(dailySaleDetailData);

          //cập nhật số lượng tối đa có thể bán trong ngày theo daily sale
          updateDailySaleForFood(dailySaleDetai.food_id,
              dailySaleDetai.quantity_for_sell.toDouble());
        }
        print('ĐÃ HOÀN TẤT THIẾT LẬP DAILY SALE');
      } else {}
    } catch (error) {
      print('Lỗi khi truy vấn: $error');
    }
  }

  Future<void> reSetDailySale() async {
    //cho về 0
    try {
      var foodCollection = FirebaseFirestore.instance.collection('foods');
      var foodCollectionQuery = await foodCollection.get();

      for (var food in foodCollectionQuery.docs) {
        Food foodData = Food.fromSnap(food);
        print(foodData.food_id);

        await firestore.collection('foods').doc(foodData.food_id).update({
          "max_order_limit": 0,
          "current_order_count": 0,
        });
      }
    } catch (error) {
      print('Lỗi khi truy vấn: $error');
    }
  }

  updateDailySaleForFood(
    String food_id,
    double max_order_limit,
  ) async {
    try {
      if (food_id != "") {
        await firestore.collection('foods').doc(food_id).update({
          "max_order_limit": max_order_limit,
          "current_order_count": max_order_limit,
        });
      }

      update();
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }

  final Rx<List<DailySales>> _activeDailySales = Rx<List<DailySales>>([]);
  List<DailySales> get activeDailySales => _activeDailySales.value;
  getActiveDailySales() async {
    _activeDailySales.bindStream(
      firestore
          .collection('dailySales')
          .where('active', isEqualTo: ACTIVE)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<DailySales> retValue = [];
          for (var element in query.docs) {
            retValue.add(DailySales.fromSnap(element));
            print(element);
          }
          return retValue;
        },
      ),
    );
  }

  void createDailySale(
    String name,
    Timestamp? date_apply,
  ) async {
    try {
      //Khi tạo mới daily sale
      //Mặc định sẽ tạo detail từ tất cả các món hiện đang ACTIVE - số lượng mặc định là 0
      //Sau đó vào chi tiết chỉnh sửa số lượng bán theo date_apply từng món
      if (date_apply != null) {
        String id = Utils.generateUUID();
        DailySales dailySale = DailySales(
            daily_sale_id: id,
            name: name,
            active: ACTIVE,
            date_apply: date_apply);

        await firestore
            .collection('dailySales')
            .doc(id)
            .set(dailySale.toJson());

        //lấy thông tin tất cả món ăn

        var foodCollection = FirebaseFirestore.instance
            .collection('foods')
            .where("active", isEqualTo: ACTIVE);

        var foodCollectionQuery = await foodCollection.get();

        for (var foodlData in foodCollectionQuery.docs) {
          Food food = Food.fromSnap(foodlData);

          String idDetail = Utils.generateUUID();
          DailySaleDetail dailySaleDetail = DailySaleDetail(
              daily_sale_detail_id: idDetail,
              food_id: food.food_id,
              quantity_for_sell: 0,
              active: ACTIVE);

          //tạo tất cả daily detail từ các món đang kinh doanh
          await firestore
              .collection('dailySales')
              .doc(id)
              .collection('dailySaleDetails')
              .doc(idDetail)
              .set(dailySaleDetail.toJson());
        }
      } else {
        Get.snackbar(
          'Error!',
          'Thêm mới thất bại!',
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

  void createDailySaleCopy(
    String dailySaleId,
    String name,
    Timestamp? date_apply,
  ) async {
    try {
      if (date_apply != null) {
        String id = Utils.generateUUID();
        DailySales dailySale = DailySales(
            daily_sale_id: id,
            name: name,
            active: ACTIVE,
            date_apply: date_apply);

        await firestore
            .collection('dailySales')
            .doc(id)
            .set(dailySale.toJson());

        //lấy thông tin tất cả món ăn

        var dailySaleDetailCollection = FirebaseFirestore.instance
            .collection('dailySales')
            .doc(dailySaleId)
            .collection('dailySaleDetails');

        var dailySaleDetailCollectionQuery =
            await dailySaleDetailCollection.get();

        for (var dailySaleDetailData in dailySaleDetailCollectionQuery.docs) {
          DailySaleDetail dataDatail =
              DailySaleDetail.fromSnap(dailySaleDetailData);

          String idDetail = Utils.generateUUID();
          DailySaleDetail dailySaleDetail = DailySaleDetail(
              daily_sale_detail_id: idDetail,
              food_id: dataDatail.food_id,
              quantity_for_sell: dataDatail.quantity_for_sell,
              active: ACTIVE);

          //tạo tất cả daily detail từ các món đang kinh doanh
          await firestore
              .collection('dailySales')
              .doc(id)
              .collection('dailySaleDetails')
              .doc(idDetail)
              .set(dailySaleDetail.toJson());
        }
      } else {
        Get.snackbar(
          'Error!',
          'Thêm mới thất bại!',
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

  updateDailySale(
    String daily_sale_id,
    String name,
    Timestamp date_apply,
  ) async {
    try {
      await firestore.collection('dailySales').doc(daily_sale_id).update({
        "name": name.trim().toUpperCase(),
        "date_apply": date_apply,
      });

      update();
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }

  // Block account
  updateToggleActive(
    String daily_sale_id,
    int active,
  ) async {
    try {
      await firestore.collection('dailySales').doc(daily_sale_id).update({
        "active": active == ACTIVE ? DEACTIVE : ACTIVE,
      });

      Get.snackbar(
        'THÀNH CÔNG!',
        'Cập nhật thông tin thành công!',
        backgroundColor: backgroundSuccessColor,
        colorText: Colors.white,
      );
      update();
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
        backgroundColor: backgroundFailureColor,
        colorText: Colors.white,
      );
    }
  }
}
