// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_price_read_only.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class MyDialogCalculator2 extends StatefulWidget {
  final double value;
  const MyDialogCalculator2({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  State<MyDialogCalculator2> createState() => _MyDialogCalculator2State();
}

class _MyDialogCalculator2State extends State<MyDialogCalculator2> {
  var textEditingController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      backgroundColor: grayColor200,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: primaryColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                color: primaryColor,
                height: 40,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      marginRight20,
                      marginRight10,
                      Spacer(),
                      Text(
                        "SỐ LƯỢNG",
                        style: textStyleWhiteBold20,
                      ),
                      Spacer(),
                      MyCloseIcon(heightWidth: 30, sizeIcon: 16),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: MyTextFieldPriceReadOnly(
                textEditingController: textEditingController,
                label: '',
                placeholder: '0',
                min: 0,
                max: MAX_PRICE,
                isRequire: false,
                textAlignRight: true,
                defaultValue: double.parse(widget.value.toString()),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          marginRight10,
                          ButtonCalculator(
                            item: '7',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '8',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '9',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: 'AC',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                        ],
                      ),
                    ),
                    marginTop10,
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          marginRight10,
                          ButtonCalculator(
                            item: '4',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '5',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '6',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: 'Tăng',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                        ],
                      ),
                    ),
                    marginTop10,
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          marginRight10,
                          ButtonCalculator(
                            item: '1',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '2',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '3',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: 'Giảm',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                        ],
                      ),
                    ),
                    marginTop10,
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          marginRight10,
                          ButtonCalculator(
                            item: '1',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '0',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '.',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: 'Xong',
                            textEditingController: textEditingController,
                          ),
                          marginRight10,
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class ButtonCalculator extends StatefulWidget {
  final TextEditingController textEditingController;
  final String item;
  const ButtonCalculator({
    super.key,
    required this.item,
    required this.textEditingController,
  });

  @override
  State<ButtonCalculator> createState() => _ButtonCalculatorState();
}

class _ButtonCalculatorState extends State<ButtonCalculator> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            print(widget.item);

            if (widget.item == 'AC') {
              widget.textEditingController.text = '';
            } else if (widget.item == 'Tăng') {
              double value =
                  double.tryParse(widget.textEditingController.text) ?? 0;
              value += 0.1;
              if (value >= 0) {
                widget.textEditingController.text = value.toStringAsFixed(1);
              } else {
                widget.textEditingController.text = '0';
              }
            } else if (widget.item == 'Giảm') {
              double value =
                  double.tryParse(widget.textEditingController.text) ?? 0;
              value -= 0.1;
              if (value >= 0) {
                widget.textEditingController.text = value.toStringAsFixed(1);
              } else {
                widget.textEditingController.text = '0';
              }
            } else if (widget.item == 'Xong') {
              Utils.myPopResult(context, widget.textEditingController.text);
            } else {
              //Là số bình thường
              double currentValue =
                  double.tryParse(widget.textEditingController.text) ?? 0;
              double newItem = double.tryParse(widget.item) ?? 0;

              double newValue = currentValue * 10 + newItem;
              if (newValue <= MAX_PRICE) {
                widget.textEditingController.text = newValue.toStringAsFixed(1);
              } else {
                widget.textEditingController.text = MAX_PRICE.toString();
                Utils.showStylishDialog(context, 'THÔNG BÁO',
                    'Đã đạt số lượng tối đa.', StylishDialogType.INFO);
              }
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: secondColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.item.toString(),
              textAlign: TextAlign.center,
              style: textStyleLabel16,
            ),
          ),
        ),
      ),
    );
  }
}
