// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/warehouse_receipts/warehouse_receipt_controller.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/warehouse_receipt.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';
import 'package:myorder/utils.dart';

class CustomDialogCreateWarehouseReceipt extends StatefulWidget {
  final WarehouseReceipt warehouseReceipt;
  final List<Ingredient> listIngredientSelected;
  const CustomDialogCreateWarehouseReceipt({
    Key? key,
    required this.warehouseReceipt,
    required this.listIngredientSelected,
  }) : super(key: key);

  @override
  State<CustomDialogCreateWarehouseReceipt> createState() =>
      _CustomDialogCreateWarehouseReceiptState();
}

class _CustomDialogCreateWarehouseReceiptState
    extends State<CustomDialogCreateWarehouseReceipt> {
  @override
  void dispose() {
    super.dispose();
  }

  WarehouseReceiptController warehouseReceiptController =
      Get.put(WarehouseReceiptController());
  String code = "";
  List<WarehouseReceiptDetail> warehouseRecceiptDetails = [];
  @override
  void initState() {
    super.initState();
    //mã phiếu
    if (widget.warehouseReceipt.warehouse_receipt_id != "") {
      code = widget.warehouseReceipt.warehouse_receipt_code;
    } else {
      code = Utils.generateInvoiceCode("PNK");
    }

    //chuyển đổi ingredient -> warehouseRecceiptDetail
    for (Ingredient ingredient in widget.listIngredientSelected) {
      WarehouseReceiptDetail warehouseRecceiptDetail = WarehouseReceiptDetail(
        warehouse_receipt_detail_id: "",
        ingredient_id: ingredient.ingredient_id,
        quantity: ingredient.quantity ?? 0,
        price: ingredient.price ?? 0,
        unit_id: ingredient.unit_id ?? '',
        ingredient_name: ingredient.name,
        unit_name: ingredient.unit_name ?? "",
      );
      warehouseRecceiptDetails.add(warehouseRecceiptDetail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
      ),
      elevation: 5, // Độ nâng của bóng đổ
      backgroundColor: backgroundColor,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'PHIẾU NHẬP KHO',
                        style: textStylePrimaryBold,
                      ),
                    ),
                    marginTop20,
                    ListTile(
                      title: Center(
                        child: Text(
                          widget.warehouseReceipt.warehouse_receipt_id == ""
                              ? "Mã phiếu '$code' sẽ được tạo?"
                              : "Phiếu '$code' sẽ được cập nhật?",
                          style: textStyleBlackRegular,
                        ),
                      ),
                    ),
                    marginTop20,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => {Navigator.pop(context)},
                            child: Container(
                              height: 50,
                              width: 136,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: backgroundColorGray,
                              ),
                              child: const Center(
                                child: Text(
                                  'HỦY BỎ',
                                  style: textStyleCancel,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => {
                              //mã phiếu
                              if (widget
                                      .warehouseReceipt.warehouse_receipt_id ==
                                  "")
                                {
                                  print("add"),

                                  widget.warehouseReceipt
                                      .warehouse_receipt_code = code,
                                  warehouseReceiptController
                                      .createWarehouseReceipt(
                                          widget.warehouseReceipt,
                                          warehouseRecceiptDetails),
                                  Utils.myPopResult(context, 'add')
                                }
                              else
                                {
                                  print("update"),
                                  warehouseReceiptController
                                      .updateWarehouseReceipt(
                                          widget.warehouseReceipt,
                                          warehouseRecceiptDetails),
                                  Utils.myPopResult(context, 'update')
                                }
                            },
                            child: Container(
                              height: 50,
                              width: 136,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: primaryColor,
                              ),
                              child: const Center(
                                child: Text(
                                  'XÁC NHẬN',
                                  style: textStyleWhiteBold20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
