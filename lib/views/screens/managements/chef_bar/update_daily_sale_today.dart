// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/models/food_order.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/chef_bar/dialogs.dart/dialog_confirm_sold_out.dart';
import 'package:myorder/views/screens/managements/chef_bar/dialogs.dart/dialog_confirm_update_daily_sale_today_detail.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_int.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class DailySaleTodayScreen extends StatefulWidget {
  const DailySaleTodayScreen({Key? key}) : super(key: key);
  @override
  State<DailySaleTodayScreen> createState() => _DailySaleTodayScreenState();
}

class _DailySaleTodayScreenState extends State<DailySaleTodayScreen> {
  FoodController foodController = Get.put(FoodController());

  @override
  void initState() {
    super.initState();
    foodController.getfoodsToOrder("", defaultCategory);
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
            "SỐ LƯỢNG BÁN HÔM NAY",
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
          backgroundColor: primaryColor,
        ),
        body: Column(
          children: [
            marginTop10,
            Container(
              height: 40,
              width: 400,
              margin: const EdgeInsets.all(kDefaultPadding),
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding / 4, // 5 top and bottom
              ),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: borderRadiusTextField30,
                  border: Border.all(width: 1, color: grayColor)),
              child: TextField(
                onChanged: (value) {
                  foodController.getAllFood(value);
                },
                style: const TextStyle(color: grayColor),
                decoration: const InputDecoration(
                  isDense: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: grayColor,
                  icon: Icon(
                    Icons.search,
                    color: grayColor,
                  ),
                  hintText: 'Tìm kiếm ',
                  hintStyle: TextStyle(color: grayColor),
                ),
                cursorColor: grayColor,
              ),
            ),
            deviderColor10,
            //DANH SÁCH CÁC MÓN
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                      child: Row(children: [
                        Expanded(
                            flex: 4,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                marginRight5,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Món ăn", style: textStyleLabel14),
                                  ],
                                ),
                              ],
                            )),
                        Expanded(
                          flex: 2,
                          child: Center(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Ước lượng còn",
                                      style: textStyleLabel14),
                                  marginRight5,
                                  Text(
                                    '(*)',
                                    style: textStyleErrorInput,
                                  )
                                ],
                              ),
                            ],
                          )),
                        ),
                      ]),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Obx(() {
                          return ListView.builder(
                              itemCount: foodController.foodsToOrder.length,
                              itemBuilder: (context, index) {
                                FoodOrder food =
                                    foodController.foodsToOrder[index];

                                return Slidable(
                                    key: const ValueKey(0),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) async {
                                            final result = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CustomDialogUpdateSoldOut(
                                                 food: food
                                                );
                                              },
                                            );
                                            if (result == 'success') {
                                              Utils.showSuccessFlushbar(context,
                                                  '', 'Cập nhật thành công!');
                                            } else if (result == 'cancel') {
                                              Utils.myPopCancel(context);
                                            }
                                          },
                                          backgroundColor: colorCancel,
                                          foregroundColor: textWhiteColor,
                                          icon: Icons.close,
                                          label: 'Hết món',
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          child: Row(children: [
                                            marginRight5,
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  food.image != ""
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child: Image.network(
                                                            food.image ??
                                                                defaultFoodImageString,
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child:
                                                              defaultFoodImage),
                                                ],
                                              ),
                                            ),
                                            marginRight5,
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Marquee(
                                                    direction: Axis.horizontal,
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    animationDuration:
                                                        const Duration(
                                                            seconds: 1),
                                                    backDuration:
                                                        const Duration(
                                                            milliseconds: 4000),
                                                    pauseDuration:
                                                        const Duration(
                                                            milliseconds: 1000),
                                                    directionMarguee:
                                                        DirectionMarguee
                                                            .TwoDirection,
                                                    child: Text(food.name,
                                                        style:
                                                            textStyleFoodNameBold16,
                                                        textAlign:
                                                            TextAlign.left),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: InkWell(
                                                onTap: () async {
                                                  final result =
                                                      await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return MyDialogCalculatorInt(
                                                        value:
                                                            food.new_current_order_count ??
                                                                0,
                                                        label: 'SỐ LƯỢNG',
                                                        min: 0,
                                                        max: 10000,
                                                      );
                                                    },
                                                  );
                                                  if (result != null) {
                                                    setState(() {
                                                      print(result);
                                                      food.new_current_order_count =
                                                          int.parse(result);
                                                    });
                                                  }
                                                },
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      (food.new_current_order_count ??
                                                                  0) >
                                                              0
                                                          ? Text(
                                                              food.new_current_order_count
                                                                  .toString(),
                                                              style:
                                                                  textStyleGreen14,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )
                                                          : Text(
                                                              "Đã hết",
                                                              style:
                                                                  textStyleRed14,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                        marginTop5,
                                      ],
                                    ));
                              });
                        }))
                  ],
                ),
              ),
            )),
            Container(
              color: backgroundColor,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Utils.myPop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: grayColor200,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.xmark,
                                    color: colorCancel, size: 16),
                                marginRight5,
                                Text("QUAY LẠI", style: textStyleCanceBoldl16),
                              ]),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialogUpdateCurrentCountOrder();
                            },
                          );
                          if (result == 'success') {
                            Utils.showStylishDialog(
                                context,
                                'THÀNH CÔNG!',
                                'Cập nhật thành công!',
                                StylishDialogType.SUCCESS);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: greenColor50,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.check,
                                    color: colorSuccess, size: 16),
                                marginRight5,
                                Text("CẬP NHẬT", style: textStyleSuccessBold16),
                              ]),
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
