import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myorder/constants.dart';

class MyCloseIcon extends StatefulWidget {
  final double heightWidth;
  final double sizeIcon;
  const MyCloseIcon(
      {super.key,
      required this.heightWidth,
      required this.sizeIcon});

  @override
  State<MyCloseIcon> createState() => _MyCloseIconState();
}

class _MyCloseIconState extends State<MyCloseIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.heightWidth,
      width: widget.heightWidth,
      decoration: BoxDecoration(
        color: grayColor200,
        borderRadius: BorderRadius.circular(widget.heightWidth / 2),
      ),
      child: Center(
        child: FaIcon(FontAwesomeIcons.xmark,
            color: iconColor, size: widget.sizeIcon),
      ),
    );
  }
}
