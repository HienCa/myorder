// ignore_for_file: avoid_single_cascade_in_expression_statements, avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/models/test.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_string.dart';

class AddTestPage extends StatefulWidget {
  const AddTestPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTestPage> createState() => _AddTestPageState();
}

class _AddTestPageState extends State<AddTestPage> {
  FoodController foodController = Get.put(FoodController());

  String? errorTextName = "";
  String? errorTextVatPercent = "";

  bool isErrorTextName = false;
  bool isErrorTextVatPercent = false;
  bool isCheckCombo = false;
  // List<Food> foodController.foods = [];
  @override
  void initState() {
    super.initState();
    // foodController.getfoods("");
    // foodController.foods = foodController.foods;
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController vatPercentController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    vatPercentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundColor,
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
          "THÊM MỚI TEST",
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
      body: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      marginTop10,
                      MyTextFieldString(
                        textController: nameController,
                        label: 'TÊN TEST',
                        placeholder: 'Nhập tên',
                        isReadOnly: false,
                        min: minlength2,
                        max: maxlength50,
                        isRequire: true,
                      ),
                      ListTile(
                        leading: Theme(
                          data: ThemeData(unselectedWidgetColor: primaryColor),
                          child: Checkbox(
                            value: isCheckCombo,
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckCombo = value!;
                              });
                            },
                            activeColor: primaryColor,
                          ),
                        ),
                        title: const Text(
                          "Món combo",
                          style: textStylePriceBold16,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity:
                            isCheckCombo ? 1.0 : 0.0, // 1.0 là hiện, 0.0 là ẩn
                        duration: const Duration(
                            milliseconds: 500), // Độ dài của animation
                        child: isCheckCombo
                            ? Column(
                                children: [
                                  Container(
                                    color: primaryColor,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: kDefaultPadding / 2),
                                    height: 50,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: foodController.foods.length,
                                      itemBuilder: (context, index) =>
                                          GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                            left: kDefaultPadding,
                                            right: index ==
                                                    foodController
                                                            .foods.length -
                                                        1
                                                ? kDefaultPadding
                                                : 0,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: textWhiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  width: 5,
                                                  color: borderColorPrimary)),
                                          child: Text(
                                            foodController.foods[index].name,
                                            style: const TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                      //DANH SÁCH FOOD
                      AnimatedOpacity(
                        opacity:
                            isCheckCombo ? 1.0 : 0.0, // 1.0 là hiện, 0.0 là ẩn
                        duration: const Duration(
                            milliseconds: 500), // Độ dài của animation
                        child: isCheckCombo
                            ? Column(
                                children: [
                                  Container(
                                    color: primaryColor,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: kDefaultPadding / 2),
                                    height: 500,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: foodController.foods.length,
                                      itemBuilder: (context, index) =>
                                          GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (foodController.foods[index]
                                                .isSelected == true) {
                                              foodController.foods[index]
                                                  .isSelected = false;
                                            } else {
                                              foodController.foods[index]
                                                  .isSelected = true;
                                            }
                                          });
                                        },
                                        child: Stack(children: [
                                          Container(
                                            height: 50,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.all(
                                              5,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: colorCancel,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              foodController.foods[index].name,
                                              style: const TextStyle(
                                                  color: secondColor,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          Utils.isSelected(
                                                  foodController.foods[index])
                                              ? Positioned(
                                                  top: 0,
                                                  right: 10,
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    height: 30,
                                                    width: 30,
                                                    child: ClipRRect(
                                                      child: checkImageGreen,
                                                    ),
                                                  ))
                                              : const SizedBox()
                                        ]),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => {Navigator.pop(context)},
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                                color: dividerColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text("QUAY LẠI", style: buttonStyleCancel),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // if (!Utils.isValidLengthTextEditController(
                            //         nameController, minlength2, maxlength50) &&
                            //     !Utils.isValidRangeTextEditController(
                            //         vatPercentController, 1, 100)) {
                            //   Utils.showStylishDialog(
                            //       context,
                            //       'THÔNG BÁO',
                            //       'Vui lòng kiểm tra lại thông tin nhập liệu.',
                            //       StylishDialogType.ERROR);
                            // } else if (!Utils.isValidLengthTextEditController(
                            //     nameController, minlength2, maxlength50)) {
                            //   Utils.showStylishDialog(
                            //       context,
                            //       'THÔNG BÁO',
                            //       'Tên vat phải từ $minlength2 đến $maxlength50',
                            //       StylishDialogType.ERROR);
                            // } else if (!Utils.isValidRangeTextEditController(
                            //     vatPercentController, 1, 100)) {
                            //   Utils.showStylishDialog(
                            //       context,
                            //       'THÔNG BÁO',
                            //       'Phần trăm phải từ 1 đến 100',
                            //       StylishDialogType.ERROR);
                            // } else {
                            //   vatController.createVat(
                            //     nameController.text,
                            //     vatPercentController.text,
                            //   );
                            //   Utils.myPopSuccess(context);
                            // }
                          },
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child:
                                  Text("THÊM MỚI", style: buttonStyleBlackBold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
