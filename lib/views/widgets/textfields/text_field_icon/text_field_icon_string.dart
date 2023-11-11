import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/utils.dart';

class MyTextFieldIconString extends StatefulWidget {
  final TextEditingController textController;
  final double height;
  final IconData iconData;
  final String placeholder;
  final bool isReadOnly;
  final bool isRequire;
  final bool isBorder;
  final int max;
  final int min;

  const MyTextFieldIconString({
    super.key,
    required this.textController,
    required this.iconData,
    required this.placeholder,
    required this.isReadOnly,
    required this.min,
    required this.max,
    required this.isRequire,
    required this.height,
    required this.isBorder,
  });

  @override
  State<MyTextFieldIconString> createState() => _MyTextFieldIconStringState();
}

class _MyTextFieldIconStringState extends State<MyTextFieldIconString> {
  bool isInValid = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
              FaIcon(widget.iconData,
                  color: iconColor,
                  size: Utils.isLandscapeOrientation(context) ? 10 : 16),
              marginRight5,
              Expanded(
                child: TextField(
                    readOnly: widget.isReadOnly,
                    controller: widget.textController,
                    style: Utils.isLandscapeOrientation(context)
                        ? textStyleInputLandscape
                        : textStyleInput,
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      //nằm giữa container
                      isDense: true,
                    ),
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
                  ? Text(
                      "Từ ${widget.min} đến ${widget.max} ký tự.",
                      style: Utils.isLandscapeOrientation(context)
                          ? textStyleErrorInput8
                          : textStyleErrorInput,
                    )
                  : const SizedBox(),
              const SizedBox(width: 4), // Khoảng cách giữa hai phần tử
              Text(
                "${widget.textController.text.length}/${widget.max}",
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
