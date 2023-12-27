// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/warehouse/warehouse_receipt_controller.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';

class CustomDialogRecommendIngredients extends StatefulWidget {
  final DateTime date;
  const CustomDialogRecommendIngredients({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  State<CustomDialogRecommendIngredients> createState() =>
      _CustomDialogRecommendIngredientsState();
}

class _CustomDialogRecommendIngredientsState
    extends State<CustomDialogRecommendIngredients> {
  WarehouseReceiptController warehouseReceiptController =
      Get.put(WarehouseReceiptController());
  DateTime dateSelected = DateTime.now();
  bool isCheckAll = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isCheckAll = Utils.isCheckedAllDyamic(
        warehouseReceiptController.recommendedingredients);
    dateSelected = widget.date;
    dateSelected = DateTime(
        dateSelected.year, dateSelected.month, dateSelected.day, 0, 0, 0, 0);
    // if (warehouseReceiptController.recommendedingredients.isEmpty) {
      warehouseReceiptController.getRecommendedIngredients(dateSelected);
    // }
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
                    InkWell(
                      onTap: () async {
                        //Thay đổi ngày
                        DateTime now = Timestamp.now().toDate();
                        DateTime? date = await Utils.selectDate(context);
                        if (date != null) {
                          setState(() {
                            dateSelected = date ?? DateTime.now();
                          });
                          date = DateTime(
                              date.year, date.month, date.day, 0, 0, 0, 0);
                          warehouseReceiptController
                              .getRecommendedIngredients(date);
                        } else {
                          now = DateTime(
                              now.year, now.month, now.day, 0, 0, 0, 0);
                          warehouseReceiptController
                              .getRecommendedIngredients(now);
                        }
                      },
                      child: Row(
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
                                  'GỢI Ý NHẬP KHO',
                                  style: textStylePrimaryBold,
                                ),
                                Text(
                                  '(${Utils.formatDateTime(dateSelected)})',
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
                    ),
                    marginTop10,
                    SizedBox(
                      height: 50,
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Checkbox(
                            value: isCheckAll,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckAll = value ?? false;
                                Utils.toggleCheckAll(
                                    warehouseReceiptController
                                        .recommendedingredients,
                                    value ?? false);
                              });
                            },
                            activeColor: primaryColor,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Mặt hàng", style: textStyleLabel14),
                                const Text("Tình trạng kho",
                                    style: textStyleLabel14),
                              ],
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Số lượng", style: textStyleLabel14),
                              Text("Tồn", style: textStyleLabel14),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Số lượng", style: textStyleLabel14),
                              Text("Cần dùng", style: textStyleLabel14),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Obx(() {
                            return ListView.builder(
                                itemCount: warehouseReceiptController
                                    .recommendedingredients.length,
                                itemBuilder: (context, index) {
                                  Ingredient ingredient =
                                      warehouseReceiptController
                                          .recommendedingredients[index];
                                  double quantityToOrder =
                                      (ingredient.quantity_in_stock ?? 0) -
                                          (ingredient.quantity ?? 0);
                                  if (quantityToOrder < 0) {
                                    ingredient.quantity_in_stock_note =
                                        "(Thiếu ${quantityToOrder.toInt().toString().replaceAll(RegExp(r'-'), "")}${ingredient.unit_name})";
                                  } else {
                                    ingredient.quantity_in_stock_note = "(Đủ)";
                                  }
                                  return SizedBox(
                                    height: 50,
                                    child: Row(children: [
                                      //STT
                                      Expanded(
                                        flex: 1,
                                        child: Checkbox(
                                          value: ingredient.isSelected,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              ingredient.isSelected = value;
                                              isCheckAll =
                                                  Utils.isCheckedAllDyamic(
                                                      warehouseReceiptController
                                                          .recommendedingredients);
                                            });
                                          },
                                          activeColor: primaryColor,
                                        ),
                                      ),
                                      //MẶT HÀNG - TÌNH TRẠNG KHO
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
                                              textDirection: TextDirection.ltr,
                                              animationDuration:
                                                  const Duration(seconds: 1),
                                              backDuration: const Duration(
                                                  milliseconds: 4000),
                                              pauseDuration: const Duration(
                                                  milliseconds: 1000),
                                              directionMarguee:
                                                  DirectionMarguee.TwoDirection,
                                              child: Text(ingredient.name,
                                                  style:
                                                      textStyleFoodNameBold16,
                                                  textAlign: TextAlign.left),
                                            ),
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
                                              child: Text(
                                                  ingredient
                                                          .quantity_in_stock_note ??
                                                      "",
                                                  style: quantityToOrder < 0
                                                      ? textStyleRed14
                                                      : textStyleGreen14,
                                                  textAlign: TextAlign.left),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //SL TỒN
                                      Expanded(
                                        flex: 2,
                                        child: InkWell(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  (ingredient.quantity_in_stock
                                                              ?.toInt() ??
                                                          0)
                                                      .toString(),
                                                  style: textStyleOrange14),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  (ingredient.quantity
                                                              ?.toInt() ??
                                                          0)
                                                      .toString(),
                                                  style: (ingredient
                                                                  .quantity_in_stock ??
                                                              0) >=
                                                          (ingredient
                                                                  .quantity ??
                                                              0)
                                                      ? textStyleGreen14
                                                      : textStyleRed14),
                                              marginTop5,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
                                });
                          })),
                    ),
                    marginTop20,
                    InkWell(
                      onTap: () async {
                        List<Ingredient> ingredientSelected = [];
                        for (Ingredient ingredient in warehouseReceiptController
                            .recommendedingredients) {
                          //Chỉ chọn nguyên liệu được check và trong kho còn thiếu hoặc đủ dùng
                          // if (ingredient.isSelected == true &&
                          //     (ingredient.quantity_in_stock ?? 0) <=
                          //         (ingredient.quantity ?? 0)) {
                          //   ingredientSelected.add(ingredient);
                          // }
                          //Chọn tất tả nguyên liệu được check -> gợi ý nhập tất cả
                          if (ingredient.isSelected == true) {
                            ingredientSelected.add(ingredient);
                          }
                        }
                        Utils.myPopResult(context, ingredientSelected);
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
