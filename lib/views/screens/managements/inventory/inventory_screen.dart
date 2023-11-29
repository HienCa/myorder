// ignore_for_file: constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/suppliers/suppliers_controller.dart';
import 'package:myorder/controllers/units/units_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/inventory/inventory_detail_screen.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

enum Inventory { Import, Export }

enum DateType { From, To }

enum SubInventory { Waiting, Main, Finish }

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool isSearch = false;
  TextEditingController searchTextEditingController = TextEditingController();
  SupplierController supplierController = Get.put(SupplierController());
  UnitController unitController = Get.put(UnitController());

  @override
  void initState() {
    super.initState();
    isImport = true;
    isExport = false;

    //sub
    isWaiting = true;
    isMain = false;
    isFinish = false;

    //search
    isSearch = false;

    //datetime
    fromDateString = Utils.formatDatetime(DateTime.now());
    toDateString = Utils.formatDatetime(DateTime.now());
    supplierController.getSuppliers("");
    unitController.getUnits("");
  }

  bool isImport = true;
  bool isExport = false;

  void setUpScreen(Inventory inventory) {
    switch (inventory) {
      case Inventory.Import:
        setState(() {
          isImport = true;
          isExport = false;
        });
      case Inventory.Export:
        setState(() {
          isImport = false;
          isExport = true;
        });

      default:
    }
  }

  bool isWaiting = true;
  bool isMain = false;
  bool isFinish = false;

  void setUpSecondScreen(SubInventory subInventory) {
    switch (subInventory) {
      case SubInventory.Waiting:
        setState(() {
          isWaiting = true;
          isMain = false;
          isFinish = false;
        });
      case SubInventory.Main:
        setState(() {
          isWaiting = false;
          isMain = true;
          isFinish = false;
        });
      case SubInventory.Finish:
        setState(() {
          isWaiting = false;
          isMain = false;
          isFinish = true;
        });

      default:
    }
  }

  TextEditingController fromDateTextEditingController = TextEditingController();
  TextEditingController toDateTextEditingController = TextEditingController();
  String fromDateString = "dd/mm/yyyy";
  String toDateString = "dd/mm/yyyy";

  Future<void> selectDateTime(
      TextEditingController textEditingController, DateType dateType) async {
    final DateTime currentDate = DateTime.now();
    final TimeOfDay currentTime = TimeOfDay.fromDateTime(currentDate);
    final DateTime pickedDate = (await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(1900),
          lastDate:
              DateTime(2200), // You can adjust this to a suitable maximum date.
        )) ??
        currentDate;

    final TimeOfDay pickedTime = (await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay(hour: currentTime.hour, minute: currentTime.minute),
        )) ??
        TimeOfDay(hour: currentTime.hour, minute: currentTime.minute);

    final DateTime pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      //Giá trị cần lưu db
      textEditingController.text = pickedDateTime.toString();
      print(textEditingController.text);
      //Giá trị hiển thị
      switch (dateType) {
        case DateType.From:
          fromDateString =
              "${pickedDateTime.day.toString().padLeft(2, '0')}/${pickedDateTime.month.toString().padLeft(2, '0')}/${pickedDateTime.year} ${pickedTime.format(context)}";

        case DateType.To:
          toDateString =
              "${pickedDateTime.day.toString().padLeft(2, '0')}/${pickedDateTime.month.toString().padLeft(2, '0')}/${pickedDateTime.year} ${pickedTime.format(context)}";

        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("QUẢN LÝ KHO")),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const InventoryDetailScreen()));
                      if (result == 'success') {
                        Utils.showStylishDialog(
                            context,
                            'THÀNH CÔNG!',
                            'Thêm mới vat thành công!',
                            StylishDialogType.SUCCESS);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.add_circle_outline),
                    )))
          ],
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: backgroundColor,
            child: Column(
              children: [
                marginTop10,
                SizedBox(
                  height: 50,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: grayColor100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setUpScreen(Inventory.Import);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isImport
                                      ? primaryColor
                                      : transparentColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 40,
                                child: Center(
                                  child: Text(
                                    "NHẬP KHO",
                                    style: isImport
                                        ? textStyleWhiteBold16
                                        : textStyleGreyBold16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setUpScreen(Inventory.Export);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isExport
                                      ? primaryColor
                                      : transparentColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 40,
                                child: Center(
                                  child: Text(
                                    "XUẤT KHO",
                                    style: isExport
                                        ? textStyleWhiteBold16
                                        : textStyleGreyBold16,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      // margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                setUpSecondScreen(SubInventory.Waiting);
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "CHỜ XỬ LÝ",
                                        style: isWaiting
                                            ? textStylePriceBold14
                                            : textStyleGreyBold14,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: colorCancel,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: const Text(
                                          "99",
                                          style: textStyleWhiteBold14,
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: isWaiting
                                          ? primaryColor
                                          : transparentColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  )
                                ],
                              ),
                            )),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                setUpSecondScreen(SubInventory.Main);
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "NHẬP KHO",
                                        style: isMain
                                            ? textStylePriceBold14
                                            : textStyleGreyBold14,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: colorCancel,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: const Text(
                                          "99",
                                          style: textStyleWhiteBold14,
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: isMain
                                          ? primaryColor
                                          : transparentColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  )
                                ],
                              ),
                            )),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                setUpSecondScreen(SubInventory.Finish);
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "HOÀN THÀNH",
                                        style: isFinish
                                            ? textStylePriceBold14
                                            : textStyleGreyBold14,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: colorCancel,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: const Text(
                                          "99",
                                          style: textStyleWhiteBold14,
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: isFinish
                                          ? primaryColor
                                          : transparentColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  )
                                ],
                              ),
                            )),
                          ]),
                    ),
                  ),
                ),
                //Bộ lọc
                SizedBox(
                  height: 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 550,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Tìm kiếm
                            // Container(
                            //   height: 40,
                            //   width: isSearch ? 200 : 40,
                            //   // margin: const EdgeInsets.all(4),
                            //   decoration: BoxDecoration(
                            //     color: grayColor100,
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            //   child: IconButton(
                            //     onPressed: () {
                            //       setState(() {
                            //         isSearch = true;
                            //       });
                            //     },
                            //     icon: const FaIcon(
                            //         FontAwesomeIcons.magnifyingGlass,
                            //         color: grayColor,
                            //         size: 16),
                            //   ),
                            // ),
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(left: 4),
                              margin: const EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: borderRadiusTextField30,
                                border: Border.all(
                                    width: 1, color: borderColorTextField),
                              ),
                              child: TextField(
                                controller: searchTextEditingController,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                style: const TextStyle(color: grayColor),
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  fillColor: grayColor,
                                  icon: Icon(
                                    Icons.search,
                                    color: grayColor,
                                  ),
                                  hintText: 'Tìm kiếm',
                                  hintStyle: TextStyle(color: grayColor),
                                ),
                                cursorColor: grayColor,
                              ),
                            ),
                            marginRight10,
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                selectDateTime(fromDateTextEditingController,
                                    DateType.From);
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: grayColor100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FaIcon(FontAwesomeIcons.calendarDays,
                                        color: grayColor, size: 16),
                                    marginRight5,
                                    Text(
                                      fromDateString,
                                      style: textStyleGrey14,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                            marginRight10,
                            const FaIcon(FontAwesomeIcons.arrowsLeftRight,
                                color: grayColor, size: 16),
                            marginRight10,

                            Expanded(
                                child: InkWell(
                              onTap: () {
                                selectDateTime(
                                    toDateTextEditingController, DateType.To);
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: grayColor100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FaIcon(FontAwesomeIcons.calendarDays,
                                        color: grayColor, size: 16),
                                    marginRight5,
                                    Text(
                                      fromDateString,
                                      style: textStyleGrey14,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                            marginRight10
                          ]),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    // height: 60,
                    color: grayColor100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4, right: 4, top: 4),
                                  child: Container(
                                      decoration: const BoxDecoration(
                                        color: colorCancel,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10)),
                                      ),
                                      height: 40,
                                      child: const Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                              FontAwesomeIcons.clockRotateLeft,
                                              color: secondColor,
                                              size: 16),
                                          marginRight5,
                                          Text("CHỜ XÁC NHẬN",
                                              style: textStyleWhiteBold16),
                                        ],
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: backgroundColor,
                                    ),
                                    height: 50,
                                    child: const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("15/06/2023 17:42",
                                                    style: textStyleLabel14),
                                                Text(
                                                  "PNK001",
                                                  style: textStyleLabel14,
                                                ),
                                              ],
                                            )),
                                        Text("7,000,000",
                                            style: textStyleLabel16),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: backgroundColor,
                                    ),
                                    height: 40,
                                    child: const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Tổng mặt hàng",
                                                    style: textStyleLabel14),
                                              ],
                                            )),
                                        Text("18", style: textStyleLabel16),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: backgroundColor,
                                    ),
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                FaIcon(FontAwesomeIcons.userPen,
                                                    color: grayColor, size: 16),
                                                marginRight5,
                                                Text("Nhân viên tạo",
                                                    style: textStyleLabel14),
                                              ],
                                            )),
                                        Expanded(
                                            child: Text(
                                          "Chủ nhà hàng",
                                          style: textStyleLabel16,
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: backgroundColor,
                                    ),
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                FaIcon(
                                                    FontAwesomeIcons.clipboard,
                                                    color: grayColor,
                                                    size: 16),
                                                marginRight5,
                                                Text("Ghi chú",
                                                    style: textStyleLabel14),
                                              ],
                                            )),
                                        Expanded(
                                            child: Text(
                                          "Yêu cầu này nọ sdfsdf dfgdefg sedfsdfgs sdgsdfsdf",
                                          style: textStyleLabel16,
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
