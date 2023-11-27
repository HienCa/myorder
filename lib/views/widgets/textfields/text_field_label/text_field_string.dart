import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/utils.dart';

class MyTextFieldString extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final String placeholder;
  final bool isReadOnly;
  final bool isRequire;
  final bool? isBorder;
  final bool? isMultiline;
  final int max;
  final int min;

  const MyTextFieldString({
    super.key,
    required this.textController,
    required this.label,
    required this.placeholder,
    required this.isReadOnly,
    required this.min,
    required this.max,
    required this.isRequire,
    this.isBorder, this.isMultiline,
  });

  @override
  State<MyTextFieldString> createState() => _MyTextFieldStringState();
}

class _MyTextFieldStringState extends State<MyTextFieldString> {
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
       (widget.isMultiline == null || widget.isMultiline == false) ? Container(
          height: 50,
          padding: paddingLeftRight8,
          decoration: BoxDecoration(
              borderRadius: borderContainer8,
              border: (widget.isBorder == null || widget.isBorder == true)
                  ? Border.all(color: borderColor, width: 1)
                  : const Border()),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TextField(
                  maxLines: null,
                  readOnly: widget.isReadOnly,
                  controller: widget.textController,
                  style: textStyleInput,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  // autofocus: true,
                  // maxLength: widget.max,
                  onChanged: (value) => {
                        setState(() {
                          isInValid = !Utils.isValidLengthString(
                              value, widget.min, widget.max);
                          // print(value.length);
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
        ) :  Container(
         margin: const EdgeInsets.all(0),
          padding: paddingLeftRight8,
          decoration: BoxDecoration(
              borderRadius: borderContainer8,
              border: (widget.isBorder == null || widget.isBorder == true)
                  ? Border.all(color: borderColor, width: 1)
                  : const Border()),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TextField(
                  maxLines: null,
                  readOnly: widget.isReadOnly,
                  controller: widget.textController,
                  style: textStyleInput,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  // autofocus: true,
                  // maxLength: widget.max,
                  onChanged: (value) => {
                        setState(() {
                          isInValid = !Utils.isValidLengthString(
                              value, widget.min, widget.max);
                          // print(value.length);
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
                  ? Text(
                      "Từ ${widget.min} đến ${widget.max} ký tự.",
                      style: textStyleErrorInput,
                    )
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
