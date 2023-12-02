import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/views/widgets/icons/icon_close.dart';

class MyHeaderIconClose extends StatefulWidget {
  final String title;
  const MyHeaderIconClose({
    super.key,
    required this.title,
  });

  @override
  State<MyHeaderIconClose> createState() => _MyHeaderIconState();
}

class _MyHeaderIconState extends State<MyHeaderIconClose> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        height: 40,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.abc,
                    color: Colors.transparent,
                  )),
              const Spacer(),
              Text(
                widget.title.toString(),
                style: textStyleWhiteBold20,
              ),
              const Spacer(),
              const MyCloseIcon(heightWidth: 30, sizeIcon: 16),
            ],
          ),
        ));
  }
}
