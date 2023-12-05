// ignore_for_file: non_constant_identifier_names, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/daily_sales/daily_sales_controller.dart';
import 'package:myorder/models/daily_sales.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/utils.dart';

class DailySaleDetailController extends GetxController {
  DailySalesController dailySaleController = Get.put(DailySalesController());
  final Rx<List<DailySaleDetail>> _dailySaleDetails =
      Rx<List<DailySaleDetail>>([]);
  List<DailySaleDetail> get dailySaleDetails => _dailySaleDetails.value;
  getDailySaleDetails(String dailySaleDetailId, String keySearch) async {
    if (keySearch.isEmpty) {
      _dailySaleDetails.bindStream(
        firestore
            .collection('dailySales')
            .doc(dailySaleDetailId)
            .collection('dailySaleDetails')
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<DailySaleDetail> retValue = [];
            for (var element in query.docs) {
              DailySaleDetail dailySaleDetail =
                  DailySaleDetail.fromSnap(element);
              dailySaleDetail.new_quantity_for_sell =
                  dailySaleDetail.quantity_for_sell;
              //thông tin món
              DocumentSnapshot foodCollection = await firestore
                  .collection('foods')
                  .doc(dailySaleDetail.food_id)
                  .get();
              if (foodCollection.exists) {
                final foodData = foodCollection.data();
                if (foodData != null && foodData is Map<String, dynamic>) {
                  Food food = Food.fromSnap(foodCollection);
                  dailySaleDetail.food = food;
                }
              }

              retValue.add(dailySaleDetail);
            }
            return retValue;
          },
        ),
      );
    } else {
      _dailySaleDetails.bindStream(firestore
          .collection('dailySales')
          .doc(dailySaleDetailId)
          .collection('dailySaleDetails')
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<DailySaleDetail> retVal = [];
        for (var elem in query.docs) {
          DailySaleDetail dailySaleDetail = DailySaleDetail.fromSnap(elem);
          dailySaleDetail.new_quantity_for_sell =
              dailySaleDetail.quantity_for_sell;

          //thông tin món
          DocumentSnapshot foodCollection = await firestore
              .collection('foods')
              .doc(dailySaleDetail.food_id)
              .get();
          if (foodCollection.exists) {
            final foodData = foodCollection.data();
            if (foodData != null && foodData is Map<String, dynamic>) {
              Food food = Food.fromSnap(foodCollection);
              dailySaleDetail.food = food;
            }
          }
          if ((dailySaleDetail.food?.name ?? "").contains(keySearch)) {
            retVal.add(dailySaleDetail);
          }
        }
        return retVal;
      }));
    }
  }

  updatedailySaleDetail(
      DailySales dailySale, List<DailySaleDetail> dailySaleDetails) async {
    try {
      for (DailySaleDetail dailySaleDetail in dailySaleDetails) {
        if (dailySaleDetail.new_quantity_for_sell !=
            dailySaleDetail.quantity_for_sell) {
          await firestore
              .collection('dailySales')
              .doc(dailySale.daily_sale_id)
              .collection('dailySaleDetails')
              .doc(dailySaleDetail.daily_sale_detail_id)
              .update({
            "quantity_for_sell": dailySaleDetail.new_quantity_for_sell,
          });
        }
      }
      if (Utils.isSameDateFromTimstamp(dailySale.date_apply, Timestamp.now())) {
        dailySaleController
            .setUpDailySalesByDateTime(dailySale.date_apply.toDate());
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
}
