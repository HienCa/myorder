// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/controllers/orders/orders_controller.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/headers/header_icon.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class MyCalculator extends StatefulWidget {
  final double priceDefault;

  const MyCalculator({super.key, required this.priceDefault});

  @override
  State<MyCalculator> createState() => _MyCalculatorState();
}

class _MyCalculatorState extends State<MyCalculator> {
  int selectedRadioDecrease = CATEGORY_ALL;
  final TextEditingController percentTextEditController =
      TextEditingController();
  final TextEditingController priceTextEditController = TextEditingController();
  OrderController orderController = Get.put(OrderController());
  bool isCheckedPrice = true;
  bool isCheckedPercent = false;
  String result = "0";
  @override
  void initState() {
    super.initState();
    result = Utils.formatCurrency(widget.priceDefault);
  }

  ok() {
    double formattedResult = Utils.stringConvertToDouble(result);
    if (formattedResult >= MIN_PRICE) {
      Utils.myPopResult(context, result);
    } else {
      Utils.showStylishDialog(context, "THÔNG BÁO!", 'Giá tiền phải lớn hơn $MIN_PRICE', StylishDialogType.INFO);
      // Utils.myPopResult(widget.context2, '0');
    }
    print('Giá trị đã nhập là: $result');
  }

  removeLastDigitFromResult() {
    priceTextEditController.text = priceTextEditController.text
        .substring(0, priceTextEditController.text.length - 1);
    if (priceTextEditController.text.isEmpty) {
      priceTextEditController.text = '0';
    }

    result =
        Utils.formatCurrency(double.tryParse(priceTextEditController.text));
  }

  incrementValue() {
    int currentValue = int.tryParse(priceTextEditController.text) ?? 0;
    priceTextEditController.text = (currentValue + 1).toString();
    result =
        Utils.formatCurrency(double.tryParse(priceTextEditController.text));
  }

  decrementValue() {
    int currentValue = int.tryParse(priceTextEditController.text) ?? 0;
    priceTextEditController.text = (currentValue - 1).toString();
    result =
        Utils.formatCurrency(double.tryParse(priceTextEditController.text));
  }

  onButtonClick(value) {
    if (value.isNotEmpty) {
      if ((priceTextEditController.text == '0') ||
          priceTextEditController.text == '000') {
        priceTextEditController.text = '';
      } else {
        priceTextEditController.text += value;
      }
      print(priceTextEditController.text);
      if (priceTextEditController.text.isNotEmpty) {
        if (double.tryParse(priceTextEditController.text)! > 100000000) {
          priceTextEditController.text = '100000000';
          result = Utils.formatCurrency(
              double.tryParse(priceTextEditController.text));
        } else {
          result = Utils.formatCurrency(
              double.tryParse(priceTextEditController.text));
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Góc bo tròn
      ),
      elevation: 5, // Độ nâng của bóng đổ
      backgroundColor: const Color.fromARGB(255, 204, 203, 203),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: primaryColor,
            child: MyHeaderIcon(
              icon: iconCloseWhite,
              label: "NHẬP GIÁ TIỀN",
              labelStyle: textStyleWhiteBold20,
              context: context,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    textAlign: TextAlign.right,
                    result,
                    style: textStyleCalculaorBold20,
                  ),
                ),
              ],
            ),
          ),
          marginTop10,
          Row(children: [
            Expanded(
              child: Container(
                  height: 60,
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: primaryColor),
                    onPressed: () => {
                      setState(() {
                        priceTextEditController.text = '0';
                        result = priceTextEditController.text;
                      })
                    },
                    child: const Text(
                      "AC",
                      style: TextStyle(
                          color: secondColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Expanded(
              child: Container(
                  height: 60,
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: primaryColor),
                    onPressed: () => {
                      setState(() {
                        incrementValue();
                      })
                    },
                    child: const Text(
                      "+",
                      style: TextStyle(
                          color: secondColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Expanded(
              child: Container(
                  height: 60,
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: primaryColor),
                    onPressed: () => {
                      setState(() {
                        decrementValue();
                      })
                    },
                    child: const Text(
                      "-",
                      style: TextStyle(
                          color: secondColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Expanded(
                child: Container(
              height: 60,
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: primaryColor),
                  onPressed: () => {
                        setState(() {
                          removeLastDigitFromResult();
                        })
                      },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: secondColor,
                  )),
            ))
          ]),
          Row(children: [
            button(text: '7'),
            button(text: '8'),
            button(text: '9'),
          ]),
          Row(children: [
            button(text: '4'),
            button(text: '5'),
            button(text: '6'),
          ]),
          Row(children: [
            button(text: '1'),
            button(text: '2'),
            button(text: '3'),
          ]),
          Row(children: [
            button(text: '0'),
            button(text: '000'),
            Expanded(
              child: Container(
                  height: 60,
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: primaryColor
                        // shadowColor: buttonBGcolor,
                        ),
                    onPressed: () => {ok()},
                    child: const Text(
                      "Xong",
                      style: TextStyle(
                          color: secondColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          ]),
        ],
      ),
    );
  }

  Widget button(
      {text, tColor = Colors.white, buttonBGcolor = buttonCalculatorColor}) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(22),
              // shadowColor: buttonBGcolor,
              backgroundColor: Colors.white),
          onPressed: () => onButtonClick(text),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          )),
    ));
  }
}
