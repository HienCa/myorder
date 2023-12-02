// ignore_for_file: constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/units/units_controller.dart';
import 'package:myorder/models/ingredient.dart';
import 'package:myorder/models/unit.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator_double.dart';
import 'package:myorder/views/widgets/dialogs/dialog_select.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class AddIngredientToWarehouseExportScreen extends StatefulWidget {
  final bool isUpdate;
  final List<Ingredient> listIngredientSelected;
  final List<Ingredient> listIngredient;
  const AddIngredientToWarehouseExportScreen(
      {super.key,
      required this.listIngredient,
      required this.listIngredientSelected,
      required this.isUpdate});

  @override
  State<AddIngredientToWarehouseExportScreen> createState() =>
      _AddIngredientToWarehouseExportScreenState();
}

class _AddIngredientToWarehouseExportScreenState
    extends State<AddIngredientToWarehouseExportScreen> {
  UnitController unitController = Get.put(UnitController());

  final TextEditingController unitIdConversionController =
      TextEditingController();
  final TextEditingController nameValueConversationController =
      TextEditingController();
  @override
  void initState() {
    super.initState();

    if (widget.isUpdate) {
      //Cập nhật
      for (Ingredient item in widget.listIngredient) {
        Ingredient? foundIngredient = widget.listIngredientSelected.firstWhere(
            (ingredient) => ingredient.ingredient_id == item.ingredient_id,
            orElse: () => Ingredient(ingredient_id: "", name: "", active: 0));

        // Nếu tìm thấy, thiết lập giá trị
        if (foundIngredient.ingredient_id != "") {
          item.isSelected = true;
          item.quantity = foundIngredient.quantity;
          item.price = foundIngredient.price;
          item.unit_id = foundIngredient.unit_id;
          item.unit_name = foundIngredient.unit_name;
        }
      }
    } else {
      //Tạo mới phiếu
      for (Ingredient item in widget.listIngredient) {
        // Tìm kiếm phần tử tương ứng trong danh sách ingredients
        Ingredient? foundIngredient = widget.listIngredientSelected.firstWhere(
            (ingredient) => ingredient.ingredient_id == item.ingredient_id,
            orElse: () => Ingredient(ingredient_id: "", name: "", active: 0));

        // Nếu tìm thấy, thiết lập giá trị
        if (foundIngredient.ingredient_id != "") {
          foundIngredient.isSelected = true;
          foundIngredient.quantity = item.quantity;
          foundIngredient.price = item.price;
          foundIngredient.unit_id = item.unit_id;
          foundIngredient.unit_name = item.unit_name;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => {
                    Navigator.pop(context),
                  },
              child: const Icon(Icons.arrow_back_ios)),
          title: const Center(child: Text("DANH SÁCH MẶT HÀNG")),
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
        body: Theme(
          data: ThemeData(unselectedWidgetColor: primaryColor),
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: backgroundColor,
            child: Column(
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
                      // ingredientController.getIngredients(value);
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
                                    // Text("18", style: textStyleGreen14),
                                    marginRight20,
                                    marginRight10,
                                    marginRight5,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Mặt hàng",
                                            style: textStyleLabel14),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Đơn vị",
                                              style: textStyleLabel14,
                                            ),
                                            marginRight5,
                                            Text(
                                              '(*)',
                                              style: textStyleErrorInput,
                                            )
                                          ],
                                        ),
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
                                      Text("SL Xuất", style: textStyleLabel14),
                                      marginRight5,
                                      Text(
                                        '(*)',
                                        style: textStyleErrorInput,
                                      )
                                    ],
                                  ),
                                  Text("SL Tồn", style: textStyleLabel14),
                                ],
                              )),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Thành tiền", style: textStyleLabel14),
                                  Text("Đơn giá",
                                      style: textStyleLabel14,
                                      textAlign: TextAlign.right),
                                ],
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: ListView.builder(
                                itemCount: widget.listIngredient.length,
                                itemBuilder: (context, index) {
                                  Ingredient ingredient =
                                      widget.listIngredient[index];

                                  return SizedBox(
                                    height: 50,
                                    child: Row(children: [
                                      SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Checkbox(
                                          value: ingredient.isSelected ?? false,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              ingredient.isSelected = value;
                                            });
                                          },
                                          activeColor: primaryColor,
                                        ),
                                      ),
                                      marginRight5,
                                      Expanded(
                                          flex: 4,
                                          child: InkWell(
                                            onTap: () async {
                                              Unit result = await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return MyDialogSelect(
                                                      lable: "DANH SÁCH ĐƠN VỊ",
                                                      list: Utils.filterActive(
                                                          unitController.units),
                                                      keyNameSearch: "name");
                                                },
                                              );
                                              if (result.unit_id != "") {
                                                setState(() {
                                                  ingredient.unit_name =
                                                      result.name;
                                                  ingredient.unit_id =
                                                      result.unit_id;
                                                  unitIdConversionController
                                                      .text = result.unit_id;
                                                  nameValueConversationController
                                                      .text = result.name;
                                                });
                                              }
                                            },
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
                                                      textAlign:
                                                          TextAlign.left),
                                                ),
                                                marginRight5,
                                                ingredient.isSelected == true
                                                    ? Row(
                                                        children: [
                                                          ingredient.unit_name !=
                                                                  ""
                                                              ? Text(
                                                                  ingredient
                                                                          .unit_name ??
                                                                      "",
                                                                  style:
                                                                      textStyleGreen14)
                                                              : Text(
                                                                  "Chọn đơn vị xuất",
                                                                  style:
                                                                      textStyleRed14),
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
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
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  (ingredient.quantity ?? 0)
                                                      .toString(),
                                                  style: textStyleOrange14,
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  (ingredient.quantity ?? 0)
                                                      .toString(),
                                                  style: textStylePrimary14,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: InkWell(
                                          onTap: () async {
                                            final result = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return MyCalculator(
                                                    priceDefault:
                                                        ingredient.price ?? 0,
                                                    min: 0,
                                                    max: MAX_PRICE);
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
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  Utils.formatCurrency(
                                                      ((ingredient.quantity ??
                                                              0) *
                                                          (ingredient.price ??
                                                              0))),
                                                  style: textStylePrimary14),
                                              marginTop5,
                                              Text(
                                                  Utils.formatCurrency(
                                                      (ingredient.price ?? 0)),
                                                  style: textStyleOrange14),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
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
                                    Text("HỦY", style: textStyleCanceBoldl16),
                                  ]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              List<Ingredient> list =
                                  Utils.filterIngredientSelected(
                                      widget.listIngredient);
                              String listUnitName = "";
                              print(
                                  "Số lượng mặt hàng đã chọn: ${list.length}");
                              bool isCheckUnit = true;
                              for (int i = 0; i < list.length; i++) {
                                //kiểm tra đã chọn đươn vị xuất kho hay chưa?
                                if (list[i].unit_id == null) {
                                  isCheckUnit = false;
                                  listUnitName =
                                      "$listUnitName, ${list[i].name}";
                                }
                              }
                              if (isCheckUnit) {
                                Utils.myPopResult(context, list);
                              } else {
                                listUnitName = listUnitName.substring(1);
                                Utils.showStylishDialog(
                                    context,
                                    "THÔNG BÁO",
                                    "Vui lòng chọn đơn vị xuất cho: $listUnitName",
                                    StylishDialogType.INFO);
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
                                    FaIcon(FontAwesomeIcons.plus,
                                        color: colorSuccess, size: 16),
                                    marginRight5,
                                    Text("XÁC NHẬN",
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
      ),
    );
  }
}
