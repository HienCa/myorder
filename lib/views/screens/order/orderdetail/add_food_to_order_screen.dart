// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/categories/categories_controller.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/models/order_detail.dart';
import 'package:myorder/models/table.dart' as model;
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/dialogs.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_int.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class AddFoodToOrderPage extends StatefulWidget {
  final model.Table table;
  final bool booking; // vào thêm món nếu true - false đặt bàn
  final bool isGift; // vào thêm món nếu true - false đặt bàn
  const AddFoodToOrderPage(
      {super.key,
      required this.table,
      required this.booking,
      required this.isGift});

  @override
  State<AddFoodToOrderPage> createState() => _AddFoodToOrderPageState();
}

class _AddFoodToOrderPageState extends State<AddFoodToOrderPage> {
  int selectedIndex = 0;
  int categoryselectedIndex = 0;
  bool isAddFood = false;
  int quantity = 1; // Số lượng đã chọn
  var categoryIdSelected = defaultCategory;
  FoodController foodController = Get.put(FoodController());
  CategoryController categoryController = Get.put(CategoryController());
  OrderController orderController = Get.put(OrderController());

  final TextEditingController slotTextEditingController =
      TextEditingController();

  String keySearch = "";
  @override
  void initState() {
    super.initState();
    categoryController.getCategoriesActive();
    foodController.getfoodsToOrder(keySearch, defaultCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        title: Center(
            child: Text(
          "GỌI MÓN - ${widget.table.name}",
          style: const TextStyle(color: secondColor),
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
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            height: 35,
            child: Obx(() {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryController.categoriesActive.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      categoryselectedIndex = index;
                      categoryIdSelected = categoryController
                          .categoriesActive[index].category_id;
                      foodController.getfoodsToOrder(
                          keySearch, categoryIdSelected);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      left: kDefaultPadding,
                      // At end item it adds extra 20 right padding
                      right: index ==
                              categoryController.categoriesActive.length - 1
                          ? kDefaultPadding
                          : 0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: index == categoryselectedIndex
                            ? kBlueColor
                            : textWhiteColor,
                        borderRadius: BorderRadius.circular(20),
                        border: index == categoryselectedIndex
                            ? Border.all(width: 5, color: borderColorPrimary)
                            : Border.all(width: 1, color: borderColorPrimary)),
                    child: Text(
                      categoryController.categoriesActive[index].name,
                      style: index == categoryselectedIndex
                          ? const TextStyle(
                              color: textWhiteColor,
                              fontWeight: FontWeight.bold)
                          : const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              );
            }),
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
                border: Border.all(width: 1, color: borderColorPrimary)),
            child: TextField(
              onChanged: (value) {
                foodController.getfoodsToOrder(value, categoryIdSelected);
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
                hintText: 'Tìm kiếm món ...',
                hintStyle: TextStyle(color: borderColorPrimary),
              ),
              cursorColor: borderColorPrimary,
            ),
          ),
          Expanded(
            child: Container(
                margin:
                    const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: foodController.foodsToOrder.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(
                            2), // Khoảng cách dưới dạng đệm

                        decoration: foodController
                                    .foodsToOrder[index].isSelected ==
                                true
                            ? BoxDecoration(
                                color: const Color(0xFF40BAD5).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              )
                            : BoxDecoration(
                                border: const Border(
                                    bottom: BorderSide(
                                        width: 0.1, color: borderColor)),
                                color: (foodController.foodsToOrder[index]
                                                .current_order_count ??
                                            0) >
                                        0
                                    ? secondColor
                                    : redColor50),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              // Chiều cao của ListTile thay đổi
                              child: InkWell(
                                onTap: () => {setState(() {})},
                                child: Column(
                                  children: [
                                    ListTile(
                                      selectedColor: primaryColor,
                                      leading: Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor:
                                                primaryColor),
                                        child: SizedBox(
                                          width: 80,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                child: Checkbox(
                                                  value: foodController
                                                          .foodsToOrder[index]
                                                          .isSelected ??
                                                      false,
                                                  onChanged: (bool? value) {
                                                    if ((foodController
                                                                .foodsToOrder[
                                                                    index]
                                                                .current_order_count ??
                                                            0) >
                                                        0) {
                                                      setState(() {
                                                        foodController
                                                            .foodsToOrder[index]
                                                            .isSelected = value;
                                                        //kiem tra xem co bat ky mon nao da duoc chon khong
                                                        isAddFood = Utils
                                                            .isAnyFoodSelected(
                                                                foodController
                                                                    .foodsToOrder);
                                                        print(
                                                            "isChecked - $value: ${foodController.foodsToOrder[index].name}");
                                                      });
                                                    } else {
                                                      Utils.showStylishDialog(
                                                          context,
                                                          "THÔNG BÁO",
                                                          "Hiện tại món này đã hết, vui lòng chọn món khác!",
                                                          StylishDialogType
                                                              .ERROR);
                                                    }
                                                  },
                                                  activeColor: primaryColor,
                                                ),
                                              ),
                                              marginRight10,
                                              foodController.foodsToOrder[index]
                                                          .image !=
                                                      ""
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: Image.network(
                                                        foodController
                                                                .foodsToOrder[
                                                                    index]
                                                                .image ??
                                                            defaultFoodImageString,
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: defaultFoodImage),
                                            ],
                                          ),
                                        ),
                                      ),
                                      title: Marquee(
                                          direction: Axis.horizontal,
                                          textDirection: TextDirection.ltr,
                                          animationDuration:
                                              const Duration(seconds: 1),
                                          backDuration: const Duration(
                                              milliseconds: 4000),
                                          pauseDuration: const Duration(
                                              milliseconds: 1000),
                                          directionMarguee:
                                              DirectionMarguee.TwoDirection,
                                          child: RichText(
                                              text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: foodController
                                                      .foodsToOrder[index].name,
                                                  style: foodController
                                                              .foodsToOrder[
                                                                  index]
                                                              .isSelected ==
                                                          true
                                                      ? textStyleWhiteRegular16
                                                      : textStyleFoodNameBold16),
                                              (Utils.isDateTimeInRange(
                                                      foodController
                                                          .foodsToOrder[index]
                                                          .temporary_price_from_date,
                                                      foodController
                                                          .foodsToOrder[index]
                                                          .temporary_price_to_date)
                                                  ? ((foodController
                                                                  .foodsToOrder[
                                                                      index]
                                                                  .price_with_temporary ??
                                                              0) >
                                                          0
                                                      ? const WidgetSpan(
                                                          child: Icon(
                                                            Icons.arrow_drop_up,
                                                            size: 24.0,
                                                            color:
                                                                colorPriceIncrease,
                                                          ),
                                                        )
                                                      : const WidgetSpan(
                                                          child: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            size: 24.0,
                                                            color:
                                                                colorPriceDecrease,
                                                          ),
                                                        ))
                                                  : const TextSpan()),
                                            ],
                                          ))),
                                      subtitle: foodController
                                                  .foodsToOrder[index]
                                                  .price_with_temporary !=
                                              0
                                          ? (Utils.isDateTimeInRange(
                                                  foodController
                                                      .foodsToOrder[index]
                                                      .temporary_price_from_date,
                                                  foodController
                                                      .foodsToOrder[index]
                                                      .temporary_price_to_date)
                                              ? Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Marquee(
                                                          direction:
                                                              Axis.horizontal,
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          animationDuration:
                                                              const Duration(
                                                                  seconds: 1),
                                                          backDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      4000),
                                                          pauseDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          directionMarguee:
                                                              DirectionMarguee
                                                                  .TwoDirection,
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      "${Utils.formatCurrency(foodController.foodsToOrder[index].price + (foodController.foodsToOrder[index].price_with_temporary ?? 0))} / ",
                                                                  style:
                                                                      textStyleTemporaryPriceDeActive16,
                                                                ),
                                                                TextSpan(
                                                                  text: Utils.formatCurrency(foodController
                                                                      .foodsToOrder[
                                                                          index]
                                                                      .price),
                                                                  style:
                                                                      textStyleTemporaryPriceActive14,
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  Utils.formatCurrency(
                                                      foodController
                                                          .foodsToOrder[index]
                                                          .price),
                                                  style:
                                                      textStyleTemporaryPriceDeActive16,
                                                ))
                                          : Text(
                                              Utils.formatCurrency(
                                                  foodController
                                                      .foodsToOrder[index]
                                                      .price),
                                              style: foodController
                                                          .foodsToOrder[index]
                                                          .isSelected ==
                                                      true
                                                  ? textStyleWhiteBold16
                                                  : textStyleTemporaryPriceDeActive16),
                                      trailing: (foodController
                                                      .foodsToOrder[index]
                                                      .current_order_count ??
                                                  0) >
                                              0
                                          ? foodController.foodsToOrder[index]
                                                      .isSelected ==
                                                  true
                                              ? SizedBox(
                                                  width: 110,
                                                  child: (foodController
                                                                  .foodsToOrder[
                                                                      index]
                                                                  .current_order_count ??
                                                              0) >
                                                          0
                                                      ? Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                if ((foodController
                                                                            .foodsToOrder[index]
                                                                            .quantity ??
                                                                        0) >
                                                                    1) {
                                                                  setState(() {
                                                                    foodController
                                                                        .foodsToOrder[
                                                                            index]
                                                                        .quantity = (foodController.foodsToOrder[index].quantity ??
                                                                            0) -
                                                                        1;
                                                                  });
                                                                }
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      iconColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                height: 30,
                                                                width: 30,
                                                                child:
                                                                    const Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                final result =
                                                                    await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return MyDialogCalculatorInt(
                                                                        value:
                                                                            foodController.foodsToOrder[index].quantity ??
                                                                                1,
                                                                        label:
                                                                            "SỐ LƯỢNG",
                                                                        min: 1,
                                                                        max: (foodController.foodsToOrder[index].current_order_count ??
                                                                                0)
                                                                            .toInt());
                                                                  },
                                                                );
                                                                if (result !=
                                                                    null) {
                                                                  setState(() {
                                                                    print(
                                                                        result);
                                                                    foodController
                                                                            .foodsToOrder[
                                                                                index]
                                                                            .quantity =
                                                                        int.parse(
                                                                            result);
                                                                  });
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        6.0),
                                                                child: Text(
                                                                    (foodController.foodsToOrder[index].quantity ??
                                                                            1)
                                                                        .toString(),
                                                                    style:
                                                                        textStyleWhiteBold16),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  if ((foodController
                                                                              .foodsToOrder[
                                                                                  index]
                                                                              .quantity ??
                                                                          0) <
                                                                      (foodController
                                                                              .foodsToOrder[index]
                                                                              .current_order_count ??
                                                                          0)) {
                                                                    foodController
                                                                        .foodsToOrder[
                                                                            index]
                                                                        .quantity = (foodController.foodsToOrder[index].quantity ??
                                                                            0) +
                                                                        1;
                                                                  } else {
                                                                    Utils.showStylishDialog(
                                                                        context,
                                                                        "THÔNG BÁO",
                                                                        "Số lượng đã đạt tối đa",
                                                                        StylishDialogType
                                                                            .INFO);
                                                                  }
                                                                });
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      iconColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                height: 30,
                                                                width: 30,
                                                                child:
                                                                    const Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : const Text(
                                                          "HẾT MÓN",
                                                          style:
                                                              textStyleCancel16,
                                                        ),
                                                )
                                              : const SizedBox(
                                                  // width: 40,
                                                  )
                                          : const Text(
                                              "HẾT MÓN",
                                              style: textStyleCanceBoldl16,
                                            ),
                                    ),
                                    //Danh sách món combo
                                    foodController.foodsToOrder[index]
                                                .isSelected ==
                                            true
                                        ? AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 78),
                                              height: foodController
                                                      .foodsToOrder[index]
                                                      .food_combo_details
                                                      .length *
                                                  65,
                                              child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                itemCount: foodController
                                                    .foodsToOrder[index]
                                                    .food_combo_details
                                                    .length,
                                                itemBuilder:
                                                    (context, indexCombo) {
                                                  return Container(
                                                    margin: const EdgeInsets
                                                        .all(
                                                        4), // Khoảng cách dưới dạng đệm

                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 0.1,
                                                              color:
                                                                  borderColor)),
                                                    ),
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child:
                                                            AnimatedContainer(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          curve:
                                                              Curves.easeInOut,
                                                          // Chiều cao của ListTile thay đổi
                                                          child: InkWell(
                                                            onTap: () => {
                                                              setState(() {})
                                                            },
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  selectedColor:
                                                                      primaryColor,
                                                                  leading:
                                                                      Theme(
                                                                    data: ThemeData(
                                                                        unselectedWidgetColor:
                                                                            primaryColor),
                                                                    child:
                                                                        SizedBox(
                                                                      width: 40,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          foodController.foodsToOrder[index].food_combo_details[indexCombo].image != ""
                                                                              ? ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  child: Image.network(
                                                                                    foodController.foodsToOrder[index].food_combo_details[indexCombo].image ?? defaultFoodImageString,
                                                                                    width: 40,
                                                                                    height: 40,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                )
                                                                              : ClipRRect(borderRadius: BorderRadius.circular(5), child: defaultFoodImage40),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  title: Marquee(
                                                                      direction: Axis.horizontal,
                                                                      textDirection: TextDirection.ltr,
                                                                      animationDuration: const Duration(seconds: 1),
                                                                      backDuration: const Duration(milliseconds: 4000),
                                                                      pauseDuration: const Duration(milliseconds: 1000),
                                                                      directionMarguee: DirectionMarguee.TwoDirection,
                                                                      child: RichText(
                                                                          text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: foodController.foodsToOrder[index].food_combo_details[indexCombo].name,
                                                                              style: textStyleWhiteRegular16),
                                                                        ],
                                                                      ))),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),

                                    //Danh sách bán kèm
                                    foodController.foodsToOrder[index]
                                                .isSelected ==
                                            true
                                        ? AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 30),
                                              height: foodController
                                                      .foodsToOrder[index]
                                                      .food_combo_details
                                                      .length *
                                                  80,
                                              child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                itemCount: foodController
                                                    .foodsToOrder[index]
                                                    .addition_food_details
                                                    .length,
                                                itemBuilder:
                                                    (context, indexAddition) {
                                                  return Container(
                                                    margin: const EdgeInsets
                                                        .all(
                                                        4), // Khoảng cách dưới dạng đệm

                                                    decoration: foodController
                                                                .foodsToOrder[
                                                                    index]
                                                                .addition_food_details[
                                                                    indexAddition]
                                                                .isSelected ==
                                                            true
                                                        ? BoxDecoration(
                                                            color: const Color(
                                                                    0xFF40BAD5)
                                                                .withOpacity(
                                                                    0.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.2),
                                                                spreadRadius: 2,
                                                                blurRadius: 10,
                                                                offset:
                                                                    const Offset(
                                                                        0, 3),
                                                              ),
                                                            ],
                                                          )
                                                        : const BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    width: 0.1,
                                                                    color:
                                                                        borderColor)),
                                                          ),
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child:
                                                            AnimatedContainer(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          curve:
                                                              Curves.easeInOut,
                                                          // Chiều cao của ListTile thay đổi
                                                          child: InkWell(
                                                            onTap: () => {
                                                              setState(() {})
                                                            },
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  selectedColor:
                                                                      secondColor,
                                                                  leading:
                                                                      Theme(
                                                                    data: ThemeData(
                                                                        unselectedWidgetColor:
                                                                            secondColor),
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          100,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Checkbox(
                                                                            value:
                                                                                foodController.foodsToOrder[index].addition_food_details[indexAddition].isSelected ?? false,
                                                                            onChanged:
                                                                                (bool? value) {
                                                                              if ((foodController.foodsToOrder[index].current_order_count ?? 0) > 0) {
                                                                                setState(() {
                                                                                  foodController.foodsToOrder[index].addition_food_details[indexAddition].isSelected = value;
                                                                                  //kiem tra xem co bat ky mon nao da duoc chon khong
                                                                                  isAddFood = Utils.isAnyFoodSelected(foodController.foodsToOrder);
                                                                                  print("isChecked - $value: ${foodController.foodsToOrder[index].addition_food_details[indexAddition].name}");
                                                                                });
                                                                              } else {
                                                                                Utils.showStylishDialog(context, "THÔNG BÁO", "Hiện tại món này đã hết, vui lòng chọn món khác!", StylishDialogType.ERROR);
                                                                              }
                                                                            },
                                                                            activeColor:
                                                                                primaryColor,
                                                                          ),
                                                                          foodController.foodsToOrder[index].addition_food_details[indexAddition].image != ""
                                                                              ? ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  child: Image.network(
                                                                                    foodController.foodsToOrder[index].addition_food_details[indexAddition].image ?? defaultFoodImageString,
                                                                                    width: 40,
                                                                                    height: 40,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                )
                                                                              : ClipRRect(borderRadius: BorderRadius.circular(5), child: defaultFoodImage40),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  title: Marquee(
                                                                      direction: Axis.horizontal,
                                                                      textDirection: TextDirection.ltr,
                                                                      animationDuration: const Duration(seconds: 1),
                                                                      backDuration: const Duration(milliseconds: 4000),
                                                                      pauseDuration: const Duration(milliseconds: 1000),
                                                                      directionMarguee: DirectionMarguee.TwoDirection,
                                                                      child: RichText(
                                                                          text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: foodController.foodsToOrder[index].addition_food_details[indexAddition].name,
                                                                              style: textStyleWhiteRegular16),
                                                                          (Utils.isDateTimeInRange(foodController.foodsToOrder[index].addition_food_details[indexAddition].temporary_price_from_date, foodController.foodsToOrder[index].addition_food_details[indexAddition].temporary_price_to_date)
                                                                              ? ((foodController.foodsToOrder[index].addition_food_details[indexAddition].price_with_temporary ?? 0) > 0
                                                                                  ? const WidgetSpan(
                                                                                      child: Icon(
                                                                                        Icons.arrow_drop_up,
                                                                                        size: 24.0,
                                                                                        color: colorPriceIncrease,
                                                                                      ),
                                                                                    )
                                                                                  : const WidgetSpan(
                                                                                      child: Icon(
                                                                                        Icons.arrow_drop_down,
                                                                                        size: 24.0,
                                                                                        color: colorPriceDecrease,
                                                                                      ),
                                                                                    ))
                                                                              : const TextSpan()),
                                                                        ],
                                                                      ))),
                                                                  subtitle: foodController
                                                                              .foodsToOrder[
                                                                                  index]
                                                                              .addition_food_details[
                                                                                  indexAddition]
                                                                              .price_with_temporary !=
                                                                          0
                                                                      ? (Utils.isDateTimeInRange(
                                                                              foodController.foodsToOrder[index].addition_food_details[indexAddition].temporary_price_from_date,
                                                                              foodController.foodsToOrder[index].addition_food_details[indexAddition].temporary_price_to_date)
                                                                          ? Row(
                                                                              children: <Widget>[
                                                                                Expanded(
                                                                                  child: Marquee(
                                                                                      direction: Axis.horizontal,
                                                                                      textDirection: TextDirection.ltr,
                                                                                      animationDuration: const Duration(seconds: 1),
                                                                                      backDuration: const Duration(milliseconds: 4000),
                                                                                      pauseDuration: const Duration(milliseconds: 1000),
                                                                                      directionMarguee: DirectionMarguee.TwoDirection,
                                                                                      child: RichText(
                                                                                        text: TextSpan(
                                                                                          style: DefaultTextStyle.of(context).style,
                                                                                          children: <TextSpan>[
                                                                                            TextSpan(
                                                                                              text: "${Utils.formatCurrency(foodController.foodsToOrder[index].addition_food_details[indexAddition].price + (foodController.foodsToOrder[index].addition_food_details[indexAddition].price_with_temporary ?? 0))} / ",
                                                                                              style: textStyleWhiteRegular16,
                                                                                            ),
                                                                                            TextSpan(
                                                                                              text: Utils.formatCurrency(foodController.foodsToOrder[index].addition_food_details[indexAddition].price),
                                                                                              style: textStyleTemporaryPriceActive14,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          : Text(
                                                                              Utils.formatCurrency(foodController.foodsToOrder[index].addition_food_details[indexAddition].price),
                                                                              style: textStyleWhiteRegular16,
                                                                            ))
                                                                      : Text(Utils.formatCurrency(foodController.foodsToOrder[index].addition_food_details[indexAddition].price), style: textStyleWhiteRegular16),
                                                                  trailing: foodController
                                                                              .foodsToOrder[index]
                                                                              .addition_food_details[indexAddition]
                                                                              .isSelected ==
                                                                          true
                                                                      ? SizedBox(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  if ((foodController.foodsToOrder[index].addition_food_details[indexAddition].quantity ?? 0) > 1) {
                                                                                    setState(() {
                                                                                      foodController.foodsToOrder[index].addition_food_details[indexAddition].quantity = (foodController.foodsToOrder[index].addition_food_details[indexAddition].quantity ?? 0) - 1;
                                                                                    });
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: iconColor,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  height: 30,
                                                                                  width: 30,
                                                                                  child: const Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Icon(Icons.remove, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 5),
                                                                              Text((foodController.foodsToOrder[index].addition_food_details[indexAddition].quantity ?? 0).toString(), style: textStyleWhiteBold16),
                                                                              const SizedBox(width: 5),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    foodController.foodsToOrder[index].addition_food_details[indexAddition].quantity = (foodController.foodsToOrder[index].addition_food_details[indexAddition].quantity ?? 0) + 1;
                                                                                  });
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: iconColor,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  height: 30,
                                                                                  width: 30,
                                                                                  child: const Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Icon(Icons.add, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : const SizedBox(
                                                                          // width: 40,
                                                                          ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            )),
                      );
                    },
                  );
                })),
          ),
          Column(
            children: [
              isAddFood == true
                  ? Column(
                      children: [
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            List<OrderDetail> orderDetailList =
                                []; // danh sach cac mon khi order
                            print(
                                "================MÓN CẦN ORDER===================");
                            for (var foodOrder in foodController.foodsToOrder) {
                              if (foodOrder.isSelected == true) {
                                //chi tiet don hang
                                //Nếu món ăn có giá thời vụ thì lấy giá thời vụ, ngược lại lấy giá gốc
                                Food foodDetail = Food.empty();
                                foodDetail.name = foodOrder.name;
                                foodDetail.food_combo_details =
                                    foodOrder.food_combo_details;
                                foodDetail.addition_food_details =
                                    foodOrder.addition_food_details;
                                OrderDetail orderDetail = OrderDetail(
                                    order_detail_id: "",
                                    price: Utils.isDateTimeInRange(
                                            foodOrder.temporary_price_from_date,
                                            foodOrder.temporary_price_to_date)
                                        ? (foodOrder.price +
                                            (foodOrder.price_with_temporary ??
                                                0))
                                        : foodOrder.price,
                                    quantity: foodOrder.quantity ?? 0,
                                    food_status: FOOD_STATUS_IN_CHEF,
                                    food_id: foodOrder.food_id,
                                    is_gift: false,
                                    category_id: foodOrder.category_id,
                                    category_code: foodOrder.category_code,
                                    chef_bar_status: CHEF_BAR_STATUS,
                                    is_addition: false,
                                    food: foodDetail);

                                orderDetailList.add(orderDetail);

                                //show thong tin console
                                print("--------------------------------");
                                print("ID: ${foodOrder.food_id}");
                                print("Name: ${foodOrder.name}");
                                print("Price: ${foodOrder.price}");
                                print("Quantity: ${foodOrder.quantity}");
                                print("Is Selected: ${foodOrder.isSelected}");
                                print("--------------------------------");
                              }

                              //Món bán kèm nếu chọn
                              for (var additionFood
                                  in foodOrder.addition_food_details) {
                                if (additionFood.isSelected == true) {
                                  //chi tiet don hang
                                  //Nếu món ăn có giá thời vụ thì lấy giá thời vụ, ngược lại lấy giá gốc
                                  OrderDetail orderDetail = OrderDetail(
                                    order_detail_id: "",
                                    price: Utils.isDateTimeInRange(
                                            additionFood
                                                .temporary_price_from_date,
                                            additionFood
                                                .temporary_price_to_date)
                                        ? (additionFood.price +
                                                additionFood
                                                    .price_with_temporary ??
                                            0)
                                        : additionFood.price,
                                    quantity: additionFood.quantity ?? 0,
                                    food_status: FOOD_STATUS_IN_CHEF,
                                    food_id: additionFood.food_id,
                                    is_gift: false,
                                    category_id: additionFood.category_id,
                                    category_code: additionFood.category_code,
                                    chef_bar_status: CHEF_BAR_STATUS,
                                    is_addition: true,
                                  );

                                  orderDetailList.add(orderDetail);

                                  //show thong tin console
                                  print("--------------------------------");
                                  print("ID: ${additionFood.food_id}");
                                  print("Name: ${additionFood.name}");
                                  print("Price: ${additionFood.price}");
                                  print("Quantity: ${additionFood.quantity}");
                                  print(
                                      "Is Selected: ${additionFood.isSelected}");
                                  print("--------------------------------");
                                }
                              }
                            }
                            print(
                                "================HẾT MÓN CẦN ORDER===================");

                            if (widget.booking) {
                              widget.table.status == TABLE_STATUS_EMPTY
                                  ? showCustomAlertDialogConfirmOrder(
                                      context,
                                      "YÊU CẦU ĐẶT BÀN ${widget.table.name}",
                                      "Bạn đang muốn đặt bàn ${widget.table.name} ?",
                                      colorInformation,
                                      slotTextEditingController, //số khách muốn đặt
                                      widget.table
                                          .total_slot, // số lượng khách tối đa có thể tiếp của 1 bàn
                                      () async {
                                      // order theo table_id
                                      print(
                                          "SỐ KHÁCH CỦA ĐƠN HÀNG NÀY: ${slotTextEditingController.text}");
                                      if (Utils.isValidRangeString(
                                          slotTextEditingController.text,
                                          1,
                                          widget.table.total_slot)) {
                                        //Nếu là đơn hàng mới thì phải nhập số khách
                                        orderController.createOrder(
                                            widget.table.table_id,
                                            widget.table.name,
                                            orderDetailList,
                                            widget.isGift,
                                            context,
                                            int.tryParse(
                                                slotTextEditingController
                                                    .text));
                                      } else {
                                        Get.snackbar(
                                          'THÔNG BÁO',
                                          'Bạn phải nhập số lượng khách của bàn này.',
                                          backgroundColor:
                                              backgroundFailureColor,
                                          colorText: Colors.white,
                                        );
                                      }
                                    }, false)
                                  : showCustomAlertDialogConfirm(
                                      context,
                                      "GỌI THÊM MÓN",
                                      "Bạn bạn muốn gọi thêm món cho bàn ${widget.table.name} ?",
                                      colorInformation,
                                      () async {
                                        // order theo table_id
                                        orderController.createOrder(
                                            widget.table.table_id,
                                            widget.table.name,
                                            orderDetailList,
                                            widget.isGift,
                                            context,
                                            int.tryParse(
                                                slotTextEditingController
                                                    .text));
                                      },
                                    );
                            } else {
                              orderController.createOrder(
                                  widget.table.table_id,
                                  widget.table.name,
                                  orderDetailList,
                                  widget.isGift,
                                  context,
                                  int.tryParse(slotTextEditingController.text));
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
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
                        const SizedBox(height: 10),
                      ],
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}
