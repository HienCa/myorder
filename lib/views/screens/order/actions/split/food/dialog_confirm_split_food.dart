// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';

import 'package:myorder/models/order.dart' as model;
import 'package:myorder/models/order_detail.dart';
// ignore: library_prefixes
import 'package:myorder/models/table.dart' as tableModel;
import 'package:myorder/utils.dart';

class CustomDialogSplitFood extends StatefulWidget {
  final model.Order order;
  final tableModel.Table table;
  final List<OrderDetail> orderDetailNeedSplitArray;
  const CustomDialogSplitFood({
    Key? key,
    required this.order,
    required this.table,
    required this.orderDetailNeedSplitArray,
  }) : super(key: key);

  @override
  State<CustomDialogSplitFood> createState() => _CustomDialogSplitFoodState();
}

class _CustomDialogSplitFoodState extends State<CustomDialogSplitFood> {
  @override
  void dispose() {
    super.dispose();
  }

  OrderController orderController = Get.put(OrderController());

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: Text(
                        'XÁC NHẬN TÁCH MÓN',
                        style: textStylePrimaryBold,
                      ),
                    ),
                    marginTop30,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                           child:Center(
                                  child: Text(
                                "Bạn chắc chắn muốn tách món từ bàn ${widget.order.table!.name} sang ${widget.table.name} ?",
                                style: textStyleContentDialog16,
                              )),
                        ),
                      ],
                    ),
                    marginTop30,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Utils.myPopCancel(context);
                            },
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
                            onTap: () {
                              orderController.splitFood(
                                  context,
                                  widget.order,
                                  widget.orderDetailNeedSplitArray,
                                  // widget.order.order_details,
                                  widget.table);
                              Utils.myPopSuccess(context);
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
