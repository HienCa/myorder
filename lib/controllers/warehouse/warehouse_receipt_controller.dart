// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Correct import for Firestore
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/models/daily_sales.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/recipe_detail.dart';
import 'package:myorder/models/unit.dart';
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
              //reset về rỗng mỗi khi gọi
              warehouseReceipt.expiredIngredients = [];
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

                //Kiểm tra có nguyên liệu nào hết hạn không?
                print(
                    "${warehouseRecceiptDetail.ingredient_name} - Ngày hết hạn: ${Utils.formatTimestamp(warehouseRecceiptDetail.expiration_date)}");
                if (warehouseRecceiptDetail.expiration_date != null) {
                  bool isExpired = Utils.isBeforeDateFromTimstamp(
                      warehouseRecceiptDetail.expiration_date ??
                          Timestamp.now(),
                      Timestamp.now());
                  print(isExpired);
                  //quantity_in_stock > 0 thì chưa được hủy
                  if (isExpired &&
                      warehouseRecceiptDetail.quantity_in_stock > 0) {
                    //đánh dấu nguyên liệu này đã hết hạn
                    warehouseReceipt.isExpired = true;
                    //danh sách các nguyên liệu đã hết hạn -> cần hủy
                    warehouseReceipt.expiredIngredients!
                        .add(warehouseRecceiptDetail);
                  }
                }
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
            //reset về rỗng mỗi khi gọi
            warehouseReceipt.expiredIngredients = [];
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

              //Kiểm tra có nguyên liệu nào hết hạn không?
              print(
                  "${warehouseRecceiptDetail.ingredient_name} - Ngày hết hạn: ${Utils.formatTimestamp(warehouseRecceiptDetail.expiration_date)}");
              if (warehouseRecceiptDetail.expiration_date != null) {
                bool isExpired = Utils.isBeforeDateFromTimstamp(Timestamp.now(),
                    warehouseRecceiptDetail.expiration_date ?? Timestamp.now());
                print(isExpired);
                //quantity_in_stock > 0 thì chưa được hủy
                if (isExpired &&
                    warehouseRecceiptDetail.quantity_in_stock > 0) {
                  //đánh dấu nguyên liệu này đã hết hạn
                  warehouseReceipt.isExpired = true;
                  //danh sách các nguyên liệu đã hết hạn -> cần hủy
                  warehouseReceipt.expiredIngredients!
                      .add(warehouseRecceiptDetail);
                }
              }
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

  final Rx<List<Ingredient>> _recommendedingredients = Rx<List<Ingredient>>([]);
  List<Ingredient> get recommendedingredients => _recommendedingredients.value;
  getRecommendedIngredients(DateTime dateApply) async {
    _recommendedingredients.bindStream(
      firestore
          .collection('dailySales')
          .where('date_apply', isEqualTo: Timestamp.fromDate(dateApply))
          .snapshots()
          .asyncMap(
        (QuerySnapshot query) async {
          List<Ingredient> listIngredient = [];

          try {
            //Lấy daily sale của ngày cần gợi ý nhập
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('dailySales')
                .where('date_apply', isEqualTo: Timestamp.fromDate(dateApply))
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              DailySales dailySales =
                  DailySales.fromSnap(querySnapshot.docs.first);

              //danh sách nguyên liệu
              var ingredientCollection =
                  FirebaseFirestore.instance.collection('ingredients');
              var IngredientCollectionQuery = await ingredientCollection.get();

              for (var item in IngredientCollectionQuery.docs) {
                Ingredient ingredient = Ingredient.fromSnap(item);
                listIngredient.add(ingredient);
              }

              //thông tin chi tiết daily sale -> các món cần phục vụ kèm số lượng
              var dailySaleDetailCollection = FirebaseFirestore.instance
                  .collection('dailySales')
                  .doc(dailySales.daily_sale_id)
                  .collection('dailySaleDetails');

              var dailySaleDetailCollectionQuery =
                  await dailySaleDetailCollection.get();

              for (var dailySaleDetailData
                  in dailySaleDetailCollectionQuery.docs) {
                //thông tin chi tiết daily sale -> các món cần phục vụ kèm số lượng
                DailySaleDetail dailySaleDetail =
                    DailySaleDetail.fromSnap(dailySaleDetailData);
                if (dailySaleDetail.quantity_for_sell > 0) {
                  //thông tin công thức
                  var recipeOfFoodCollection = FirebaseFirestore.instance
                      .collection('foods')
                      .doc(dailySaleDetail.food_id)
                      .collection('recipes');

                  var recipeOfFoodCollectionQuery =
                      await recipeOfFoodCollection.get();

                  if (recipeOfFoodCollectionQuery.docs.isNotEmpty) {
                    for (var item in recipeOfFoodCollectionQuery.docs) {
                      RecipeDetail recipeDetail = RecipeDetail.fromSnap(item);

                      print(recipeDetail.new_quantity);

                      //xét danh sách nguyên liệu ban đầu
                      for (Ingredient item in listIngredient) {
                        if (recipeDetail.ingredient_id == item.ingredient_id) {
                          item.isSelected = true;
                          String unitId = recipeDetail.unit_id;
                          String unitName = recipeDetail.unit_name;
                          //Đơn vị không cần chuyển đổi
                          double quantity = recipeDetail.quantity *
                              dailySaleDetail.quantity_for_sell;
                          // Nếu có chuyển đổi đơn vị
                          //Tìm xem unit_id của từng thằng có là con của unit id khác không, nếu là con thì chuyển về gốc
                          if (unitId != "") {
                            var unitCollection =
                                FirebaseFirestore.instance.collection('units');

                            var unitCollectionQuery =
                                await unitCollection.get();

                            if (unitCollectionQuery.docs.isNotEmpty) {
                              for (var itemUnit in unitCollectionQuery.docs) {
                                Unit unit = Unit.fromSnap(itemUnit);
                                if (unit.unit_id_conversion == unitId) {
                                  unitId = unit.unit_id;
                                  unitName = unit.name;
                                  print(
                                      "SL daily sale: ${dailySaleDetail.quantity_for_sell}");
                                  print(
                                      "Gía trị đã chuyển đổi từ ${unit.unit_name_conversion} -> ${unit.name} là ${recipeDetail.quantity / unit.value_conversion}");
                                  quantity = (recipeDetail.quantity /
                                          unit.value_conversion) *
                                      dailySaleDetail.quantity_for_sell;
                                }
                              }
                            }
                          }
                          quantity = quantity.ceil().toDouble();
                          item.quantity = quantity;
                          item.new_quantity = item.quantity;
                          item.unit_id = unitId;
                          item.unit_name = unitName;
                          print(item.name.toUpperCase());
                          print(
                              "${recipeDetail.quantity} : SL trong công thức ");
                          print(
                              "${recipeDetail.unit_value_conversion} : Giá trị đơn vị chuyển đổi ");
                          print(
                              "${dailySaleDetail.quantity_for_sell} : Số lượng muốn bán ");
                          print("${item.unit_id} : ID đơn vị ");
                          print("${item.unit_name} : Tên đơn vị ");

                          //SỐ LƯỢNG NGUYÊN LIỆU CÒN TRONG KHO
                          item.quantity_in_stock =
                              await getInventoryOfIngredient(
                                  item.ingredient_id);
                          print(
                              "${item.quantity_in_stock} : SỐ LƯỢNG TỒN KHO ");
                        }
                      }
                    }
                  }
                }
              }
            } else {}
          } catch (error) {
            print('Lỗi khi truy vấn: $error');
          }
          return listIngredient
              .where((ingredient) => ingredient.isSelected == true)
              .toList();
        },
      ),
    );
  }

  Future<double> getInventoryOfIngredient(String ingredientId) async {
    double quantity = 0;
    var warehouseReceiptCollection =
        FirebaseFirestore.instance.collection('warehouseReceipts');

    var warehouseReceiptCollectionQuery =
        await warehouseReceiptCollection.get();

    if (warehouseReceiptCollectionQuery.docs.isNotEmpty) {
      for (var warehouseReceiptDocs in warehouseReceiptCollectionQuery.docs) {
        WarehouseReceipt warehouseReceipt =
            WarehouseReceipt.fromSnap(warehouseReceiptDocs);
        var warehouseReceiptDetailCollection = FirebaseFirestore.instance
            .collection('warehouseReceipts')
            .doc(warehouseReceipt.warehouse_receipt_id)
            .collection("warehouseReceiptDetails");

        var warehouseReceiptDetailCollectionQuery =
            await warehouseReceiptDetailCollection.get();
        if (warehouseReceiptDetailCollectionQuery.docs.isNotEmpty) {
          for (var warehouseReceiptDetailDocs
              in warehouseReceiptDetailCollectionQuery.docs) {
            WarehouseReceiptDetail warehouseReceiptDetail =
                WarehouseReceiptDetail.fromSnap(warehouseReceiptDetailDocs);
            if (warehouseReceiptDetail.ingredient_id == ingredientId) {
              if (warehouseReceiptDetail.expiration_date != null &&
                  Utils.isSameDateFromTimstamp(Timestamp.now(),
                      warehouseReceiptDetail.expiration_date!)) {
                print(
                    "NGUYÊN LIỆU ${warehouseReceiptDetail.ingredient_name} : SL ${warehouseReceiptDetail.quantity_in_stock} ĐÃ HẾT HẠN (Id phiếu nhập là ${warehouseReceiptDetail.warehouse_receipt_detail_id})");
              } else {
                // Số lượng còn trong kho
                quantity += warehouseReceiptDetail.quantity_in_stock;
                print(
                    "${warehouseReceiptDetail.ingredient_name} ${warehouseReceiptDetail.quantity_in_stock}");
              }
            }
            ;
          }
        }
      }
    }
    return quantity;
  }

  //gợi ý nhập kho từ nguyên liệu của món ăn
  // Future<List<Ingredient>> getRecommendedIngredients(DateTime dateApply) async {
  //   // List<Ingredient> listRecommendedIngredients = [];
  //   List<Ingredient> listIngredient = [];

  //   try {
  //     //Lấy daily sale của ngày cần gợi ý nhập
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('dailySales')
  //         .where('date_apply', isEqualTo: Timestamp.fromDate(dateApply))
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       DailySales dailySales = DailySales.fromSnap(querySnapshot.docs.first);

  //       //danh sách nguyên liệu
  //       var ingredientCollection =
  //           FirebaseFirestore.instance.collection('ingredients');
  //       var IngredientCollectionQuery = await ingredientCollection.get();

  //       for (var item in IngredientCollectionQuery.docs) {
  //         Ingredient ingredient = Ingredient.fromSnap(item);
  //         listIngredient.add(ingredient);
  //       }

  //       //thông tin chi tiết daily sale -> các món cần phục vụ kèm số lượng
  //       var dailySaleDetailCollection = FirebaseFirestore.instance
  //           .collection('dailySales')
  //           .doc(dailySales.daily_sale_id)
  //           .collection('dailySaleDetails');

  //       var dailySaleDetailCollectionQuery =
  //           await dailySaleDetailCollection.get();

  //       for (var dailySaleDetailData in dailySaleDetailCollectionQuery.docs) {
  //         //thông tin chi tiết daily sale -> các món cần phục vụ kèm số lượng
  //         DailySaleDetail dailySaleDetail =
  //             DailySaleDetail.fromSnap(dailySaleDetailData);
  //         if (dailySaleDetail.quantity_for_sell > 0) {
  //           //thông tin công thức
  //           var recipeOfFoodCollection = FirebaseFirestore.instance
  //               .collection('foods')
  //               .doc(dailySaleDetail.food_id)
  //               .collection('recipes');

  //           var recipeOfFoodCollectionQuery =
  //               await recipeOfFoodCollection.get();

  //           if (recipeOfFoodCollectionQuery.docs.isNotEmpty) {
  //             for (var item in recipeOfFoodCollectionQuery.docs) {
  //               RecipeDetail recipeDetail = RecipeDetail.fromSnap(item);

  //               print(recipeDetail.new_quantity);

  //               //xét danh sách nguyên liệu bàn đầu
  //               for (Ingredient item in listIngredient) {
  //                 if (recipeDetail.ingredient_id == item.ingredient_id) {
  //                   item.isSelected = true;
  //                   // String unitId = "";
  //                   // String unitName = "";
  //                   //Nếu có chuyển đổi đơn vị
  //                   // if (recipeDetail.unit_value_conversion > 1) {
  //                   //   print("CẦN CHUYỂN ĐỔI ĐƠN VỊ");
  //                   //   //lấy thông tin unit chuyển đổi
  //                   //   QuerySnapshot querySnapshot = await FirebaseFirestore
  //                   //       .instance
  //                   //       .collection('units')
  //                   //       .where('unit_id', isEqualTo: item.unit_id)
  //                   //       .get();

  //                   //   if (querySnapshot.docs.isNotEmpty) {
  //                   //     //đã chuyển đổi
  //                   //     Unit converedUnit =
  //                   //         Unit.fromSnap(querySnapshot.docs.first);
  //                   //     unitId = converedUnit.unit_id_conversion;
  //                   //     unitName = converedUnit.unit_name_conversion;
  //                   //   }
  //                   // } else {
  //                   //   //Không có đơn vị chuyển đổi
  //                   //   unitId = recipeDetail.unit_id;
  //                   //   unitName = recipeDetail.unit_name;
  //                   // }

  //                   // item.quantity = (recipeDetail.quantity /
  //                   //         recipeDetail.unit_value_conversion) *
  //                   //     dailySaleDetail.quantity_for_sell;
  //                   item.quantity = recipeDetail.quantity *
  //                       dailySaleDetail.quantity_for_sell;
  //                   item.new_quantity = item.quantity;
  //                   item.unit_id = recipeDetail.unit_id;
  //                   item.unit_name = recipeDetail.unit_name;
  //                   print(item.name.toUpperCase());
  //                   print("${recipeDetail.quantity} : SL trong công thức ");
  //                   print(
  //                       "${recipeDetail.unit_value_conversion} : Giá trị đơn vị chuyển đổi ");
  //                   print(
  //                       "${dailySaleDetail.quantity_for_sell} : Số lượng muốn bán ");
  //                   print("${item.unit_id} : ID đơn vị ");
  //                   print("${item.unit_name} : Tên đơn vị ");
  //                 }
  //               }
  //             }
  //           }
  //         }
  //       }
  //     } else {}
  //   } catch (error) {
  //     print('Lỗi khi truy vấn: $error');
  //   }
  //   return Future.value(listIngredient
  //       .where((ingredient) => ingredient.isSelected == true)
  //       .toList());
  // }
}
