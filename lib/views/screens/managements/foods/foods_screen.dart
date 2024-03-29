// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/foods/additon_foods_controller.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/foods/add_addition_food_screen.dart';
import 'package:myorder/views/screens/managements/foods/add_food_screen.dart';
import 'package:myorder/views/screens/managements/foods/detail_addition_food_screen.dart';
import 'package:myorder/views/screens/managements/foods/detail_food_screen.dart';
import 'package:myorder/views/widgets/dialogs.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class ManagementFoodsPage extends StatefulWidget {
  const ManagementFoodsPage({Key? key}) : super(key: key);
  @override
  _ManagementFoodsPageState createState() => _ManagementFoodsPageState();
}

class _ManagementFoodsPageState extends State<ManagementFoodsPage> {
  FoodController foodController = Get.put(FoodController());
  AdditionFoodController additionFoodController =
      Get.put(AdditionFoodController());
  @override
  void initState() {
    super.initState();
    foodController.getfoods("", DEACTIVE);
    additionFoodController.getAdditionfoods('', ACTIVE);
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
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: secondColor,
              ),
            ),
            title: const Center(
                child: Text(
              "QUẢN LÝ MÓN",
              style: TextStyle(color: secondColor),
            )),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: transparentColor,
                  ),
                ),
              ),
            ],
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
                  text: "MÓN THƯỜNG",
                ),
                Tab(
                  text: "MÓN BÁN KÈM/TOPPING",
                ),
              ],
            ),
            backgroundColor: primaryColor,
          ),
          body: TabBarView(children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        border:
                            Border.all(width: 1, color: borderColorPrimary)),
                    child: TextField(
                      onChanged: (value) {
                        foodController.getfoods(value, DEACTIVE);
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
                        hintText: 'Tìm kiếm món ăn ...',
                        hintStyle: TextStyle(color: borderColorPrimary),
                      ),
                      cursorColor: borderColorPrimary,
                    ),
                  ),
                  marginTop10,
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Obx(() {
                      return ListView.builder(
                          itemCount: foodController.foods.length,
                          itemBuilder: (context, index) {
                            final food = foodController.foods[index];
                            String string;
                            return InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FoodDetailPage(
                                            food:
                                                foodController.foods[index])));
                                if (result == 'success') {
                                  Utils.showStylishDialog(
                                      context,
                                      'THÀNH CÔNG!',
                                      'Cập nhật thông tin món thành công!',
                                      StylishDialogType.SUCCESS);
                                }
                              },
                              child: Card(
                                color: food.active == 1
                                    ? backgroundColor
                                    : const Color.fromARGB(255, 213, 211, 211),
                                child: ListTile(
                                  leading: food.image != ""
                                      ? CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.black,
                                          backgroundImage:
                                              NetworkImage(food.image!),
                                        )
                                      : CircleAvatar(
                                          child: Image.asset(
                                            defaultFoodImageString,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                  title: Marquee(
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
                                      style: textStyleNameBlackRegular,
                                    ),
                                  ),
                                  subtitle: RichText(
                                    text: food.price_with_temporary! != 0
                                        ? (Utils.isDateTimeInRange(
                                                food.temporary_price_from_date!,
                                                food.temporary_price_to_date!)
                                            ? (food.price_with_temporary! > 0
                                                ? TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: Utils
                                                            .formatCurrency(food
                                                                    .price +
                                                                (food.price_with_temporary ??
                                                                    0)),
                                                        style: const TextStyle(
                                                          color: colorPrice,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons
                                                              .arrow_drop_up, // Thay thế bằng biểu tượng bạn muốn sử dụng
                                                          size:
                                                              24.0, // Điều chỉnh kích thước biểu tượng
                                                          color:
                                                              colorPriceIncrease, // Điều chỉnh màu sắc của biểu tượng
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: Utils
                                                            .formatCurrency(food
                                                                    .price +
                                                                (food.price_with_temporary ??
                                                                    0)),
                                                        style: const TextStyle(
                                                          color: colorPrice,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons
                                                              .arrow_drop_down, // Thay thế bằng biểu tượng bạn muốn sử dụng
                                                          size:
                                                              24.0, // Điều chỉnh kích thước biểu tượng
                                                          color:
                                                              colorPriceDecrease, // Điều chỉnh màu sắc của biểu tượng
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                            : TextSpan(
                                                text: Utils.formatCurrency(
                                                    food.price),
                                                style: const TextStyle(
                                                  color: colorPrice,
                                                ),
                                              ))
                                        : TextSpan(
                                            text: Utils.formatCurrency(
                                                food.price),
                                            style: const TextStyle(
                                              color: colorPrice,
                                            ),
                                          ),
                                    maxLines: 5,
                                    overflow: TextOverflow
                                        .ellipsis, // Hiển thị dấu ba chấm khi văn bản quá dài
                                  ),
                                  trailing: InkWell(
                                    onTap: () => {
                                      string = food.active == ACTIVE
                                          ? "khóa"
                                          : "bỏ khóa",
                                      showCustomAlertDialogConfirm(
                                        context,
                                        "TRẠNG THÁI HOẠT ĐỘNG",
                                        "Bạn có chắc chắn muốn $string món này?",
                                        colorWarning,
                                        () async {
                                          await foodController
                                              .updateToggleActive(
                                                  food.food_id, food.active);
                                        },
                                      )
                                    },
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
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddFoodPage()));
                      if (result == 'success') {
                        Utils.showStylishDialog(
                            context,
                            'THÀNH CÔNG!',
                            'Thêm món mới thành công!',
                            StylishDialogType.SUCCESS);
                      }
                    },
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
                          "+ THÊM MÓN THƯỜNG",
                          style: textStyleWhiteBold20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //MÓN BÁN KÈM

            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        border:
                            Border.all(width: 1, color: borderColorPrimary)),
                    child: TextField(
                      onChanged: (value) {
                        additionFoodController.getAdditionfoods(value, ACTIVE);
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
                        hintText: 'Tìm kiếm món bán kèm ...',
                        hintStyle: TextStyle(color: borderColorPrimary),
                      ),
                      cursorColor: borderColorPrimary,
                    ),
                  ),
                  marginTop10,
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Obx(() {
                      return ListView.builder(
                          itemCount: additionFoodController.foods.length,
                          itemBuilder: (context, index) {
                            final food = additionFoodController.foods[index];
                            String string;
                            return InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdditionFoodDetailPage(
                                                food: additionFoodController
                                                    .foods[index])));
                                if (result == 'success') {
                                  Utils.showStylishDialog(
                                      context,
                                      'THÀNH CÔNG!',
                                      'Cập nhật thông tin món bán kèm thành công!',
                                      StylishDialogType.SUCCESS);
                                }
                              },
                              child: Card(
                                color: food.active == 1
                                    ? backgroundColor
                                    : const Color.fromARGB(255, 213, 211, 211),
                                child: ListTile(
                                  leading: food.image != ""
                                      ? CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.black,
                                          backgroundImage:
                                              NetworkImage(food.image!),
                                        )
                                      : CircleAvatar(
                                          child: Image.asset(
                                            defaultFoodImageString,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                  title: Marquee(
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
                                      style: textStyleNameBlackRegular,
                                    ),
                                  ),
                                  subtitle: RichText(
                                    text: food.price_with_temporary! != 0
                                        ? (Utils.isDateTimeInRange(
                                                food.temporary_price_from_date!,
                                                food.temporary_price_to_date!)
                                            ? (food.price_with_temporary! > 0
                                                ? TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: Utils
                                                            .formatCurrency(food
                                                                    .price +
                                                                (food.price_with_temporary ??
                                                                    0)),
                                                        style: const TextStyle(
                                                          color: colorPrice,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons
                                                              .arrow_drop_up, // Thay thế bằng biểu tượng bạn muốn sử dụng
                                                          size:
                                                              24.0, // Điều chỉnh kích thước biểu tượng
                                                          color:
                                                              colorPriceIncrease, // Điều chỉnh màu sắc của biểu tượng
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: Utils
                                                            .formatCurrency(food
                                                                    .price +
                                                                (food.price_with_temporary ??
                                                                    0)),
                                                        style: const TextStyle(
                                                          color: colorPrice,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons
                                                              .arrow_drop_down, // Thay thế bằng biểu tượng bạn muốn sử dụng
                                                          size:
                                                              24.0, // Điều chỉnh kích thước biểu tượng
                                                          color:
                                                              colorPriceDecrease, // Điều chỉnh màu sắc của biểu tượng
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                            : TextSpan(
                                                text: Utils.formatCurrency(
                                                    food.price),
                                                style: const TextStyle(
                                                  color: colorPrice,
                                                ),
                                              ))
                                        : TextSpan(
                                            text: Utils.formatCurrency(
                                                food.price),
                                            style: const TextStyle(
                                              color: colorPrice,
                                            ),
                                          ),
                                    maxLines: 5,
                                    overflow: TextOverflow
                                        .ellipsis, // Hiển thị dấu ba chấm khi văn bản quá dài
                                  ),
                                  trailing: InkWell(
                                    onTap: () => {
                                      string = food.active == ACTIVE
                                          ? "khóa"
                                          : "bỏ khóa",
                                      showCustomAlertDialogConfirm(
                                        context,
                                        "TRẠNG THÁI HOẠT ĐỘNG",
                                        "Bạn có chắc chắn muốn $string món này?",
                                        colorWarning,
                                        () async {
                                          await additionFoodController
                                              .updateToggleActive(
                                                  food.food_id, food.active);
                                        },
                                      )
                                    },
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
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AddAdditionFoodPage()));
                      if (result == 'success') {
                        Utils.showStylishDialog(
                            context,
                            'THÀNH CÔNG!',
                            'Thêm món bán kèm mới thành công!',
                            StylishDialogType.SUCCESS);
                      }
                    },
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
                          "+ THÊM MÓN BÁN KÈM/TOPPING",
                          style: textStyleWhiteBold20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
