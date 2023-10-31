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

  const MyTextFieldPrice(
      {super.key,
      required this.textEditingController,
      required this.label,
      required this.placeholder,
      required this.min,
      required this.max,
      required this.isRequire});

  @override
  State<MyTextFieldPrice> createState() => _MyTextFieldPriceState();
}

class _MyTextFieldPriceState extends State<MyTextFieldPrice> {
  @override
  void initState() {
    widget.textEditingController.text = Utils.convertTextFieldPrice('${widget.min}');
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
                          if ((int.tryParse(widget.textEditingController.text
                                      .replaceAll(r',', '')) ??
                                  0) <
                              MIN_PRICE) {
                            widget.textEditingController.text = '$MIN_PRICE';
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