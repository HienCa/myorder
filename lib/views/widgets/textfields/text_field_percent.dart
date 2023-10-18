import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';

class MyTextFieldPercent extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final String placeholder;
  final bool isReadOnly;

  const MyTextFieldPercent(
      {super.key,
      required this.textController,
      required this.label,
      required this.placeholder, required this.isReadOnly});

  @override
  State<MyTextFieldPercent> createState() => _MyTextFieldPercentState();
}

class _MyTextFieldPercentState extends State<MyTextFieldPercent> {
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
                          if (int.parse(value) > 100) {
                            widget.textController.text = "100";
                          } else if (int.parse(value) <= 0) {
                            widget.textController.text = "1";
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
