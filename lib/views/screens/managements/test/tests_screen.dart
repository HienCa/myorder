// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/test/add_food_test_screen.dart';
import 'package:myorder/views/screens/managements/test/detail_food_test_screen.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class ManagementTestsPage extends StatefulWidget {
  const ManagementTestsPage({Key? key}) : super(key: key);
  @override
  _ManagementTestsPageState createState() => _ManagementTestsPageState();
}

class _ManagementTestsPageState extends State<ManagementTestsPage> {
  FoodController foodController = Get.put(FoodController());
  @override
  void initState() {
    super.initState();
    foodController.getFoodCombos("");
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
          title: const Center(child: Text("QUẢN LÝ TEST")),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddFoodComboPage()));
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                marginTop10,
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
                      foodController.getFoodCombos(value);
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
                      hintText: 'Tìm kiếm vats ...',
                      hintStyle: TextStyle(color: borderColorPrimary),
                    ),
                    cursorColor: borderColorPrimary,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.87,
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: foodController.foodCombos.length,
                        itemBuilder: (context, index) {
                          final food = foodController.foodCombos[index];
                          String string;
                          return InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailFoodComboPage(
                                          food: foodController.foodCombos[index])));
                              if (result == 'success') {
                                Utils.showStylishDialog(
                                    context,
                                    'THÀNH CÔNG!',
                                    'Cập nhật thông tin món thành công!',
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
                                      child: Text(
                                        food.name,
                                        // food.listFood[index].name,
                                        style: textStyleNameBlackRegular,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: RichText(
                                  text: TextSpan(
                                    text: food.active == ACTIVE
                                        ? "Đang hoạt động"
                                        : "Ngừng hoạt động",
                                    style: food.active == ACTIVE
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
                                  // onTap: () => {
                                  //   string = vat.active == ACTIVE
                                  //       ? "ngừng hoạt động"
                                  //       : "hoạt động trở lại",
                                  //   showCustomAlertDialogConfirm(
                                  //     context,
                                  //     "TRẠNG THÁI HOẠT ĐỘNG",
                                  //     "Bạn có chắc chắn muốn $string đơn vị tính này?",
                                  //     colorWarning,
                                  //     () async {
                                  //       await foodController.updateToggleActive(
                                  //           vat.vat_id, vat.active);
                                  //     },
                                  //   )
                                  // },
                                  child: food.active == ACTIVE
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