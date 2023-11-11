import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';

class MyTextFieldNumber extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final String placeholder;
  final bool isReadOnly;
  final bool isRequire;
  final int max;
  final int min;

  const MyTextFieldNumber(
      {super.key,
      required this.textController,
      required this.label,
      required this.placeholder,
      required this.isReadOnly,
      required this.max,
      required this.min,
      required this.isRequire});

  @override
  State<MyTextFieldNumber> createState() => _MyTextFieldNumberState();
}

class _MyTextFieldNumberState extends State<MyTextFieldNumber> {
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
                  readOnly: widget.isReadOnly,
                  controller: widget.textController,
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
                          if (int.parse(value) > widget.max) {
                            widget.textController.text = "${widget.max}";
                          } else if (int.parse(value) <= widget.min) {
                            widget.textController.text = "${widget.min}";
                          }
                        })
                      }),
            ],
          ),
        ),
      ],
    );
  }
}
