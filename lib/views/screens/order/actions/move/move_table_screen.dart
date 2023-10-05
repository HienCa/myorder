// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/tables/tables_controller.dart';
import 'package:myorder/views/screens/area/option_area.dart';
import 'package:myorder/views/screens/order/actions/move/dialog_confirm_move_table.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:myorder/models/order.dart' as model;

class MoveTablePage extends StatefulWidget {
  final model.Order order;
  const MoveTablePage({Key? key, required this.order}) : super(key: key);

  @override
  State<MoveTablePage> createState() => _MoveTablePageState();
}

class _MoveTablePageState extends State<MoveTablePage> {
  TableController tableController = Get.put(TableController());
  var areaIdSelected = defaultArea; // mặc định lấy tất cả danh sách
  var keySearch = "";
  @override
  void initState() {
    super.initState();
    tableController.getActiveTablesOfArea(defaultArea, "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chuyển bàn từ ${widget.order.table!.name} đến",
              style: textStyleAppBar20),
          backgroundColor: secondColor,
        ),
        body: Obx(() {
          return SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OptionArea(
                      onOptionSelected: (selectedValue) {
                        // Xử lý giá trị trả về từ OptionArea tại đây
                        print(
                            'Đã nhận được giá trị từ OptionArea: $selectedValue');
                        setState(() {
                          areaIdSelected = selectedValue;
                          tableController.getActiveTablesOfArea(selectedValue,
                              keySearch); // tìm tất cả bàn theo khu vực
                        });
                      },
                    ),
                    Container(
                      height: 50,
                      width: 400,
                      margin: const EdgeInsets.all(kDefaultPadding),
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                        vertical: kDefaultPadding / 4, // 5 top and bottom
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: borderRadiusTextField30,
                          border:
                              Border.all(width: 1, color: borderColorPrimary)),
                      child: TextField(
                        onChanged: (value) {
                          //tìm tất cả bàn theo khu vực và keysearch
                          tableController.getActiveTablesOfArea(
                              areaIdSelected, value);
                          setState(() {
                            keySearch = value;
                          });
                        },
                        style: const TextStyle(color: borderColorPrimary),
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: borderColorPrimary,
                          icon: Icon(
                            Icons.search,
                            color: iconColorPrimary,
                          ),
                          hintText: 'Tìm kiếm bàn theo khu vực...',
                          hintStyle: TextStyle(color: borderColorPrimary),
                        ),
                        cursorColor: borderColorPrimary,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: ResponsiveGridList(
                          desiredItemWidth: 100,
                          minSpacing: 10,
                          children: List.generate(tableController.tables.length,
                              (index) => index).map((i) {
                            return Container(
                                height: 100,
                                alignment: const Alignment(0, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                ),
                                child: InkWell(
                                  onTap: () => {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialogMoveTable(
                                          order: widget.order,
                                          table: tableController.tables[i],
                                        );
                                      },
                                    )
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipOval(
                                              child: tableImageEmpty,
                                            ),
                                      Text(
                                        tableController.tables[i].name,
                                        style: const TextStyle(
                                            fontSize: 30,
                                            color: textWhiteColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ));
                          }).toList()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () => {Navigator.pop(context)},
                      child: Container(
                        height: 50,
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "HỦY BỎ",
                            style: textStyleWhiteBold20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        }));
  }
}
