import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/utils.dart';

class MyTextFieldNumberLength extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final String placeholder;
  final int min;
  final int max;
  final bool isRequire;

  const MyTextFieldNumberLength({
    super.key,
    required this.textController,
    required this.label,
    required this.placeholder,
    required this.isRequire,
    required this.min,
    required this.max,
  });

  @override
  State<MyTextFieldNumberLength> createState() =>
      _MyTextFieldNumberLengthState();
}

class _MyTextFieldNumberLengthState extends State<MyTextFieldNumberLength> {
  bool isInValid = false;
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
                  controller: widget.textController,
                  style: textStyleInput,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Only allows digits
                  ],
                  decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                  onChanged: (value) => {
                        setState(() {
                          isInValid = !Utils.isValidLengthString(
                              value, widget.min, widget.max);

                          if (value.trim().length > widget.max) {
                            // Nếu vượt quá giới hạn, cắt bớt chuỗi
                            widget.textController.text =
                                value.substring(0, widget.max);
                            widget.textController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: widget.textController.text.length),
                            );
                            isInValid = false;
                          }
                        })
                      }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isInValid
                  ? (widget.min == widget.max
                      ? Text(
                          "Yêu cầu đủ ${widget.min} số.",
                          style: textStyleErrorInput,
                        )
                      : Text(
                          "Từ ${widget.min} đến ${widget.max} số.",
                          style: textStyleErrorInput,
                        ))
                  : const SizedBox(),
              const SizedBox(width: 4), // Khoảng cách giữa hai phần tử
              Text(
                "${widget.textController.text.length}/${widget.max}",
                style: textStyleLabel16,
              ),
            ],
          ),
        )
      ],
    );
  }
}
