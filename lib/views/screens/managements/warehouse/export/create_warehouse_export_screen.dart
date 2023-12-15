// ignore_for_file: constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/ingredients/ingredients_controller.dart';
import 'package:myorder/controllers/suppliers/suppliers_controller.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/warehouse_export.dart';
import 'package:myorder/models/warehouse_export_detail.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/warehouse/export/add_ingredient_to_warehouse_export_screen.dart';
import 'package:myorder/views/screens/managements/warehouse/export/dialogs/dialog_create_update_warehouse_export.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_double.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_int.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class WarehouseExportDetailScreen extends StatefulWidget {
  final WarehouseExport? warehouseExport;

  const WarehouseExportDetailScreen({super.key, this.warehouseExport});
  @override
  State<WarehouseExportDetailScreen> createState() =>
      _WarehouseExportDetailScreenState();
}

class _WarehouseExportDetailScreenState
    extends State<WarehouseExportDetailScreen> {
  TextEditingController nameSupplierTextEditingController =
      TextEditingController();
  TextEditingController supplierIdTextEditingController =
      TextEditingController();

  TextEditingController noteTextEditingController = TextEditingController();
  TextEditingController discountTextEditingController = TextEditingController();
  TextEditingController vatTextEditingController = TextEditingController();
  IngredientController ingredientController = Get.put(IngredientController());

  List<Ingredient> listIngredientSelected = [];
  SupplierController supplierController = Get.put(SupplierController());

  @override
  void initState() {
    super.initState();
    listIngredientSelected = [];

    //setup WarehouseExport
    if (widget.warehouseExport != null) {
      //update
      discountTextEditingController.text =
          Utils.formatCurrency(widget.warehouseExport?.discount ?? 0);

      vatTextEditingController.text =
          widget.warehouseExport?.vat.toString() ?? "0";

      noteTextEditingController.text = widget.warehouseExport?.note ?? "";

      supplierIdTextEditingController.text =
          widget.warehouseExport?.supplier_id ?? "";

      nameSupplierTextEditingController.text =
          widget.warehouseExport?.supplier_name ?? "";

      //thiết lập danh sách mặt hàng của phiếu
      List<Ingredient> listIngredientFromReceipt = [];

      for (WarehouseExportDetail warehouseRecceiptDetail
          in widget.warehouseExport?.warehouseExportDetails ?? []) {
        // Tìm kiếm phần tử tương ứng trong danh sách ingredients
        Ingredient? foundIngredient = ingredientController.ingredients
            .firstWhere(
                (ingredient) =>
                    ingredient.ingredient_id ==
                    warehouseRecceiptDetail.ingredient_id,
                orElse: () =>
                    Ingredient(ingredient_id: "", name: "", active: 0));

        // Nếu tìm thấy, thiết lập giá trị
        if (foundIngredient.ingredient_id != "") {
          Ingredient ingredient = Ingredient(
              ingredient_id: warehouseRecceiptDetail.ingredient_id,
              name: warehouseRecceiptDetail.ingredient_name,
              active: 1);
          ingredient.price = warehouseRecceiptDetail.price;
          ingredient.quantity = warehouseRecceiptDetail.quantity;
          ingredient.new_quantity = warehouseRecceiptDetail.new_quantity;
          ingredient.unit_id = warehouseRecceiptDetail.unit_id;
          ingredient.unit_name = warehouseRecceiptDetail.unit_name;
          ingredient.isSelected = true;
          listIngredientFromReceipt.add(ingredient);
        }
      }
      listIngredientSelected = listIngredientFromReceipt;
    } else {
      discountTextEditingController.text = '0';
      vatTextEditingController.text = '0';
    }
  }

  double getTotal() {
    double totalAmount = Utils.getSumPriceQuantity2(listIngredientSelected);
    int vatPercent = int.tryParse(vatTextEditingController.text) ?? 0;
    double discountPrice =
        Utils.stringConvertToDouble(discountTextEditingController.text);

    double totalVat = totalAmount * vatPercent / 100;
    return totalAmount + totalVat - discountPrice;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: Center(
              child: Text(widget.warehouseExport == null
                  ? "TẠO PHIẾU XUẤT KHO"
                  : "THÔNG TIN PHIẾU XUẤT")),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.add_circle_outline,
                  color: transparentColor,
                ),
              ),
            ),
          ],
          backgroundColor: primaryColor,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: backgroundColor,
          child: Column(
            children: [
              marginTop10,

              Container(
                margin: const EdgeInsets.all(0),
                child: Container(
                  decoration: BoxDecoration(
                    color: grayColor100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      MyTextFieldString(
                        textController: noteTextEditingController,
                        label: "GHI CHÚ",
                        placeholder: "Nhập ghi chú vào đây",
                        isReadOnly: false,
                        min: 0,
                        max: 200,
                        isRequire: false,
                        isBorder: false,
                        isMultiline: true,
                      )
                    ],
                  ),
                ),
              ),
              deviderColor10,
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text("Tổng tiền", style: textStyleLabel14),
                            ),
                            Expanded(
                              child: Text(
                                Utils.formatCurrency(Utils.getSumPriceQuantity2(
                                    listIngredientSelected)),
                                style: textStyleLabel14,
                                textAlign: TextAlign.right,
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text("Giảm trừ", style: textStyleLabel14),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final result = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MyCalculator(
                                        priceDefault:
                                            Utils.stringConvertToDouble(
                                                discountTextEditingController
                                                    .text),
                                        min: 0,
                                        max: Utils.getSumPriceQuantity2(
                                                listIngredientSelected)
                                            .toInt(),
                                      );
                                    },
                                  );
                                  if (result != null) {
                                    setState(() {
                                      print(result);
                                      discountTextEditingController.text =
                                          Utils.formatCurrency(
                                              Utils.stringConvertToDouble(
                                                  Utils.formatCurrencytoDouble(
                                                      result)));
                                    });
                                  }
                                },
                                child: Text(
                                  Utils.formatCurrency(
                                      Utils.stringConvertToDouble(
                                          discountTextEditingController.text)),
                                  style: textStyleLabel14,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text("V.A.T (%)", style: textStyleLabel14),
                            ),
                            InkWell(
                              onTap: () async {
                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MyDialogCalculatorInt(
                                        value: int.tryParse(
                                                vatTextEditingController
                                                    .text) ??
                                            0,
                                        label: "V.A.T (%)",
                                        min: 0,
                                        max: 10);
                                  },
                                );
                                if (result != null) {
                                  setState(() {
                                    print(result);
                                    vatTextEditingController.text =
                                        result.toString();
                                  });
                                }
                              },
                              child: Expanded(
                                child: Text(
                                  vatTextEditingController.text,
                                  style: textStyleLabel14,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text("THANH TOÁN",
                                  style: textStylePriceBold16),
                            ),
                            Expanded(
                              child: Text(
                                Utils.formatCurrency(getTotal()),
                                style: textStylePriceBold16,
                                textAlign: TextAlign.right,
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
              deviderColor10,
              //DANH SÁCH CÁC MẶT HÀNG
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Text("Mặt hàng ",
                                        style: textStyleLabel14),
                                    Text('(${listIngredientSelected.length})',
                                        style: textStyleGreen14),
                                  ],
                                ),
                                const Text("Đơn vị", style: textStyleLabel14),
                              ],
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("SL Xuất", style: textStyleLabel14),
                                Text("SL Tồn", style: textStyleLabel14),
                              ],
                            ),
                          ),
                          const Expanded(
                            flex: 3,
                            child: Center(
                              child: Text("Đơn giá", style: textStyleLabel14),
                            ),
                          ),
                          const Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Thành tiền", style: textStyleLabel14),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      //DANH SÁCH NGUYÊN LIỆU CỦA PHIẾU NHẬP KHO
                      SingleChildScrollView(
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: ListView.builder(
                                itemCount: listIngredientSelected.length,
                                itemBuilder: (context, index) {
                                  Ingredient ingredient =
                                      listIngredientSelected[index];
                                  return SizedBox(
                                    height: 50,
                                    child: Row(children: [
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Marquee(
                                                direction: Axis.horizontal,
                                                textDirection:
                                                    TextDirection.ltr,
                                                animationDuration:
                                                    const Duration(seconds: 1),
                                                backDuration: const Duration(
                                                    milliseconds: 4000),
                                                pauseDuration: const Duration(
                                                    milliseconds: 1000),
                                                directionMarguee:
                                                    DirectionMarguee
                                                        .TwoDirection,
                                                child: Text(ingredient.name,
                                                    style:
                                                        textStyleFoodNameBold16,
                                                    textAlign: TextAlign.left),
                                              ),
                                              marginRight5,
                                              Row(
                                                children: [
                                                  Text(
                                                      ingredient.unit_name ??
                                                          "",
                                                      style: textStyleGreen14),
                                                ],
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: InkWell(
                                          onTap: () async {
                                            final result = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return MyDialogCalculator2(
                                                  value:
                                                      ingredient.quantity ?? 0,
                                                );
                                              },
                                            );
                                            if (result != null) {
                                              setState(() {
                                                print(result);
                                                ingredient.quantity =
                                                    double.parse(result);
                                              });
                                            }
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  (ingredient.quantity ?? 0)
                                                      .toString(),
                                                  style: textStyleOrange14),
                                              marginTop5,
                                              Text(
                                                  (ingredient.quantity ?? 0)
                                                      .toString(),
                                                  style: textStylePrimary14),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: InkWell(
                                          onTap: () async {
                                            final result = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return MyCalculator(
                                                  priceDefault:
                                                      ingredient.price ?? 0,
                                                  min: 0,
                                                  max: MAX_PRICE,
                                                );
                                              },
                                            );
                                            if (result != null) {
                                              setState(() {
                                                print(result);
                                                ingredient.price = Utils
                                                    .stringConvertToDouble(Utils
                                                        .formatCurrencytoDouble(
                                                            result));
                                              });
                                            }
                                          },
                                          child: Center(
                                            child: Text(
                                              Utils.formatCurrency(
                                                  (ingredient.price ?? 0)),
                                              style: textStyleOrange14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              Utils.formatCurrency(
                                                  ((ingredient.quantity ?? 0) *
                                                      (ingredient.price ?? 0))),
                                              style: textStylePrimary14,
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  );
                                })),
                      )
                    ],
                  ),
                ),
              )),

              Container(
                color: backgroundColor,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            List<Ingredient> result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddIngredientToWarehouseExportScreen(
                                          isUpdate:
                                              widget.warehouseExport != null
                                                  ? true
                                                  : false,
                                        )));
                            if (result.isNotEmpty) {
                              setState(() {
                                listIngredientSelected = result;
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryColorOpacity,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.plus,
                                      color: primaryColor, size: 16),
                                  marginRight5,
                                  Text("MẶT HÀNG",
                                      style: textStylePrimaryBold16),
                                ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            if (listIngredientSelected.isEmpty) {
                              Utils.showStylishDialog(
                                  context,
                                  "THÔNG BÁO",
                                  "Vui lòng thêm các mặt hàng cần xuất!",
                                  StylishDialogType.INFO);
                            } else {
                              int vatPercent =
                                  int.tryParse(vatTextEditingController.text) ??
                                      0;
                              double discountPrice =
                                  Utils.stringConvertToDouble(
                                      discountTextEditingController.text);

                              if (widget.warehouseExport == null) {
                                WarehouseExport warehouseExport =
                                    WarehouseExport(
                                  warehouse_export_id: "",
                                  warehouse_export_code: "",
                                  employee_id: "",
                                  employee_name: "",
                                  created_at: Timestamp.now(),
                                  note: noteTextEditingController.text.trim(),
                                  vat: vatPercent,
                                  discount: discountPrice,
                                  status: 1,
                                  active: 1,
                                  supplier_id:
                                      supplierIdTextEditingController.text,
                                  supplier_name:
                                      nameSupplierTextEditingController.text
                                          .trim(),
                                );
                                //Tạo mới
                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogCreateWarehouseExport(
                                        warehouseExport: warehouseExport,
                                        listIngredientSelected:
                                            listIngredientSelected);
                                  },
                                );
                                if (result == 'add') {
                                  Utils.myPopSuccess(context);
                                }
                              } else {
                                //Cập nhật
                                widget.warehouseExport?.vat = vatPercent;
                                widget.warehouseExport?.discount =
                                    discountPrice;
                                widget.warehouseExport?.supplier_id =
                                    supplierIdTextEditingController.text;
                                widget.warehouseExport?.supplier_name =
                                    nameSupplierTextEditingController.text
                                        .trim();

                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogCreateWarehouseExport(
                                        warehouseExport:
                                            widget.warehouseExport!,
                                        listIngredientSelected:
                                            listIngredientSelected);
                                  },
                                );
                                if (result == 'update') {
                                  Utils.myPopSuccess(context);
                                }
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: greenColor50,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(FontAwesomeIcons.check,
                                      color: colorSuccess, size: 16),
                                  marginRight5,
                                  Text(
                                      widget.warehouseExport == null
                                          ? "TẠO PHIẾU"
                                          : "CẬP NHẬT",
                                      style: textStyleSuccessBold16),
                                ]),
                          ),
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
