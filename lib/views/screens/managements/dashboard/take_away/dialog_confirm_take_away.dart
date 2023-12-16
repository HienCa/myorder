// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/bills/bills_controller.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/models/order_detail.dart';

class MyDialogConfirmOrderTakeAway extends StatefulWidget {
  final String title;
  final String discription;
  final double total_vat_amount;
  final double total_discount_amount;
  final double total_surcharge_amount;
  final double total_amount;
  final double discount_percent;
  final String customer_name;
  final String customer_phone;
  final List<OrderDetail> orderDetailList;
  const MyDialogConfirmOrderTakeAway({
    Key? key,
    required this.title,
    required this.discription,
    required this.total_vat_amount,
    required this.total_discount_amount,
    required this.total_surcharge_amount,
    required this.orderDetailList,
    required this.total_amount,
    required this.discount_percent, required this.customer_name, required this.customer_phone,
  }) : super(key: key);

  @override
  State<MyDialogConfirmOrderTakeAway> createState() =>
      _MyDialogConfirmOrderTakeAwayState();
}

class _MyDialogConfirmOrderTakeAwayState
    extends State<MyDialogConfirmOrderTakeAway> {
  OrderController orderController = Get.put(OrderController());
  BillController billController = Get.put(BillController());
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
                    Center(
                      child: Text(
                        widget.title.toUpperCase(),
                        style: textStylePrimaryBold,
                      ),
                    ),
                    marginTop20,
                    ListTile(
                      title: Center(
                        child: Text(
                          widget.discription,
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
                              orderController.createOrderTakeAway(
                                  widget.orderDetailList,
                                  widget.discount_percent,
                                  widget.total_discount_amount,
                                  widget.total_vat_amount,
                                  widget.total_surcharge_amount,
                                  widget.total_amount,
                                  widget.customer_name,
                                  widget.customer_phone,
                                  context),
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
                                  style: textStyleWhiteBold16,
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
