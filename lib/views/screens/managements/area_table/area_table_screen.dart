// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/area/areas_controller.dart';
import 'package:myorder/controllers/tables/tables_controller.dart';
import 'package:myorder/views/screens/area/option_area.dart';
import 'package:myorder/views/screens/managements/area_table/custom/dialog_create_update_area.dart';
import 'package:myorder/views/screens/managements/area_table/custom/dialog_create_update_table.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ManagementAreaTablePage extends StatefulWidget {
  const ManagementAreaTablePage({Key? key}) : super(key: key);

  @override
  State<ManagementAreaTablePage> createState() =>
      _ManagementAreaTablePageState();
}

class _ManagementAreaTablePageState extends State<ManagementAreaTablePage> {
  AreaController areaController = Get.put(AreaController());
  TableController tableController = Get.put(TableController());
  var areaIdSelected = defaultArea; // mặc định lấy tất cả danh sách
  var keySearch = "";
  @override
  void initState() {
    super.initState();
    areaController.getAreas("");
    tableController.getTablesOfArea(defaultArea, "");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: primaryColor,
            leading: InkWell(
                onTap: () => {Navigator.pop(context)},
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                )),
            bottom: const TabBar(
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: backgroundColor,
                    width: 2.5,
                  ),
                ),
              ),
              tabs: [
                Tab(
                  text: "QUẢN LÝ KHU VỰC",
                ),
                Tab(
                  text: "QUẢN LÝ BÀN",
                ),
              ],
            ),
            title: const Text('QUẢN LÝ KHU VỰC / BÀN'),
          ),
          body: TabBarView(
            children: [
              Obx(() {
                return SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                                border: Border.all(
                                    width: 1, color: borderColorPrimary)),
                            child: TextField(
                              onChanged: (value) {
                                areaController.getAreas(value);
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
                                hintText: 'Tìm kiếm khu vực ...',
                                hintStyle: TextStyle(color: borderColorPrimary),
                              ),
                              cursorColor: borderColorPrimary,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.55,
                            child: ResponsiveGridList(
                                desiredItemWidth: 100,
                                minSpacing: 10,
                                children: List.generate(
                                    areaController.areas.length,
                                    (index) => index).map((i) {
                                  return InkWell(
                                    onTap: () => {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialogCreateUpdateArea(
                                            isUpdate: true,
                                            area_id:
                                                areaController.areas[i].area_id,
                                            name: areaController.areas[i].name,
                                            active:
                                                areaController.areas[i].active,
                                          );
                                        },
                                      )
                                    },
                                    child: Container(
                                      height: 100,
                                      alignment: const Alignment(0, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: areaController.areas[i].active ==
                                                ACTIVE
                                            ? activeColor
                                            : deActiveColor,
                                      ),
                                      child: Text(areaController.areas[i].name,
                                          style: textStyleWhiteBold20),
                                    ),
                                  );
                                }).toList()),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () => {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialogCreateUpdateArea(
                                    isUpdate: false,
                                  );
                                },
                              )
                            },
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "+ THÊM KHU VỰC",
                                  style: textStyleWhiteBold20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              }),
              //BÀN
              Obx(() {
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
                                tableController.getTablesOfArea(selectedValue,
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
                                border: Border.all(
                                    width: 1, color: borderColorPrimary)),
                            child: TextField(
                              onChanged: (value) {
                                //tìm tất cả bàn theo khu vực và keysearch
                                tableController.getTablesOfArea(
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
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ResponsiveGridList(
                                desiredItemWidth: 100,
                                minSpacing: 10,
                                children: List.generate(
                                    tableController.tables.length,
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
                                              return CustomDialogCreateUpdateTable(
                                                isUpdate: true,
                                                name: tableController
                                                    .tables[i].name,
                                                total_slot: tableController
                                                    .tables[i].total_slot,
                                                table_id: tableController
                                                    .tables[i].table_id,
                                                active: tableController
                                                    .tables[i].active,
                                                area_id: tableController
                                                    .tables[i].area_id,
                                              );
                                            },
                                          )
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            tableController.tables[i].active ==
                                                    ACTIVE
                                                ? ClipOval(
                                                    child: Image.asset(
                                                      "assets/images/icon-table-simple-serving.jpg",
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : ClipOval(
                                                    child: Image.asset(
                                                      "assets/images/icon-table-simple-empty.jpg",
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
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
                            onTap: () => {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialogCreateUpdateTable(
                                    isUpdate: false,
                                  );
                                },
                              )
                            },
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "+ THÊM BÀN",
                                  style: textStyleWhiteBold20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              })
            ],
          ),
        ));
  }
}
