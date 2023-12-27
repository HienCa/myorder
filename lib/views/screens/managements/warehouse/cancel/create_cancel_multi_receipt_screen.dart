// ignore_for_file: constant_identifier_names, avoid_print, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/warehouse/cancellation_receipt_controller.dart';
import 'package:myorder/models/cancellation_receipt.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/warehouse/cancel/dialogs/dialog_confirm_create_cancel_multi_receipt.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';

class CancelMultiReceiptDetailScreen extends StatefulWidget {
  final CancellationReceipt? cancellationReceipt;
  const CancelMultiReceiptDetailScreen({super.key, this.cancellationReceipt});
  @override
  State<CancelMultiReceiptDetailScreen> createState() =>
      _CancelMultiReceiptDetailScreenState();
}

class _CancelMultiReceiptDetailScreenState
    extends State<CancelMultiReceiptDetailScreen> {
  TextEditingController nameSupplierTextEditingController =
      TextEditingController();
  TextEditingController reasonTextEditingController = TextEditingController();

  CancellationReceiptController cancellationReceiptController =
      Get.put(CancellationReceiptController());

  @override
  void initState() {
    super.initState();
    cancellationReceiptController.getCheckCancellationReceiptDetails("");
    //setup
    if (widget.cancellationReceipt != null) {
    } else {}
    reasonTextEditingController.text = "Nguyên liệu đã hết hạn sử dụng";
  }

  bool isCheckAll = false;
  void checkedAll() {
    for (WarehouseReceiptDetail item
        in cancellationReceiptController.checkCancellationReceips) {
      if (item.isSelected == false) {
        isCheckAll = false;
        break;
      } else {
        isCheckAll = true;
        print("CHỌN TẤT CẢ");
      }
    }
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
            child: Text(widget.cancellationReceipt == null
                ? "TẠO PHIẾU HỦY"
                : "THÔNG TIN PHIẾU HỦY")),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: InkWell(
                onTap: () async {
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return CustomDialogRecommendExpiredIngredients();
                  //   },
                  // );
                },
                child: Icon(
                  Icons.book,
                  color: transparentColor,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: primaryColor,
      ),
      body: //Create
          Container(
        height: MediaQuery.of(context).size.height,
        color: backgroundColor,
        child: Theme(
          data: ThemeData(unselectedWidgetColor: primaryColor),
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
                        placeholder: "Nhập lý do vào đây",
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
                              child: Text("TỔNG GIÁ TRỊ HỦY",
                                  style: textStylePriceBold16),
                            ),
                            Expanded(
                              child: Text(
                                Utils.formatCurrency(
                                    Utils.getTotalAmountCancelReceipt(
                                        cancellationReceiptController
                                            .checkCancellationReceips)),
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
              //DANH SÁCH CÁC MẶT HÀNG HỦY
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
                                  flex: 1,
                                  child: Center(
                                    child: Checkbox(
                                      value: isCheckAll,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckAll = value ?? false;
                                          for (WarehouseReceiptDetail item
                                              in cancellationReceiptController
                                                  .checkCancellationReceips) {
                                            if (value == true) {
                                              //tất cả được check
                                              item.isSelected = true;
                                              print("CHỌN TẤT CẢ");
                                            } else {
                                              //tất cả bỏ check
                                              item.isSelected = false;
                                              print("BỎ CHỌN TẤT CẢ");
                                            }
                                          }
                                        });
                                      },
                                      activeColor: primaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Mặt hàng ",
                                              style: textStyleLabel14),
                                          Obx(() {
                                            return Text(
                                                '(${Utils.counterSelected(cancellationReceiptController.checkCancellationReceips)})',
                                                style: textStyleGreen14);
                                          }),
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
                                    child:
                                        Text("Số lô", style: textStyleLabel14),
                                  ),
                                ),
                                const Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("SL hủy", style: textStyleLabel14),
                                      Text("Đơn vị", style: textStyleLabel14),
                                    ],
                                  ),
                                ),
                                const Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Đơn giá", style: textStyleLabel14),
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
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: cancellationReceiptController
                                                  .checkCancellationReceips
                                                  .length *
                                              50,
                                          margin: const EdgeInsets.all(0),
                                          child: Obx(() {
                                            return ListView.builder(
                                                itemCount:
                                                    cancellationReceiptController
                                                        .checkCancellationReceips
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  WarehouseReceiptDetail item =
                                                      cancellationReceiptController
                                                              .checkCancellationReceips[
                                                          index];
                                                  return SizedBox(
                                                    height: 50,
                                                    child: Row(children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: InkWell(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Checkbox(
                                                                  value: cancellationReceiptController
                                                                      .checkCancellationReceips[
                                                                          index]
                                                                      .isSelected,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      cancellationReceiptController
                                                                          .checkCancellationReceips[
                                                                              index]
                                                                          .isSelected = !cancellationReceiptController.checkCancellationReceips[index].isSelected;
                                                                    });
                                                                    checkedAll();
                                                                  },
                                                                  activeColor:
                                                                      primaryColor,
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                      Expanded(
                                                          flex: 4,
                                                          child: InkWell(
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
                                                                          TextAlign
                                                                              .left),
                                                                ),
                                                                marginRight5,
                                                                Row(
                                                                  children: [
                                                                    item.expiration_date !=
                                                                            null
                                                                        ? Text(
                                                                            Utils.formatTimestamp(item
                                                                                .expiration_date),
                                                                            style:
                                                                                textStyleRed14)
                                                                        : Text(
                                                                            "Không",
                                                                            style:
                                                                                textStyleRed14),
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
                                                                            item
                                                                                .batch_number,
                                                                            style:
                                                                                textStyleGreen14,
                                                                            textAlign:
                                                                                TextAlign.left),
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
                                                                            style:
                                                                                textStyleRed14,
                                                                            textAlign:
                                                                                TextAlign.left),
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
                                                              child: Text(
                                                                  item.quantity_in_stock
                                                                      .toString(),
                                                                  style:
                                                                      textStyleOrange14),
                                                            ),
                                                            marginTop5,
                                                            InkWell(
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
                                                                  (item.quantity_in_stock *
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
                                                });
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
                            if (Utils.counterSelected(
                                    cancellationReceiptController
                                        .checkCancellationReceips) >
                                0) {
                              List<WarehouseReceiptDetail> list = [];

                              for (WarehouseReceiptDetail item
                                  in cancellationReceiptController
                                      .checkCancellationReceips) {
                                if (item.isSelected) {
                                  list.add(item);
                                }
                              }
                              print(
                                  "SỐ LƯỢNG NGUYÊN LIỆU CẦN HỦY: ${list.length}");
                              final result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialogConfirmCancelMultiReceipt(
                                      expiredIngredients: list);
                                },
                              );
                              if (result == 'success') {
                                Utils.myPopResult(context, "PH_success");
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
                            child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.check,
                                      color: colorSuccess, size: 16),
                                  marginRight5,
                                  Text("TẠO PHIẾU HỦY",
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
    ));
  }
}
