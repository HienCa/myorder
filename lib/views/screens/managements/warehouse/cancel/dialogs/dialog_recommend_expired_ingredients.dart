// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/warehouse/cancellation_receipt_controller.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';

class CustomDialogRecommendExpiredIngredients extends StatefulWidget {
  const CustomDialogRecommendExpiredIngredients({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDialogRecommendExpiredIngredients> createState() =>
      _CustomDialogRecommendExpiredIngredientsState();
}

class _CustomDialogRecommendExpiredIngredientsState
    extends State<CustomDialogRecommendExpiredIngredients> {
  CancellationReceiptController cancellationReceiptController =
      Get.put(CancellationReceiptController());
  bool isCheckAll = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cancellationReceiptController.getCheckCancellationReceiptDetails("");
  }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.clockRotateLeft,
                            color: transparentColor, size: 16),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'NGUYÊN LIỆU CẦN HỦY',
                                style: textStylePrimaryBold,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            for (WarehouseReceiptDetail item
                                in cancellationReceiptController
                                    .checkCancellationReceips) {
                              item.isSelected = false;
                            }
                          },
                          child: MyCloseIcon(
                            heightWidth: 40,
                            sizeIcon: 20,
                          ),
                        )
                      ],
                    ),
                    marginTop10,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Text("Mặt hàng",
                                      style: textStyleLabel14),
                                  Text(
                                      '(${cancellationReceiptController.checkCancellationReceips.length})',
                                      style: textStyleGreen14),
                                ],
                              ),
                              const Text("Hạn SD", style: textStyleLabel14),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Center(
                            child: Text("Số lô", style: textStyleLabel14),
                          ),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("SL hủy", style: textStyleLabel14),
                              Text("Đơn vị", style: textStyleLabel14),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    //DANH SÁCH NGUYÊN LIỆU CẦN HỦY

                    SingleChildScrollView(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                //danh sách nguyên liệu mới
                                Container(
                                  height: cancellationReceiptController
                                          .checkCancellationReceips.length *
                                      50,
                                  margin: const EdgeInsets.all(0),
                                  child: Obx(() {
                                    return ListView.builder(
                                        itemCount: cancellationReceiptController
                                            .checkCancellationReceips.length,
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
                                                              (bool? value) {
                                                            setState(() {
                                                              cancellationReceiptController
                                                                      .checkCancellationReceips[
                                                                          index]
                                                                      .isSelected =
                                                                  !cancellationReceiptController
                                                                      .checkCancellationReceips[
                                                                          index]
                                                                      .isSelected;
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
                                                          direction:
                                                              Axis.horizontal,
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          animationDuration:
                                                              const Duration(
                                                                  seconds: 1),
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
                                                                : Text("Không",
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                        child:
                                                            item.batch_number !=
                                                                    ""
                                                                ? Marquee(
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
                                                                            .batch_number,
                                                                        style:
                                                                            textStyleGreen14,
                                                                        textAlign:
                                                                            TextAlign.left),
                                                                  )
                                                                : Marquee(
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
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                        direction:
                                                            Axis.horizontal,
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        animationDuration:
                                                            const Duration(
                                                                seconds: 1),
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
                                                            item.unit_name,
                                                            style:
                                                                textStyleGreen14,
                                                            textAlign:
                                                                TextAlign.left),
                                                      ),
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
                    marginTop20,
                  ],
                ),
              ),
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
                            Utils.myPop(context);
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
                                  Text("XÁC NHẬN",
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
