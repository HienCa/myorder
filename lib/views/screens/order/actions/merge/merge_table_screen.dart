// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/tables/tables_controller.dart';
import 'package:myorder/views/screens/area/option_area.dart';
import 'package:myorder/views/screens/order/actions/merge/dialog_confirm_merge_table.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:myorder/models/order.dart' as model;

class MergeTablePage extends StatefulWidget {
  final model.Order order;
  const MergeTablePage({Key? key, required this.order}) : super(key: key);

  @override
  State<MergeTablePage> createState() => _MergeTablePageState();
}

class _MergeTablePageState extends State<MergeTablePage> {
  TableController tableController = Get.put(TableController());
  var areaIdSelected = defaultArea; // mặc định lấy tất cả danh sách
  var keySearch = "";
  List<dynamic> tableIds = []; // id những bàn cần gộp
  @override
  void initState() {
    super.initState();
    tableController.getActiveTablesOfAreaHasSearchExceptId(
        widget.order, defaultArea, "");
    // tableIds = widget.order.table_merge_ids;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gộp bàn vào ${widget.order.table!.name}",
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
                          tableController
                              .getActiveTablesOfAreaHasSearchExceptId(
                                  widget.order,
                                  selectedValue,
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
                          tableController
                              .getActiveTablesOfAreaHasSearchExceptId(
                                  widget.order, areaIdSelected, value);
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
                      //*0.65 nếu không có bottom
                      height: MediaQuery.of(context).size.height * 0.55,
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
                                    //nếu đã có trong danh sách thì bỏ ra
                                    setState(() {
                                      if (tableIds.any((element) =>
                                          element ==
                                          tableController.tables[i].table_id)) {
                                        //trả về list đã được xóa phần tử được chọn 2 lần
                                        tableIds.remove(
                                            tableController.tables[i].table_id);
                                      } else {
                                        tableIds.add(
                                            tableController.tables[i].table_id);
                                      }

                                      print(
                                          "Bàn ${widget.order.table!.name} cần gộp với các bàn: $tableIds");
                                    })
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      tableController.tables[i].status ==
                                              TABLE_STATUS_SERVING
                                          ? ClipOval(
                                              child: tableImageServing,
                                            )
                                          : ClipOval(
                                              child: tableImageEmpty,
                                            ),
                                      Text(
                                        tableController.tables[i].name,
                                        style: const TextStyle(
                                            fontSize: 30,
                                            color: textWhiteColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      tableIds.any((element) =>
                                              element ==
                                              tableController
                                                  .tables[i].table_id)
                                          ? Positioned(
                                              top: 0,
                                              right: 10,
                                              child: Container(
                                                color: Colors.transparent,
                                                height: 30,
                                                width: 30,
                                                child: ClipRRect(
                                                  child: checkImageGreen,
                                                ),
                                              ))
                                          : const SizedBox()
                                    ],
                                  ),
                                ));
                          }).toList()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => {Navigator.pop(context)},
                            child: Expanded(
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2.5,
                                decoration: BoxDecoration(
                                  color: buttonCancelColor,
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
                          ),
                          marginRight20,
                          InkWell(
                            onTap: () => {
                              //Truyền vào order và tableIds

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialogMergeTable(
                                    order: widget.order,
                                    tableIds: tableIds,
                                  );
                                },
                              )
                            },
                            child: Expanded(
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2.5,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    "XÁC NHẬN",
                                    style: textStyleWhiteBold20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        }));
  }
}
