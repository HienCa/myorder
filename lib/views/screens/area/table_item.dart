// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/daily_sales/daily_sales_controller.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/controllers/tables/tables_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/area/dialogs/dialog_confirm_table_booking.dart';
import 'package:myorder/views/screens/order/actions/merge/dialog_confirm_cancel_merge_table.dart';
import 'package:myorder/views/screens/order/orderdetail/add_food_to_order_screen.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:myorder/models/table.dart' as model;
import 'package:stylish_dialog/stylish_dialog.dart';

class TableItem extends StatefulWidget {
  final String? areaIdSelected;
  const TableItem({super.key, this.areaIdSelected});

  @override
  State<TableItem> createState() => _TableItemState();
}

class _TableItemState extends State<TableItem> {
  int selectedIndex = 0;
  TableController tableController = Get.put(TableController());
  OrderController orderController = Get.put(OrderController());
  DailySalesController dailySalesController = Get.put(DailySalesController());

  @override
  void initState() {
    super.initState();
    orderController.getOrdersAllStatus(defaultEmployee, "");
  }

  //allArea-hienca mặc định lấy tất cả các table
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.areaIdSelected == defaultArea
          ? FirebaseFirestore.instance
              .collection('tables')
              .where('active', isEqualTo: 1)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('tables')
              .where('active', isEqualTo: 1)
              .where('area_id', isEqualTo: widget.areaIdSelected)
              .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Hiển thị loading khi dữ liệu đang được tải
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        // Lấy danh sách bàn từ dữ liệu snapshot
        final tables = snapshot.data?.docs
                .map((doc) => model.Table.fromSnap(doc))
                .toList() ??
            [];
        return ResponsiveGridList(
          desiredItemWidth: 100,
          minSpacing: 10,
          children: List.generate(tables.length, (index) => index).map((i) {
            return InkWell(
              onTap: () async {
                if (tables[i].status == TABLE_STATUS_MERGED) {
                  //MERGE
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialogCancelMergeTable(
                        targetTable: tables[i],
                      );
                    },
                  );
                } else if (tables[i].status == TABLE_STATUS_BOOKING) {
                  //BOOKING
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialogConfirmTableBooking(
                        targetTable: tables[i],
                      );
                    },
                  );
                } else {
                  //EMPTY AND SERVING
                  if (await dailySalesController
                      .isDailySalesByDateTime(Utils.getDateTimeNow())) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddFoodToOrderPage(
                                table: tables[i],
                                booking: true,
                                isGift: false,
                              )),
                    );
                  } else {
                    Utils.showStylishDialog(
                        context,
                        "CẢNH BÁO",
                        "QUÁN CHƯA THIẾT LẬP SỐ LƯỢNG BÁN CỦA CÁC MÓN ĂN HÔM NAY.\nVUI LÒNG NHẮC QUẢN LÝ THIẾT LẬP NGAY!",
                        StylishDialogType.WARNING);
                  }
                }
              },
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
                    tables[i].status == TABLE_STATUS_EMPTY
                        ? ClipOval(child: tableImageEmpty)
                        : const SizedBox(),
                    tables[i].status == TABLE_STATUS_SERVING
                        ? ClipOval(
                            child: tableImageServing,
                          )
                        : const SizedBox(),
                    tables[i].status == TABLE_STATUS_MERGED
                        ? ClipOval(
                            child: tableImageMerge,
                          )
                        : const SizedBox(),
                    tables[i].status == TABLE_STATUS_EMPTY
                        ? ClipOval(
                            child: tableImageEmpty,
                          )
                        : const SizedBox(),
                    tables[i].status == TABLE_STATUS_BOOKING
                        ? ClipOval(
                            child: tableImageBooking,
                          )
                        : const SizedBox(),
                    Text(
                      tables[i].name,
                      style: const TextStyle(
                        fontSize: 30,
                        color: textWhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: colorWarning,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          height: 35,
                          width: 35,
                          child: Center(
                            child: Text(
                              "${tables[i].total_slot}",
                              style: const TextStyle(
                                fontSize: 20,
                                color: secondColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
