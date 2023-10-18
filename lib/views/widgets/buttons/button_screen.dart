import 'package:flutter/material.dart';
import 'package:myorder/constants/app_constants.dart';

class MyButtonScreen extends StatefulWidget {
  final String buttonText;
  final TextStyle style;
  final Color color;
  final void Function()? onTap;
  const MyButtonScreen(
      {super.key,
      required this.buttonText,
      required this.style,
      required this.color,
      this.onTap});

  @override
  State<MyButtonScreen> createState() => _MyButtonScreenState();
}

class _MyButtonScreenState extends State<MyButtonScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        margin: marginAll8,
        height: 50,
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Align(
          alignment: Alignment.center,
          child: Text(
              widget.buttonText != ""
                  ? widget.buttonText.toUpperCase()
                  : "THÊM MỚI",
              style: widget.style),
        ),
      ),
    );
  }
}
