// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/controllers/tables/tables_controller.dart';
import 'package:myorder/views/screens/managements/dashboard/booking/dialog_confirm_change_table_booking.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:myorder/models/table.dart' as model;
import 'package:myorder/models/order.dart' as orderM;

class TableItemChangeTableBooking extends StatefulWidget {
  final String? areaIdSelected;
  final int slot;
  final orderM.Order order;
  const TableItemChangeTableBooking({
    super.key,
    this.areaIdSelected,
    required this.slot,
    required this.order,
  });

  @override
  State<TableItemChangeTableBooking> createState() =>
      _TableItemChangeTableBookingState();
}

class _TableItemChangeTableBookingState
    extends State<TableItemChangeTableBooking> {
  int selectedIndex = 0;
  TableController tableController = Get.put(TableController());
  OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
  }

  //allArea-hienca mặc định lấy tất cả các table
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.areaIdSelected == defaultArea
          ? FirebaseFirestore.instance
              .collection('tables')
              .where('status', isEqualTo: TABLE_STATUS_EMPTY)
              .where('active', isEqualTo: 1)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('tables')
              .where('active', isEqualTo: 1)
              .where('status', isEqualTo: TABLE_STATUS_EMPTY)
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
        var tables = snapshot.data?.docs
                .map((doc) => model.Table.fromSnap(doc))
                .toList() ??
            [];
        if (widget.slot > 1) {
          tables = tables
              .where((element) => element.total_slot >= widget.slot)
              .toList();
        }
        return ResponsiveGridList(
          desiredItemWidth: 100,
          minSpacing: 10,
          children: List.generate(tables.length, (index) => index).map((i) {
            return InkWell(
              onTap: () async {
                //Đổi bàn đã booking khi bàn booking vô tình đang phục vụ
                final result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MyDialogConfirmChangeTableBooking(
                      order_id: widget.order.order_id,
                      oldTable: widget.order.table!,
                      newTable: tables[i],
                    );
                  },
                );
                if (result == 'success') {
                  Navigator.pop(context);
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
                    ClipOval(child: tableImageEmpty),
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
