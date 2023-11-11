import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/utils.dart';

class MyTextFieldPhone extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final String placeholder;

  final bool isRequire;

  const MyTextFieldPhone({
    super.key,
    required this.textController,
    required this.label,
    required this.placeholder,
    required this.isRequire,
  });

  @override
  State<MyTextFieldPhone> createState() => _MyTextFieldPhoneState();
}

class _MyTextFieldPhoneState extends State<MyTextFieldPhone> {
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
                              value, minlengthPhone, maxlengthPhone);
                          if (!value.startsWith('0', 0)) {
                            widget.textController.text = '0';
                          }
                          if (value.trim().length > maxlengthPhone) {
                            // Nếu vượt quá giới hạn, cắt bớt chuỗi
                            widget.textController.text =
                                value.substring(0, maxlengthPhone);
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
                  ? const Text(
                      "Từ $minlengthPhone đến $maxlengthPhone số.",
                      style: textStyleErrorInput,
                    )
                  : const SizedBox(),
              const SizedBox(width: 4), // Khoảng cách giữa hai phần tử
              Text(
                "${widget.textController.text.length}/$maxlengthPhone",
                style: textStyleLabel16,
              ),
            ],
          ),
        )
      ],
    );
  }
}
