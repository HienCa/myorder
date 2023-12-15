// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/warehouse/warehouse_export_controller.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/warehouse_export.dart';
import 'package:myorder/models/warehouse_export_detail.dart';

import 'package:myorder/utils.dart';

class CustomDialogCreateWarehouseExport extends StatefulWidget {
  final WarehouseExport warehouseExport;
  final List<Ingredient> listIngredientSelected;
  const CustomDialogCreateWarehouseExport({
    Key? key,
    required this.warehouseExport,
    required this.listIngredientSelected,
  }) : super(key: key);

  @override
  State<CustomDialogCreateWarehouseExport> createState() =>
      _CustomDialogCreateWarehouseExportState();
}

class _CustomDialogCreateWarehouseExportState
    extends State<CustomDialogCreateWarehouseExport> {
  @override
  void dispose() {
    super.dispose();
  }

  WarehouseExportController warehouseExportController =
      Get.put(WarehouseExportController());
  String code = "";
  List<WarehouseExportDetail> warehouseExportDetails = [];
  @override
  void initState() {
    super.initState();
    //mã phiếu
    if (widget.warehouseExport.warehouse_export_id != "") {
      code = widget.warehouseExport.warehouse_export_id;
    } else {
      code = Utils.generateInvoiceCode("PXK");
    }

    //chuyển đổi ingredient -> warehouseRecceiptDetail
    for (Ingredient ingredient in widget.listIngredientSelected) {
      WarehouseExportDetail warehouseRecceiptDetail = WarehouseExportDetail(
        warehouse_export_detail_id: "",
        ingredient_id: ingredient.ingredient_id,
        quantity: ingredient.quantity ?? 0,
        price: ingredient.price ?? 0,
        unit_id: ingredient.unit_id ?? '',
        ingredient_name: ingredient.name,
        unit_name: ingredient.unit_name ?? "",
      );
      warehouseExportDetails.add(warehouseRecceiptDetail);
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
                        'PHIẾU XUẤT KHO',
                        style: textStylePrimaryBold,
                      ),
                    ),
                    marginTop20,
                    ListTile(
                      title: Center(
                        child: Text(
                          widget.warehouseExport.warehouse_export_id == ""
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
                              if (widget.warehouseExport.warehouse_export_id ==
                                  "")
                                {
                                  print("add"),
                                  widget.warehouseExport.warehouse_export_code =
                                      code,
                                  warehouseExportController
                                      .createWarehouseExport(
                                          widget.warehouseExport,
                                          warehouseExportDetails),
                                  Utils.myPopResult(context, 'add')
                                }
                              else
                                {
                                  print("update"),
                                  warehouseExportController
                                      .updateWarehouseExport(
                                          widget.warehouseExport,
                                          warehouseExportController
                                              .warehouseExportDetails,
                                          widget.listIngredientSelected),
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
