// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/warehouse/cancellation_receipt_controller.dart';
import 'package:myorder/models/cancellation_receipt.dart';

import 'package:myorder/utils.dart';

class CustomDialogConfirmUpdateQuantityCancelMultiReceipt
    extends StatefulWidget {
  final CancellationReceipt cancellationReceipt;
  final String reason;

  const CustomDialogConfirmUpdateQuantityCancelMultiReceipt({
    Key? key,
    required this.cancellationReceipt, required this.reason,
  }) : super(key: key);

  @override
  State<CustomDialogConfirmUpdateQuantityCancelMultiReceipt> createState() =>
      _CustomDialogConfirmUpdateQuantityCancelMultiReceiptSate();
}

class _CustomDialogConfirmUpdateQuantityCancelMultiReceiptSate
    extends State<CustomDialogConfirmUpdateQuantityCancelMultiReceipt> {
  CancellationReceiptController cancellationReceiptController =
      Get.put(CancellationReceiptController());
  @override
  void dispose() {
    super.dispose();
  }

  String code = "";

  @override
  void initState() {
    super.initState();
    code = Utils.generateInvoiceCode("PH");
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
                        'CẬP NHẬT PHIẾU HỦY',
                        style: textStylePrimaryBold,
                      ),
                    ),
                    marginTop20,
                    ListTile(
                      title: Text(
                        "Cập nhật mã phiếu hủy: ${widget.cancellationReceipt.cancellation_receipt_code}",
                        style: textStyleBlackRegular,
                      ),
                    ),
                    marginTop20,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => {Utils.myPopCancel(context)},
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
                                  .updateCancallationReceipt(widget.reason, widget.cancellationReceipt),
                              Utils.myPopSuccess(
                                context,
                              )
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
