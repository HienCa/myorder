import 'package:flutter/material.dart';

class MyHeaderIcon extends StatefulWidget {
  final BuildContext context;
  final Icon icon;
  final String label;
  final TextStyle labelStyle;
  const MyHeaderIcon(
      {super.key,
      required this.icon,
      required this.label,
      required this.labelStyle,
      required this.context});

  @override
  State<MyHeaderIcon> createState() => _MyHeaderIconState();
}

class _MyHeaderIconState extends State<MyHeaderIcon> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () => {}, icon: const Icon(Icons.abc,color: Colors.transparent,)),
        const Spacer(),
        Text(
          widget.label.toUpperCase(),
          style: widget.labelStyle,
        ),
        const Spacer(),
        IconButton(
            onPressed: () => {Navigator.pop(context)}, icon: widget.icon),
      ],
    );
  }
}
