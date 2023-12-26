// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/daily_sales/daily_sales_controller.dart';
import 'package:myorder/controllers/warehouse/warehouse_receipt_controller.dart';
import 'package:myorder/models/daily_sales.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class CustomDialogRecommendIngredientsDailySales extends StatefulWidget {
  const CustomDialogRecommendIngredientsDailySales({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDialogRecommendIngredientsDailySales> createState() =>
      _CustomDialogRecommendIngredientsDailySalesState();
}

class _CustomDialogRecommendIngredientsDailySalesState
    extends State<CustomDialogRecommendIngredientsDailySales> {
  WarehouseReceiptController warehouseReceiptController =
      Get.put(WarehouseReceiptController());
  DailySalesController dailySalesController = Get.put(DailySalesController());
  bool isLoaded = false;
  // DateTime dateSelected = DateTime.now();
  late Future future;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isLoaded = true;
    // dateSelected = DateTime(
    //     dateSelected.year, dateSelected.month, dateSelected.day, 0, 0, 0, 0);
    // future = dailySalesController.getDailySalesByTimestamp("");
    dailySalesController.getDailySalesByTimestamp("");
  }

  void checkOneItem(String id, bool value) {
    for (DailySales item in dailySalesController.dailySalesByTimestamp) {
      if (item.daily_sale_id == id) {
        item.isSelected = value;
      } else {
        item.isSelected = !value;
      }
    }
  }

  void updateIsLoaded() {
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
      ),
      elevation: 5, // Độ nâng của bóng đổ
      backgroundColor: backgroundColor,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.clockRotateLeft,
                            color: transparentColor, size: 16),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'GỢI Ý XUẤT KHO',
                                style: textStylePrimaryBold,
                              ),
                            ],
                          ),
                        ),
                        MyCloseIcon(
                          heightWidth: 40,
                          sizeIcon: 20,
                        )
                      ],
                    ),
                    marginTop10,
                    // FutureBuilder<dynamic>(
                    //   future: dailySalesController.getDailySalesByTimestamp(""),
                    //   builder: (BuildContext context,
                    //       AsyncSnapshot<dynamic> snapshot) {
                    //     switch (snapshot.connectionState) {
                    //       case ConnectionState.none:
                    //         return Text('Press button to start.');
                    //       case ConnectionState.active:
                    //       case ConnectionState.waiting:
                    //         return CircularProgressIndicator();
                    //       case ConnectionState.done:
                    //         if (snapshot.hasError) {
                    //           return Text('Error: ${snapshot.error}');
                    //         }

                    //         return Text("");
                    //     }
                    //   },
                    // ),
                    isLoaded
                        ? SingleChildScrollView(
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Obx(() {
                                  return ListView.builder(
                                      itemCount: dailySalesController
                                          .dailySalesByTimestamp.length,
                                      itemBuilder: (context, index) {
                                        DailySales dailySale =
                                            dailySalesController
                                                .dailySalesByTimestamp[index];

                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: Row(children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: InkWell(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Checkbox(
                                                            value: dailySale
                                                                .isSelected,
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                checkOneItem(
                                                                    dailySale
                                                                        .daily_sale_id,
                                                                    value ??
                                                                        false);
                                                              });
                                                            },
                                                            activeColor:
                                                                primaryColor,
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 10,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            Utils.formatTimestamp(
                                                                dailySale
                                                                    .date_apply),
                                                            style:
                                                                textStylePriceBold16),
                                                        Text(dailySale.name,
                                                            style:
                                                                textStyleLabel14),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ),

                                            //DANH SÁCH CHI TIẾT DAILY SALE DETAILS
                                            dailySale.isSelected
                                                ? Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 50,
                                                        child: Row(children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Text("",
                                                                    style:
                                                                        textStyleLabel14),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 4,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 4),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      "Mặt hàng (${dailySale.ingredients?.length})",
                                                                      style:
                                                                          textStyleLabel14),
                                                                  const Text(
                                                                      "Tình trạng kho",
                                                                      style:
                                                                          textStyleLabel14),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text("Số lượng",
                                                                    style:
                                                                        textStyleLabel14),
                                                                Text("Tồn",
                                                                    style:
                                                                        textStyleLabel14),
                                                              ],
                                                            ),
                                                          ),
                                                          const Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text("Số lượng",
                                                                    style:
                                                                        textStyleLabel14),
                                                                Text("Cần dùng",
                                                                    style:
                                                                        textStyleLabel14),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                      ),
                                                      SingleChildScrollView(
                                                        child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.3,
                                                            child: ListView
                                                                .builder(
                                                                    itemCount: (dailySale.ingredients ??
                                                                            [])
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      Ingredient
                                                                          ingredient =
                                                                          (dailySale.ingredients ??
                                                                              [])[index];

                                                                      double
                                                                          quantityToOrder =
                                                                          (ingredient.quantity_in_stock ?? 0) -
                                                                              (ingredient.quantity ?? 0);
                                                                      if (quantityToOrder <
                                                                          0) {
                                                                        ingredient.quantity_in_stock_note =
                                                                            "(Thiếu ${quantityToOrder.toInt().toString().replaceAll(RegExp(r'-'), "")}${ingredient.unit_name})";
                                                                      } else {
                                                                        ingredient.quantity_in_stock_note =
                                                                            "(Đủ)";
                                                                      }
                                                                      return SizedBox(
                                                                        height:
                                                                            50,
                                                                        child: Row(
                                                                            children: [
                                                                              //STT
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Text("", style: textStyleFoodNameBold16, textAlign: TextAlign.left),
                                                                              ),
                                                                              //MẶT HÀNG - TÌNH TRẠNG KHO
                                                                              Expanded(
                                                                                flex: 4,
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Marquee(
                                                                                      direction: Axis.horizontal,
                                                                                      textDirection: TextDirection.ltr,
                                                                                      animationDuration: const Duration(seconds: 1),
                                                                                      backDuration: const Duration(milliseconds: 4000),
                                                                                      pauseDuration: const Duration(milliseconds: 1000),
                                                                                      directionMarguee: DirectionMarguee.TwoDirection,
                                                                                      child: Text("${index + 1}.${ingredient.name}", style: textStyleFoodNameBold16, textAlign: TextAlign.left),
                                                                                    ),
                                                                                    Marquee(
                                                                                      direction: Axis.horizontal,
                                                                                      textDirection: TextDirection.ltr,
                                                                                      animationDuration: const Duration(seconds: 1),
                                                                                      backDuration: const Duration(milliseconds: 4000),
                                                                                      pauseDuration: const Duration(milliseconds: 1000),
                                                                                      directionMarguee: DirectionMarguee.TwoDirection,
                                                                                      child: Text(ingredient.quantity_in_stock_note ?? "", style: quantityToOrder < 0 ? textStyleRed14 : textStyleGreen14, textAlign: TextAlign.left),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              //SL TỒN
                                                                              Expanded(
                                                                                flex: 2,
                                                                                child: InkWell(
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text((ingredient.quantity_in_stock?.toInt() ?? 0).toString(), style: textStyleOrange14),
                                                                                      marginTop5,
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              //SL CẦN NHẬP
                                                                              Expanded(
                                                                                flex: 2,
                                                                                child: InkWell(
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text((ingredient.quantity?.toInt() ?? 0).toString(), style: (ingredient.quantity_in_stock ?? 0) >= (ingredient.quantity ?? 0) ? textStyleGreen14 : textStyleRed14),
                                                                                      marginTop5,
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                      );
                                                                    })),
                                                      )
                                                    ],
                                                  )
                                                : emptyBox,
                                          ],
                                        );
                                      });
                                })),
                          )
                        : emptyBox,
                    marginTop20,
                    InkWell(
                      onTap: () async {
                        for (DailySales dailySale
                            in dailySalesController.dailySalesByTimestamp) {
                          if (dailySale.isSelected) {
                            bool isStockAvailable = true;
                            List<String> listName = [];
                            //kiểm tra xem có nguyên liệu nào trong kho còn thiếu không
                            for (Ingredient ingredient
                                in dailySale.ingredients ?? []) {
                              // hàng tồn < cần dùng
                              if ((ingredient.quantity_in_stock ?? 0) <
                                  (ingredient.quantity ?? 0)) {
                                isStockAvailable = false;
                                listName.add("+ ${ingredient.name}\n");
                              }
                            }
                            if (isStockAvailable) {
                              Utils.myPopResult(context, dailySale);
                            } else {
                              Utils.showStylishDialogSetTime(
                                  context,
                                  "KHÔNG ĐỦ SỐ LƯỢNG XUẤT\n            (${Utils.formatTimestamp(dailySale.date_apply)})",
                                  "Danh sách nguyên liệu trong kho không đủ số lượng:\n${listName.join('')}",
                                  StylishDialogType.WARNING,
                                  3);
                            }
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColorOpacity,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.check,
                                  color: primaryColor, size: 16),
                              marginRight5,
                              Text("CHỌN", style: textStylePrimaryBold16),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
