// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/employee.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/warehouse_export.dart';
import 'package:myorder/models/warehouse_export_detail.dart';
import 'package:myorder/models/warehouse_receipt.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';

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
                  //Lấy số lượng tồn

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

  final Rx<List<WarehouseExportDetail>> _warehouseExportDetails =
      Rx<List<WarehouseExportDetail>>([]);
  List<WarehouseExportDetail> get warehouseExportDetails =>
      _warehouseExportDetails.value;
  void getWarehouseExportDetails(
      String warehouseExportId, String keySearch) async {
    try {
      if (keySearch.isEmpty) {
        _warehouseExportDetails.bindStream(
          firestore
              .collection('warehouseExports')
              .doc(warehouseExportId)
              .collection('warehouseExportDetails')
              .snapshots()
              .map(
            (QuerySnapshot query) {
              List<WarehouseExportDetail> retValue = [];
              for (var element in query.docs) {
                retValue.add(WarehouseExportDetail.fromSnap(element));
              }
              return retValue;
            },
          ),
        );
      } else {
        _warehouseExportDetails.bindStream(firestore
            .collection('warehouseExports')
            .doc(warehouseExportId)
            .collection('warehouseExportDetails')
            .snapshots()
            .map((QuerySnapshot query) {
          List<WarehouseExportDetail> retVal = [];
          for (var elem in query.docs) {
            String name = elem['ingredient_name'].toLowerCase();
            String search = keySearch.toLowerCase().trim();
            if (name.contains(search)) {
              retVal.add(WarehouseExportDetail.fromSnap(elem));
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

  /*
    Nhập kho theo lịch bán hằng ngày - đảm bảo số lượng bán (nhiên viên ql kho chịu trách nhiệm)
      - Chọn lịch cần nhập (giới hạn là ngày hiện tại) -> hiển thị danh sách lịch date_apply >= now
      - cho phép chọn nhiều lịch cùng 1 lúc
      - gợi ý số lượng cần nhập vào cho các lịch đã được chọn
    check SL theo lịch - thiếu thì nhập thêm (hiển thị tồn hiện tại)
    Xuất kho theo lịch bán (sl món muốn bán * sl nguyên liệu cần dùng trong công thức) xuất dư: vd 1.6kg xuất 2kg  


    xuất theo Hạn sử dụng - xuất hạn sử dụng gần hết hạn xuất trước 
    Nhập lại theo id phiếu nhập và chi tiết phiếu nhập nếu dư
  */
  void createWarehouseExport(
    int vat,
    double discount,
    String code,
    String note,
    List<Ingredient> ingredients,
  ) async {
    try {
      if (ingredients.isNotEmpty) {
        //Thông tin nhân viên phụ trách đơn hàng
        Employee currentEmployee = await Utils.getCurrentEmployee();
        String id = Utils.generateUUID();
        WarehouseExport warehouseExport = WarehouseExport(
            warehouse_export_id: id,
            warehouse_export_code: code,
            employee_id: currentEmployee.employee_id,
            employee_name: currentEmployee.name,
            created_at: Timestamp.now(),
            note: note,
            vat: vat,
            discount: discount,
            status: WAREHOUSE_STATUS_FINISH,
            active: ACTIVE);

        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('warehouseExports');
        await usersCollection.doc(id).set(warehouseExport.toJson());

        /*
           1.Danh sách chi tiết phiếu nhập orderby theo hạn sử dụng

           2.Kiểm tra số lượng cần xuất - xuất trừ trên xuống không đủ lấy cái tiếp theo (tạo warehouseExportDetail mới)
           Nhầm phân biệt các lô hàng khác nhau để nhập vào kho lại nếu dư

          */
        //1.
        //danh sách phiếu
        List<WarehouseReceipt> warehouseReceipts = [];
        var warehouseReceiptsCollection = firestore
            .collection('warehouseReceipts')
            .where('active', isEqualTo: ACTIVE);
        var warehouseReceiptsCollectionQuery =
            await warehouseReceiptsCollection.get();
        for (var warehouseReceiptsData
            in warehouseReceiptsCollectionQuery.docs) {
          WarehouseReceipt warehouseReceipt =
              WarehouseReceipt.fromSnap(warehouseReceiptsData);

          //danh sách chi tiết phiếu nhập
          List<WarehouseReceiptDetail> warehouseReceiptDetails = [];
          var warehouseReceiptDetailsCollection = firestore
              .collection('warehouseReceipts')
              .doc(warehouseReceipt.warehouse_receipt_id)
              .collection('warehouseReceiptDetails')
              .where('quantity_in_stock', isGreaterThan: 0);
          // .orderBy('expiration_date', descending: false);
          var warehouseReceiptDetailsCollectionQuery =
              await warehouseReceiptDetailsCollection.get();
          for (var warehouseReceiptDetailsData
              in warehouseReceiptDetailsCollectionQuery.docs) {
            print("ĐÃ VÀO ĐÂY");

            WarehouseReceiptDetail warehouseReceiptDetail =
                WarehouseReceiptDetail.fromSnap(warehouseReceiptDetailsData);

            warehouseReceiptDetails.add(warehouseReceiptDetail);
          }
          warehouseReceipt.warehouseRecceiptDetails = warehouseReceiptDetails;
          warehouseReceipts.add(warehouseReceipt);
        }

        //2.
        //xét trên mỗi nguyên liệu cần xuất
        for (Ingredient ingredient in ingredients) {
          print("ĐÃ VÀO ĐÂY 2.");

          double totalQuantity = 0; // Tổng Số lượng cần xuất
          //duyệt qua từng phiếu
          for (WarehouseReceipt warehouseReceipt in warehouseReceipts) {
            //sắp xếp lại lần nữa hạn sử dụng nếu cùng 1 phiếu có 2 nguyên liệu giống nhau khác hạn sử dụng
            warehouseReceipt.warehouseRecceiptDetails?.sort((a, b) {
              DateTime dateA = (a.expiration_date ??
                      Utils.convertTimestampFirebaseAddDay(
                          Timestamp.now(), 200))
                  .toDate();
              DateTime dateB = (b.expiration_date ??
                      Utils.convertTimestampFirebaseAddDay(
                          Timestamp.now(), 200))
                  .toDate();
              return dateA.compareTo(dateB);
            });
            //duyệt qua từng chi tiết phiếu
            for (WarehouseReceiptDetail warehouseReceiptDetail
                in warehouseReceipt.warehouseRecceiptDetails ?? []) {
              if (ingredient.ingredient_id ==
                  warehouseReceiptDetail.ingredient_id) {
                double quanity_export = 0; // Số lượng xuất
                double remainingQuantity = 0; // Số lượng còn lại
                totalQuantity += warehouseReceiptDetail.quantity_in_stock;
                //Nếu lớn hơn số lượng cần xuất thì set lại số lượng bằng số lượng muốn xuất
                if (warehouseReceiptDetail.quantity_in_stock >
                    (ingredient.quantity ?? 0)) {
                  // totalQuantity = (ingredient.quantity ?? 0);
                  //Số lượng xuất
                  quanity_export = ingredient.quantity ?? 0;
                  //số lượng còn lại trong kho
                  remainingQuantity =
                      totalQuantity - (ingredient.quantity ?? 0);
                } else {
                  // bé hơn hoặc bằng -> xuất quantity_in_stock của chi tiết phiếu nhập này
                  quanity_export = warehouseReceiptDetail.quantity_in_stock;
                  remainingQuantity =
                      0; // xuất hết số lượng có trong kho hiện tại
                }
                //Tạo chi tiết phiếu xuất
                String idDetail = Utils.generateUUID();

                WarehouseExportDetail warehouseExportDetail =
                    WarehouseExportDetail(
                  warehouse_export_detail_id: idDetail,
                  warehouse_receipt_detail_id:
                      warehouseReceiptDetail.warehouse_receipt_detail_id,
                  warehouse_receipt_id: warehouseReceipt.warehouse_receipt_id,
                  ingredient_id: ingredient.ingredient_id,
                  ingredient_name: ingredient.name,
                  quantity: quanity_export.ceilToDouble(), // 2.3 -> 2.0
                  price: 0,
                  unit_id: ingredient.unit_id ?? "",
                  unit_name: ingredient.unit_name ?? "",
                );
                await usersCollection
                    .doc(id)
                    .collection("warehouseExportDetails")
                    .doc(idDetail)
                    .set(warehouseExportDetail.toJson());
                //Cập nhật lại quantity_in_stock của chi tiết phiếu nhập
                await firestore
                    .collection("warehouseReceipts")
                    .doc(warehouseReceipt.warehouse_receipt_id)
                    .collection("warehouseReceiptDetails")
                    .doc(warehouseReceiptDetail.warehouse_receipt_detail_id)
                    .update({
                  "quantity_in_stock": remainingQuantity.floorToDouble(),
                });
                print(
                    "===============CẬP NHẬT LẠI SỐ LƯỢNG TỒN KHO===============");
                print(
                    "SL BAN ĐẦU: ${warehouseReceiptDetail.quantity_in_stock} -> SL ĐÃ XUẤT: ${ingredient.quantity} -> SL HIỆN TẠI: ${remainingQuantity.floorToDouble()}");
                // //Nếu đã lớn hoặc bằng thì ra tín hiệu dừng
                // if (totalQuantity >= (ingredient.quantity ?? 0)) {
                //   totalQuantity = (ingredient.quantity ?? 0);
                //   break;
                // }
                //Có thể trong cùng 1 phiếu có 2 nguyên liệu giống nhau nhưng khác nhau về hạn sử dụng
                //kiểm tra nếu đã đủ thì chuyển qua xuất nguyên liệu tiếp theo
                if (totalQuantity >= (ingredient.quantity ?? 0)) {
                  break;
                }
              }
            }
            //kiểm tra nếu đã đủ thì chuyển qua xuất nguyên liệu tiếp theo
            if (totalQuantity >= (ingredient.quantity ?? 0)) {
              break;
            }
          }
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

  // void createWarehouseExport(
  //   WarehouseExport warehouseExport,
  //   List<WarehouseExportDetail> warehouseRecceiptDetails,
  // ) async {
  //   try {
  //     if (warehouseRecceiptDetails.isNotEmpty) {
  //       //Thông tin nhân viên phụ trách đơn hàng
  //       Employee currentEmployee = await Utils.getCurrentEmployee();
  //       String id = Utils.generateUUID();
  //       warehouseExport.warehouse_export_id = id;
  //       warehouseExport.employee_id = currentEmployee.employee_id;
  //       warehouseExport.employee_name = currentEmployee.name;
  //       warehouseExport.created_at = Timestamp.now();
  //       warehouseExport.status = WAREHOUSE_STATUS_FINISH;
  //       warehouseExport.active = ACTIVE;

  //       CollectionReference usersCollection =
  //           FirebaseFirestore.instance.collection('warehouseExports');

  //       await usersCollection.doc(id).set(warehouseExport.toJson());

  //       //Detail
  //       for (WarehouseExportDetail warehouseRecceiptDetail
  //           in warehouseRecceiptDetails) {
  //         String idDetail = Utils.generateUUID();
  //         warehouseRecceiptDetail.warehouse_export_detail_id = idDetail;

  //         await usersCollection
  //             .doc(id)
  //             .collection("warehouseExportDetails")
  //             .doc(idDetail)
  //             .set(warehouseRecceiptDetail.toJson());
  //       }
  //     } else {
  //       Get.snackbar(
  //         'Error!',
  //         'Tạo phiếu thất bại!',
  //         backgroundColor: backgroundFailureColor,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     Get.snackbar(
  //       'Error!',
  //       e.message ?? 'Có lỗi xãy ra.',
  //     );
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error!',
  //       e.toString(),
  //     );
  //   }
  // }

  //cập nhật quantity xuất -> cập nhật lại quanity nhập
  /*
    Tạm thời chỉ cho update thông tin phiếu -> kiểm soát chặt chẽ sl nhập vào xuất ra
      - cần nhập -> tạo phiếu nhập
      - cần xuất -> tạo phiếu xuất
    */
  updateWarehouseExport(
    WarehouseExport warehouseExport,
    // List<WarehouseExportDetail> warehouseRecceiptDetails,
    // List<Ingredient> newWarehouseRecceiptDetails,
  ) async {
    try {
      await firestore
          .collection("warehouseReceipts")
          .doc(warehouseExport.warehouse_export_id)
          .update({
        "note": warehouseExport.note,
        "vat": warehouseExport.vat,
        "discount": warehouseExport.discount,
      });
      // for (WarehouseExportDetail warehouseRecceiptDetail
      //     in warehouseRecceiptDetails) {
      //   await firestore
      //       .collection("warehouseExports")
      //       .doc(warehouseExport.warehouse_export_id)
      //       .collection("warehouseExportDetails")
      //       .doc(warehouseRecceiptDetail.warehouse_export_detail_id)
      //       .delete();
      // }
      // //CẬP NHẬT
      // for (WarehouseExportDetail warehouseExportDetail
      //     in warehouseRecceiptDetails) {
      //   String idDetail = Utils.generateUUID();
      //   warehouseExportDetail.warehouse_export_detail_id = idDetail;

      //   await firestore
      //       .collection("warehouseExports")
      //       .doc(warehouseExport.warehouse_export_id)
      //       .collection("warehouseExportDetails")
      //       .doc(idDetail)
      //       .set(warehouseExportDetail.toJson());
      // }
      // //MỚI
      // for (Ingredient warehouseExportDetail in newWarehouseRecceiptDetails) {
      //   String idDetail = Utils.generateUUID();
      //   WarehouseExportDetail detail = WarehouseExportDetail(
      //     warehouse_export_detail_id: idDetail,
      //     ingredient_id: warehouseExportDetail.ingredient_id,
      //     ingredient_name: warehouseExportDetail.name,
      //     quantity: warehouseExportDetail.quantity ?? 0,
      //     price: warehouseExportDetail.price ?? 0,
      //     unit_id: warehouseExportDetail.unit_id ?? "",
      //     unit_name: warehouseExportDetail.unit_name ?? "",
      //     warehouse_receipt_detail_id:
      //         warehouseExportDetail.warehouse_receipt_detail_id ?? "",
      //     warehouse_receipt_id:
      //         warehouseExportDetail.warehouse_receipt_id ?? "",
      //   );
      //   await firestore
      //       .collection("warehouseExports")
      //       .doc(warehouseExport.warehouse_export_id)
      //       .collection("warehouseExportDetails")
      //       .doc(idDetail)
      //       .set(detail.toJson());
      // }

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
