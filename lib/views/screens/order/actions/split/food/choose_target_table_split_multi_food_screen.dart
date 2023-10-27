// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/tables/tables_controller.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/area/option_area.dart';
import 'package:myorder/views/screens/order/actions/split/food/list_food_need_split_screen.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:myorder/models/order.dart' as model;

class SplitFoodPage extends StatefulWidget {
  final model.Order order;
  //tách món đơn thì sẽ đưa món đơn đó vào orderDetailNeedSplitArray
  final List<OrderDetail>? orderDetailNeedSplitArray;
  const SplitFoodPage(
      {Key? key, required this.order, this.orderDetailNeedSplitArray})
      : super(key: key);

  @override
  State<SplitFoodPage> createState() => _SplitFoodPageState();
}

class _SplitFoodPageState extends State<SplitFoodPage> {
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
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
        ),
        elevation: 5, // Độ nâng của bóng đổ
        backgroundColor: backgroundColor,
        child: Obx(() {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                OptionArea(
                  onOptionSelected: (selectedValue) {
                    // Xử lý giá trị trả về từ OptionArea tại đây
                    print('Đã nhận được giá trị từ OptionArea: $selectedValue');
                    setState(() {
                      areaIdSelected = selectedValue;
                      tableController.getActiveTablesOfArea(selectedValue,
                          keySearch); // tìm tất cả bàn theo khu vực
                    });
                  },
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  margin: const EdgeInsets.all(kDefaultPadding),
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 4, // 5 top and bottom
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: borderRadiusTextField30,
                      border: Border.all(width: 1, color: borderColorPrimary)),
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
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: double.infinity,
                      child: ResponsiveGridList(
                          desiredItemWidth: 70,
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
                                  onTap: () async {
                                    final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListFoodNeedSplitPage(
                                                  order: widget.order,
                                                  table:
                                                      tableController.tables[i],
                                                )));
                                    if (result == 'success') {
                                      Utils.myPopResult(context, 'success');
                                    }
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
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () => {Utils.myPopResult(context, 'cancel')},
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
            ),
          );
        }));
  }
}
