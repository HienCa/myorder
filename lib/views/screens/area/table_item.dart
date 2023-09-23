import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/tables/tables_controller.dart';
import 'package:myorder/views/screens/order/orderdetail/add_food_to_order_screen.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:myorder/models/table.dart' as model;

class TableItem extends StatefulWidget {
  final String? areaIdSelected;
  const TableItem({super.key, this.areaIdSelected});

  @override
  State<TableItem> createState() => _TableItemState();
}

class _TableItemState extends State<TableItem> {
  int selectedIndex = 0;
  TableController tableController = Get.put(TableController());

  @override
  void initState() {
    super.initState();

  }
  //allArea-hienca mặc định lấy tất cả các table
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.areaIdSelected == defaultArea ? FirebaseFirestore.instance.collection('tables').where('active', isEqualTo: 1).snapshots() : FirebaseFirestore.instance.collection('tables').where('active', isEqualTo: 1).where('area_id', isEqualTo: widget.areaIdSelected).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Hiển thị loading khi dữ liệu đang được tải
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        // Lấy danh sách bàn từ dữ liệu snapshot
        final tables = snapshot.data?.docs.map((doc) => model.Table.fromSnap(doc)).toList() ?? [];
        return ResponsiveGridList(
          desiredItemWidth: 100,
          minSpacing: 10,
          children: List.generate(tables.length, (index) => index).map((i) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFoodToOrderPage(table: tables[i],)),
                );
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
                    tables[i].status == TABLE_STATUS_EMPTY ? ClipOval(
                      child: Image.asset(
                        "assets/images/icon-table-simple-empty.jpg",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ) : const SizedBox(),
                    tables[i].status == TABLE_STATUS_SERVING ? ClipOval(
                      child: Image.asset(
                        "assets/images/icon-table-simple-serving.jpg",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ) : const SizedBox(),
                    tables[i].status == TABLE_STATUS_MERGED ? ClipOval(
                      child: Image.asset(
                        "assets/images/icon-table-simple-cancel.jpg",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ) : const SizedBox(),
                    tables[i].status == TABLE_STATUS_EMPTY ? ClipOval(
                      child: Image.asset(
                        "assets/images/icon-table-simple-empty.jpg",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ) : const SizedBox(),
                    Text(
                      tables[i].name,
                      style: const TextStyle(
                        fontSize: 30,
                        color: textWhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
