// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';

import 'package:myorder/models/order.dart' as model;
// ignore: library_prefixes
import 'package:myorder/models/table.dart' as tableModel;
import 'package:myorder/utils.dart';

class CustomDialogMoveTable extends StatefulWidget {
  final model.Order order;
  final tableModel.Table table;
  const CustomDialogMoveTable({
    Key? key,
    required this.order,
    required this.table,
  }) : super(key: key);

  @override
  State<CustomDialogMoveTable> createState() => _CustomDialogMoveTableState();
}

class _CustomDialogMoveTableState extends State<CustomDialogMoveTable> {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'XÁC NHẬN CHUYỂN BÀN',
                        style: textStylePrimaryBold,
                      ),
                    ),
                    marginTop30,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                              height: 100,
                              alignment: const Alignment(0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipOval(
                                    child: tableImageServing,
                                  ),
                                  Text(
                                    widget.order.table!.name,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        color: textWhiteColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                        Expanded(
                          child: Container(
                              height: 100,
                              alignment: const Alignment(0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipOval(
                                    child: arrowRightImage,
                                  ),
                                ],
                              )),
                        ),
                        Expanded(
                          child: Container(
                              height: 100,
                              alignment: const Alignment(0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipOval(
                                    child: tableImageEmpty,
                                  ),
                                  Text(
                                    widget.table.name,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        color: textWhiteColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                    marginTop30,
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
                              orderController.moveTable(
                                  context, widget.order, widget.table),
                              Utils.myPopResult(context, 'success')
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
