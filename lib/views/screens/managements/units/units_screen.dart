// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/units/units_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/units/add_unit_screen.dart';
import 'package:myorder/views/screens/managements/units/detail_unit_screen.dart';
import 'package:myorder/views/widgets/dialogs.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class ManagementUnitsPage extends StatefulWidget {
  const ManagementUnitsPage({Key? key}) : super(key: key);
  @override
  _ManagementUnitsPageState createState() => _ManagementUnitsPageState();
}

class _ManagementUnitsPageState extends State<ManagementUnitsPage> {
  UnitController unitController = Get.put(UnitController());
  @override
  void initState() {
    super.initState();
    unitController.getUnits("");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: primaryColor,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("QUẢN LÝ ĐƠN VỊ")),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddUnitPage()));
                      if (result == 'success') {
                        Utils.showStylishDialog(
                            context,
                            'THÀNH CÔNG!',
                            'Thêm mới đơn vị thành công!',
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
        body: SafeArea(
          child: SingleChildScrollView(
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
                      border: Border.all(width: 1, color: borderColorPrimary)),
                  child: TextField(
                    onChanged: (value) {
                      unitController.getUnits(value);
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
                      hintText: 'Tìm kiếm đơn vị tính ...',
                      hintStyle: TextStyle(color: borderColorPrimary),
                    ),
                    cursorColor: borderColorPrimary,
                  ),
                ),
                marginTop10,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: unitController.units.length,
                        itemBuilder: (context, index) {
                          final unit = unitController.units[index];
                          String string;
                          return InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UnitDetailPage(
                                            unit: unit,
                                          )));
                              if (result == 'success') {
                                Utils.showStylishDialog(
                                    context,
                                    'THÀNH CÔNG!',
                                    'Cập nhật đơn vị thành công!',
                                    StylishDialogType.SUCCESS);
                              }
                            },
                            child: Card(
                              child: ListTile(
                                leading: const Icon(Icons.ac_unit),
                                title: Row(
                                  children: [
                                    Marquee(
                                      direction: Axis.horizontal,
                                      textDirection: TextDirection.ltr,
                                      animationDuration:
                                          const Duration(seconds: 1),
                                      backDuration:
                                          const Duration(milliseconds: 4000),
                                      pauseDuration:
                                          const Duration(milliseconds: 1000),
                                      directionMarguee:
                                          DirectionMarguee.TwoDirection,
                                      child: unit.value_conversion != 1
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  unit.name,
                                                  style:
                                                      textStyleNameBlackRegular,
                                                ),
                                                marginRight20,
                                                const FaIcon(
                                                    FontAwesomeIcons.shuffle,
                                                    color: iconColor,
                                                    size: 16),
                                                marginRight20,
                                                unit.value_conversion != 1
                                                    ? Text(
                                                        '${unit.value_conversion} ${unit.unit_name_conversion}',
                                                        style:
                                                            textStyleNameBlackRegular,
                                                      )
                                                    : const Text("")
                                              ],
                                            )
                                          : Text(
                                              unit.name,
                                              style: textStyleNameBlackRegular,
                                            ),
                                    ),
                                  ],
                                ),
                                subtitle: RichText(
                                  text: TextSpan(
                                    text: unit.active == ACTIVE
                                        ? "Đang hoạt động"
                                        : "Ngừng hoạt động",
                                    style: unit.active == ACTIVE
                                        ? const TextStyle(color: Colors.green)
                                        : const TextStyle(
                                            color: Colors
                                                .grey), // Đặt kiểu cho văn bản
                                  ),
                                  maxLines: 5, // Giới hạn số dòng hiển thị
                                  overflow: TextOverflow
                                      .ellipsis, // Hiển thị dấu ba chấm khi văn bản quá dài
                                ),
                                trailing: InkWell(
                                  onTap: () => {
                                    string = unit.active == ACTIVE
                                        ? "ngừng hoạt động"
                                        : "hoạt động trở lại",
                                    showCustomAlertDialogConfirm(
                                      context,
                                      "TRẠNG THÁI HOẠT ĐỘNG",
                                      "Bạn có chắc chắn muốn $string đơn vị tính này?",
                                      colorWarning,
                                      () async {
                                        await unitController.updateToggleActive(
                                            unit.unit_id, unit.active);
                                      },
                                    )
                                  },
                                  child: unit.active == ACTIVE
                                      ? const Icon(
                                          Icons.key,
                                          size: 25,
                                          color: activeColor,
                                        )
                                      : const Icon(
                                          Icons.key_off,
                                          size: 25,
                                          color: deActiveColor,
                                        ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
