// ignore_for_file: constant_identifier_names, avoid_print, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/units/units_controller.dart';
import 'package:myorder/controllers/warehouse/cancellation_receipt_controller.dart';
import 'package:myorder/models/cancellation_receipt.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/warehouse/cancel/dialogs/dialog_confirm_update_quantity_cancel_multi_receipt.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_double.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class UpdateCancelReceiptDetailScreen extends StatefulWidget {
  final CancellationReceipt cancellationReceipt;
  const UpdateCancelReceiptDetailScreen(
      {super.key, required this.cancellationReceipt});
  @override
  State<UpdateCancelReceiptDetailScreen> createState() =>
      _UpdateCancelReceiptDetailScreenState();
}

class _UpdateCancelReceiptDetailScreenState
    extends State<UpdateCancelReceiptDetailScreen> {
  TextEditingController reasonTextEditingController = TextEditingController();
  UnitController unitController = Get.put(UnitController());
  CancellationReceiptController cancellationReceiptController =
      Get.put(CancellationReceiptController());
  @override
  void initState() {
    super.initState();
    reasonTextEditingController.text = widget.cancellationReceipt.reason;
    cancellationReceiptController.getCancellationReceiptDetails(
        widget.cancellationReceipt.cancellation_receipt_id, "");
  }

//Tính tổng tiền theo quantity_in_stock
  double getTotalAmount(List<WarehouseReceiptDetail> list) {
    double total = 0;
    for (var item in list) {
      print(item.new_quantity);
      total += (item.price * (item.new_quantity ?? 0));
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: InkWell(
                  onTap: () => {
                        Navigator.pop(context),
                        cancellationReceiptController.getCancellationReceipts(
                            "", null, null)
                      },
                  child: const Icon(Icons.arrow_back_ios)),
              title: const Center(child: Text("THÔNG TIN PHIẾU HỦY")),
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
                            textController: reasonTextEditingController,
                            label: "Lý do hủy",
                            placeholder: "Nhập lú do vào đây",
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
                                  child: Text("TỔNG GIÁ TRỊ ĐÃ HỦY",
                                      style: textStylePriceBold16),
                                ),
                                Obx(() {
                                  return Expanded(
                                    child: Text(
                                      Utils.formatCurrency(getTotalAmount(
                                          cancellationReceiptController
                                              .cancellationReceiptDetails)),
                                      style: textStylePriceBold16,
                                      textAlign: TextAlign.right,
                                    ),
                                  );
                                })
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
                                                  '(${widget.cancellationReceipt.warehouseReceiptDetails?.length})',
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
                                          Text("SL hủy",
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
                                //DANH SÁCH NGUYÊN LIỆU ĐÃ HỦY

                                SingleChildScrollView(
                                  child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            //danh sách nguyên liệu mới
                                            Container(
                                              height: (widget.cancellationReceipt
                                                              .warehouseReceiptDetails ??
                                                          [])
                                                      .length *
                                                  50,
                                              margin: const EdgeInsets.all(0),
                                              child: ListView.builder(
                                                  itemCount: (widget
                                                              .cancellationReceipt
                                                              .warehouseReceiptDetails ??
                                                          [])
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    WarehouseReceiptDetail
                                                        item =
                                                        widget.cancellationReceipt
                                                                .warehouseReceiptDetails![
                                                            index];
                                                    return SizedBox(
                                                      height: 50,
                                                      child: Row(children: [
                                                        Expanded(
                                                            flex: 4,
                                                            child: InkWell(
                                                              // onTap:
                                                              //     () async {
                                                              //   DateTime?
                                                              //       expirationDateSelected =
                                                              //       await Utils
                                                              //           .selectDate(
                                                              //               context);

                                                              //   if (expirationDateSelected !=
                                                              //       null) {
                                                              //     setState(
                                                              //         () {
                                                              //       item.expiration_date =
                                                              //           Utils.convertDatetimeToTimestamp(
                                                              //               expirationDateSelected);
                                                              //     });
                                                              //   }
                                                              // },
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
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
                                                                              style:
                                                                                  textStyleRed14)
                                                                          : Text(
                                                                              "Không",
                                                                              style: textStyleRed14),
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
                                                                  // onTap:
                                                                  //     () async {
                                                                  //   String
                                                                  //       result =
                                                                  //       await showDialog(
                                                                  //           context: context,
                                                                  //           builder: (BuildContext context) {
                                                                  //             return MyDialogTextFieldString(
                                                                  //               label: "Lô hàng",
                                                                  //               textDefault: item.batch_number ?? "",
                                                                  //               minLength: 0,
                                                                  //               maxLength: 255,
                                                                  //               placeholder: "Nhập",
                                                                  //               isRequire: false,
                                                                  //               title: 'LÔ HÀNG NHẬP KHO',
                                                                  //             );
                                                                  //           });
                                                                  //   if (result !=
                                                                  //       "") {
                                                                  //     setState(
                                                                  //         () {
                                                                  //       print(
                                                                  //           result);
                                                                  //       item.batch_number =
                                                                  //           result;
                                                                  //     });
                                                                  //   }
                                                                  // },
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
                                                                          child: Text(
                                                                              item.batch_number,
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
                                                                          child: Text(
                                                                              "",
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
                                                                        value: item
                                                                            .quantity_in_stock,
                                                                      );
                                                                    },
                                                                  );
                                                                  if (result !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      print(
                                                                          result);
                                                                      item.new_quantity =
                                                                          double.parse(
                                                                              result);
                                                                    });
                                                                  }
                                                                },
                                                                child: Text(
                                                                    item.new_quantity
                                                                        .toString(),
                                                                    style:
                                                                        textStyleOrange14),
                                                              ),
                                                              marginTop5,
                                                              InkWell(
                                                                // onTap:
                                                                //     () async {
                                                                //   Unit
                                                                //       result =
                                                                //       await showDialog(
                                                                //     context:
                                                                //         context,
                                                                //     builder:
                                                                //         (BuildContext
                                                                //             context) {
                                                                //       return MyDialogSelect(
                                                                //           lable:
                                                                //               "DANH SÁCH ĐƠN VỊ",
                                                                //           list:
                                                                //               Utils.filterActive(unitController.units),
                                                                //           keyNameSearch: "name");
                                                                //     },
                                                                //   );
                                                                //   if (result
                                                                //           .unit_id !=
                                                                //       "") {
                                                                //     setState(
                                                                //         () {
                                                                //       item.unit_name =
                                                                //           result.name;
                                                                //       item.unit_id =
                                                                //           result.unit_id;
                                                                //     });
                                                                //   }
                                                                // },
                                                                child: Marquee(
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
                                                                          TextAlign
                                                                              .left),
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
                                                                    ((item.new_quantity ??
                                                                            0) *
                                                                        item.price)),
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
                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogConfirmUpdateQuantityCancelMultiReceipt(
                                      cancellationReceipt:
                                          widget.cancellationReceipt,
                                      reason: reasonTextEditingController.text,
                                    );
                                  },
                                );
                                if (result == "success") {
                                  Utils.showStylishDialog(
                                      context,
                                      "THÔNG BÁO",
                                      "Cập nhật phiếu hủy thành công!",
                                      StylishDialogType.SUCCESS);
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
            )));
  }
}
