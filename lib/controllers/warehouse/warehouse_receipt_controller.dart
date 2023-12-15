// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/warehouse_receipt.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';

import 'package:myorder/utils.dart';

class WarehouseReceiptController extends GetxController {
  /*
  B1: Thiết lập số lượng món cho từng ngày
  B2: Nhân viên kiểm tra kho, yêu cầu nhập kho nếu không đủ hàng cho ngày kế tiếp đã được thiết lập

  //Hằng ngày
  B1: Nhân viên sẽ xuất kho theo số lượng đã được ước lượng theo công thức từng món * số lượng cần phục vụ
  //Cuối ngày
  Nhân viên lập phiếu nhập kho, nhập lại vào kho những hàng còn thừa

   */

  final Rx<List<WarehouseReceipt>> _warehouseReceipts =
      Rx<List<WarehouseReceipt>>([]);
  List<WarehouseReceipt> get warehouseReceipts => _warehouseReceipts.value;
  getWarehouseReceipts(
      String keySearch, DateTime? fromDate, DateTime? toDate) async {
    if (keySearch.isEmpty) {
      // Query query = firestore.collection('warehouseReceipts');
      // if (fromDate != null && toDate != null) {
      //   query = query
      //       .where('create_at', isGreaterThanOrEqualTo: fromDate)
      //       .where('create_at', isLessThanOrEqualTo: toDate);
      // }
      _warehouseReceipts.bindStream(
        firestore.collection('warehouseReceipts').snapshots().asyncMap(
          (QuerySnapshot query) async {
            List<WarehouseReceipt> retValue = [];
            for (var element in query.docs) {
              WarehouseReceipt warehouseReceipt =
                  WarehouseReceipt.fromSnap(element);

              //Detail
              var warehouseReceiptDetailCollection = firestore
                  .collection('warehouseReceipts')
                  .doc(warehouseReceipt.warehouse_receipt_id)
                  .collection('warehouseReceiptDetails');

              List<WarehouseReceiptDetail> warehouseRecceiptDetails =
                  []; //danh sách chi tiết
              var warehouseReceiptDetailCollectionQuery =
                  await warehouseReceiptDetailCollection.get();
              for (var warehouseReceiptDetailData
                  in warehouseReceiptDetailCollectionQuery.docs) {
                // chi tiết phiếu nhấp

                WarehouseReceiptDetail warehouseRecceiptDetail =
                    WarehouseReceiptDetail.fromSnap(warehouseReceiptDetailData);

                warehouseRecceiptDetail.new_quantity =
                    warehouseRecceiptDetail.quantity;
                warehouseRecceiptDetails.add(warehouseRecceiptDetail);
              }
              //Danh sách mặt hàng đã nhập
              warehouseReceipt.warehouseRecceiptDetails =
                  warehouseRecceiptDetails;

              if (fromDate != null && toDate != null) {
                if (Utils.isTimestampInRange(
                    warehouseReceipt.created_at, fromDate, toDate)) {
                  retValue.add(warehouseReceipt);
                }
              } else {
                retValue.add(warehouseReceipt);
              }
            }
            return retValue;
          },
        ),
      );
    } else {
      _warehouseReceipts.bindStream(firestore
          .collection('warehouseReceipts')
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<WarehouseReceipt> retVal = [];
        for (var elem in query.docs) {
          String name = elem['employee_name'].toLowerCase();
          String warehouseReceiptCode =
              elem['warehouse_receipt_code'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search) || warehouseReceiptCode.contains(search)) {
            WarehouseReceipt warehouseReceipt = WarehouseReceipt.fromSnap(elem);
            //Detail
            var warehouseReceiptDetailCollection = firestore
                .collection('warehouseReceipts')
                .doc(warehouseReceipt.warehouse_receipt_id)
                .collection('warehouseReceiptDetails');

            List<WarehouseReceiptDetail> warehouseRecceiptDetails =
                []; //danh sách chi tiết
            var warehouseReceiptDetailCollectionQuery =
                await warehouseReceiptDetailCollection.get();
            for (var warehouseReceiptDetailData
                in warehouseReceiptDetailCollectionQuery.docs) {
              // chi tiết phiếu nhấp

              WarehouseReceiptDetail warehouseRecceiptDetail =
                  WarehouseReceiptDetail.fromSnap(warehouseReceiptDetailData);

              warehouseRecceiptDetail.new_quantity =
                  warehouseRecceiptDetail.quantity;
              warehouseRecceiptDetails.add(warehouseRecceiptDetail);
            }
            //Danh sách mặt hàng đã nhập
            warehouseReceipt.warehouseRecceiptDetails =
                warehouseRecceiptDetails;

            if (fromDate != null && toDate != null) {
              if (Utils.isTimestampInRange(
                  warehouseReceipt.created_at, fromDate, toDate)) {
                retVal.add(warehouseReceipt);
              }
            } else {
              retVal.add(warehouseReceipt);
            }
          }
        }
        return retVal;
      }));
    }
  }

  final Rx<List<WarehouseReceiptDetail>> _warehouseReceiptDetails =
      Rx<List<WarehouseReceiptDetail>>([]);
  List<WarehouseReceiptDetail> get warehouseReceiptDetails =>
      _warehouseReceiptDetails.value;

  void getWarehouseReceiptDetails(
      String warehouseReceiptId, String keySearch) async {
    try {
      if (keySearch.isEmpty) {
        _warehouseReceiptDetails.bindStream(
          firestore
              .collection('warehouseReceipts')
              .doc(warehouseReceiptId)
              .collection('warehouseReceiptDetails')
              .snapshots()
              .map(
            (QuerySnapshot query) {
              List<WarehouseReceiptDetail> retValue = [];
              for (var element in query.docs) {
                retValue.add(WarehouseReceiptDetail.fromSnap(element));
              }
              return retValue;
            },
          ),
        );
      } else {
        _warehouseReceiptDetails.bindStream(firestore
            .collection('warehouseReceipts')
            .doc(warehouseReceiptId)
            .collection('warehouseReceiptDetails')
            .snapshots()
            .map((QuerySnapshot query) {
          List<WarehouseReceiptDetail> retVal = [];
          for (var elem in query.docs) {
            String name = elem['ingredient_name'].toLowerCase();
            String search = keySearch.toLowerCase().trim();
            if (name.contains(search)) {
              retVal.add(WarehouseReceiptDetail.fromSnap(elem));
            }
          }
          return retVal;
        }));
      }
    } catch (error) {
      // Xử lý lỗi nếu cần thiết
      print('Error fetching warehouse receipt details: $error');
      return null;
    }
  }

  final Rx<List<WarehouseReceipt>> _activeWarehouseReceipts =
      Rx<List<WarehouseReceipt>>([]);
  List<WarehouseReceipt> get activeWarehouseReceipts =>
      _activeWarehouseReceipts.value;
  getActiveWarehouseReceipts() async {
    _activeWarehouseReceipts.bindStream(
      firestore
          .collection('warehouseReceipts')
          .where('active', isEqualTo: ACTIVE)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<WarehouseReceipt> retValue = [];
          for (var element in query.docs) {
            retValue.add(WarehouseReceipt.fromSnap(element));
            print(element);
          }
          return retValue;
        },
      ),
    );
  }

  void createWarehouseReceipt(
    WarehouseReceipt warehouseReceipt,
    List<WarehouseReceiptDetail> warehouseRecceiptDetails,
  ) async {
    try {
      if (warehouseRecceiptDetails.isNotEmpty) {
        //Thông tin nhân viên phụ trách đơn hàng
        DocumentSnapshot employeeCollection = await firestore
            .collection('employees')
            .doc(authController.user.uid)
            .get();
        if (employeeCollection.exists) {
          final employeeData = employeeCollection.data();
          if (employeeData != null && employeeData is Map<String, dynamic>) {
            String name = employeeData['name'] ?? '';
            warehouseReceipt.employee_name = name;
          }
        }
        String id = Utils.generateUUID();
        warehouseReceipt.warehouse_receipt_id = id;
        warehouseReceipt.employee_id = authController.user.uid;
        warehouseReceipt.created_at = Timestamp.now();
        warehouseReceipt.status = WAREHOUSE_STATUS_FINISH;
        warehouseReceipt.active = ACTIVE;

        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('warehouseReceipts');

        await usersCollection.doc(id).set(warehouseReceipt.toJson());

        //Detail
        for (WarehouseReceiptDetail warehouseRecceiptDetail
            in warehouseRecceiptDetails) {
          String idDetail = Utils.generateUUID();
          warehouseRecceiptDetail.warehouse_receipt_detail_id = idDetail;

          await usersCollection
              .doc(id)
              .collection("warehouseReceiptDetails")
              .doc(idDetail)
              .set(warehouseRecceiptDetail.toJson());
        }
      } else {
        Get.snackbar(
          'Error!',
          'Tạo phiếu thất bại!',
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

  updateWarehouseReceipt(
    WarehouseReceipt warehouseRecceipt,
    List<WarehouseReceiptDetail> warehouseRecceiptDetails,
    List<Ingredient> newWarehouseRecceiptDetails,
  ) async {
    try {
      for (WarehouseReceiptDetail warehouseRecceiptDetail
          in warehouseRecceiptDetails) {
        await firestore
            .collection("warehouseReceipts")
            .doc(warehouseRecceipt.warehouse_receipt_id)
            .collection("warehouseReceiptDetails")
            .doc(warehouseRecceiptDetail.warehouse_receipt_detail_id)
            .delete();
      }
      //Update
      for (WarehouseReceiptDetail warehouseRecceiptDetail
          in warehouseRecceiptDetails) {
        String idDetail = Utils.generateUUID();
        warehouseRecceiptDetail.warehouse_receipt_detail_id = idDetail;

        await firestore
            .collection("warehouseReceipts")
            .doc(warehouseRecceipt.warehouse_receipt_id)
            .collection("warehouseReceiptDetails")
            .doc(idDetail)
            .set(warehouseRecceiptDetail.toJson());
      }
      //Mới
      for (Ingredient ingredient in newWarehouseRecceiptDetails) {
        String idDetail = Utils.generateUUID();
        WarehouseReceiptDetail warehouseRecceiptDetail = WarehouseReceiptDetail(
            warehouse_receipt_detail_id: idDetail,
            ingredient_id: ingredient.ingredient_id,
            ingredient_name: ingredient.name,
            quantity: ingredient.quantity ?? 0,
            quantity_in_stock: ingredient.quantity ?? 0,
            price: ingredient.price ?? 0,
            unit_id: ingredient.unit_id ?? "",
            unit_name: ingredient.unit_name ?? "",
            expiration_date: ingredient.expiration_date,
            batch_number: ingredient.batch_number ?? "");

        await firestore
            .collection("warehouseReceipts")
            .doc(warehouseRecceipt.warehouse_receipt_id)
            .collection("warehouseReceiptDetails")
            .doc(idDetail)
            .set(warehouseRecceiptDetail.toJson());
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

  // Block account
  updateToggleActive(
    String WarehouseReceipt_id,
    int active,
  ) async {
    try {
      await firestore
          .collection('warehouseReceipts')
          .doc(WarehouseReceipt_id)
          .update({
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
