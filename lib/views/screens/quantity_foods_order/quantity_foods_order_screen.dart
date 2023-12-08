// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ManagementQuantityFoodOrderPage extends StatefulWidget {
  const ManagementQuantityFoodOrderPage({Key? key}) : super(key: key);

  @override
  State<ManagementQuantityFoodOrderPage> createState() =>
      _ManagementQuantityFoodOrderPageState();
}

class _ManagementQuantityFoodOrderPageState
    extends State<ManagementQuantityFoodOrderPage> {
  FoodController foodController = Get.put(FoodController());
  var keySearch = "";
  @override
  void initState() {
    super.initState();
    foodController.getAllFood(keySearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              )),
          title: const Text('QUẢN LÝ SỐ LƯỢNG MÓN'),
        ),
        body: Obx(() {
          return Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                              foodController.getAllFood(value);
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
                              hintText: 'Tìm kiếm món',
                              hintStyle: TextStyle(color: borderColorPrimary),
                            ),
                            cursorColor: borderColorPrimary,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: ResponsiveGridList(
                              desiredItemWidth: 150,
                              minSpacing: 10,
                              children: List.generate(
                                  foodController.foodAll.length,
                                  (index) => index).map((i) {
                                return InkWell(
                                  onTap: () async {
                                    // final result = await showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return MyDialogUpdateQuantityFood(
                                    //       food: foodController.foodAll[i],
                                    //     );
                                    //   },
                                    // );
                                    // if (result == "success") {
                                    //   Utils.showStylishDialog(
                                    //       context,
                                    //       'THÀNH CÔNG!',
                                    //       'Cập nhật số lượng thành công!',
                                    //       StylishDialogType.ERROR);
                                    // }
                                  },
                                  child: Container(
                                      height: 180,
                                      alignment: const Alignment(0, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.transparent,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.transparent,
                                                  ),
                                                  child: foodController
                                                              .foodAll[i]
                                                              .image !=
                                                          ""
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child: Image.network(
                                                            foodController
                                                                    .foodAll[i]
                                                                    .image ??
                                                                defaultFoodImageString,
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child:
                                                              defaultFoodImage80,
                                                        ),
                                                ),
                                              ),
                                              // Right side (product name)
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 2),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          4),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          4)),
                                                          color: colorSuccess,
                                                        ),
                                                        height: 75,
                                                        child: Center(
                                                          child: Text(
                                                            "${foodController.foodAll[i].max_order_limit.toInt()}",
                                                            style:
                                                                textStyleWhiteBold16,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          4),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          4)),
                                                          color: foodController
                                                                      .foodAll[
                                                                          i]
                                                                      .current_order_count >
                                                                  0
                                                              ? colorWarning
                                                              : colorCancel,
                                                        ),
                                                        height: 75,
                                                        child: Center(
                                                          child: Text(
                                                            "${foodController.foodAll[i].current_order_count.toInt()}",
                                                            style:
                                                                textStyleWhiteBold16,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          //NAME
                                          Marquee(
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
                                                          .foodAll[i].name,
                                                      style:
                                                          textStyleFoodNameBold16),
                                                ],
                                              ))),
                                        ],
                                      )),
                                );
                              }).toList()),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        }));
  }
}
