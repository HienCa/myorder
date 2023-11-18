// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/foods/foods_controller.dart';
import 'package:myorder/models/food.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_datetime.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_number.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class MyDialogUpdateQuantityFood extends StatefulWidget {
  final Food food;

  const MyDialogUpdateQuantityFood({
    Key? key,
    required this.food,
  }) : super(key: key);
  @override
  State<MyDialogUpdateQuantityFood> createState() =>
      _MyDialogUpdateQuantityFoodState();
}

class _MyDialogUpdateQuantityFoodState
    extends State<MyDialogUpdateQuantityFood> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  FoodController foodController = Get.put(FoodController());

  bool isErrorTextName = false;
  late final bool isUpdate; // Declare isUpdate here
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: primaryColor),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
        ),
        elevation: 5, // Độ nâng của bóng đổ
        backgroundColor: backgroundColor,
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'SỐ LƯỢNG',
                  style: textStylePrimaryBold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyTextFieldNumber(
                    textController: quantityController,
                    label: "Số lượng cần bán",
                    placeholder: "Số lượng",
                    isReadOnly: false,
                    max: 100000,
                    min: 1,
                    isRequire: true),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextFieldDateTime(
                    textEditingController: startDateController,
                    placeholder: "dd/mm/yyyy",
                    height: 50,
                    isRequire: true,
                    lable: "Ngày bắt đầu áp dụng",
                    greaterThanDatetime: DateTime.now(),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextFieldDateTime(
                    textEditingController: endDateController,
                    placeholder: "dd/mm/yyyy",
                    height: 50,
                    isRequire: true,
                    lable: "Ngày kết thúc",
                    greaterThanDatetime: startDateController.text != ""
                        ? DateTime.parse(startDateController.text)
                        : DateTime.now(),
                  )),
              marginTop20,
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => {Navigator.pop(context)},
                      child: Container(
                        height: 50,
                        width: 136,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: backgroundColorGray,
                        ),
                        child: const Center(
                          child: Text(
                            'HỦY BỎ',
                            style: textStyleCancel,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => {
                        if (!Utils.isValidRangeTextEditController(
                            quantityController, 1, 100000))
                          {
                            Utils.showStylishDialog(
                                context,
                                'THÔNG BÁO',
                                'Vui lòng nhập số lượng!',
                                StylishDialogType.ERROR)
                          }
                        else if (!Utils.isValidDateTime(
                            startDateController.text, DateTime.now()))
                          {
                            Utils.showStylishDialog(
                                context,
                                'THÔNG BÁO',
                                'Kiểm tra lại ngày bắt đầu!',
                                StylishDialogType.ERROR)
                          }
                        else if (!Utils.isValidDateTime(endDateController.text,
                            DateTime.parse(startDateController.text)))
                          {
                            print(startDateController.text),
                            print(endDateController.text),
                            Utils.showStylishDialog(
                                context,
                                'THÔNG BÁO',
                                'Kiểm tra lại ngày kết thúc!',
                                StylishDialogType.ERROR)
                          }
                        else
                          {
                            if (widget.food.food_id != "")
                              {
                                foodController.updateQuantityFoodOrder(
                                    widget.food.food_id,
                                    (double.tryParse(quantityController.text) ??
                                        0),
                                    Utils.convertDatetimeToTimestamp(
                                        DateTime.parse(
                                            startDateController.text)),
                                    Utils.convertDatetimeToTimestamp(
                                        DateTime.parse(endDateController.text)),
                                    context),
                              },
                          }
                      },
                      child: Container(
                        height: 50,
                        width: 136,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: primaryColor,
                        ),
                        child: const Center(
                            child: Text(
                          'THIẾT LẬP',
                          style: textStyleWhiteBold16,
                        )),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
