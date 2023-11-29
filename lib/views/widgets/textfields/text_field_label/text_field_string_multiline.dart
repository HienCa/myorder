import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/widgets/textfields/text_field_label/text_field_string.dart';

class MyTextFieldStringMultiline extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final String placeholder;
  final bool isRequire;
  final int max;
  final int min;

  const MyTextFieldStringMultiline({
    super.key,
    required this.textController,
    required this.label,
    required this.placeholder,
    required this.min,
    required this.max,
    required this.isRequire,
  });

  @override
  State<MyTextFieldStringMultiline> createState() =>
      _MyTextFieldStringMultilineState();
}

class _MyTextFieldStringMultilineState
    extends State<MyTextFieldStringMultiline> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
              color: grayColor100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                MyTextFieldString(
                  textController: widget.textController,
                  label: widget.label,
                  placeholder: widget.placeholder,
                  isReadOnly: false,
                  min: widget.min,
                  max: widget.max,
                  isRequire: widget.isRequire,
                  isBorder: false,
                  isMultiline: true,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
