import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/config.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/utils.dart';

class MyTextFieldIconPhone extends StatefulWidget {
  final TextEditingController textController;
  final String placeholder;
  final bool isBorder;
  final double height;

  final bool isRequire;

  const MyTextFieldIconPhone({
    super.key,
    required this.textController,
    required this.placeholder,
    required this.isRequire,
    required this.isBorder,
    required this.height,
  });

  @override
  State<MyTextFieldIconPhone> createState() => _MyTextFieldIconPhoneState();
}

class _MyTextFieldIconPhoneState extends State<MyTextFieldIconPhone> {
  bool isInValid = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height,
          padding: Utils.isLandscapeOrientation(context)
              ? paddingLeftRight4
              : paddingLeftRight8,
          decoration: widget.isBorder == true
              ? BoxDecoration(
                  borderRadius: borderContainer8,
                  border: Border.all(color: borderColor, width: 1))
              : null,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.phone,
                  color: iconColor,
                  size: Utils.isLandscapeOrientation(context) ? 10 : 16),
              marginRight5,
              Expanded(
                child: TextField(
                    controller: widget.textController,
                    style:  Utils.isLandscapeOrientation(context)
                        ? textStyleInputLandscape
                        : textStyleInput,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly, // Only allows digits
                    ],
                    decoration: InputDecoration(
                        hintText: widget.placeholder,
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none, isDense: true,),
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
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isInValid
                  ?  Text(
                      "Từ $minlengthPhone đến $maxlengthPhone số.",
                      style: Utils.isLandscapeOrientation(context)
                          ? textStyleErrorInput8
                          : textStyleErrorInput,
                    )
                  : const SizedBox(),
              const SizedBox(width: 4), // Khoảng cách giữa hai phần tử
              Text(
                "${widget.textController.text.length}/$maxlengthPhone",
                style: Utils.isLandscapeOrientation(context)
                    ? textStyleLabel8
                    : textStyleLabel16,
              ),
            ],
          ),
        )
      ],
    );
  }
}
