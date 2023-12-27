// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/cancellation_receipt.dart';
import 'package:myorder/models/warehouse_receipt.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';

import 'package:myorder/utils.dart';

class CancellationReceiptController extends GetxController {
  final Rx<List<CancellationReceipt>> _cancellationReceipts =
      Rx<List<CancellationReceipt>>([]);
  List<CancellationReceipt> get cancellationReceipts =>
      _cancellationReceipts.value;
  getCancellationReceipts(
      String keySearch, DateTime? fromDate, DateTime? toDate) async {
    if (keySearch.isEmpty) {
      _cancellationReceipts.bindStream(
        firestore
            .collection('cancellationReceipts')
            .orderBy('created_at', descending: true)
            .snapshots()
            .asyncMap(
          (QuerySnapshot query) async {
            List<CancellationReceipt> retValue = [];
            for (var element in query.docs) {
              CancellationReceipt cancellationReceipt =
                  CancellationReceipt.fromSnap(element);

              //Detail
              var cancellationReceiptDetailCollection = firestore
                  .collection('cancellationReceipts')
                  .doc(cancellationReceipt.cancellation_receipt_id)
                  .collection('cancellationReceiptDetails');

              List<WarehouseReceiptDetail> cancellationReceiptDetails =
                  []; //danh sách chi tiết
              var cancellationReceiptDetailCollectionQuery =
                  await cancellationReceiptDetailCollection.get();
              for (var warehouseReceiptDetailData
                  in cancellationReceiptDetailCollectionQuery.docs) {
                // chi tiết phiếu

                WarehouseReceiptDetail cancellationReceiptDetail =
                    WarehouseReceiptDetail.fromSnap(warehouseReceiptDetailData);
                cancellationReceiptDetail.new_quantity =
                    cancellationReceiptDetail.quantity_in_stock;
                cancellationReceiptDetails.add(cancellationReceiptDetail);
              }
              cancellationReceipt.warehouseReceiptDetails =
                  cancellationReceiptDetails;
              if (fromDate != null && toDate != null) {
                if (Utils.isTimestampInRange(
                    cancellationReceipt.create_at, fromDate, toDate)) {
                  retValue.add(cancellationReceipt);
                }
              } else {
                retValue.add(cancellationReceipt);
              }
            }
            return retValue;
          },
        ),
      );
    } else {
      _cancellationReceipts.bindStream(firestore
          .collection('cancellationReceipts')
          .orderBy('created_at', descending: true)
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<CancellationReceipt> retVal = [];
        for (var elem in query.docs) {
          String name = elem['employee_name'].toLowerCase();
          String code = elem['cancellation_receipt_code'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search) || code.contains(search)) {
            CancellationReceipt cancellationReceipt =
                CancellationReceipt.fromSnap(elem);

            //Detail
            var cancellationReceiptDetailCollection = firestore
                .collection('cancellationReceipts')
                .doc(cancellationReceipt.cancellation_receipt_id)
                .collection('cancellationReceiptDetails');

            List<WarehouseReceiptDetail> cancellationReceiptDetails =
                []; //danh sách chi tiết
            var cancellationReceiptDetailCollectionQuery =
                await cancellationReceiptDetailCollection.get();
            for (var warehouseReceiptDetailData
                in cancellationReceiptDetailCollectionQuery.docs) {
              // chi tiết phiếu

              WarehouseReceiptDetail cancellationReceiptDetail =
                  WarehouseReceiptDetail.fromSnap(warehouseReceiptDetailData);
              cancellationReceiptDetail.new_quantity =
                  cancellationReceiptDetail.quantity_in_stock;
              cancellationReceiptDetails.add(cancellationReceiptDetail);
            }
            cancellationReceipt.warehouseReceiptDetails =
                cancellationReceiptDetails;
            if (fromDate != null && toDate != null) {
              if (Utils.isTimestampInRange(
                  cancellationReceipt.create_at, fromDate, toDate)) {
                retVal.add(cancellationReceipt);
              }
            } else {
              retVal.add(cancellationReceipt);
            }
          }
        }
        return retVal;
      }));
    }
  }

  final Rx<List<WarehouseReceiptDetail>> _cancellationReceiptDetails =
      Rx<List<WarehouseReceiptDetail>>([]);
  List<WarehouseReceiptDetail> get cancellationReceiptDetails =>
      _cancellationReceiptDetails.value;

  void getCancellationReceiptDetails(
      String cancellationReceiptId, String keySearch) async {
    try {
      if (keySearch.isEmpty) {
        _cancellationReceiptDetails.bindStream(
          firestore
              .collection('cancellationReceipts')
              .doc(cancellationReceiptId)
              .collection('cancellationReceiptDetails')
              .snapshots()
              .map(
            (QuerySnapshot query) {
              List<WarehouseReceiptDetail> retValue = [];
              for (var element in query.docs) {
                WarehouseReceiptDetail cancellationReceiptDetail =
                    WarehouseReceiptDetail.fromSnap(element);
                cancellationReceiptDetail.new_quantity =
                    cancellationReceiptDetail.quantity_in_stock;

                retValue.add(cancellationReceiptDetail);
              }
              return retValue;
            },
          ),
        );
      } else {
        _cancellationReceiptDetails.bindStream(firestore
            .collection('cancellationReceipts')
            .doc(cancellationReceiptId)
            .collection('cancellationReceiptDetails')
            .snapshots()
            .map((QuerySnapshot query) {
          List<WarehouseReceiptDetail> retVal = [];
          for (var elem in query.docs) {
            String name = elem['ingredient_name'].toLowerCase();
            String search = keySearch.toLowerCase().trim();
            if (name.contains(search)) {
              WarehouseReceiptDetail cancellationReceiptDetail =
                  WarehouseReceiptDetail.fromSnap(elem);
              cancellationReceiptDetail.new_quantity =
                  cancellationReceiptDetail.quantity_in_stock;

              retVal.add(cancellationReceiptDetail);
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

  final Rx<List<WarehouseReceiptDetail>> _checkCancellationReceips =
      Rx<List<WarehouseReceiptDetail>>([]);
  List<WarehouseReceiptDetail> get checkCancellationReceips =>
      _checkCancellationReceips.value;
  //Lấy râ danh sách
  void getCheckCancellationReceiptDetails(String keySearch) async {
    try {
      if (keySearch.isEmpty) {
        _checkCancellationReceips.bindStream(
          firestore.collection('warehouseReceipts').snapshots().asyncMap(
            (QuerySnapshot query) async {
              List<WarehouseReceiptDetail> retValue = [];
              for (var element in query.docs) {
                WarehouseReceipt cancellationReceipt =
                    WarehouseReceipt.fromSnap(element);

                var cancellationReceiptDetailCollection = firestore
                    .collection('warehouseReceipts')
                    .doc(cancellationReceipt.warehouse_receipt_id)
                    .collection('warehouseReceiptDetails')
                    .where("expiration_date",
                        isLessThanOrEqualTo: Timestamp.now());

                var cancellationReceiptDetailCollectionQuery =
                    await cancellationReceiptDetailCollection.get();
                for (var warehouseReceiptDetailData
                    in cancellationReceiptDetailCollectionQuery.docs) {
                  // chi tiết phiếu
                  WarehouseReceiptDetail item = WarehouseReceiptDetail.fromSnap(
                      warehouseReceiptDetailData);
                  //item.quantity_in_stock = 0 là đã hủy hoặc hết rồi
                  if (item.quantity_in_stock > 0) {
                    retValue.add(item);
                  }
                }
              }
              return retValue;
            },
          ),
        );
      } else {
        _checkCancellationReceips.bindStream(firestore
            .collection('warehouseReceipts')
            .snapshots()
            .asyncMap((QuerySnapshot query) async {
          List<WarehouseReceiptDetail> retVal = [];
          for (var elem in query.docs) {
            WarehouseReceipt cancellationReceipt =
                WarehouseReceipt.fromSnap(elem);
            String name = cancellationReceipt.employee_name.toLowerCase();
            String search = keySearch.toLowerCase().trim();
            if (name.contains(search)) {
              var cancellationReceiptDetailCollection = firestore
                  .collection('warehouseReceipts')
                  .doc(cancellationReceipt.warehouse_receipt_id)
                  .collection('warehouseReceiptDetails')
                  .where("expiration_date",
                      isLessThanOrEqualTo: Timestamp.now());

              var cancellationReceiptDetailCollectionQuery =
                  await cancellationReceiptDetailCollection.get();
              for (var warehouseReceiptDetailData
                  in cancellationReceiptDetailCollectionQuery.docs) {
                // chi tiết phiếu
                WarehouseReceiptDetail item =
                    WarehouseReceiptDetail.fromSnap(warehouseReceiptDetailData);
                retVal.add(item);
              }
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

  final Rx<List<CancellationReceipt>> _activeWarehouseReceipts =
      Rx<List<CancellationReceipt>>([]);
  List<CancellationReceipt> get activeWarehouseReceipts =>
      _activeWarehouseReceipts.value;
  getActiveCancellationReceipts() async {
    _activeWarehouseReceipts.bindStream(
      firestore
          .collection('cancellationReceipts')
          .where('active', isEqualTo: ACTIVE)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<CancellationReceipt> retValue = [];
          for (var element in query.docs) {
            retValue.add(CancellationReceipt.fromSnap(element));
            print(element);
          }
          return retValue;
        },
      ),
    );
  }

  Future<bool> createCancellationReceipt(
    String code,
    List<WarehouseReceiptDetail> warehouseRecceiptDetails,
  ) async {
    try {
      if (warehouseRecceiptDetails.isNotEmpty) {
        String id = Utils.generateUUID();

        CancellationReceipt cancellationReceipt = CancellationReceipt(
          cancellation_receipt_id: id,
          cancellation_receipt_code: code,
          reason: "Nguyên liệu đã hết hạn sử dụng",
          create_at: Timestamp.now(),
          employee_id:
              await myCacheManager.getFromCache(CACHE_EMPLOYEE_ID_KEY) ?? "",
          employee_name:
              await myCacheManager.getFromCache(CACHE_EMPLOYEE_NAME_KEY) ?? "",
          status: WAREHOUSE_STATUS_FINISH,
          active: ACTIVE,
        );

        CollectionReference collection =
            FirebaseFirestore.instance.collection('cancellationReceipts');

        await collection.doc(id).set(cancellationReceipt.toJson());

        //Detail
        for (WarehouseReceiptDetail warehouseReceiptDetail
            in warehouseRecceiptDetails) {
          //Id trong chi tiết phiếu nhập
          String idDetail = warehouseReceiptDetail.warehouse_receipt_detail_id;

          await collection
              .doc(id)
              .collection("cancellationReceiptDetails")
              .doc(idDetail)
              .set(warehouseReceiptDetail.toJson());

          //Cập nhật tồn kho phiếu nhập

          await firestore
              .collection("warehouseReceipts")
              .doc(warehouseReceiptDetail.warehouse_receipt_id)
              .collection("warehouseReceiptDetails")
              .doc(idDetail)
              .update({
            "quantity_in_stock": 0.toDouble(), // đã hủy hết
          });
          update();
        }
        return true;
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
    return false;
  }

  updateCancallationReceipt(
    String reason,
    CancellationReceipt cancellationReceipt,
  ) async {
    try {
      for (WarehouseReceiptDetail item
          in cancellationReceipt.warehouseReceiptDetails ?? []) {
        if (item.quantity != item.new_quantity) {
          await firestore
            ..collection("cancellationReceipts")
                .doc(cancellationReceipt.cancellation_receipt_id)
                .collection("cancellationReceiptDetails")
                .doc(item.warehouse_receipt_detail_id)
                .update({
              "quantity_in_stock": item.new_quantity,
              "reason": reason,
            });
        }
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
