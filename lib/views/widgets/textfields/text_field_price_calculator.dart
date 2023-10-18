import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';

class MyTextFieldChoosePrice extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final String placeholder;

  const MyTextFieldChoosePrice({
    super.key,
    required this.textController,
    required this.label,
    required this.placeholder,
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
        Container(
          margin: marginLeft8,
          child: Text(
            widget.label,
            style: textStyleLabel16,
          ),
        ),
        Container(
          height: 50,
          margin: marginAll8,
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
