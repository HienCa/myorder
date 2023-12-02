import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/constants/app_constants.dart';

class MyTextFieldStringOnTap extends StatefulWidget {
  final TextEditingController textController;
  final String label;
  final String placeholder;

  final bool isRequire;

  const MyTextFieldStringOnTap({
    super.key,
    required this.textController,
    required this.label,
    required this.placeholder,
    required this.isRequire,
  });

  @override
  State<MyTextFieldStringOnTap> createState() =>
      _MyTextFieldStringOnTapState();
}

class _MyTextFieldStringOnTapState extends State<MyTextFieldStringOnTap> {
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
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  borderRadius: borderContainer8,
                  border: Border.all(color: borderColor, width: 1)),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.textController.text,
                    style: textStyleInput,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
