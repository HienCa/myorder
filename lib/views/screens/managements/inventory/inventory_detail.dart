// ignore_for_file: constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/ingredients/ingredients_controller.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/inventory/add_ingredient_to_inventory.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_double.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_int.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class InventoryDetailScreen extends StatefulWidget {
  const InventoryDetailScreen({super.key});

  @override
  State<InventoryDetailScreen> createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends State<InventoryDetailScreen> {
  TextEditingController noteTextEditingController = TextEditingController();
  TextEditingController discountTextEditingController = TextEditingController();
  TextEditingController vatTextEditingController = TextEditingController();
  IngredientController ingredientController = Get.put(IngredientController());

  List<Ingredient> listIngredient = [];
  @override
  void initState() {
    super.initState();
    listIngredient = [];
    ingredientController.getIngredients("");
    discountTextEditingController.text = '0';
    vatTextEditingController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {Navigator.pop(context)},
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("TẠO PHIẾU NHẬP KHO")),
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: backgroundColor,
          child: Column(
            children: [
              marginTop10,
              Container(
                margin: const EdgeInsets.all(0),
                child: Container(
                  decoration: BoxDecoration(
                    color: grayColor100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      MyTextFieldString(
                        textController: noteTextEditingController,
                        label: "GHI CHÚ",
                        placeholder: "Nhập ghi chú vào đây",
                        isReadOnly: false,
                        min: 0,
                        max: 200,
                        isRequire: false,
                        isBorder: false,
                        isMultiline: true,
                      )
                    ],
                  ),
                ),
              ),
              
              deviderColor10,
              //DANH SÁCH CÁC MẶT HÀNG
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
                                  Text("18", style: textStyleLabel14),
                                  marginRight5,
                                  Text("Mặt hàng", style: textStyleLabel14),
                                ],
                              )),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("SL Nhập", style: textStyleLabel14),
                                Text("SL Tồn", style: textStyleLabel14),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text("Đơn giá", style: textStyleLabel14),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Thành tiền", style: textStyleLabel14),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      //DANH SÁCH NGUYÊN LIỆU CỦA PHIẾU NHẬP KHO
                      SingleChildScrollView(
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: ListView.builder(
                                itemCount: listIngredient.length,
                                itemBuilder: (context, index) {
                                  Ingredient ingredient = listIngredient[index];
                                  return SizedBox(
                                    height: 50,
                                    child: Row(children: [
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
                                                    const Duration(seconds: 1),
                                                backDuration: const Duration(
                                                    milliseconds: 4000),
                                                pauseDuration: const Duration(
                                                    milliseconds: 1000),
                                                directionMarguee:
                                                    DirectionMarguee
                                                        .TwoDirection,
                                                child: Text(ingredient.name,
                                                    style:
                                                        textStyleFoodNameBold16,
                                                    textAlign: TextAlign.left),
                                              ),
                                              marginRight5,
                                              Row(
                                                children: [
                                                  Text("7000",
                                                      style: textStyleGreen14),
                                                  marginRight5,
                                                  const Text("|",
                                                      style: textStyleLabel14),
                                                  marginRight5,
                                                  Text("Kg",
                                                      style: textStyleGreen14),
                                                ],
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: InkWell(
                                          onTap: () async {
                                            final result = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return MyDialogCalculator2(
                                                  value:
                                                      ingredient.quantity ?? 0,
                                                );
                                              },
                                            );
                                            if (result != null) {
                                              setState(() {
                                                print(result);
                                                ingredient.quantity =
                                                    double.parse(result);
                                              });
                                            }
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  (ingredient.quantity ?? 0)
                                                      .toString(),
                                                  style: textStyleOrange14),
                                              marginTop5,
                                              Text(
                                                  (ingredient.quantity ?? 0)
                                                      .toString(),
                                                  style: textStylePrimary14),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: InkWell(
                                          onTap: () async {
                                            final result = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return MyCalculator(
                                                    priceDefault:
                                                        ingredient.price ?? 0);
                                              },
                                            );
                                            if (result != null) {
                                              setState(() {
                                                print(result);
                                                ingredient.price = Utils
                                                    .stringConvertToDouble(Utils
                                                        .formatCurrencytoDouble(
                                                            result));
                                              });
                                            }
                                          },
                                          child: Center(
                                            child: Text(
                                              Utils.formatCurrency(
                                                  (ingredient.price ?? 0)),
                                              style: textStyleOrange14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              Utils.formatCurrency(
                                                  ((ingredient.quantity ?? 0) *
                                                      (ingredient.price ?? 0))),
                                              style: textStylePrimary14,
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  );
                                })),
                      )
                    ],
                  ),
                ),
              )),
              deviderColor10,
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    
                    SizedBox(
                      height: 40,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text("Tổng tiền", style: textStyleLabel14),
                            ),
                            Expanded(
                              child: Text(
                                Utils.formatCurrency(
                                    Utils.getSumPriceQuantity2(listIngredient)),
                                style: textStyleLabel14,
                                textAlign: TextAlign.right,
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text("Giảm trừ", style: textStyleLabel14),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final result = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MyCalculator(
                                          priceDefault:
                                              Utils.stringConvertToDouble(
                                                  discountTextEditingController
                                                      .text));
                                    },
                                  );
                                  if (result != null) {
                                    setState(() {
                                      print(result);
                                      discountTextEditingController.text =
                                          Utils.formatCurrency(
                                              Utils.stringConvertToDouble(
                                                  Utils.formatCurrencytoDouble(
                                                      result)));
                                    });
                                  }
                                },
                                child: Text(
                                  Utils.formatCurrency(
                                      Utils.stringConvertToDouble(
                                          discountTextEditingController.text)),
                                  style: textStyleLabel14,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text("V.A.T (%)", style: textStyleLabel14),
                            ),
                            InkWell(
                              onTap: () async {
                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MyDialogCalculatorInt(
                                        value: int.tryParse(
                                                vatTextEditingController
                                                    .text) ??
                                            0,
                                        label: "V.A.T (%)",
                                        min: 0,
                                        max: 10);
                                  },
                                );
                                if (result != null) {
                                  setState(() {
                                    print(result);
                                    vatTextEditingController.text =
                                        result.toString();
                                  });
                                }
                              },
                              child: Expanded(
                                child: Text(
                                  vatTextEditingController.text,
                                  style: textStyleLabel14,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 40,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text("THANH TOÁN",
                                  style: textStylePriceBold16),
                            ),
                            Expanded(
                              child: Text(
                                "7,999,000",
                                style: textStylePriceBold16,
                                textAlign: TextAlign.right,
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
              Container(
                color: backgroundColor,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            List<Ingredient> result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddIngredientToInventoryScreen(
                                          listIngredientSelected:
                                              listIngredient,
                                          listIngredient:
                                              ingredientController.ingredients,
                                        )));
                            if (result.isNotEmpty) {
                              setState(() {
                                listIngredient = result;
                              });
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
                                  FaIcon(FontAwesomeIcons.plus,
                                      color: primaryColor, size: 16),
                                  marginRight5,
                                  Text("MẶT HÀNG",
                                      style: textStylePrimaryBold16),
                                ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
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
                                  FaIcon(FontAwesomeIcons.plus,
                                      color: colorSuccess, size: 16),
                                  marginRight5,
                                  Text("TẠO PHIẾU",
                                      style: textStyleSuccessBold16),
                                ]),
                          ),
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
