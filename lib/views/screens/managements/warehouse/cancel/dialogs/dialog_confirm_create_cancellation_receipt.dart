// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/warehouse/cancellation_receipt_controller.dart';
import 'package:myorder/controllers/warehouse/warehouse_receipt_controller.dart';
import 'package:myorder/models/warehouse_receipt.dart';
import 'package:myorder/models/warehouse_receipt_detail.dart';

class CustomDialogConfirmCancelationReceipt extends StatefulWidget {
  final WarehouseReceipt warehouseReceipt;
  final String code;
  final List<WarehouseReceiptDetail> expiredIngredients;
  const CustomDialogConfirmCancelationReceipt({
    Key? key,
    required this.expiredIngredients,
    required this.code,
    required this.warehouseReceipt,
  }) : super(key: key);

  @override
  State<CustomDialogConfirmCancelationReceipt> createState() =>
      _CustomDialogConfirmCancelationReceiptState();
}

class _CustomDialogConfirmCancelationReceiptState
    extends State<CustomDialogConfirmCancelationReceipt> {
  @override
  void dispose() {
    super.dispose();
  }

  WarehouseReceiptController warehouseReceiptController =
      Get.put(WarehouseReceiptController());
  CancellationReceiptController cancellationReceiptController =
      Get.put(CancellationReceiptController());
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
                    const Center(
                      child: Text(
                        'PHIẾU HỦY',
                        style: textStylePrimaryBold,
                      ),
                    ),
                    marginTop20,
                    const ListTile(
                      title: Center(
                        child: Text(
                          "Bạn có chắc chắn muốn tạo phiếu hủy này?",
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
                              cancellationReceiptController
                                  .createCancellationReceipt(
                                      widget.code, widget.expiredIngredients),
                              Navigator.pop(context, 'success')
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
