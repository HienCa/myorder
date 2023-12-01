// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/warehouse_export.dart';
import 'package:myorder/models/warehouse_export_detail.dart';

import 'package:myorder/utils.dart';

class WarehouseExportController extends GetxController {
  final Rx<List<WarehouseExport>> _warehouseExports =
      Rx<List<WarehouseExport>>([]);
  List<WarehouseExport> get warehouseExports => _warehouseExports.value;
  getwarehouseExports(
      String keySearch, DateTime? fromDate, DateTime? toDate) async {
    if (keySearch.isEmpty) {
      _warehouseExports.bindStream(
        firestore.collection('warehouseExports').snapshots().asyncMap(
          (QuerySnapshot query) async {
            List<WarehouseExport> retValue = [];
            for (var element in query.docs) {
              WarehouseExport warehouseExport =
                  WarehouseExport.fromSnap(element);

              //Detail
              var WarehouseExportDetailCollection = firestore
                  .collection('warehouseExports')
                  .doc(warehouseExport.warehouse_export_id)
                  .collection('warehouseExportDetails');

              List<WarehouseExportDetail> warehouseRecceiptDetails =
                  []; //danh sách chi tiết
              var WarehouseExportDetailCollectionQuery =
                  await WarehouseExportDetailCollection.get();
              for (var WarehouseExportDetailData
                  in WarehouseExportDetailCollectionQuery.docs) {
                // chi tiết phiếu xuất

                WarehouseExportDetail warehouseRecceiptDetail =
                    WarehouseExportDetail.fromSnap(WarehouseExportDetailData);

                warehouseRecceiptDetail.new_quantity =
                    warehouseRecceiptDetail.quantity;
                warehouseRecceiptDetails.add(warehouseRecceiptDetail);
              }
              //Danh sách mặt hàng đã xuất
              warehouseExport.warehouseExportDetails = warehouseRecceiptDetails;

              if (fromDate != null && toDate != null) {
                if (Utils.isTimestampInRange(
                    warehouseExport.created_at, fromDate, toDate)) {
                  retValue.add(warehouseExport);
                }
              } else {
                retValue.add(warehouseExport);
              }
            }
            return retValue;
          },
        ),
      );
    } else {
      _warehouseExports.bindStream(firestore
          .collection('warehouseExports')
          .snapshots()
          .asyncMap((QuerySnapshot query) async {
        List<WarehouseExport> retVal = [];
        for (var elem in query.docs) {
          String name = elem['employee_name'].toLowerCase();
          String WarehouseExportCode =
              elem['warehouse_receipt_code'].toLowerCase();
          String search = keySearch.toLowerCase().trim();
          if (name.contains(search) || WarehouseExportCode.contains(search)) {
            WarehouseExport warehouseExport = WarehouseExport.fromSnap(elem);
            //Detail
            var WarehouseExportDetailCollection = firestore
                .collection('warehouseExports')
                .doc(warehouseExport.warehouse_export_id)
                .collection('warehouseExportDetails');

            List<WarehouseExportDetail> warehouseRecceiptDetails =
                []; //danh sách chi tiết
            var WarehouseExportDetailCollectionQuery =
                await WarehouseExportDetailCollection.get();
            for (var WarehouseExportDetailData
                in WarehouseExportDetailCollectionQuery.docs) {
              // chi tiết phiếu xuất

              WarehouseExportDetail warehouseRecceiptDetail =
                  WarehouseExportDetail.fromSnap(WarehouseExportDetailData);

              warehouseRecceiptDetail.new_quantity =
                  warehouseRecceiptDetail.quantity;
              warehouseRecceiptDetails.add(warehouseRecceiptDetail);
            }
            //Danh sách mặt hàng đã xuất
            warehouseExport.warehouseExportDetails = warehouseRecceiptDetails;

            if (fromDate != null && toDate != null) {
              if (Utils.isTimestampInRange(
                  warehouseExport.created_at, fromDate, toDate)) {
                retVal.add(warehouseExport);
              }
            } else {
              retVal.add(warehouseExport);
            }
          }
        }
        return retVal;
      }));
    }
  }

  final Rx<List<WarehouseExport>> _activewarehouseExports =
      Rx<List<WarehouseExport>>([]);
  List<WarehouseExport> get activewarehouseExports =>
      _activewarehouseExports.value;
  getActivewarehouseExports() async {
    _activewarehouseExports.bindStream(
      firestore
          .collection('warehouseExports')
          .where('active', isEqualTo: ACTIVE)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<WarehouseExport> retValue = [];
          for (var element in query.docs) {
            retValue.add(WarehouseExport.fromSnap(element));
            print(element);
          }
          return retValue;
        },
      ),
    );
  }

  void createWarehouseExport(
    WarehouseExport warehouseExport,
    List<WarehouseExportDetail> warehouseRecceiptDetails,
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
            warehouseExport.employee_name = name;
          }
        }
        String id = Utils.generateUUID();
        warehouseExport.warehouse_export_id = id;
        warehouseExport.employee_id = authController.user.uid;
        warehouseExport.created_at = Timestamp.now();
        warehouseExport.status = WAREHOUSE_STATUS_FINISH;
        warehouseExport.active = ACTIVE;

        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('warehouseExports');

        await usersCollection.doc(id).set(warehouseExport.toJson());

        //Detail
        for (WarehouseExportDetail warehouseRecceiptDetail
            in warehouseRecceiptDetails) {
          String idDetail = Utils.generateUUID();
          warehouseRecceiptDetail.warehouse_export_detail_id = idDetail;

          await usersCollection
              .doc(id)
              .collection("warehouseExportDetails")
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

  updateWarehouseExport(
    WarehouseExport warehouseExport,
    List<WarehouseExportDetail> newWarehouseRecceiptDetails,
  ) async {
    try {
      for (WarehouseExportDetail warehouseRecceiptDetail
          in warehouseExport.warehouseExportDetails ?? []) {
        await firestore
            .collection("warehouseExports")
            .doc(warehouseExport.warehouse_export_id)
            .collection("warehouseExportDetails")
            .doc(warehouseRecceiptDetail.warehouse_export_detail_id)
            .delete();
      }
      //MỚI
      for (WarehouseExportDetail warehouseExportDetail
          in newWarehouseRecceiptDetails) {
        String idDetail = Utils.generateUUID();
        warehouseExportDetail.warehouse_export_detail_id = idDetail;

        await firestore
            .collection("warehouseExports")
            .doc(warehouseExport.warehouse_export_id)
            .collection("warehouseExportDetails")
            .doc(idDetail)
            .set(warehouseExportDetail.toJson());
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
    String warehouseExport_id,
    int active,
  ) async {
    try {
      await firestore
          .collection('warehouseExports')
          .doc(warehouseExport_id)
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
