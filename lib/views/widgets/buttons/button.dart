import 'package:flutter/material.dart';
import 'package:myorder/constants/app_constants.dart';

class MyButton extends StatefulWidget {
  final String buttonText;
  final TextStyle style;
  final Color color;
  final Function()? onTap;
  const MyButton({
    Key? key, // Thêm Key? key vào đây
    required this.buttonText,
    required this.style,
    required this.color,
    this.onTap,
  }) : super(
            key:
                key); // Sử dụng super(key: key) để chuyển giá trị key vào constructor của lớp cha

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
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
