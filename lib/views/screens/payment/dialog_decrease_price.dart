// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/buttons/button.dart';
import 'package:myorder/views/widgets/dialogs/dialog_choose_price_calculator.dart';
import 'package:myorder/views/widgets/headers/header_icon.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_number.dart';
import 'package:myorder/models/order.dart' as model;
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_price.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class CustomDialogDecreasePrice extends StatefulWidget {
  final model.Order order;
  const CustomDialogDecreasePrice({super.key, required this.order});

  @override
  State<CustomDialogDecreasePrice> createState() =>
      _CustomDialogDecreasePriceState();
}

class _CustomDialogDecreasePriceState extends State<CustomDialogDecreasePrice> {
  int selectedRadioDecrease = CATEGORY_ALL;
  final TextEditingController percentTextEditController =
      TextEditingController();
  final TextEditingController priceTextEditController = TextEditingController();
  OrderController orderController = Get.put(OrderController());
  bool isCheckedPrice = true;
  bool isCheckedPercent = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
        ),
        elevation: 5, // Độ nâng của bóng đổ
        backgroundColor: backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: primaryColor,
                child: MyHeaderIcon(
                  icon: iconCloseWhite,
                  label: "GIẢM GIÁ HÓA ĐƠN",
                  labelStyle: textStyleWhiteBold20,
                  context: context,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 50,
                  width: 450,
                  child: Row(
                    children: [
                      Expanded(
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: primaryColor),
                          child: Radio(
                            value: CATEGORY_ALL,
                            groupValue: selectedRadioDecrease,
                            onChanged: (value) {
                              setState(() {
                                selectedRadioDecrease = value as int;
                                print(value);
                              });
                            },
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Text('Tổng bill',
                            style: textStyleTitleGrayRegular16),
                      ),
                      Expanded(
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: primaryColor),
                          child: Radio(
                            value: CATEGORY_FOOD,
                            groupValue: selectedRadioDecrease,
                            onChanged: (value) {
                              setState(() {
                                selectedRadioDecrease = value as int;
                                print(value);
                              });
                            },
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child:
                            Text('Món ăn', style: textStyleTitleGrayRegular16),
                      ),
                      Expanded(
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: primaryColor),
                          child: Radio(
                            value: CATEGORY_DRINK,
                            groupValue: selectedRadioDecrease,
                            onChanged: (value) {
                              setState(() {
                                selectedRadioDecrease = value as int;
                                print(selectedRadioDecrease);
                              });
                            },
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Món nước',
                          style: textStyleTitleGrayRegular16,
                        ),
                      ),
                      Expanded(
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: primaryColor),
                          child: Radio(
                            value: CATEGORY_OTHER,
                            groupValue: selectedRadioDecrease,
                            onChanged: (value) {
                              setState(() {
                                selectedRadioDecrease = value as int;
                              });
                            },
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Text('Món khác',
                            style: textStyleTitleGrayRegular16),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Theme(
                    data: ThemeData(unselectedWidgetColor: primaryColor),
                    child: Checkbox(
                      value: isCheckedPrice,
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckedPrice = value!;
                          print(isCheckedPrice);
                          isCheckedPercent = !isCheckedPrice;
                          percentTextEditController.text = "0";
                        });
                      },
                      activeColor: primaryColor,
                    ),
                  ),
                  const Text(
                    'Theo giá tiền',
                    style: textStyleLabel20,
                  )
                ],
              ),
              AnimatedOpacity(
                  opacity: isCheckedPrice ? 1.0 : 0.0, // 1.0 là hiện, 0.0 là ẩn
                  duration:
                      const Duration(milliseconds: 500), // Độ dài của animation
                  child: isCheckedPrice
                      ? GestureDetector(
                          onTap: () async {
                            print(
                                'Giá trị hiện tại là: ${priceTextEditController.text}');
                            String? result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MyCalculator(
                                  priceDefault: Utils.stringConvertToDouble(
                                      priceTextEditController.text),
                                );
                              },
                            );

                            // Kiểm tra giá trị trả về và xử lý nó

                            if (result != null && result.isNotEmpty) {
                              priceTextEditController.text = result;
                            } else {
                              priceTextEditController.text = "0";
                            }
                          },
                          // child: Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: MyTextFieldChoosePrice(
                          //     textController: priceTextEditController,
                          //     label: 'Số tiền muốn giảm',
                          //     placeholder: 'Chọn số tiền',
                          //     isRequire: true,
                          //   ),
                          // ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyTextFieldPrice(
                              textEditingController: priceTextEditController,
                              label: 'Số tiền muốn giảm',
                              placeholder: 'Nhập số tiền',
                              min: MIN_PRICE,
                              max: MAX_PRICE,
                              isRequire: true,
                              textAlignRight: false,
                            ),
                          ))
                      : const SizedBox()),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Theme(
                  data: ThemeData(unselectedWidgetColor: primaryColor),
                  child: Checkbox(
                    value: isCheckedPercent,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedPercent = value!;
                        print(isCheckedPercent);
                        isCheckedPrice = !isCheckedPercent;
                        priceTextEditController.text = "0";
                      });
                    },
                    activeColor: primaryColor,
                  ),
                ),
                const Text(
                  'Theo phần trăm',
                  style: textStyleLabel20,
                )
              ]),
              AnimatedOpacity(
                  opacity:
                      isCheckedPercent ? 1.0 : 0.0, // 1.0 là hiện, 0.0 là ẩn
                  duration:
                      const Duration(milliseconds: 500), // Độ dài của animation
                  child: isCheckedPercent
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFieldNumber(
                            textController: percentTextEditController,
                            label: 'Phần trăm (%) muốn giảm',
                            placeholder: 'Nhập %',
                            isReadOnly: !isCheckedPercent,
                            min: 1,
                            max: 100,
                            isRequire: true,
                          ),
                        )
                      : const SizedBox()),
              marginTop20,
              MyButton(
                buttonText: "XÁC NHẬN",
                onTap: () {
                  //giảm theo phần trăm %
                  if (isCheckedPercent) {
                    int percent = int.tryParse(Utils.formatCurrencytoDouble(
                            percentTextEditController.text)) ??
                        0;
                    if (percent > 0) {
                      orderController.applyDiscount(
                        context,
                        orderController.orderDetail,
                        selectedRadioDecrease,
                        0,
                        int.tryParse(percentTextEditController.text) ?? 0,
                      );
                    } else {
                      // thông báo lớn hơn 0

                      Utils.showStylishDialog(
                          context,
                          'THÔNG BÁO',
                          'Vui lòng nhập phần trăm ít nhất là $MIN_PERCENT.',
                          StylishDialogType.INFO);
                    }
                  } else {
                    // giảm theo giá tiền
                    double price = double.tryParse(Utils.formatCurrencytoDouble(
                            priceTextEditController.text)) ??
                        0;
                    if (price >= MIN_PRICE && price <= MAX_PRICE) {
                      orderController.applyDiscount(
                        context,
                        orderController.orderDetail,
                        selectedRadioDecrease,
                        Utils.stringConvertToDouble(
                            priceTextEditController.text),
                        0,
                      );
                    } else {
                      // thông báo lớn hơn 1000

                      Utils.showStylishDialog(
                          context,
                          'THÔNG BÁO',
                          "Vui lòng nhập giá tiền ít nhất là $MIN_PRICE.",
                          StylishDialogType.INFO);
                    }
                  }
                },
                style: buttonStyleWhiteBold,
                color: primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
