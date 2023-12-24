// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/warehouse/warehouse_receipt_controller.dart';
import 'package:myorder/models/warehouse_receipt.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';

class CustomDialogCreateCancellationReceipt extends StatefulWidget {
  final List<WarehouseReceiptDetail> expiredIngredients;
  final WarehouseReceipt warehouseReceipt;
  const CustomDialogCreateCancellationReceipt({
    Key? key,
    required this.expiredIngredients,
    required this.warehouseReceipt,
  }) : super(key: key);

  @override
  State<CustomDialogCreateCancellationReceipt> createState() =>
      _CustomDialogCreateCancellationReceiptState();
}

class _CustomDialogCreateCancellationReceiptState
    extends State<CustomDialogCreateCancellationReceipt> {
  WarehouseReceiptController warehouseReceiptController =
      Get.put(WarehouseReceiptController());
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                              Text(
                                '(${widget.warehouseReceipt.warehouse_receipt_code})',
                                style: textStylePrimaryBold16,
                              ),
                            ],
                          ),
                        ),
                        MyCloseIcon(heightWidth: 40, sizeIcon: 20,)
                      ],
                    ),
                    marginTop10,
                    SizedBox(
                      height: 50,
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("STT", style: textStyleLabel14),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Mặt hàng", style: textStyleLabel14),
                                const Text("Đơn vị", style: textStyleLabel14),
                              ],
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Số lượng", style: textStyleLabel14),
                              Text("cần hủy", style: textStyleLabel14),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: ListView.builder(
                              itemCount: widget.expiredIngredients.length,
                              itemBuilder: (context, index) {
                                WarehouseReceiptDetail warehouseReceiptDetail =
                                    widget.expiredIngredients[index];
                                return SizedBox(
                                  height: 50,
                                  child: Row(children: [
                                    //STT
                                    Expanded(
                                      flex: 1,
                                      child: Text("${index + 1}.",
                                          style: textStyleFoodNameBold16,
                                          textAlign: TextAlign.left),
                                    ),
                                    //MẶT HÀNG - ĐƠN VỊ
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
                                            textDirection: TextDirection.ltr,
                                            animationDuration:
                                                const Duration(seconds: 1),
                                            backDuration: const Duration(
                                                milliseconds: 4000),
                                            pauseDuration: const Duration(
                                                milliseconds: 1000),
                                            directionMarguee:
                                                DirectionMarguee.TwoDirection,
                                            child: Text(
                                                warehouseReceiptDetail
                                                    .ingredient_name,
                                                style: textStyleFoodNameBold16,
                                                textAlign: TextAlign.left),
                                          ),
                                          Marquee(
                                            direction: Axis.horizontal,
                                            textDirection: TextDirection.ltr,
                                            animationDuration:
                                                const Duration(seconds: 1),
                                            backDuration: const Duration(
                                                milliseconds: 4000),
                                            pauseDuration: const Duration(
                                                milliseconds: 1000),
                                            directionMarguee:
                                                DirectionMarguee.TwoDirection,
                                            child: Text(
                                                warehouseReceiptDetail
                                                    .unit_name,
                                                style: textStyleGreen14,
                                                textAlign: TextAlign.left),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //SL CẦN HỦY
                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                warehouseReceiptDetail
                                                    .quantity_in_stock
                                                    .toString(),
                                                style: textStyleRed14),
                                            marginTop5,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                );
                              })),
                    ),
                    marginTop20,
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
