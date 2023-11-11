import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';
import 'package:myorder/utils.dart';

class MyTextFieldIconNumber extends StatefulWidget {
  final TextEditingController textController;
  final IconData iconData;
  final String placeholder;
  final bool isReadOnly;
  final bool isRequire;
  final int max;
  final int min;
  final double height;
  final bool isBorder;

  const MyTextFieldIconNumber(
      {super.key,
      required this.textController,
      required this.placeholder,
      required this.isReadOnly,
      required this.max,
      required this.min,
      required this.isRequire,
      required this.height,
      required this.isBorder, required this.iconData});

  @override
  State<MyTextFieldIconNumber> createState() => _MyTextFieldIconNumberState();
}

class _MyTextFieldIconNumberState extends State<MyTextFieldIconNumber> {
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
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly, // Only allows digits
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: widget.placeholder,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    // autofocus: true,
                    onChanged: (value) => {
                          setState(() {
                            if (int.parse(value) > widget.max) {
                              widget.textController.text = "${widget.max}";
                            } else if (int.parse(value) <= widget.min) {
                              widget.textController.text = "${widget.min}";
                            }
                          })
                        }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
