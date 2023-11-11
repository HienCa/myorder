import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomButtonIcon extends StatelessWidget {
  final String label;
  final double height;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final TextStyle textStyle;

  const CustomButtonIcon(
      {Key? key,
      required this.label,
      required this.height,
      required this.icon,
      required this.backgroundColor,
      required this.textStyle,
      required this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const EdgeInsetsGeometry margin = EdgeInsets.all(5);
    const EdgeInsetsGeometry padding = EdgeInsets.only(left: 10, right: 10);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: margin,
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(icon, color: iconColor, size: 16),
          const SizedBox(width: 5), // Adjust the spacing as needed
          Text(
            label.toUpperCase(),
            style: textStyle,
          )
        ],
      ),
    );
  }
}
