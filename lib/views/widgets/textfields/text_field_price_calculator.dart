import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';

class MyTextFieldChoosePrice extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final String placeholder;
  final bool isRequire;

  const MyTextFieldChoosePrice({
    super.key,
    required this.textController,
    required this.label,
    required this.placeholder, required this.isRequire,
  });

  @override
  State<MyTextFieldChoosePrice> createState() => _MyTextFieldChoosePriceState();
}

class _MyTextFieldChoosePriceState extends State<MyTextFieldChoosePrice> {
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
                readOnly: true,
                controller: widget.textController,
                style: textStyleInput,
                decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              )
            ],
          ),
        ),
      ],
    );
  }
}
