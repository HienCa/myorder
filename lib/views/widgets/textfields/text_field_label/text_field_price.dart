import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/utils.dart';

class MyTextFieldPrice extends StatefulWidget {
  final TextEditingController textEditingController;
  final String label;
  final String placeholder;
  final bool isRequire;
  final int max;
  final int min;
  final double? defaultValue;
  final bool textAlignRight;

  const MyTextFieldPrice(
      {super.key,
      required this.textEditingController,
      required this.label,
      required this.placeholder,
      required this.min,
      required this.max,
      required this.isRequire,
      this.defaultValue,
      required this.textAlignRight});

  @override
  State<MyTextFieldPrice> createState() => _MyTextFieldPriceState();
}

class _MyTextFieldPriceState extends State<MyTextFieldPrice> {
  @override
  void initState() {
    // widget.textEditingController.text =
    //     Utils.convertTextFieldPrice('${widget.min}');
    if ((widget.defaultValue ?? 0) > 0) {
      widget.textEditingController.text =
          Utils.formatCurrency(widget.defaultValue);
    } else {
      widget.textEditingController.text = Utils.convertTextFieldPrice('0');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Text(
                widget.label,
                style: textStyleLabel16,
              ),
              marginRight10,
              widget.isRequire
                  ? const Text(
                      '(*)',
                      style: textStyleErrorInput,
                    )
                  : const Text('')
            ],
          ),
        ),
        Container(
          height: 50,
          padding: paddingLeftRight8,
          decoration: BoxDecoration(
              borderRadius: borderContainer8,
              border: Border.all(color: borderColor, width: 1)),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TextField(
                  textAlign: widget.textAlignRight == true
                      ? TextAlign.right
                      : TextAlign.left,
                  controller: widget.textEditingController,
                  style: textStyleInput,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Only allows digits
                  ],
                  decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                  // autofocus: true,
                  onChanged: (value) => {
                        setState(() {
                          if ((int.tryParse(widget.textEditingController.text
                                      .replaceAll(r',', '')) ??
                                  0) >
                              MAX_PRICE) {
                            widget.textEditingController.text = '$MAX_PRICE';
                          }
                          // if ((int.tryParse(widget.textEditingController.text
                          //             .replaceAll(r',', '')) ??
                          //         0) <
                          //     MIN_PRICE) {
                          //   widget.textEditingController.text = '$MIN_PRICE';
                          // }
                          if (widget.textEditingController.text.isEmpty) {
                            widget.textEditingController.text = '0';
                          }
                          widget.textEditingController.text =
                              Utils.convertTextFieldPrice(widget
                                  .textEditingController.text
                                  .replaceAll(r',', ''));
                        })
                      }),
            ],
          ),
        ),
      ],
    );
  }
}
