// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_price_read_only.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class MyDialogCalculatorInt extends StatefulWidget {
  final int value;
  final String label;
  final int min;
  final int max;
  const MyDialogCalculatorInt({
    Key? key,
    required this.value,
    required this.label,
    required this.min,
    required this.max,
  }) : super(key: key);

  @override
  State<MyDialogCalculatorInt> createState() => _MyDialogCalculatorIntState();
}

class _MyDialogCalculatorIntState extends State<MyDialogCalculatorInt> {
  var textEditingController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.value.toString();
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      marginRight20,
                      marginRight10,
                      const Spacer(),
                      Text(
                        widget.label.toUpperCase(),
                        style: textStyleWhiteBold20,
                      ),
                      const Spacer(),
                      const MyCloseIcon(heightWidth: 30, sizeIcon: 16),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: MyTextFieldPriceReadOnly(
                textEditingController: textEditingController,
                label: '',
                placeholder: '1',
                min: widget.min,
                max: widget.max,
                isRequire: false,
                textAlignRight: true,
                defaultValue: double.parse(widget.value.toString()),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
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
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '8',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '9',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: 'AC',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
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
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '5',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '6',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: 'Tăng',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
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
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '2',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '3',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: 'Giảm',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
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
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '0',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: '.',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                          ButtonCalculator(
                            item: 'Xong',
                            textEditingController: textEditingController,
                            min: widget.min,
                            max: widget.max,
                          ),
                          marginRight10,
                        ],
                      ),
                    ),
                  ],
                )),
            marginTop10
          ],
        ),
      ),
    );
  }
}

class ButtonCalculator extends StatefulWidget {
  final TextEditingController textEditingController;
  final String item;
  final int min;
  final int max;
  const ButtonCalculator({
    super.key,
    required this.item,
    required this.textEditingController,
    required this.min,
    required this.max,
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
            } else if (widget.item == 'Tăng' ) {
              int value = int.tryParse(widget.textEditingController.text) ?? 0;
              value += 1;
              if (value >= 0 && value <= widget.max) {
                widget.textEditingController.text = value.toString();
              } else {
                widget.textEditingController.text = '10';
              }
            } else if (widget.item == 'Giảm') {
              int value = int.tryParse(widget.textEditingController.text) ?? 0;
              value -= 1;
              if (value >= 0 && value >= widget.min) {
                widget.textEditingController.text = value.toString();
              } else {
                widget.textEditingController.text = widget.min.toString();
              }
            } else if (widget.item == 'Xong') {
              Utils.myPopResult(context, widget.textEditingController.text);
            } else {
              //Là số bình thường
              int currentValue =
                  int.tryParse(widget.textEditingController.text) ?? 0;
              int newItem = int.tryParse(widget.item) ?? 0;

              int newValue = currentValue * 10 + newItem;
              if (newValue <= widget.max) {
                widget.textEditingController.text = newValue.toString();
              } else {
                widget.textEditingController.text = widget.max.toString();
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
