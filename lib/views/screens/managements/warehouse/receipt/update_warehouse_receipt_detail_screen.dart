// ignore_for_file: constant_identifier_names, avoid_print, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/suppliers/suppliers_controller.dart';
import 'package:myorder/controllers/units/units_controller.dart';
import 'package:myorder/controllers/warehouse/warehouse_export_controller.dart';
import 'package:myorder/controllers/warehouse/warehouse_receipt_controller.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/unit.dart';
import 'package:myorder/models/warehouse_receipt.dart';
import 'package:myorder/models/supplier.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/warehouse/receipt/add_ingredient_to_warehouse_receipt_screen.dart';
import 'package:myorder/views/screens/managements/warehouse/receipt/dialogs/dialog_create_update_warehouse_receipt.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_double.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_int.dart';
import 'package:myorder/views/widgets/dialogs/dialog_select.dart';
import 'package:myorder/views/widgets/dialogs/dialog_text_field_string.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string_select.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class UpdateWarehouseReceiptDetailScreen extends StatefulWidget {
  final WarehouseReceipt warehouseReceipt;
  const UpdateWarehouseReceiptDetailScreen(
      {super.key, required this.warehouseReceipt});
  @override
  State<UpdateWarehouseReceiptDetailScreen> createState() =>
      _UpdateWarehouseReceiptDetailScreenState();
}

class _UpdateWarehouseReceiptDetailScreenState
    extends State<UpdateWarehouseReceiptDetailScreen> {
  TextEditingController nameSupplierTextEditingController =
      TextEditingController();
  TextEditingController supplierIdTextEditingController =
      TextEditingController();
  TextEditingController noteTextEditingController = TextEditingController();
  TextEditingController discountTextEditingController = TextEditingController();
  TextEditingController vatTextEditingController = TextEditingController();

  List<Ingredient> listIngredientSelected = [];
  SupplierController supplierController = Get.put(SupplierController());
  WarehouseReceiptController warehouseReceiptController =
      Get.put(WarehouseReceiptController());
  WarehouseExportController warehouseExportController =
      Get.put(WarehouseExportController());

  UnitController unitController = Get.put(UnitController());

  @override
  void initState() {
    super.initState();
    warehouseReceiptController.getWarehouseReceiptDetails(
        widget.warehouseReceipt.warehouse_receipt_id, "");

    nameSupplierTextEditingController.text =
        widget.warehouseReceipt.supplier_name;

    supplierIdTextEditingController.text = widget.warehouseReceipt.supplier_id;
    noteTextEditingController.text = widget.warehouseReceipt.note;

    vatTextEditingController.text = widget.warehouseReceipt.vat.toString();
    discountTextEditingController.text =
        widget.warehouseReceipt.discount.toString();
  }

  double getTotal() {
    double totalAmount = Utils.getSumPriceQuantity2(
        warehouseReceiptController.warehouseReceiptDetails);
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
                  onTap: () => {
                        Navigator.pop(context),
                        warehouseReceiptController.getWarehouseReceipts(
                            "", null, null)
                      },
                  child: const Icon(Icons.arrow_back_ios)),
              title: const Center(child: Text("THÔNG TIN PHIẾU NHẬP")),
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
            body: Obx(() {
              return Container(
                height: MediaQuery.of(context).size.height,
                color: backgroundColor,
                child: Column(
                  children: [
                    marginTop10,
                    InkWell(
                        onTap: () async {
                          Supplier result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MyDialogSelect(
                                  lable: "DANH SÁCH NHÀ CUNG CẤP",
                                  list: Utils.filterActive(
                                      supplierController.suppliers),
                                  keyNameSearch: "name");
                            },
                          );
                          if (result.supplier_id != "") {
                            setState(() {
                              nameSupplierTextEditingController.text =
                                  result.name;
                              supplierIdTextEditingController.text =
                                  result.supplier_id;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: MyTextFieldStringOnTap(
                              textController: nameSupplierTextEditingController,
                              label: "Nhà cung cấp",
                              placeholder: "",
                              isRequire: true),
                        )),

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
                                    child: Text("Tổng tiền",
                                        style: textStyleLabel14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      Utils.formatCurrency(
                                          Utils.getSumPriceQuantity2(
                                                  warehouseReceiptController
                                                      .warehouseReceiptDetails) +
                                              Utils.getSumPriceQuantity2(
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
                                    child: Text("Giảm trừ",
                                        style: textStyleLabel14),
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
                                                      warehouseReceiptController
                                                          .warehouseReceiptDetails)
                                                  .toInt(),
                                            );
                                          },
                                        );
                                        if (result != null) {
                                          setState(() {
                                            print(result);
                                            discountTextEditingController.text =
                                                Utils.formatCurrency(Utils
                                                    .stringConvertToDouble(Utils
                                                        .formatCurrencytoDouble(
                                                            result)));
                                          });
                                        }
                                      },
                                      child: Text(
                                        Utils.formatCurrency(
                                            Utils.stringConvertToDouble(
                                                discountTextEditingController
                                                    .text)),
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
                                    child: Text("V.A.T (%)",
                                        style: textStyleLabel14),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Mặt hàng ",
                                                    style: textStyleLabel14),
                                                Text(
                                                    '(${warehouseReceiptController.warehouseReceiptDetails.length})',
                                                    style: textStyleGreen14),
                                              ],
                                            ),
                                            const Text("Hạn SD",
                                                style: textStyleLabel14),
                                          ],
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text("Số lô",
                                              style: textStyleLabel14),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("SL Nhập",
                                                style: textStyleLabel14),
                                            Text("Đơn vị",
                                                style: textStyleLabel14),
                                          ],
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Đơn giá",
                                                style: textStyleLabel14),
                                            Text("Thành tiền",
                                                style: textStyleLabel14),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                  //DANH SÁCH NGUYÊN LIỆU CỦA PHIẾU NHẬP KHO

                                  SingleChildScrollView(
                                    child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              //danh sách nguyên liệu mới
                                              Container(
                                                height: listIngredientSelected
                                                        .length *
                                                    50,
                                                margin: const EdgeInsets.all(0),
                                                child: ListView.builder(
                                                    itemCount:
                                                        listIngredientSelected
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      Ingredient item =
                                                          listIngredientSelected[
                                                              index];
                                                      return SizedBox(
                                                        height: 50,
                                                        child: Row(children: [
                                                          Expanded(
                                                              flex: 4,
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  DateTime?
                                                                      expirationDateSelected =
                                                                      await Utils
                                                                          .selectDate(
                                                                              context);

                                                                  if (expirationDateSelected !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      item.expiration_date =
                                                                          Utils.convertDatetimeToTimestamp(
                                                                              expirationDateSelected);
                                                                    });
                                                                  }
                                                                },
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Marquee(
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      textDirection:
                                                                          TextDirection
                                                                              .ltr,
                                                                      animationDuration:
                                                                          const Duration(
                                                                              seconds: 1),
                                                                      backDuration:
                                                                          const Duration(
                                                                              milliseconds: 4000),
                                                                      pauseDuration:
                                                                          const Duration(
                                                                              milliseconds: 1000),
                                                                      directionMarguee:
                                                                          DirectionMarguee
                                                                              .TwoDirection,
                                                                      child: Text(
                                                                          item
                                                                              .name,
                                                                          style:
                                                                              textStyleFoodNameBold16,
                                                                          textAlign:
                                                                              TextAlign.left),
                                                                    ),
                                                                    marginRight5,
                                                                    Row(
                                                                      children: [
                                                                        item.expiration_date !=
                                                                                null
                                                                            ? Text(Utils.formatTimestamp(item.expiration_date),
                                                                                style: textStyleGreen14)
                                                                            : Text("Không", style: textStyleRed14),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      String
                                                                          result =
                                                                          await showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return MyDialogTextFieldString(
                                                                                  label: "Lô hàng",
                                                                                  textDefault: item.batch_number ?? "",
                                                                                  minLength: 0,
                                                                                  maxLength: 255,
                                                                                  placeholder: "Nhập",
                                                                                  isRequire: false,
                                                                                  title: 'LÔ HÀNG NHẬP KHO',
                                                                                );
                                                                              });
                                                                      if (result !=
                                                                          "") {
                                                                        setState(
                                                                            () {
                                                                          print(
                                                                              result);
                                                                          item.batch_number =
                                                                              result;
                                                                        });
                                                                      }
                                                                    },
                                                                    child: item.batch_number !=
                                                                            ""
                                                                        ? Marquee(
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            textDirection:
                                                                                TextDirection.ltr,
                                                                            animationDuration:
                                                                                const Duration(seconds: 1),
                                                                            backDuration:
                                                                                const Duration(milliseconds: 4000),
                                                                            pauseDuration:
                                                                                const Duration(milliseconds: 1000),
                                                                            directionMarguee:
                                                                                DirectionMarguee.TwoDirection,
                                                                            child: Text(item.batch_number ?? "",
                                                                                style: textStyleGreen14,
                                                                                textAlign: TextAlign.left),
                                                                          )
                                                                        : Marquee(
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            textDirection:
                                                                                TextDirection.ltr,
                                                                            animationDuration:
                                                                                const Duration(seconds: 1),
                                                                            backDuration:
                                                                                const Duration(milliseconds: 4000),
                                                                            pauseDuration:
                                                                                const Duration(milliseconds: 1000),
                                                                            directionMarguee:
                                                                                DirectionMarguee.TwoDirection,
                                                                            child: Text("",
                                                                                style: textStyleRed14,
                                                                                textAlign: TextAlign.left),
                                                                          )),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    final result =
                                                                        await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return MyDialogCalculator2(
                                                                          value:
                                                                              item.quantity ?? 0,
                                                                        );
                                                                      },
                                                                    );
                                                                    if (result !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        print(
                                                                            result);
                                                                        item.quantity =
                                                                            double.parse(result);
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                      (item.quantity)
                                                                          .toString(),
                                                                      style:
                                                                          textStyleOrange14),
                                                                ),
                                                                marginTop5,
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    Unit
                                                                        result =
                                                                        await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return MyDialogSelect(
                                                                            lable:
                                                                                "DANH SÁCH ĐƠN VỊ",
                                                                            list:
                                                                                Utils.filterActive(unitController.units),
                                                                            keyNameSearch: "name");
                                                                      },
                                                                    );
                                                                    if (result
                                                                            .unit_id !=
                                                                        "") {
                                                                      setState(
                                                                          () {
                                                                        item.unit_name =
                                                                            result.name;
                                                                        item.unit_id =
                                                                            result.unit_id;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      Marquee(
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .ltr,
                                                                    animationDuration:
                                                                        const Duration(
                                                                            seconds:
                                                                                1),
                                                                    backDuration:
                                                                        const Duration(
                                                                            milliseconds:
                                                                                4000),
                                                                    pauseDuration:
                                                                        const Duration(
                                                                            milliseconds:
                                                                                1000),
                                                                    directionMarguee:
                                                                        DirectionMarguee
                                                                            .TwoDirection,
                                                                    child: Text(
                                                                        item.unit_name ??
                                                                            "",
                                                                        style:
                                                                            textStyleGreen14,
                                                                        textAlign:
                                                                            TextAlign.left),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    final result =
                                                                        await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return MyCalculator(
                                                                          priceDefault:
                                                                              item.price ?? 0,
                                                                          min:
                                                                              0,
                                                                          max:
                                                                              MAX_PRICE,
                                                                        );
                                                                      },
                                                                    );
                                                                    if (result !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        print(
                                                                            result);
                                                                        item.price =
                                                                            Utils.stringConvertToDouble(Utils.formatCurrencytoDouble(result));
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    Utils.formatCurrency(
                                                                        (item
                                                                            .price)),
                                                                    style:
                                                                        textStyleOrange14,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  Utils.formatCurrency(((item
                                                                              .quantity ??
                                                                          0) *
                                                                      (item.price ??
                                                                          0))),
                                                                  style:
                                                                      textStylePrimary14,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                      );
                                                    }),
                                              ),

                                              Container(
                                                height: warehouseReceiptController
                                                        .warehouseReceiptDetails
                                                        .length *
                                                    50,
                                                margin: const EdgeInsets.all(0),
                                                child: ListView.builder(
                                                    itemCount:
                                                        warehouseReceiptController
                                                            .warehouseReceiptDetails
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      WarehouseReceiptDetail
                                                          item =
                                                          warehouseReceiptController
                                                                  .warehouseReceiptDetails[
                                                              index];
                                                      return SizedBox(
                                                        height: 50,
                                                        child: Row(children: [
                                                          Expanded(
                                                              flex: 4,
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  DateTime?
                                                                      expirationDateSelected =
                                                                      await Utils
                                                                          .selectDate(
                                                                              context);

                                                                  if (expirationDateSelected !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      item.expiration_date =
                                                                          Utils.convertDatetimeToTimestamp(
                                                                              expirationDateSelected);
                                                                    });
                                                                  }
                                                                },
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Marquee(
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      textDirection:
                                                                          TextDirection
                                                                              .ltr,
                                                                      animationDuration:
                                                                          const Duration(
                                                                              seconds: 1),
                                                                      backDuration:
                                                                          const Duration(
                                                                              milliseconds: 4000),
                                                                      pauseDuration:
                                                                          const Duration(
                                                                              milliseconds: 1000),
                                                                      directionMarguee:
                                                                          DirectionMarguee
                                                                              .TwoDirection,
                                                                      child: Text(
                                                                          item
                                                                              .ingredient_name,
                                                                          style:
                                                                              textStyleFoodNameBold16,
                                                                          textAlign:
                                                                              TextAlign.left),
                                                                    ),
                                                                    marginRight5,
                                                                    Row(
                                                                      children: [
                                                                        item.expiration_date !=
                                                                                null
                                                                            ? Text(Utils.formatTimestamp(item.expiration_date),
                                                                                style: textStyleGreen14)
                                                                            : Text("Không", style: textStyleRed14),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      String
                                                                          result =
                                                                          await showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return MyDialogTextFieldString(
                                                                                  label: "Lô hàng",
                                                                                  textDefault: item.batch_number,
                                                                                  minLength: 0,
                                                                                  maxLength: 255,
                                                                                  placeholder: "Nhập",
                                                                                  isRequire: false,
                                                                                  title: 'LÔ HÀNG NHẬP KHO',
                                                                                );
                                                                              });
                                                                      if (result !=
                                                                          "") {
                                                                        setState(
                                                                            () {
                                                                          print(
                                                                              result);
                                                                          item.batch_number =
                                                                              result;
                                                                        });
                                                                      }
                                                                    },
                                                                    child: item.batch_number !=
                                                                            ""
                                                                        ? Marquee(
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            textDirection:
                                                                                TextDirection.ltr,
                                                                            animationDuration:
                                                                                const Duration(seconds: 1),
                                                                            backDuration:
                                                                                const Duration(milliseconds: 4000),
                                                                            pauseDuration:
                                                                                const Duration(milliseconds: 1000),
                                                                            directionMarguee:
                                                                                DirectionMarguee.TwoDirection,
                                                                            child: Text(item.batch_number,
                                                                                style: textStyleGreen14,
                                                                                textAlign: TextAlign.left),
                                                                          )
                                                                        : Marquee(
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            textDirection:
                                                                                TextDirection.ltr,
                                                                            animationDuration:
                                                                                const Duration(seconds: 1),
                                                                            backDuration:
                                                                                const Duration(milliseconds: 4000),
                                                                            pauseDuration:
                                                                                const Duration(milliseconds: 1000),
                                                                            directionMarguee:
                                                                                DirectionMarguee.TwoDirection,
                                                                            child: Text("",
                                                                                style: textStyleRed14,
                                                                                textAlign: TextAlign.left),
                                                                          ))
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    final result =
                                                                        await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return MyDialogCalculator2(
                                                                          value:
                                                                              item.quantity,
                                                                        );
                                                                      },
                                                                    );
                                                                    if (result !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        print(
                                                                            result);
                                                                        item.quantity =
                                                                            double.parse(result);
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                      (item.quantity)
                                                                          .toString(),
                                                                      style:
                                                                          textStyleOrange14),
                                                                ),
                                                                marginTop5,
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    Unit
                                                                        result =
                                                                        await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return MyDialogSelect(
                                                                            lable:
                                                                                "DANH SÁCH ĐƠN VỊ",
                                                                            list:
                                                                                Utils.filterActive(unitController.units),
                                                                            keyNameSearch: "name");
                                                                      },
                                                                    );
                                                                    if (result
                                                                            .unit_id !=
                                                                        "") {
                                                                      setState(
                                                                          () {
                                                                        item.unit_name =
                                                                            result.name;
                                                                        item.unit_id =
                                                                            result.unit_id;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      Marquee(
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .ltr,
                                                                    animationDuration:
                                                                        const Duration(
                                                                            seconds:
                                                                                1),
                                                                    backDuration:
                                                                        const Duration(
                                                                            milliseconds:
                                                                                4000),
                                                                    pauseDuration:
                                                                        const Duration(
                                                                            milliseconds:
                                                                                1000),
                                                                    directionMarguee:
                                                                        DirectionMarguee
                                                                            .TwoDirection,
                                                                    child: Text(
                                                                        item
                                                                            .unit_name,
                                                                        style:
                                                                            textStyleGreen14,
                                                                        textAlign:
                                                                            TextAlign.left),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    final result =
                                                                        await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return MyCalculator(
                                                                          priceDefault:
                                                                              item.price,
                                                                          min:
                                                                              0,
                                                                          max:
                                                                              MAX_PRICE,
                                                                        );
                                                                      },
                                                                    );
                                                                    if (result !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        print(
                                                                            result);
                                                                        item.price =
                                                                            Utils.stringConvertToDouble(Utils.formatCurrencytoDouble(result));
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    Utils.formatCurrency(
                                                                        (item
                                                                            .price)),
                                                                    style:
                                                                        textStyleOrange14,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  Utils.formatCurrency(
                                                                      ((item.quantity) *
                                                                          (item
                                                                              .price))),
                                                                  style:
                                                                      textStylePrimary14,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ))),

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
                                  List<Ingredient> result =
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddIngredientToWarehouseReceiptScreen(
                                                    isUpdate: true,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  if (supplierIdTextEditingController.text ==
                                      "") {
                                    Utils.showStylishDialog(
                                        context,
                                        "THÔNG BÁO",
                                        "Nhà cung cấp chưa được chọn!",
                                        StylishDialogType.INFO);
                                  }
                                  // else if (listIngredientSelected.isEmpty) {
                                  //   Utils.showStylishDialog(
                                  //       context,
                                  //       "THÔNG BÁO",
                                  //       "Vui lòng thêm các mặt hàng cần nhập!",
                                  //       StylishDialogType.INFO);
                                  // }
                                  else {
                                    int vatPercent = int.tryParse(
                                            vatTextEditingController.text) ??
                                        0;
                                    double discountPrice =
                                        Utils.stringConvertToDouble(
                                            discountTextEditingController.text);

                                    //Cập nhật
                                    widget.warehouseReceipt.vat = vatPercent;
                                    widget.warehouseReceipt.discount =
                                        discountPrice;
                                    widget.warehouseReceipt.supplier_id =
                                        supplierIdTextEditingController.text;
                                    widget.warehouseReceipt.supplier_name =
                                        nameSupplierTextEditingController.text
                                            .trim();
                                    widget.warehouseReceipt.note =
                                        noteTextEditingController.text.trim();
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialogCreateWarehouseReceipt(
                                            warehouseReceipt:
                                                widget.warehouseReceipt,
                                            listIngredientSelected:
                                                listIngredientSelected);
                                      },
                                    );
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
                                  child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(FontAwesomeIcons.check,
                                            color: colorSuccess, size: 16),
                                        marginRight5,
                                        Text("CẬP NHẬT",
                                            style: textStyleSuccessBold16),
                                      ]),
                                ),
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              );
            })));
  }
}
